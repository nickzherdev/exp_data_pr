% Title: Determining and removing drawbacks of exponential and running mean
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

% PART 1
% Backward exponential smoothing

len3 = 300;
% Generate a true trajectory
stepsVariance3 = 28^2;
[trajectoryTrue3, steps3] = trajectoryGenerate(len3, 10, stepsVariance3);
% generate measurements
measurementsVariance3 = 97^2;
[measurements3, measurementsNoise3] = measurementsGenerate(trajectoryTrue3, measurementsVariance3);
% Determine optimal smoothing in exponential smoothing
x3 = stepsVariance3 / measurementsVariance3;
optimalSmoothingCoefficient3 = (- x3 + sqrt(x3 ^ 2 + 4 * x3)) / 2;

% Determine the window size M
M = round((2 - optimalSmoothingCoefficient3) / optimalSmoothingCoefficient3);
skip = (M - 1) / 2;
% Apply running mean using determined window size
runningMean = zeros(len3, 1);
runningMean(1:skip) = mean(measurements3(1:skip));
runningMean(len3 - skip + 1:len3) = mean(measurements3(len3 - skip + 1:len3));
for i = (1 + skip):(len3 - skip)
   runningMean(i) = mean(measurements3(i-skip:i+skip));
end
% Apply exponential mean
exponentialMean = zeros(len3, 1);
exponentialMean(1) = trajectoryTrue3(1);
for i = 2:len3
    exponentialMean(i) = exponentialMean(i - 1) + optimalSmoothingCoefficient3 * (measurements3(i) - exponentialMean(i - 1));
end
% Apply bachward exponential mean
exponentialMeanBackward = zeros(len3, 1);
exponentialMeanBackward(len3) = exponentialMean(len3);
for i = len3-1:-1:1
    exponentialMeanBackward(i) = exponentialMeanBackward(i + 1) + optimalSmoothingCoefficient3 * (exponentialMean(i) - exponentialMeanBackward(i + 1));
end

% determine indicators
[deviationIndicatorRM, variabilityIndicatorRM] = getIndicators(measurements3,runningMean);
[deviationIndicatorFEM, variabilityIndicatorFEM] = getIndicators(measurements3,exponentialMean);
[deviationIndicatorBEM, variabilityIndicatorBEM] = getIndicators(measurements3,exponentialMeanBackward);

figure
hold on
grid on;

% % display Part 1
% plot(trajectoryTrue3, 'k');
% plot(measurements3, 'g');
% plot(runningMean, 'b');
% plot(exponentialMean, 'y');
% plot(exponentialMeanBackward, 'r');
% legend('Trajectory', 'Measurements', 'Running Mean', 'Exponential Mean', 'Backward Exponential Mean');
% title('Backward Exponential Mean');
% xlabel('Step');
% ylabel('Position');

% Part 2. Drawbacks of running mean
% Generate a true trajectory of an object motion disturbed by normally 
% distributed random acceleration

% First trajectory
len1 = 300;
[trajectory1, velocity1, acceleration1] = trajectoryGenerate2(len1,5,0,0.1,10);
% generate measurements 
measurementsVariance1 = 500;
[measurements1, measurementsNoise1] = measurementsGenerate(trajectory1, measurementsVariance1);

% Apply running mean (window size M empiricaly determined)
M1 = 101;
skip1 = (M1 - 1) / 2;
runningMean1 = zeros(len1, 1);
runningMean1(1:skip1) = mean(measurements1(1:skip1));
runningMean1(len1 - skip1 + 1:len1) = mean(measurements1(len1 - skip1 + 1:len1));
for i = (1 + skip1):(len1 - skip1)
   runningMean1(i) = mean(measurements1(i-skip1:i+skip1));
end

% Apply exponential mean (Optimal Smoothing Coefficient empiricaly determined)
optimalSmoothingCoefficient1 = 0.05;
exponentialMean1 = zeros(len1, 1);
exponentialMean1(1) = trajectory1(1);
for i = 2:len1
    exponentialMean1(i) = exponentialMean1(i - 1) + optimalSmoothingCoefficient1 * (measurements1(i) - exponentialMean1(i - 1));
end

% Apply bachward exponential mean (Optimal Smoothing Coefficient empiricaly determined)
exponentialMeanBackward1 = zeros(len1, 1);
exponentialMeanBackward1(len1) = exponentialMean1(len1);
for i = len1-1:-1:1
    exponentialMeanBackward1(i) = exponentialMeanBackward1(i + 1) + optimalSmoothingCoefficient1 * (exponentialMean1(i) - exponentialMeanBackward1(i + 1));
end
% determine indicators
[deviationIndicatorRM1, variabilityIndicatorRM1] = getIndicators(measurements1,runningMean1);
[deviationIndicatorFEM1, variabilityIndicatorFEM1] = getIndicators(measurements1,exponentialMean1);
[deviationIndicatorBEM1, variabilityIndicatorBEM1] = getIndicators(measurements1,exponentialMeanBackward1);
% % display Part 2 First trajectory
% plot(trajectory1, 'k');
% plot(measurements1, 'y');
% plot(runningMean1, 'r');
% plot(exponentialMean1, 'g');
% plot(exponentialMeanBackward1, 'b');
% legend('Trajectory', 'Measurements', 'Running Mean', 'Forward Exp Mean', 'Backward Exp Mean');
% title('Random acceleration, first trajectory');
% xlabel('Step');
% ylabel('Position');

% Second trajectory
len2 = 200;
T = 50;
[trajectory2] = trajectoryGenerate22(len2,1,T,0.08^2);
% generate measurements 
measurementsVariance2 = 0.05;
[measurements, measurementsNoise] = measurementsGenerate(trajectory2, measurementsVariance2);

% Apply running mean
M2 = 15;
skip2 = (M2 - 1) / 2;
runningMean2 = zeros(len2, 1);
runningMean2(1:skip2) = mean(measurements(1:skip2));
runningMean2(len2 - skip2 + 1:len2) = mean(measurements(len2 - skip2 + 1:len2));
for i = (1 + skip2):(len2 - skip2)
   runningMean2(i) = mean(measurements(i-skip2:i+skip2));
end

% determine indicators
[deviationIndicatorRM2, variabilityIndicatorRM2] = getIndicators(measurements,runningMean2);

% % display Part 2 Second trajectory
% plot(trajectory2, 'k');
% plot(measurements, 'y');
% plot(runningMean2, 'r');
% legend('Trajectory', 'Measurements', 'Running Mean');
% title('Random acceleration, second trajectory');
% xlabel('Step');
% ylabel('Position');


% inverse oscillations when T = 4, 8..13
% zero oscillations when T = 1..3,5
% insignificantly changed oscillations when T = 30+