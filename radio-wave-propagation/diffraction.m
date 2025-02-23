% Nom:hamnouche Prénom : Houcine promotion : ige45
function [Gv] = diffractionLoss(v)
% Compute diffraction loss G(v) dB for Fresnel-Kirchoff parameter (v)
% according to Rec. ITU-R P.526-5
Gv = zeros(1, length(v));
idx = (v > -0.7); % Indices where v > 0.7
Gv(idx) = 6.9 + 20 * log10(sqrt((v(idx) - 0.1).^2 + 1) + v(idx) - 0.1);
Gv(~idx) = 0; % For v < -0.7
end

v = -5:1:20; % Range of Fresnel-Kirchoff diffraction parameter
Ld = diffractionLoss(v); % Diffraction gain/loss (dB)
plot(v, -Ld);
title('Diffraction Gain Vs. Fresnel-Kirchoff parameter');
xlabel('Fresnel-Kirchoff parameter (v)');
ylabel('Diffraction gain - G_d(v) dB');
