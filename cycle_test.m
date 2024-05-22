function [plotFigure] = cycle_test(start, stop, touch, accel_s, accelY, jerk, samplingFrequency, figureVisibility)
%CYCLE_TEST plot the figure for the results from cycle selection
% return figure

mag = sqrt(sum(accel_s.^2, 2));
%get time in second
xInSecond = (1:length(jerk)) ./ samplingFrequency;
startInSecond = start ./ samplingFrequency;
stopInSecond = stop ./ samplingFrequency;
touchInSecond = touch ./ samplingFrequency;

% figure specification
colorStart = 'r';
colorStop = 'b';
colorTouch = 'g';
colorCurve = 'c';
sizeOfMarker = 20;

% number of test
numTest = 10;

%% generate figure
plotFigure = figure('units', 'normalized', 'outerposition', [0, 0, 1, 1], 'visible', figureVisibility);

% subplot A plot whole acceleration
subplot(6, 2, 1)
plot(xInSecond, accelY, 'Color', colorCurve);
hold on
scatter(startInSecond, accelY(start), sizeOfMarker, colorStart, 'filled')
scatter(stopInSecond, accelY(stop), sizeOfMarker, colorStop, 'filled')
scatter(touchInSecond, accelY(touch), sizeOfMarker, colorTouch, 'filled')
ylim([0, 100]);

% subplot B plot whole jerk
subplot(6, 2, 3)
plot(xInSecond, jerk, 'Color', colorCurve);
hold on
scatter(startInSecond, jerk(start), sizeOfMarker, colorStart, 'filled')
scatter(stopInSecond, jerk(stop), sizeOfMarker, colorStop, 'filled')
scatter(touchInSecond, jerk(touch), sizeOfMarker, colorTouch, 'filled')
ylim([0, 100]);

% plot Tests

randInd = ceil(rand(1, numTest)*length(start));
accelPlotIndex = [3:4:23, 9:4:21];
jerkPlotIndex = accelPlotIndex + 1;

for ind = 1:numTest
    PickInd = randInd(ind);
    PickStart = start(PickInd);
    PickStop = stop(PickInd);
    PickTouch = touch(PickInd);

    x = PickStart:PickStop;
    xPlot = PickStart - 48:PickStop + 48;

    % 3D trajectory
    subplot(6, 4, accelPlotIndex(ind))
    plot(xPlot./samplingFrequency, accelY(xPlot))
    hold on
    scatter(PickStart./samplingFrequency, accelY(PickStart), 100, colorStart, 'filled') % trajectory start point
    scatter(PickStop./samplingFrequency, accelY(PickStop), 100, colorStop, 'filled') % trajectory stop point
    scatter(PickTouch./samplingFrequency, accelY(PickTouch), 100, colorTouch, 'filled') % trajectory touch point
    xlabel('Time')
    ylabel('Acceleration')
    legend(strcat('trial #', num2str(PickInd)))

    % first column speed profile
    subplot(6, 4, jerkPlotIndex(ind))
    plot(xPlot./samplingFrequency, jerk(xPlot))
    hold on
    scatter(PickStart./samplingFrequency, jerk(PickStart), 100, colorStart, 'filled') % trajectory start point
    scatter(PickStop./samplingFrequency, jerk(PickStop), 100, colorStop, 'filled') % trajectory stop point
    scatter(PickTouch./samplingFrequency, jerk(PickTouch), 100, colorTouch, 'filled') % trajectory touch point
    xlabel('Time')
    ylabel('Jerk')
    legend(strcat('trial #', num2str(PickInd)))
end


end
