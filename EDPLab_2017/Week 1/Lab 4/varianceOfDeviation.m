function [variance] = varianceOfDeviation(surface1,surface2)
% Determine the variance of deviation of surface1 from surface2.
diffData = reshape(surface1,1,[]) - reshape(surface2,1,[]);
variance = mean(diffData.^2);
end

