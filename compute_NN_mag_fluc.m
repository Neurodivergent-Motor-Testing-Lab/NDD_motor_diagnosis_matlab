function [mag_diff] = compute_NN_mag_fluc(ip_signal, start, stop)
moving_signal = [];
for k = 1:length(start)
    moving_signal = [moving_signal; ip_signal(start(k):stop(k))];
end

[pks, pksIdx] = findpeaks(moving_signal);
mag_diff = diff(pks)

clear moving_signal
end