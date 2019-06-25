function [measurements, measurementsNoise] = measurementsGenerate(trajectory, measurementsVariance)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
len = length(trajectory);
measurements = zeros(len,1);
measurementsNoise = sqrt(measurementsVariance).*randn(len,1);
for i = 1:len
    measurements(i) = trajectory(i) + measurementsNoise(i);
end
end

