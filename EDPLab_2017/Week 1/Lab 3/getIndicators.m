function [deviationIndicator, variabilityIndicator] = getIndicators(measurements,estimation)
% Determine deviation and variability indicators of estimation of
% trajectory by measurements
len = length(measurements);
deviationIndicator = 0;
variabilityIndicator = 0;
for i = 1:len
    deviationIndicator = deviationIndicator + (measurements(i) - estimation(i))^2;
end
for i = 1:len-2
    variabilityIndicator = variabilityIndicator + (estimation(i+2) - 2*estimation(i+1) + estimation(i))^2;
end
end

