function [smooth, Psmooth] = backwardSmooth(filtration, Pfiltration, Pprediction, T)
N = length(filtration);
smooth = zeros(2, N);
smooth(:, N) = filtration(:, N);
F = [1, T; 0, 1];
A = zeros(2, 2, N);
Psmooth = zeros(2, 2, N);
Psmooth(:, :, N) = Pfiltration(:, :, N);

for i = N-1:-1:1
    A(:, :, i) = Pfiltration(:, :, i) * transpose(F) * inv(Pprediction(:, :, i + 1));
    smooth(:, i) = filtration(:, i) + A(:, :, i) * (smooth(:, i + 1) - F * filtration(:, i));
    Psmooth(:, :, i) = Pfiltration(:, :, i) + A(:, :, i) * (Psmooth(:, :, i + 1) - Pprediction(:, :, i + 1)) * transpose(A(:, :, i));
end
end

