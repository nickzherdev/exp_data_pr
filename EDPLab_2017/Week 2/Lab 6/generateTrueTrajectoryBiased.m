function [X] = generateTrueTrajectoryBiased(size, x1, V1, T, variance, bias)
% Generate a true trajectory ?? of an object motion disturbed by normally 
% distributed random acceleration
% Output X is an array of state vectors [x, V] (it's final size is [2, size])

X = zeros(2, size);
X(:, 1) = [x1; V1];
aBiased = sqrt(variance).*randn(1, size) + bias;
G = [T^2; T];
F = [1, T; 0, 1];

for i = 2:size
    X(:, i) = F * X(:, i - 1) + G * aBiased(i - 1);
end
    
end

