function [extrapolation_m_steps] = extrapolation_mSteps(filtration, m, T)
%UNTITLED3 Summary of this function goes here
len = length(filtration);
extrapolation_m_steps = zeros(2, len);
Fm = [1, T; 0, 1] ^ m;
for i = m:len
    extrapolation_m_steps(:, i) = Fm * filtration(:, i - m + 1); 
end
end

