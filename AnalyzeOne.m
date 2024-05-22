function [data, figTest] = AnalyzeOne(raw_sensor_data, subject_folder, figureVisibility, smoothingWindowWidth, cycleDurationEstimation, samplingFrequency)
%RunCode Summarize of the codes from raw sensor data to ISI
%calculation

% output
% data
% data.accel : acceleration of the moving
% data.linear_jerk : raw linear_jerk (3 columns)
% data.linear_jerk_s: filtered linear_jerk (3 columns)
% data.speedRaw:  raw speed
% data.speed25:  speed filtered with window 25;
% data.touch,data.start,data.stop: index for touch, start, stop points
% data.kineticISI :  s-IPIs in cycles (unit in frames)
% data.trialISI.meanISI25 : mean value
% data.trialISI.RISI25 :  R value (exponential fit with intervals below 10)

% output figures
% figure to check the start and stop point
% plot the speed profile as well as the second direction acceleration
% interval histogram
%

% functions:
% GET_STARTENDING
% GET_linear_jerk
% GET_TOUCH
% SMOOTHING_TRI

%% Inputs
if nargin > 6
    error('RunCode:TooManyInputs', ...
        'requires at most 6 optional inputs');
end

%% Fill in unset optional values.
trialTime = 1.25; %(seconds)
switch nargin
    case 2
        figureVisibility = 'off';
        samplingFrequency = 100;
        smoothingWindowWidth = 12;
        cycleDurationEstimation = trialTime * samplingFrequency;
    case 3
        samplingFrequency = 100;
        smoothingWindowWidth = 12;
        cycleDurationEstimation = trialTime * samplingFrequency;
    case 4
        samplingFrequency = 100;
        cycleDurationEstimation = trialTime * samplingFrequency;
    case 5
        samplingFrequency = 100;
end

%% Parse input data

linear_accel = raw_sensor_data(:, [1:3]);

%% Smoothen and compute higher derivatives

[linear_jerk, linear_jerk_s, linear_accel_s, magLinearJerkRaw, magLinearJerkFilter] = get_kinematics(linear_accel, samplingFrequency, smoothingWindowWidth);
% get highly smoothed linear_jerk profile, double the smoothing window
[~, linearJerkHighFilter, ~, ~, ~] = get_kinematics(linear_accel, samplingFrequency, smoothingWindowWidth*2);

%% Identify dominant direction and trials

linear_accel = repmat((2 * (mean(linear_accel) > 0) - 1), [size(linear_accel, 1), 1]) .* linear_accel; % make sure the moving direction is positive
dominantDirectionIndex = std(linear_accel(floor(1/3*length(linear_accel)):floor(2/3*length(linear_accel)), 1:2)) ...
    == max(std(linear_accel(floor(1/3*length(linear_accel)):floor(2/3*length(linear_accel)), 1:2)));
% dominant direction (the direction pointing to the screen)
linear_accelY = linear_accel(:, dominantDirectionIndex);

[touch, start, stop] = get_trial_data(linear_accel_s(:, dominantDirectionIndex), linearJerkHighFilter(:, dominantDirectionIndex), cycleDurationEstimation);
clear dominantDirectionIndex linearJerkHighFilter

%% Visualize trial markers
x = 1:size(linear_accelY);

figure('visible', figureVisibility);
plot(x, linear_accelY, x(start), linear_accelY(start), 'r*', x(stop), linear_accelY(stop), 'g*', x(touch), linear_accelY(touch), 'b*');

%% Save off trial wise data for deep learning
max_temporal_diff = max(stop-start);
trial_data = NaN(size(start, 1), max_temporal_diff, size(raw_sensor_data, 2));
for indCycle = 1:length(start)
    trial_data(indCycle, 1:stop(indCycle)-start(indCycle)+1, :) = raw_sensor_data(start(indCycle):stop(indCycle), :);
end
basefile = sprintf('trial_wise_data.mat');
fullfilename = fullfile(subject_folder, basefile);
save(fullfilename, 'trial_data');

%% Amplitude based biometrics
magAccelFilter = sqrt(sum(linear_accel_s.^2, 2));

%% amp bm's for linear_accel
linear_accel_analyzed_data = analyze_signal(magAccelFilter, start, stop, 0.0021, 0.01, figureVisibility, subject_folder, "Linear Acceleration", "(m/s^{2})");
data.linear_accel_analyzed_data = linear_accel_analyzed_data;

%% amp bm's for linear_jerk
linear_jerk_analyzed_data = analyze_signal(magLinearJerkFilter, start, stop, 0.0016, 0.01, figureVisibility, subject_folder, "Linear Jerk", "(m/s^{3})");
data.linear_jerk_analyzed_data = linear_jerk_analyzed_data;

%% ASSIGN TO DATA

data.smoothingWindowWidth = smoothingWindowWidth;
data.cycleDurationEstimation = cycleDurationEstimation;

data.touch = touch;
data.start = start;
data.stop = stop;
clear smoothingWindowWidth cycleDurationEstimation touch start stop;

data.linear_accel = linear_accel;
data.linear_accel_s = linear_accel_s;

clear linear_accel linear_accel_s;

data.linear_jerk = linear_jerk;
data.linear_jerk_s = linear_jerk_s;


clear linear_jerk linear_jerk_s;

basefile = sprintf('compdata.mat');
fullfilename = fullfile(subject_folder, basefile);
save(fullfilename, 'data');
end
