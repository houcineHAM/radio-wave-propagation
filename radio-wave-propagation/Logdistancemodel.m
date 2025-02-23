% Nom:hamnouche Prénom : Houcine promotion : ige45
% Calculates the received power using the Friis Free Space model
function [Pr_dBm] = friisfreespace(Pt_dBm, Gt_dBi, Gr_dBi, f, d, L, n)
lambda = 3 * 10^8 / f; % Wavelength in meters
Pr_dBm =  Pt_dBm + Gt_dBi + Gr_dBi + 20*log10(lambda/(4*pi))-10*n*log10(d)-10*log10(L);
end

% Calculates the received power with log distance shadowing model
function [PL, Pr_dBm] = logdistance(Pt_dBm, Gt_dBi, Gr_dBi, f, d0, d, L, sigma, n)
lambda = 3 * 10^8 / f; % Wavelength in meters
K = 20*log10(lambda/(4*pi)) - 10*n*log10(d0) - 10*log10(L); % Path-loss factor
X = sigma*randn(1,numel(d)); % Normal random variable
PL = Gt_dBi + Gr_dBi + K -10*n*log10(d/d0) - X; % Path loss including antenna gains
Pr_dBm = Pt_dBm + PL; % Received power in dBm
end

% Input parameters
Pt_dBm = 0; % Transmitted power in dBm
Gt_dBi = 1; % Transmitter antenna gain in dBi
Gr_dBi = 1; % Receiver antenna gain in dBi
f = 2.4e9; % Transmitted signal frequency in Hertz
d0 = 1; % Reference distance in meters
d = 100 * (1:0.2:100); % Array of distances to simulate
L = 1; % Other system losses
sigma = 2; % Standard deviation of log-normal shadowing in dB
n = 2; % Path loss exponent

% Log distance shadowing model
[PL_shadow, Pr_shadow] = logdistance(Pt_dBm, Gt_dBi, Gr_dBi, f, d0, d, L, sigma, n);
figure;
plot(d, Pr_shadow, 'b');
hold on;

% Friis Free Space model
[Pr_Friss] = friisfreespace(Pt_dBm, Gt_dBi, Gr_dBi, f, d, L, n);
plot(d, Pr_Friss, 'r');
grid on;

xlabel('Distance (m)');
ylabel('Received Power (dBm)');
title('Log Distance Shadowing Model');
legend('Log distance shadowing', 'Friis Free Space model');
