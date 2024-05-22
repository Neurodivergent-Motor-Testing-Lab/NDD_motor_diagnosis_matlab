trialTime = 1.25;
figureVisibility = 'on';
samplingFrequency = 100;

data_folder = "../Data";

S = dir(fullfile(data_folder, '*'));
N = setdiff({S([S.isdir]).name}, {'.', '..'}); % list of subfolders of data_folder.
for ii = 1:numel(N)
    disp(["Running for ", N{ii}]);
    pathfile = fullfile(data_folder, N{ii});
    F = fullfile(data_folder, N{ii}, 'sensor_data.csv');
    user_input_data = csvread(F);
    op_pathfile = strrep(pathfile, "Data", "Data_analyzed");
    mkdir(op_pathfile);
    ip_diagnosis_path = fullfile(data_folder, N{ii}, "diagnosis.txt");
    op_diagnosis_path = strrep(pathfile, "Data", "Data_analyzed");
    copyfile(ip_diagnosis_path, op_diagnosis_path);
    AnalyzeOne(user_input_data, op_pathfile);
    close all;
end