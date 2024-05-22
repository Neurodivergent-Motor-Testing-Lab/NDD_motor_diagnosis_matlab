function [s] = smoothing_gaussian(x, win)
%SMOOTHING_TRI triangular smoothig algorithm
%   input signal:x (vector), smoothing windth: win (meaning the number of data
%   points contributing to the output signal at each point, should be even number, if odd, then one digit down)

%   two alternatives to do so, one is using conv function directly; the
%   other is interpreting it with for loop. Have tested these two work
%   equally

% triangule function: (tau-t)/(tau^2)
% t: -(tau-1):(tau-1),  tau is the half width: tau=ceil(win/2);
%(attention: the width is defined as the values that have ontributed to the output, the edge is not zero)
% if win=25, tau=13, t: -12:12

% TEST
% x=1:1000;
% y=sin(2*pi*x./500)+rand(1,1000)*0.2;
% s=smoothing_tri(y,25);
% plot(x,y)
% hold on
% plot(x,s,'r','LineWidth',2)


tau = ceil(win/2);
t = -(tau - 1):(tau - 1);
gaussianFunction = normpdf(t, 0, tau/2);

% use convolution
s = conv(x, gaussianFunction, 'same');
% the output signal is of the same size as the input signal


end
