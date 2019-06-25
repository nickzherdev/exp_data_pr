function [trajectory, steps] = trajectoryGenerate(len, initialCondition, variance)
% Generate a true trajectory with length len using the random walk model 
% with zero mathematical expectation and given variance and initialCondition
trajectory = zeros(len,1);
trajectory(1) = initialCondition;
steps = sqrt(variance).*randn(len,1);
for i = 2:len
    trajectory(i) = trajectory(i - 1) + steps(i);
end
end

