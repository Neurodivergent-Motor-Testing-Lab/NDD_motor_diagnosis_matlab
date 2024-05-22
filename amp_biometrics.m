function [ExtremaDiff, histFig, cumulative_FF, cumulative_Entropy] = amp_biometrics(magSignalFilter, N, start, stop, units)
ExtremaDiff = [];
CumulativeExtremaDiff = {};
% Done in this way to make sure analyzwd signal is only of trials and not
% between them and to make sure the last extrema of a trial isn't compared
% to the first of the next
for k = 1:length(start)
    SignalKinetic = magSignalFilter(start(k):stop(k)); %Kinetic signal when in motion for one trial
    EDiff_chop = compute_extrema_diff(SignalKinetic);
    ExtremaDiff = [ExtremaDiff, EDiff_chop'];
    CumulativeExtremaDiff{k} = ExtremaDiff;
    clear SignalKinetic
end

xmax = max(abs(ExtremaDiff));
xmax = round(xmax, N);
ind = 10^-N;
x = (-xmax - ind):ind:(xmax + ind);

histFig = figure('visible', 'off');
his = histogram(ExtremaDiff, x, 'Normalization', 'probability'); %normalized so that area is equal to 1 (change pdf to probability to make sum of heigths equal to 1)
ax = gca;
ax.FontSize = 15;
ylabel('P(\DeltaA_{NN})');
xlabel("\DeltaA_{NN} "+units)

%% Get biometrics

%% Fano Factor
cumulative_FF = trialwise_biometric_analysis(CumulativeExtremaDiff, @FF_from_hist, N);

%% Entropy
cumulative_Entropy = trialwise_biometric_analysis(CumulativeExtremaDiff, @entropy_from_hist, N);
