Coupled = 1;
TwoCarriers = 1;
RC = 1;

nx = 201;
l = 1e-6;

x = linspace(0, l, nx);
dx = x(2) - x(1);
xm = x(1:nx-1) + 0.5 * dx;

% Define linearly graded doping profile
Nd_max = 4e16 * 1e6; % Maximum doping concentration
Na_max = 1e16 * 1e6;
Nd_min = 1e16 * 1e6; % Minimum doping concentration
Na_min = 4e16 * 1e6;

Nd = linspace(Nd_max, Nd_min, nx); % Linearly varying N-doping
Na = linspace(Na_max, Na_min, nx); % Linearly varying P-doping

NetDoping = Nd - Na;

x0 = l / 2;
nw = l / 20;
npDisturbance = 0e16 * 1e6 * exp(-((x - x0) / nw).^2);

JBC = 1;

RVbc = 0;

TStop = 80000000 * 1e-18;
PlDelt = 1000000 * 1e-18;

Phi = C.Vt * log(Na_max * Nd_max / (niSi * niSi));
W = sqrt(2 * EpiSi * (Nd_max + Nd_max) * (Phi) / (C.q_0 * Nd_max * Na_max));
Wn = W * Na_max / (Nd_max + Na_max);
Wp = (W - Wn);

LVbc = Phi;

PlotSS = 0;
% PlotYAxis = {[0 Phi + 0.1] [0e5 40e5] [-20e2 40e2] ...
%     [0e21 2.5e22] [0 1.1e22] [0 20e43] ...
%     [-5e33 5e33] [-5e33 5e33] [-0e8 3e8] ...
%     [1e-3 1e8] [-3e6 1e6] [0 2.5e22]};
doPlotImage = 0;

SecondSim = 1;
LVbc2 = Phi - 0.3;
TStop2 = TStop + 80000000 * 1e-18;

fprintf('Phi: %g W: %g Wn: %g Wp: %g \n', Phi, W, Wn, Wp);
