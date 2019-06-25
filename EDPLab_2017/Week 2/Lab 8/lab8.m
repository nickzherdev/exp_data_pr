% Title: Tracking and forecasting in conditions of measurement gaps
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

T = 1;
len = 200;
sigma_a_sqr = 0.2^2;
sigma_eta_sqr = 20^2;
P = 0.2;
Pinitial = [10000, 0; 0, 10000];
m = 7;

Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr, P);
[prediction, Pprediction, filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);

% display
figure
hold on;
grid on;
plot(Xtrue(1, :), 'k');
scatter([1:len], Xmeasurements, 'g');
plot(filtration(1, :), 'r');
legend('True trajectory', 'Measurements', 'Kalman Filter');
title('Kalman filter');
xlabel('Time');
ylabel('Position');

% M runs
M = 500;
ErrorsFiltered = zeros(M, len);
ErrorsPrediction = zeros(M, len);
Errors_mSteps = zeros(M, len);
for i = 1 : M
    Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
    Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr, P);
    [prediction, Pprediction, filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
    extrapolation_m_steps = extrapolation_mSteps(filtration, m, T);
    ErrorsFiltered(i, :) = errorOfEstimation(Xtrue, filtration);
    ErrorsPrediction(i, :) = errorOfEstimation(Xtrue, prediction);
    Errors_mSteps(i, :) = errorOfEstimation(Xtrue, extrapolation_m_steps);
end

% Dynamics of mean-squared error of estimaiton
FinalErrorFiltered = zeros(1, len);
FinalErrorPredicted = zeros(1, len);
FinalError_mSteps = zeros(1, len);
% P
FinalErrorFilteredP = zeros(1, len);
FinalErrorPredictedP = zeros(1, len);
for i = 1:len
    for Run = 1:M
        FinalErrorFiltered(i) = FinalErrorFiltered(i) + ErrorsFiltered(Run, i);
        FinalErrorPredicted(i) = FinalErrorPredicted(i) + ErrorsPrediction(Run, i);
        FinalError_mSteps(i) = FinalError_mSteps(i) + Errors_mSteps(Run, i);
    end
    FinalErrorFiltered(i) = sqrt(FinalErrorFiltered(i) / (M + 1));
    FinalErrorPredicted(i) = sqrt(FinalErrorPredicted(i) / (M + 1));
    FinalError_mSteps(i) = sqrt(FinalError_mSteps(i) / (M + 1));
end


% Calculate sqrt of diagonal elements of Psmooth
sqrt_Pfiltation = zeros(1, len);
sqrt_Pprediction = zeros(1, len);
for i=1:len
    sqrt_Pfiltation(i) = sqrt(Pfiltration(1, 1, i));
    sqrt_Pprediction(i) = sqrt(Pprediction(1, 1, i));
end

%display Final Error
figure
hold on;
grid on;
subplot(3,2,[1,2]);
plot([1:len], FinalErrorFiltered, 'r', [1:len], sqrt_Pfiltation, 'b');
title('Dynamics of mean-squared error of filtration');
legend('True Error', 'Sqrt of P');
xlabel('Time');
ylabel('Final Error');
grid on;
subplot(3,2,[3,4]);
plot([1:len], FinalErrorPredicted, 'r', [1:len], sqrt_Pprediction, 'b');
title('Dynamics of mean-squared error of 1-step prediction');
legend('True Error', 'Sqrt of P');
xlabel('Time');
ylabel('Final Error');
grid on;
subplot(3,2,[5,6]);
plot([1:len], FinalError_mSteps, 'r');
title('Dynamics of mean-squared error of 7-step prediction');
xlabel('Time');
ylabel('Final Error');
grid on;