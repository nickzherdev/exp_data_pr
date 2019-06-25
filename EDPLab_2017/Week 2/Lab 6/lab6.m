% Title: Analysis of accuracy decrease of filtration in conditions  of 
%        correlated biased state and measurement noise
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

T = 1;
len = 200;
sigma_a_sqr = 0.2^2;
sigma_eta_sqr = 20^2;
Pinitial = [10000, 0; 0, 10000];
q = 0.2;

Xtrue = generateTrueTrajectoryBiased(len, 5, 1, T, sigma_a_sqr, q);
Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
[filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
%[filtration, Pfiltration, K] = kalmanFilterBiased(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial, q);

% display
figure
hold on;
grid on;
plot(Xtrue(1, :), 'k');
plot(Xmeasurements, 'g');
plot(filtration(1, :), 'r');
legend('True trajectory', 'Measurements', 'Kalman Filter');
title('Kalman filter');
xlabel('Time');
ylabel('Position');

% M runs of filter
M = 500;
ErrorKalman = zeros(len, M);
for j = 1:M
    Xtrue = generateTrueTrajectoryBiased(len, 5, 1, T, sigma_a_sqr, q);
    Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
    %[filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
    [filtration, Pfiltration, K] = kalmanFilterBiased(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial, q);
    for i = 3:len
        ErrorKalman(i, j) = (Xtrue(1,i) - filtration(1,i))^2;
    end
end
% Dynamics of mean-squared error of estimaiton
FinalErrorKalman = zeros(1, len);
for i = 3:len
    for Run = 1:M
        FinalErrorKalman(i) = FinalErrorKalman(i) + ErrorKalman(i, Run);
    end
    FinalErrorKalman(i) = sqrt(FinalErrorKalman(i) / (M + 1));
end

% display Final Error
figure
hold on;
grid on;
plot(FinalErrorKalman, 'r');
legend('Kalman filter');
title('Dynamics of mean-squared error of estimaiton');
xlabel('Time');
ylabel('Final Error');

% Compare true estimation error with cov matrix
figure
hold on;
grid on;
plot(FinalErrorKalman, 'r');
temp1 = zeros(len);
temp2 = zeros(len);
for i=1:len
    temp1(i) = sqrt(Pfiltration(1, 1, i));
end
plot(temp1, 'b');
legend('Kalman filter Final error', 'Sqrt of first element of the matrix');
title('Compare calculation errors');
xlabel('Time');
ylabel('Value');