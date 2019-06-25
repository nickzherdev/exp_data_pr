function [beta] = coeffLSM(F, R)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
R_T = transpose(R)
beta = (inv(R_T * R) * R_T) * F;
end

