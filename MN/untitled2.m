% Define parameters
G1 = 1;
C1 = 0.25;
G2 = 2;
L = 0.2;
G3 = 10;
alpha = 100;
G4 = 0.1;
Go = 1000;
omega = pi; % example frequency
Vin = 1; % example input voltage

% Define range for input voltage V1 (for DC analysis)
V1_range = linspace(-10, 10, 100); % DC sweep range

% Preallocate arrays for results
Vo_dc = zeros(size(V1_range));
V3_dc = zeros(size(V1_range));


% Loop over DC voltage range
for i = 1:length(V1_range)
    Vin = V1_range(i); % Set input voltage for DC analysis

    % Construct the conductance matrix G
    G = [1, 0, 0, 0, 0, 0, 0;
        0,G1, -G1, 0, 0, 0, 0;
        0, G1, G2-G1, 0, 0, 0, 0;
        0, 0, 0, G3, 0, 0, 0;
        0, 0, 0, alpha*G3, 1, 0, 0;
        0, 0, 0, -G3, G4, -G4, -1;
        0, 0, 0, 0, -G4, G4+Go, 0];

    % Construct the capacitance matrix C
    C = [C1, (-C1), 0, 0, 0, 0, 0;
         (-C1), C1, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0];

    
    % Define the right-hand side vector F
    F = [Vin; 0; 0; 0; 0; 0; 0];

    % Construct the complex matrix G + jωC
    G_complex = G + (1i * omega * C);

    % Solve for V
    V = (G_complex)\F;

    % Store Vo and V3 for DC analysis
    Vo_dc(i) = V(5); % Vo is the 5th element of V
    V3_dc(i) = V(3); % V3 is the 3rd element of V

end

% Plot results for DC case
plot(V1_range, Vo_dc, 'b', V1_range, V3_dc, 'r');
xlabel('Input Voltage (V1)');
ylabel('Voltage (V)');
legend('Vo', 'V3');
title('DC Case: Vo and V3 vs. V1');



