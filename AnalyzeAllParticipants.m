trialTime = 1.25;
figureVisibility = 'on';
samplingFrequency = 100;

ip_data_folder = ['..' filesep 'NDD_motor_diagnosis_subject_data'];
op_data_folder = ['..' filesep 'NDD_motor_diagnosis_subject_data_analyzed'];
S = dir(fullfile(ip_data_folder, '*'));
N = setdiff({S([S.isdir]).name}, {'.', '..'}); % list of subfolders of data_folder.
for ii = 1:numel(N)
    disp(["Running for ", N{ii}]);
    pathfile = fullfile(ip_data_folder, N{ii});
    F = fullfile(ip_data_folder, N{ii}, 'sensor_data.csv');
    user_input_data = csvread(F);
    op_pathfile = strrep(pathfile, ip_data_folder, op_data_folder);
    mkdir(op_pathfile);
    ip_diagnosis_path = fullfile(ip_data_folder, N{ii}, "diagnosis.txt");
    op_diagnosis_path = strrep(pathfile, ip_data_folder, op_data_folder);
    copyfile(ip_diagnosis_path, op_diagnosis_path);
    AnalyzeOne(user_input_data, op_pathfile);
    close all;
end