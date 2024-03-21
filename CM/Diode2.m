% Constants
Is = 0.01e-12; % 0.01pA
Ib = 0.1e-12; % 0.1pA
Vb = 1.3; % V
Gp = 0.1; % Ω^-1

% Create V vector
V = linspace(-1.95, 0.7, 200);

% Calculate I vector without noise
I = Is * (exp((V - Vb) / (0.0259)) - 1) + Gp * V - Ib;

% Add 20% random variation to the current to represent experimental noise
noise_percentage = 0.20;
noise_amplitude = noise_percentage .* I;
noise = noise_amplitude .* randn(size(I));
I_noisy = I + noise;

% Fit polynomials
order_4_fit = polyfit(V, I_noisy, 4);
order_8_fit = polyfit(V, I_noisy, 8);

% Evaluate polynomial fits
I_order_4_fit = polyval(order_4_fit, V);
I_order_8_fit = polyval(order_8_fit, V);

% Plot data with polynomial fits
figure;
subplot(2, 1, 1);
plot(V, I_noisy, 'b', V, I_order_4_fit, 'r--', V, I_order_8_fit, 'g--');
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Noisy Current-Voltage Characteristic with Polynomial Fits');
legend('Experimental Data', '4th Order Fit', '8th Order Fit');
grid on;

subplot(2, 1, 2);
semilogy(V, abs(I_noisy), 'b', V, abs(I_order_4_fit), 'r--', V, abs(I_order_8_fit), 'g--');
xlabel('Voltage (V)');
ylabel('Absolute Current (A)');
title('Semilog Plot of Noisy Current-Voltage Characteristic with Polynomial Fits');
legend('Experimental Data', '4th Order Fit', '8th Order Fit');
grid on;

% Nonlinear curve fitting
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff_a_c = fit(V', I_noisy', fo, 'StartPoint', [1e-11, 0.1e-11, 1e-12, 1.3]);
ff_a_b_c = fit(V', I_noisy', fo, 'StartPoint', [1e-11, 0.1e-11, 1e-12, 1.3]);
ff_all = fit(V', I_noisy', fo);

% Generate curves
If_a_c = ff_a_c(V);
If_a_b_c = ff_a_b_c(V);
If_all = ff_all(V);

% Plot data with fitted curves
figure;
subplot(2, 1, 1);
plot(V, I_noisy, 'b', V, If_a_c, 'r--', V, If_a_b_c, 'g--', V, If_all, 'k--');
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Noisy Current-Voltage Characteristic with Fitted Curves');
legend('Experimental Data', 'A and C Fitted', 'A, B, and C Fitted', 'All Parameters Fitted');
grid on;

subplot(2, 1, 2);
semilogy(V, abs(I_noisy), 'b', V, abs(If_a_c), 'r--', V, abs(If_a_b_c), 'g--', V, abs(If_all), 'k--');
xlabel('Voltage (V)');
ylabel('Absolute Current (A)');
title('Semilog Plot of Noisy Current-Voltage Characteristic with Fitted Curves');
legend('Experimental Data', 'A and C Fitted', 'A, B, and C Fitted', 'All Parameters Fitted');
grid on;
