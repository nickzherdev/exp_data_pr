% Title: Development of optimal smoothing to increase the estimation accuracy
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017


T = 1;
len = 200;
sigma_a_sqr = 0.2^2;
sigma_eta_sqr = 20^2;
Pinitial = [10000, 0; 0, 10000];

Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
[prediction, Pprediction, filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
[smooth, Psmooth] = backwardSmooth(filtration, Pfiltration, Pprediction, T);

% display
figure
hold on;
grid on;
plot(Xtrue(1, :), 'k');
plot(Xmeasurements, 'g');
plot(filtration(1, :), 'r');
plot(smooth(1, :), 'b');
legend('True trajectory', 'Measurements', 'Kalman Filter', 'Backward Smoothing');
title('Kalman filter');
xlabel('Time');
ylabel('Position');

% M runs
M = 500;
Errors_x = zeros(M, len);
Errors_V = zeros(M, len);
for i = 1 : M
    Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
    Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
    [prediction, Pprediction, filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
    [smooth, Psmooth] = backwardSmooth(filtration, Pfiltration, Pprediction, T);
    [Errors_x(i, :), Errors_V(i, :)] = errorOfEstimation(Xtrue, smooth);
end

% Dynamics of mean-squared error of estimaiton
FinalError_x = zeros(1, len);
FinalError_V = zeros(1, len);
for i = 1:len
    for Run = 1:M
        FinalError_x(i) = FinalError_x(i) + Errors_x(Run, i);
        FinalError_V(i) = FinalError_V(i) + Errors_V(Run, i);
    end
    FinalError_x(i) = sqrt(FinalError_x(i) / (M + 1));
    FinalError_V(i) = sqrt(FinalError_V(i) / (M + 1));
end

% Calculate sqrt of diagonal elements of Psmooth
sqrt_x = zeros(1, len);
sqrt_V = zeros(1, len);
for i=1:len
    sqrt_x(i) = sqrt(Psmooth(1, 1, i));
    sqrt_V(i) = sqrt(Psmooth(2, 2, i));
end

% display Final Error x
figure
hold on;
grid on;
subplot(2,2,[1,2]);
plot([1:len], FinalError_x, 'r', [1:len], sqrt_x, 'b');
legend('x', 'Sqrt of 1st diagonal elements of P');
title('Dynamics of mean-squared error of estimaiton of smoothing');
xlabel('Time');
ylabel('Final Error');

% display Final Error V
subplot(2,2,[3,4]);
plot([1:len], FinalError_V, 'c', [1:len], sqrt_V, 'm');
legend('V', 'Sqrt of 2nd diagonal elements of P');
title('Dynamics of mean-squared error of estimaiton of smoothing');
xlabel('Time');
ylabel('Final Error');