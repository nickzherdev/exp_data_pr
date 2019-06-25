function [trajectory] = trajectoryGenerate22(len, initialA, T, varianceA)
% Generate a true trajectory of an object motion disturbed by normally \
% distributed random acceleration
w = 2*pi/T; 
trajectory = zeros(len,1);
trajectory(1) = 0;
A = zeros(len,1);
A(1) = initialA;
noise = sqrt(varianceA).*randn(len,1);
for i = 2:len
    A(i) = A(i - 1) + noise(i - 1);
end
for i = 1:len
    trajectory(i) = A(i) * sin(w*i + 3);
end
end

