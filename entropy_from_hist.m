function [biometric] = entropy_from_hist(his)
nEDiff = his.BinCounts;
EDiff_dist = nEDiff / sum(nEDiff);
EDiff_dist(EDiff_dist == 0) = [];
biometric = -sum(EDiff_dist.*log(EDiff_dist));
end