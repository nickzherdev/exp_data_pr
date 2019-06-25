function [z] = generateMeasurementsX(x, variance)
size = length(x);
eta = sqrt(variance).*randn(1, size);
z = x + eta;
end

