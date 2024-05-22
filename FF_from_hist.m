function [biometric] = FF_from_hist(his)
nEDiff = his.BinCounts;
EDiff_dist = nEDiff / sum(nEDiff);
m = mean(EDiff_dist);
v = var(EDiff_dist);
biometric = v / m;
end