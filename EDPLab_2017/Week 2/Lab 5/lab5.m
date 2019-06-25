% Title: Tracking of a moving object which trajectory is disturbed by random acceleration
% Group 1: Viktor Liviniuk, Alina Liviniuk
% Skoltech
% 2017

T = 1;
len = 200;
sigma_a_sqr = 0.2^2;
% sigma_a_sqr = 0;
sigma_eta_sqr = 20^2;
Pinitial = [10000, 0; 0, 10000];
m = 7;

Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
[filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
extrapolation_m_steps = extrapolation_mSteps(filtration, m, T);

% display
figure
hold on;
grid on;
plot(Xtrue(1, :), 'k');
plot(Xmeasurements, 'g');
plot(filtration(1, :), 'r');
plot(extrapolation_m_steps(1, :), 'b');
legend('True trajectory', 'Measurements', 'Kalman Filter', '7 steps extrapolation');
title('Kalman filter');
xlabel('Time');
ylabel('Position');

% Plot filter gain K over the whole filtration interval.
figure
hold on;
grid on;
plot(K(1, :), 'b');
%plot(K(2, :), 'r');
legend('1 coordinate', '2 coordinate');
title('Kalman filter - Filter gain');
xlabel('Time');
ylabel('Filter gain');


% % Analyze filtration error covariance matrix
% figure
% hold on;
% grid on;
% temp1 = zeros(len);
% temp2 = zeros(len);
% for i=1:len
%     temp1(i) = sqrt(Pfiltration(1, 1, i));
% end
% plot(temp1, 'b');
% title('To analyse filtration error covariance matrix');
% xlabel('Time');
% ylabel('Sqrt of first element of the matrix');

% M runs of filter
M = 500;
ErrorKalman = zeros(len, M);
Error_mSteps = zeros(len, M);
for j = 1:M
    Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
    Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
    [filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial);
    extrapolation_m_steps = extrapolation_mSteps(filtration, m, T);
    for i = 3:len
        ErrorKalman(i, j) = (Xtrue(1,i) - filtration(1,i))^2;
    end
    for i = m:len
        Error_mSteps(i, j) = (Xtrue(1,i) - extrapolation_m_steps(1,i))^2;
    end
end

FinalErrorKalman = zeros(1, len);
FinalError_mSteps = zeros(1, len);
for i = 3:len
    for Run = 1:M
        FinalErrorKalman(i) = FinalErrorKalman(i) + ErrorKalman(i, Run);
    end
    FinalErrorKalman(i) = sqrt(FinalErrorKalman(i) / (M + 1));
end
for i = m:len
    for Run = 1:M
        FinalError_mSteps(i) = FinalError_mSteps(i) + Error_mSteps(i, Run);
    end
    FinalError_mSteps(i) = sqrt(FinalError_mSteps(i) / (M + 1));
end

% display Final Error
figure
hold on;
grid on;
plot(FinalErrorKalman, 'r');
%plot(FinalError_mSteps, 'b');
legend('Kalman filter', '7 steps extrapolation');
title('Final Error');
%title('Final Error - deterministic model, but random acceleration ');
xlabel('Time');
ylabel('Final Error');

% % Compare calculation errors of estimation provided Kalman filter 
% % algorithm with true estimation errors
% figure
% hold on;
% grid on;
% plot(FinalErrorKalman, 'r');
% temp1 = zeros(len);
% temp2 = zeros(len);
% for i=1:len
%     temp1(i) = sqrt(Pfiltration(1, 1, i));
% end
% plot(temp1, 'b');
% legend('Kalman filter Final error', 'Sqrt of first element of the matrix');
% title('Compare calculation errors');
% xlabel('Time');
% ylabel('Value');


Pinitial2 = [100, 0; 0, 100];
% M runs of filter with another initial matrix P
M = 500;
ErrorKalman2 = zeros(len, M);
Error_mSteps2 = zeros(len, M);
for j = 1:M
    Xtrue = generateTrueTrajectory(len, 5, 1, T, sigma_a_sqr);
    Xmeasurements = generateMeasurementsX(Xtrue(1, :), sigma_eta_sqr);
    [filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial2);
    extrapolation_m_steps = extrapolation_mSteps(filtration, m, T);
    for i = 3:len
        ErrorKalman2(i, j) = (Xtrue(1,i) - filtration(1,i))^2;
    end
    for i = m:len
        Error_mSteps2(i, j) = (Xtrue(1,i) - extrapolation_m_steps(1,i))^2;
    end
end

FinalErrorKalman2 = zeros(1, len);
FinalError_mSteps2 = zeros(1, len);
for i = 3:len
    for Run = 1:M
        FinalErrorKalman2(i) = FinalErrorKalman2(i) + ErrorKalman2(i, Run);
    end
    FinalErrorKalman2(i) = sqrt(FinalErrorKalman2(i) / (M + 1));
end
for i = m:len
    for Run = 1:M
        FinalError_mSteps2(i) = FinalError_mSteps2(i) + Error_mSteps2(i, Run);
    end
    FinalError_mSteps2(i) = sqrt(FinalError_mSteps2(i) / (M + 1));
end

% % display Final Error again
% figure
% hold on;
% grid on;
% plot(FinalErrorKalman, 'r');
% plot(FinalError_mSteps, 'b');
% plot(FinalErrorKalman2, 'g');
% plot(FinalError_mSteps2, 'y');
% legend('Kalman filter', '7 steps extrapolation', 'Kalman filter 2', '7 steps extrapolation 2');
% title('Final Error');
% xlabel('Time');
% ylabel('Final Error');
