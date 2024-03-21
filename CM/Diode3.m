% Constants
Is = 0.01e-12; % 0.01pA
Ib = 0.1e-12; % 0.1pA
Vb = 1.3; % V
Gp = 0.1; % Ω^-1

% Create V vector
V = linspace(-1.95, 0.7, 200)';

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

% Fit using Neural Net model
inputs = V';
targets = I_noisy';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);

% Calculate errors and performance
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);

% View the neural network
view(net)

% Plot data with polynomial and neural net fits
figure;
subplot(2, 1, 1);
plot(V, I_noisy, 'b', V, I_order_4_fit, 'r--', V, I_order_8_fit, 'g--', V, outputs, 'm--');
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Noisy Current-Voltage Characteristic with Fits');
legend('Experimental Data', '4th Order Poly Fit', '8th Order Poly Fit', 'Neural Net Fit');
grid on;

subplot(2, 1, 2);
semilogy(V, abs(I_noisy), 'b', V, abs(I_order_4_fit), 'r--', V, abs(I_order_8_fit), 'g--', V, abs(outputs), 'm--');
xlabel('Voltage (V)');
ylabel('Absolute Current (A)');
title('Semilog Plot of Noisy Current-Voltage Characteristic with Fits');
legend('Experimental Data', '4th Order Poly Fit', '8th Order Poly Fit', 'Neural Net Fit');
grid on;
