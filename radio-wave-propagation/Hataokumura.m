function PL = hataokumura(fc, d, hb, hm, environment_type)
    % Hata-Okumura model for propagation loss
    % fc - frequency in MHz (single value)
    % d - array of distances (in km) to simulate
    % hb - effective base station height in meters
    % hm - effective mobile height in meters
    % environment_type - 'metro', 'smallcity', 'suburban', or 'open'
    % returns the path loss (PL) in dB

    environment_type = lower(environment_type);

    switch environment_type
        case 'metro'
            C = 0;
            if fc <= 200
                aHm = 8.29 * (log10(1.54 * hm))^2 - 1.1;
            else
                aHm = 3.2 * (log10(11.75 * hm))^2 - 4.97;
            end
        case 'smallcity'
            C = 0;
            aHm = (1.1 * log10(fc) - 0.7) * hm - (1.56 * log10(fc) - 0.8);
        case 'suburban'
            aHm = (1.1 * log10(fc) - 0.7) * hm - (1.56 * log10(fc) - 0.8);
            C = -2 * (log10(fc / 28))^2 - 5.4;
        case 'open'
            aHm = (1.1 * log10(fc) - 0.7) * hm - (1.56 * log10(fc) - 0.8);
            C = -4.78 * (log10(fc))^2 + 18.33 * log10(fc) - 40.98;
        otherwise
            error('Invalid model selection');
    end

    A = 69.55 + 26.16 * log10(fc) - 13.82 * log10(hb) - aHm;
    B = 44.9 - 6.55 * log10(hb);

    PL = A + B * log10(d) + C;
end

% Input parameters
fc = 1500; % frequency in MHz
d = 1:100; % array of distances in km
hb = 70; % height of base station in meters
hm = 1.5; % height of mobile station in meters

% Calculate path loss for different environments
PL_metro = hataokumura(fc, d, hb, hm, 'metro');
PL_suburban = hataokumura(fc, d, hb, hm, 'suburban');
PL_open = hataokumura(fc, d, hb, hm, 'open');

% Plotting
semilogx(d, PL_metro, 'b', 'LineWidth', 2);
hold on;
semilogx(d, PL_suburban, 'r', 'LineWidth', 2);
semilogx(d, PL_open, 'g', 'LineWidth', 2);
xlabel('Distance (km)');
ylabel('Path Loss (dB)');
title('Propagation Path Loss for Different Environments');
legend('Metro', 'Suburban', 'Open');
grid on;

