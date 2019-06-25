function [filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial)
% Develop Kalman filter algorithm to estimate state vector
G = [T^2; T];
F = [1, T; 0, 1];
Ftransposed = transpose(F);

prediction = zeros(2, len);
Pprediction = zeros(2, 2, len);

Q = G * transpose(G) * sigma_a_sqr;
%Q = 0;
H = [1, 0];
Htransposed = [1; 0];
I = eye(2);

filtration = zeros(2, len);
Pfiltration = zeros(2, 2, len);
R = sigma_eta_sqr;
K = zeros(2, len);

% first step
Xinivial = [2; 0];
Xinivial = [100; 5];
% Prediction
prediction(:, 1) = F * Xinivial;
Pprediction(:, :, 1) = F * Pinitial * Ftransposed + Q;
% Filtration
%K(:, 1) = Pprediction(:, :, 1) * Htransposed * inv(H * Pprediction(:, :, 1) * Htransposed + R);
K(:, 1) = [0.132; 0.009] / 5;
filtration(:, 1) = prediction(:, 1) + K(:, 1) * (Xmeasurements(1) - H * prediction(:, 1));
Pfiltration(:, :, 1) = (I - K(:, 1) * H) * Pprediction(:, :, 1);

for i = 2:len
    % Prediction
    prediction(:, i) = F * filtration(:, i - 1);
    Pprediction(:, :, i) = F * Pfiltration(:, :, i - 1) * Ftransposed + Q;
    % Filtration
    %K(:, i) = Pprediction(:, :, i) * Htransposed * inv(H * Pprediction(:, :, i) * Htransposed + R);
    K(:, i) = [0.132; 0.009] / 5;
    filtration(:, i) = prediction(:, i) + K(:, i) * (Xmeasurements(i) - H * prediction(:, i));
    Pfiltration(:, :, i) = (I - K(:, i) * H) * Pprediction(:, :, i);
end
end

