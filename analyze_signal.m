function [signal_data] = analyze_signal(magSignalFilter, start, stop, FF_threshold, entropy_threshold, figureVisibility, subject_folder, signal_name, signal_units)
[ampIEI, ampHist, ampFFs, ampEnts] = amp_biometrics(magSignalFilter, 1, start, stop, signal_units);

%% Compute Stability
[FF_stable_point, FF_stable_var] = find_stability(ampFFs, FF_threshold);
[entropy_stable_point, entropy_stable_var] = find_stability(ampEnts, entropy_threshold);

%% Output stuff
figure('visible', figureVisibility);
ampHist;
title("PDF of Amplitude Differences of Consecutive Local Extrema Histogram");
basefile = sprintf('AmpISI_%s.jpg', signal_name);
fullfilename = fullfile(subject_folder, basefile);
saveas(ampHist, fullfilename);

figure('Visible', figureVisibility);
plot(ampFFs);
title(sprintf("%s Edif Fano Factor", signal_name));
basefile = sprintf("%s Ediff_ff_stability", signal_name);
fullfilename = fullfile(subject_folder, basefile);
saveas(gcf, fullfilename, "fig");
saveas(gcf, fullfilename, "jpg");

figure('Visible', figureVisibility);
plot(ampEnts);
title(sprintf("%s Ediff Entropty", signal_name));
basefile = sprintf("%s Ediff_ent_stability", signal_name);
fullfilename = fullfile(subject_folder, basefile);
saveas(gcf, fullfilename, "fig");
saveas(gcf, fullfilename, "jpg");

%%
signal_data.ampIEI = ampIEI;

signal_data.FF.ampBiometrics = ampFFs;
signal_data.FF.stable_point = FF_stable_point;
signal_data.FF.stable_var = FF_stable_var;

signal_data.Entropy.ampBiometrics = ampEnts;
signal_data.Entropy.stable_point = entropy_stable_point;
signal_data.Entropy.stable_var = entropy_stable_var;
end