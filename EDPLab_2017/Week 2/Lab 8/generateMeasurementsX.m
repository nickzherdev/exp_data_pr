function [z] = generateMeasurementsX(x, variance, P)

size = length(x);
z = zeros(1, size);
ksi = rand(size);
eta = sqrt(variance).*randn(1, size);
for i = 1 : size
    if ksi(i) <= P
        z(i) = NaN;
    else
        z(i) = x(i) + eta(i);
    end
end
end

