function [EDiff] = compute_extrema_diff(signal)
[magpeaksmax, idx_max] = findpeaks(signal);
[magpeaksmin, idx_min] = findpeaks(-signal);
idx = [idx_max; idx_min];
[~, sortIdx] = sort(idx);
magpeaks = [magpeaksmax; magpeaksmin]; % Local maxima and minima in signal
magpeaks = magpeaks(sortIdx);
EDiff = diff(magpeaks); % The amplitude differences for consecutive maxima and minima within a trial
end