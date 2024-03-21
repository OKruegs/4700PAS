% Constants
Is = 0.01e-12; % 0.01pA
Ib = 0.1e-12; % 0.1pA
Vb = 1.3; % V
Gp = 0.1; % Ω^-1

% Create V vector
V = linspace(-1.95, 0.7, 200);

% Calculate I vector without noise
I = Is.*(exp(1.2*V/25e-3)-1) + Gp.*V - Ib*(exp(1.2*(-(V+Vb))/25e-3)-1);

% Add 20% random variation to the current to represent experimental noise
noise_percentage = 0.20;
noise_amplitude = noise_percentage .* I;
noise = noise_amplitude .* randn(size(I));
I_noisy = I + noise;

% Plot data
figure;
subplot(2, 1, 1);
plot(V, I_noisy);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Noisy Current-Voltage Characteristic');
grid on;

subplot(2, 1, 2);
semilogy(V, abs(I_noisy));
xlabel('Voltage (V)');
ylabel('Absolute Current (A)');
title('Semilog Plot of Noisy Current-Voltage Characteristic');
grid on;

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
