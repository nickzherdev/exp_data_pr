function [trajectory, velocity, acceleration] = trajectoryGenerate2(len, initialX, initialV, T, varianceA)
% Generate a true trajectory of an object motion disturbed by normally \
% distributed random acceleration
trajectory = zeros(len,1);
trajectory(1) = initialX;
velocity = zeros(len,1);
velocity(1) = initialV;
acceleration = sqrt(varianceA).*randn(len,1);
for i = 2:len
    velocity(i) = velocity(i - 1) + T * acceleration(i - 1);
    trajectory(i) = trajectory(i - 1) + T * velocity(i - 1) + T^2 * acceleration(i - 1) / 2;
end
end

