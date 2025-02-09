function [cumulative_biometrics] = trialwise_biometric_analysis(cumulativeExtremaDiffs, biometric_function, N)
%Used to find biometric as additional trials are considered for both
%habituation information and final biometric
cumulative_biometrics = [];
for i = 1:length(cumulativeExtremaDiffs)
    extrema_diffs_so_far = cumulativeExtremaDiffs{i};

    xmax = max(abs(extrema_diffs_so_far));
    xmax = round(xmax, N);
    ind = 10^-N;
    x = (-xmax - ind):ind:(xmax + ind);

    figure('visible', 'off')
    his = histogram(extrema_diffs_so_far, x, 'Normalization', 'pdf');
    biometric = biometric_function(his); %biometric from addition of one more trial
    cumulative_biometrics = [cumulative_biometrics, biometric]; %Last value is biometric of individual using all trials
end

end