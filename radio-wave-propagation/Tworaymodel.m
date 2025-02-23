function plotTwoRayModel(Pt, Glos, Gref, ht, hr, d, f, R)
    % Two-ray model calculations
    d_los = sqrt((ht - hr)^2 + d.^2);
    d_ref = sqrt((ht + hr)^2 + d.^2);
    lambda = 3 * 10^8 / f;
    phi = 2 * pi * (d_ref - d_los) / lambda;
    s = lambda / (4 * pi) * (sqrt(Glos) ./ d_los + R * sqrt(Gref) ./ d_ref .* exp(1i * phi));
    Pr = Pt * abs(s).^2;
    Pr_norm = Pr / (Pr(find(d >= 10, 1))* 10^(-24.16/10)); % Normalize to 0 dB at log10(d) = 1
    semilogx(d, 10 * log10(Pr_norm)); hold on;

    % Approximate models
    dc = 4 * ht * hr / lambda;
    d1 = 1:0.1:ht; d2 = ht:0.1:dc; d3 = dc:0.1:10^5;
    K_fps = Glos * Gref * lambda^2 / ((4 * pi)^2);
    K_2ray = Glos * Gref * ht^2 * hr^2;
    Pr1 = Pt * K_fps ./ (d1.^2 + ht^2);
    Pr2 = Pt * K_fps ./ d2.^2;
    Pr3 = Pt * K_2ray ./ d3.^4;
    semilogx(d1, 10 * log10(Pr1 / Pr(find(d >= 10, 1))), 'k-.');
    semilogx(d2, 10 * log10(Pr2 / Pr(find(d >= 10, 1))), 'r-.');
    semilogx(d3, 10 * log10(Pr3 / Pr(find(d >= 10, 1))), 'g-.');
    
    % Plot formatting
    title('Two-ray ground reflection model');
    xlabel('log_{10}(d)');
    ylabel('Normalized Received power (in dB)');
end
Pt = 1;           % Transmitted power (mW)
Glos = 1;         % Tx-Rx antenna pattern product in LOS
Gref = 1;         % Tx-Rx antenna pattern product in reflection
ht = 50;          % Tx antenna height (m)
hr = 2;           % Rx antenna height (m)
d = 1:0.1:10^5;   % Distance between antennas (m)
f = 900e6;        % Transmission frequency (Hz)
R = -1;           % Reflection coefficient

plotTwoRayModel(Pt, Glos, Gref, ht, hr, d, f, R);
