function [signal_dt, signal_dt_s, signal_s, magSignalDtRaw, magSignalDtFilter] = get_kinematics(ip_signal, freq, win)
% GET_KINEMATICS is a function to get d/dx (signal)/ mag of d/dx signal of input signal data
% freq is collecting frequency, win is smoothing window size
% signal_dt (ith) is calcuated directly as the change of signal between two adjacent
% time stamp (between i and i+1). signal_dt at time stamp 0 =0.
% the smoothing algorithm is applied to signal (signal_s)
% signal_dt_s calculated from signal_s
% magSignalDtFilter calculated from signal_dt_s

%initialize output vectors or matrixes
numCol = size(ip_signal, 2);
%filtering signal in each direction independently
for indCol = 1:numCol
    signal_s(:, indCol) = smoothing_gaussian(ip_signal(:, indCol), win);
end

% Store the approximate time derivative
signal_dt = zeros(size(ip_signal));
% Store the smoothened approximate time derivative
signal_dt_s = zeros(size(ip_signal));

signal_dt(2:end, :) = diff(ip_signal) * freq; % raw velocity
signal_dt_s(2:end, :) = diff(signal_s) * freq; % smoothed velocity


magSignalDtRaw = sqrt(sum(signal_dt.^2, 2));
magSignalDtFilter = sqrt(sum(signal_dt_s.^2, 2));

end
