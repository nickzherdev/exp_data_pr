function [error] = errorOfEstimation(Xtrue, Xestimated)
len = length(Xtrue);
error = zeros(1, len);
for i = 1:len
    error(1, i) = (Xtrue(1, i) - Xestimated(1, i))^2;
end
end

