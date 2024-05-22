data_folder = "../Data_analyzed";

S = dir(fullfile(data_folder, '*'));
N = setdiff({S([S.isdir]).name}, {'.', '..'}); % list of subfolders of data_folder.
color = ["#0086A8"; "#A00E00"; "#D04E00"; "#F6C200"];
possible_conditions = ["ASD", "A^2", "ADHD", "NT"];
signal_name = ["linear_accel_analyzed_data", "linear_jerk_analyzed_data"];
pretty_signal_names = ["Linear Acceleration", "Linear Jerk"];
biometrics_names = ["FF", "Entropy"];
for s_idx = 1:numel(signal_name)
    for biometric_idx = 1:numel(biometrics_names)
        habituation_trials = [];
        habituation_variance = [];
        diagnoses = [];
        severities = [];
        biometrics = [];
        for ii = 1:numel(N)
            % disp(["Running for ", N{ii}]);
            pathfile = fullfile(data_folder, N{ii});
            F = fullfile(data_folder, N{ii}, 'compdata.mat');
            userdata = load(F);
            user_data_cell = struct2cell(userdata);
            user_input_data = user_data_cell{1};
            analyzed_data = user_input_data.(signal_name(s_idx)).(biometrics_names(biometric_idx));
            
            habituation_trials = [habituation_trials; analyzed_data.stable_point];
            habituation_variance = [habituation_variance; analyzed_data.stable_var];
            user_biometric_data = analyzed_data.ampBiometrics(end);
            biometrics = [biometrics; user_biometric_data];

            diagnosis_file = fullfile(data_folder, N{ii}, 'diagnosis.txt');
            diagnosis_data = readlines(diagnosis_file);
            diagnoses = [diagnoses, diagnosis_data(1)];
            severities = [severities, diagnosis_data(2)];
            
        end
        numbered_diagnoses = zeros(size(diagnoses)) - 1;
        numbered_diagnoses(diagnoses == "ASD") = 0;
        numbered_diagnoses(diagnoses == "A^2") = 1;
        numbered_diagnoses(diagnoses == "ADHD") = 2;
        numbered_diagnoses(diagnoses == "NT") = 3;

        NT_biometrics = biometrics(numbered_diagnoses == 3);
        num_NTs = size(NT_biometrics, 1);
        for diagnosis_idx = 1:3
            participant_idc = numbered_diagnoses == diagnosis_idx - 1;
            diagnosis_severities = severities(participant_idc);
            diagnosis_biometrics = biometrics(participant_idc);

            %% Plot
            LF_biometrics = diagnosis_biometrics(diagnosis_severities == "LF");
            MF_biometrics = diagnosis_biometrics(diagnosis_severities == "MF");
            HF_biometrics = diagnosis_biometrics(diagnosis_severities == "HF");

            num_LF = size(LF_biometrics, 1);
            num_MF = size(MF_biometrics, 1);
            num_HF = size(HF_biometrics, 1);

            all_xs = [LF_biometrics; MF_biometrics; HF_biometrics; NT_biometrics];
            all_ys = zeros(size(all_xs));
            count = 1;
            all_ys(1:count + num_LF) = 0;
            count = count + num_LF;

            all_ys(count : count + num_MF) = 1;
            count = count + num_MF;
            all_ys(count : count + num_HF) = 2;
            count = count + num_HF;
            all_ys(count:end) = 3;

            figure('visible', 'on');
            g = gscatter(all_xs, all_ys, all_ys, 'k', 'dddd', 7);
            yticks([0, 1, 2, 3])
            yticklabels({'Low', 'Mid', 'High', 'NT'})
            ylim([-0.5, 3.5])
            xlabel(biometrics_names(biometric_idx));
            ylabel(' ')
            title(biometrics_names(biometric_idx) + " for " + possible_conditions(diagnosis_idx) + " using " + pretty_signal_names(s_idx));
            for n = 1:length(g)
                g(n).MarkerFaceColor = color(n);
            end
            ax = gca;
            ax.FontSize = 15;
            legend('off');

        end

        %% Habituation Statistics

        habituation_trials = habituation_trials(~isnan(habituation_trials));
        habituation_variance = habituation_variance(~isnan(habituation_variance));
        mean_habituation_trials = mean(habituation_trials);
        std_habituation_trials = std(habituation_trials);
        
        mean_habituation_var = mean(habituation_variance);
        std_habituation_var = std(habituation_variance);

        disp(["Habituation statistics ", biometrics_names(biometric_idx), " using ",  pretty_signal_names(s_idx)]);
        mean_habituation_trials
        std_habituation_trials
        mean_habituation_var
        std_habituation_var

    end

end