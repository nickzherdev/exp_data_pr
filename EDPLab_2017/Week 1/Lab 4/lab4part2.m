% Title: Determining and removing drawbacks of exponential and running mean. Task 2
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

% Part 2. 3d surface filtration using forward-backward smoothing.

%importing data
noisyData = importdata("noisy_surface.mat");
trueData = importdata("true_surface.mat");

% display noisy Data
figure
view(-34,23);
hold on
grid on
colormap jet
colorbar
mesh(noisyData);
title('Noisy Data');
xlabel('X');
ylabel('Y');
zlabel('N');

% display true Data
figure
view(-34,23);
hold on
grid on
colormap jet
colorbar
mesh(trueData);
title('True Data');
xlabel('X');
ylabel('Y');
zlabel('N');

% Determine the variance of deviation of noisy surface from the true one.
varianceOfDeviationNoisy = varianceOfDeviation(noisyData, trueData);

% Apply forward-backward exponential smoothing to filter noisy surface measurements.
alpha = 0.335;
processedData = noisyData;
[m, n] = size(processedData);
for i = 1:m
    processedData = forwardBackwardExponentialMean(processedData, "row", i, alpha);
end
for i = 1:n
    processedData = forwardBackwardExponentialMean(processedData, "column", i, alpha);
end


% display processed Data
figure
view(-34,23);
hold on
grid on
colormap jet
colorbar
mesh(processedData);
title('Processed Data');
xlabel('X');
ylabel('Y');
zlabel('N');

% Determine the variance of deviation of smoothed surface from the true one.
varianceOfDeviationProcessed = varianceOfDeviation(processedData, trueData);