function [array] = forwardBackwardExponentialMean(array, direction, num, alpha)
% Applies Backward Exponential Mean to a row/column with number n
% direction is a line, either "row" or "column"
[m, n] = size(array);
if (direction == "row")
    for i = 2:n
        array(num,i) = array(num,i-1) + alpha * (array(num,i) - array(num,i-1));
    end
    for i = n-1:-1:1
        array(num,i) = array(num,i+1) + alpha * (array(num,i) - array(num,i+1));
    end
elseif (direction == "column")
    for i = 2:m
        array(i,num) = array(i-1,num) + alpha * (array(i,num) - array(i-1,num));
    end
    for i = m-1:-1:1
        array(i,num) = array(i+1,num) + alpha * (array(i,num) - array(i+1,num));
    end
    
end
end

