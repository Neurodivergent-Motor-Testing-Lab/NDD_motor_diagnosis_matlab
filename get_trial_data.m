function [touchIdx, start, stop] = get_trial_data(accelY, smoothedJerk, EstimationOfCycleDuration)
% get_trial_data is a function to locate start and ending points based on acceleration and smoothed jerk profile,
% PARAMETER:EstimationOfCycleDuration is the estimation of duration of a complete trial,
% INPUT: accelY: acceleration in the dominant direction; SmoothedJerk: highly
% smoothed jerk profile
% OUTPUT:
% function returns the points for the cycles: start and stop point as
% well as the target touching point

% ues function: GET_TOUCH

%% get touch points (minima in acceleration)

% Look in the middle third of the signal for touch
touchAccelThreshold = mean(-accelY(floor(1/3*length(accelY)):floor(2/3*length(accelY)))) ...
    +std(-accelY(floor(1/3*length(accelY)):floor(2/3*length(accelY))));

% Classify a peak as at least mean+std
[accelPeaks, touchIdx] = findpeaks(-accelY, 'MINPEAKHEIGHT', touchAccelThreshold, ...
    'MINPEAKDISTANCE', EstimationOfCycleDuration);

% Ensure peaks are large enough
ind = (accelPeaks > touchAccelThreshold);
touchIdx = touchIdx(ind);

%% Initialize start and ending with zeros
start = zeros(length(touchIdx), 1);
stop = zeros(length(touchIdx), 1);

%% get valleys in the highly smoothed accel profile
[~, ind] = findpeaks(accelY);

%% select potential points in between touch points
temporalThreshold = EstimationOfCycleDuration / 5; % temporal threshold
for i = 1:length(touchIdx) - 1
    accelBetweenTwoTouches = accelY(touchIdx(i):touchIdx(i+1));
    jerkBetweenTwoTouches = smoothedJerk(touchIdx(i):touchIdx(i+1));

    % accelerational threshold
    accelThreshold = mean(accelBetweenTwoTouches) + (std(accelBetweenTwoTouches) / 3);

    % jerk threshold (average)
    jerkMean = mean(jerkBetweenTwoTouches);
    jerkThreshold = std(jerkBetweenTwoTouches) * 2;

    % Points at temporal distance from the touch, and a accel zero crossing
    % with a jerk maxima
    start_ind = intersect(intersect(find(ind < touchIdx(i)-temporalThreshold), find(accelY(ind) > accelThreshold)), find(abs(jerkMean-smoothedJerk(ind)) < jerkThreshold));
    if i ~= 1
        start_ind = intersect(start_ind, find(ind >= stop(i-1)));
    end
    ending_ind = intersect(intersect(find(ind > (touchIdx(i))+temporalThreshold), find(accelY(ind) > accelThreshold)), find(abs(jerkMean-smoothedJerk(ind)) < jerkThreshold));

    if isempty(start_ind) == 0 && isempty(ending_ind) == 0
        start(i) = max(ind(start_ind));
        stop(i) = min(ind(ending_ind));
    end
end

%% delete outliers (set temporal threshold)
index = union(find(start == 0), find(stop == 0));

% delete trials that are exceding the temporal threshold
d = stop - start;
aved = mean(d);
stdd = std(d);
cycle_th = aved + 2 * stdd; % below average plus two standard deviation and below 720
ind = find(d > cycle_th);

index = union(index, ind);
start(index) = [];
stop(index) = [];
touchIdx(index) = [];
end