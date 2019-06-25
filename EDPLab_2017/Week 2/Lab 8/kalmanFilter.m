function [prediction, Pprediction, filtration, Pfiltration, K] = kalmanFilter(T, len, Xmeasurements, sigma_a_sqr, sigma_eta_sqr, Pinitial)
% Develop Kalman filter algorithm to estimate state vector
G = [T^2; T];
F = [1, T; 0, 1];
Ftransposed = transpose(F);

prediction = zeros(2, len);
Pprediction = zeros(2, 2, len);
Q = G * transpose(G) * sigma_a_sqr;
H = [1, 0];
Htransposed = [1; 0];
I = eye(2);

filtration = zeros(2, len);
Pfiltration = zeros(2, 2, len);
R = sigma_eta_sqr;
K = zeros(2, len);

% first step
Xinivial = [2; 0];
% Prediction
prediction(:, 1) = F * Xinivial;
Pprediction(:, :,R 1) = F * Pinitial * Ftransposed + Q;
% Filtration
if isnan(Xmeasurements(1))
    filtration(:, 1) = prediction(:, 1);
    Pfiltration(:, :, 1) = Pprediction(:, :, 1);
else
    K(:, 1) = Pprediction(:, :, 1) * Htransposed * inv(H * Pprediction(:, :, 1) * Htransposed + R);
    filtration(:, 1) = prediction(:, 1) + K(:, 1) * (Xmeasurements(1) - H * prediction(:, 1));
    Pfiltration(:, :, 1) = (I - K(:, 1) * H) * Pprediction(:, :, 1);
end

for i = 2:len
    % Prediction
    prediction(:, i) = F * filtration(:, i - 1);
    Pprediction(:, :, i) = F * Pfiltration(:, :, i - 1) * Ftransposed + Q;
    % Filtration
    if isnan(Xmeasurements(i))
        filtration(:, i) = prediction(:, i);
        Pfiltration(:, :, i) = Pprediction(:, :, i);
    else
        K(:, i) = Pprediction(:, :, i) * Htransposed * inv(H * Pprediction(:, :, i) * Htransposed + R);
        filtration(:, i) = prediction(:, i) + K(:, i) * (Xmeasurements(i) - H * prediction(:, i));
        Pfiltration(:, :, i) = (I - K(:, i) * H) * Pprediction(:, :, i);
    end
end
end

