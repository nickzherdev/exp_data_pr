% Title: Determining and removing drawbacks of exponential and running mean. Task 2
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

% Part 1. Comparison of the traditional 13-month running mean with the 
% forward-backward exponential smoothing for approximation of 11-year sunspot cycle


%importing data
data = importdata("data_group1.mat");
sunspotNumberMeasurements = data(:,3);
time = data(:,1) + data(:,2) / 12;
len = length(sunspotNumberMeasurements);

% 13-month running mean
runningMean = runningMean13month(sunspotNumberMeasurements);


% following peice of code is to determine best alpha 
% can be commented, this script will work just fine without it
% -------------------------------------------------------------------------
step = 0.001;
first = 0.01;
last = 0.89;
number = round((last - first) / step);
% create an array with columns: alpha, deviationIndicatorFEM, variabilityIndicatorFEM
indicators = zeros(number, 5);
[deviationIndicatorRM, variabilityIndicatorRM] = getIndicators(sunspotNumberMeasurements,runningMean);
k = 1;
for alpha = first:step:last
    % Forward-backward exponential smoothing
    % Apply exponential mean
    exponentialMean = zeros(len, 1);
    exponentialMean(1) = sunspotNumberMeasurements(1);
    for i = 2:len
        exponentialMean(i) = exponentialMean(i - 1) + alpha * (sunspotNumberMeasurements(i) - exponentialMean(i - 1));
    end
    % Apply bachward exponential mean
    exponentialMeanBackward = zeros(len, 1);
    exponentialMeanBackward(len) = exponentialMean(len);
    for i = len-1:-1:1
        exponentialMeanBackward(i) = exponentialMeanBackward(i + 1) + alpha * (exponentialMean(i) - exponentialMeanBackward(i + 1));
    end

    % determine indicators
    [deviationIndicatorBEM, variabilityIndicatorBEM] = getIndicators(sunspotNumberMeasurements,exponentialMeanBackward);
    indicators(k,1) = alpha;
    indicators(k,2) = deviationIndicatorBEM;
    indicators(k,3) = variabilityIndicatorBEM;
    indicators(k,4) = deviationIndicatorRM; 
    indicators(k,5) = variabilityIndicatorRM;
    k = k + 1;
end

% plot results
figure
hold on;
grid on;
plot(indicators(:,1), indicators(:,2), 'r');
plot(indicators(:,1), indicators(:,4), 'g');
legend('Backward Exponential Mean', 'Running Mean');
title('Deviation Indicators');
xlabel('Alpha');
ylabel('Deviation Indicator');

figure
hold on;
grid on;
plot(indicators(:,1), indicators(:,3), 'b');
plot(indicators(:,1), indicators(:,5), 'k');
legend('Backward Exponential Mean', 'Running Mean');
title('Variability Indicators');
xlabel('Alpha');
ylabel('Variability Indicator');
% -------------------------------------------------------------------------


% Forward-backward exponential smoothing
% Apply exponential mean
alpha = 0.22;
exponentialMean = zeros(len, 1);
exponentialMean(1) = sunspotNumberMeasurements(1);
for i = 2:len
    exponentialMean(i) = exponentialMean(i - 1) + alpha * (sunspotNumberMeasurements(i) - exponentialMean(i - 1));
end
% Apply bachward exponential mean
exponentialMeanBackward = zeros(len, 1);
exponentialMeanBackward(len) = exponentialMean(len);
for i = len-1:-1:1
    exponentialMeanBackward(i) = exponentialMeanBackward(i + 1) + alpha * (exponentialMean(i) - exponentialMeanBackward(i + 1));
end

% determine indicators
[deviationIndicatorRM, variabilityIndicatorRM] = getIndicators(sunspotNumberMeasurements,runningMean);
[deviationIndicatorFEM, variabilityIndicatorFEM] = getIndicators(sunspotNumberMeasurements,exponentialMean);
[deviationIndicatorBEM, variabilityIndicatorBEM] = getIndicators(sunspotNumberMeasurements,exponentialMeanBackward);


% display
figure
hold on;
grid on;
plot(sunspotNumberMeasurements, 'g');
plot(runningMean, 'r');
plot(exponentialMeanBackward, 'b');
legend('Measurements', '13-month Running Mean', 'Backward Exponential Mean');
title('Sunspot Number');
xlabel('Year');
ylabel('Sunspot Number');