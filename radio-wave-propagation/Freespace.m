% Nom:hamnouche Prénom : Houcine promotion : ige45
function [Pr_dBm] = friisfreespace(Pt_dBm, Gt_dBi, Gr_dBi, f, d, L, n)
lambda = 3 * 10^8 / f;
Pt_W = 1e-3 * 10^(Pt_dBm/10);
Pr = (Pt_W * Gt_dBi * Gr_dBi * (lambda).^2) ./ ((4 * pi * d).^2 * L);
Pr_dBm = 10*log10(Pr*1e3);
end

% Input parameters
Pt_dBm = 0; % Tx power (dBm)
Gt_dBi = 1; % Tx antenna gain (dBi)
Gr_dBi = 1; % Rx antenna gain (dBi)
exponents = [0, 1, 2, 3, 4, 5]; % Distances in powers of 2
distances = 2 .^ exponents;
d = kron(distances, ones(1, length(exponents))); % Array of distances (m)
L = 1; % System Losses, No Loss case L=1
n = 2; % Path loss exponent for Free space
f = 2.4e9; % Signal frequency (Hz)

% Simulation
[Pr1_dBm] = friisfreespace(Pt_dBm, Gt_dBi, Gr_dBi, f, d, L, n);
plot(d, Pr1_dBm, 'b-o'); hold on;
f = 5e9; % Signal frequency (Hz)
[Pr2_dBm] = friisfreespace(Pt_dBm, Gt_dBi, Gr_dBi, f, d, L, n);
plot(d, Pr2_dBm, 'r-o');
grid on;
title('Free space path loss');
xlabel('Distance (m)');
ylabel('Received power (dBm)');
set(gca, 'XTick', [1, 2, 4, 8, 16, 32]);
set(gca, 'XTickLabel', {'1', '2', '4', '8', '16', '32'});
