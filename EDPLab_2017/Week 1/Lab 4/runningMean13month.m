function [smoothData] = runningMean13month(data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
n = length(data);
coef = [1/24, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/24];
smoothData = zeros(n, 1);
smoothData(1:6) = mean(data(1:6));
smoothData(n - 5:n) = mean(data(n - 5:n));
for i = 7:(n - 6)
    for j = (1:13)
        smoothData(i) = smoothData(i) + coef(j) * data(i + j - 7);
    end
end
end

