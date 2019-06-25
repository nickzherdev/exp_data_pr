% Title: Comparison of exponential and running mean for random walk model
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

% PART 1
% Determination of optimal smoothing constant in exponential mean

len1 = 3000;
len2 = 300;
% Generate true trajectories with the random walk model
[trajectoryTrue1, steps1] = trajectoryGenerate(len1, 10, 10);
[trajectoryTrue2, steps2] = trajectoryGenerate(len2, 10, 10);

% generate measurements
[measurements1, measurementsNoise1] = measurementsGenerate(trajectoryTrue1, 15);
[measurements2, measurementsNoise2] = measurementsGenerate(trajectoryTrue2, 15);

% Identify variances
v1 = zeros(len1,1);
v2 = zeros(len2,1);
p1 = zeros(len1,1);
p2 = zeros(len2,1);
for i = 2:len1
    v1(i) = steps1(i) + measurementsNoise1(i) - measurementsNoise1(i - 1);
end
for i = 2:len2
    v2(i) = steps2(i) + measurementsNoise2(i) - measurementsNoise2(i - 1);
end
for i = 3:len1
    p1(i) = steps1(i) + steps1(i - 1) + measurementsNoise1(i) - measurementsNoise1(i - 2);
end
for i = 3:len2
    p2(i) = steps2(i) + steps2(i - 1) + measurementsNoise2(i) - measurementsNoise2(i - 2);
end
v1_sqr = v1.^2;
v2_sqr = v2.^2;
p1_sqr = p1.^2;
p2_sqr = p2.^2;
expectation_v1_sqr = sum(v1_sqr)/ (len1 - 1);
expectation_v2_sqr = sum(v2_sqr)/ (len2 - 1);
expectation_p1_sqr = sum(p1_sqr)/ (len1 - 2);
expectation_p2_sqr = sum(p2_sqr)/ (len2 - 2); 
varianceSystematicError1 = expectation_p1_sqr - expectation_v1_sqr;
varianceSystematicError2 = expectation_p2_sqr - expectation_v2_sqr;
varianceMeasurementError1 = expectation_v1_sqr - expectation_p1_sqr / 2;
varianceMeasurementError2 = expectation_v2_sqr - expectation_p2_sqr / 2;

% Determine optimal smoothing coefficient in exponential smoothing
x1 = varianceSystematicError1 / varianceMeasurementError1;
x2 = varianceSystematicError2 / varianceMeasurementError2;
optimalSmoothingCoefficient1 = (- x1 + sqrt(x1 ^ 2 + 4 * x1)) / 2;
optimalSmoothingCoefficient2 = (- x2 + sqrt(x2 ^ 2 + 4 * x2)) / 2;

% PART 2
% Comparison of methodical errors of exponential and running mean.

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
skip = round((M - 1) / 2);

% Apply running mean using determined window size ?
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

figure
hold on
grid on;
plot(trajectoryTrue3, 'k');
plot(measurements3, 'g');
plot(runningMean, 'r');
plot(exponentialMean, 'b');
legend('Trajectory', 'Measurements', 'Running Mean', 'Exponential Mean');
title('Random walk');
xlabel('Step');
ylabel('Position');