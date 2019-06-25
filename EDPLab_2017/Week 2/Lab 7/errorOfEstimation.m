function [error_x, error_V] = errorOfEstimation(Xtrue, Xestimated)
len = length(Xtrue);
error_x = zeros(1, len);
error_V = zeros(1, len);
for i = 1:len
    error_x(1, i) = (Xtrue(1, i) - Xestimated(1, i))^2;
    error_V(1, i) = (Xtrue(2, i) - Xestimated(2, i))^2;
end
end

