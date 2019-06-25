function [outArray] = smooth(inpArray)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
n = length(inpArray);
coef = [1/24, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/12, 1/24];
outArray = zeros(n, 1);
outArray(1:6) = mean(inpArray(1:6));
outArray(n - 5:n) = mean(inpArray(n - 5:n));
for i = 7:(n - 6)
    for j = (1:13)
        outArray(i) = outArray(i) + coef(j) * inpArray(i + j - 7);
    end
end
end

