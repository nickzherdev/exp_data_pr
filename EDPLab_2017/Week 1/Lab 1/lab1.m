% Title: Relationship between solar radio flux F10.7 and sunspot number
% Viktor Liviniuk, Alina Liviniuk, Sergei Vostrikov
% Skoltech
% 2017

%importing data
Data = importdata("data_group1.mat");
solarRadioFlux = Data(:,3);
sunspotNumber = Data(:,4);
time = Data(:,1) + Data(:,2) / 12;

% prepare figure
figure
hold on;
grid on;

% % plot data and smoothed data
% plot(time,sunspotNumber);
% plot(time,solarRadioFlux);
% plot(time,smooth(sunspotNumber));
% plot(time,smooth(solarRadioFlux)); 
% title('Mean sunspot number and solar radio flux F10.7cm');
% xlabel('Year');
% ylabel('Sunspot number/Solar radio flux');
% legend('Sunspot Number', 'Solar Radio Flux', 'Sunspot Number (Smooth)', 'Solar Radio Flux (Smooth)');
% hello

% determine smoothed data
sunspotNumberSmooth = smooth(sunspotNumber);
solarRadioFluxSmooth = smooth(solarRadioFlux);

% raw and smoothed scatter plot between monthly mean sunspot number and solar radio flux F10.7cm
scatter(sunspotNumber, solarRadioFlux);
scatter(sunspotNumberSmooth, solarRadioFluxSmooth);
title('Plot between monthly mean sunspot number and solar radio flux F10.7cm');
xlabel('Monthly mean sunspot number');
ylabel('Solar radio flux F10.7cm');

% Construction of multi-dimensional linear regression.
len = length(sunspotNumber);
beta = zeros(4, 1);
F = smooth(solarRadioFlux);
% create R
R = ones(len, 4);
for i = 1:len
    R(i, 2) = sunspotNumberSmooth(i);
    R(i, 3) = sunspotNumberSmooth(i) ^ 2;
    R(i, 4) = sunspotNumberSmooth(i) ^ 3;
end
% Determine vector of coefficients by LSM
beta = coeffLSM(F,R);

% Reconstructing the flux on the basis of sunspot number using Equation (1)
F_reconstructed = [1:len];
for i = 1:len
    F_reconstructed(i) = beta(1) + sunspotNumberSmooth(i) * beta(2) + (sunspotNumberSmooth(i) ^ 2) * beta(3) + (sunspotNumberSmooth(i) ^ 3) * beta(4);
end
% plot reconstructed F
scatter(sunspotNumberSmooth, F_reconstructed);

% Determine the variance of estimation error of solar radio flux at 10.7
sigmaSqr = 0;
for i = 1:len
    sigmaSqr = sigmaSqr + (solarRadioFluxSmooth(i) - F_reconstructed(i))^2
end
sigmaSqr = sigmaSqr / (len - 1);

legend('raw data', 'smoothed by 13-month mean', 'reconstructed flux');