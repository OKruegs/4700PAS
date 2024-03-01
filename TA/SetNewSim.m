%Determines if different parts of the simulation are connected 
% or dependent on each other. When set to 1, it means 
% these parts affect each other's behavior
Coupled = 1;

% Indicates whether the simulation models both electrons and 
% holes (the two main charge carriers in semiconductors). 
% If set to 1, the simulation considers both types; 
% if set to 0, it considers only one type
TwoCarriers = 1;

%Represents the inclusion of effects related to time constants 
% or delays in the simulation. When set to 1, 
% it means these effects are included, 
% which can affect how quickly the system responds to changes.
RC = 1;

nx = 201;
l = 1e-6;

x =linspace(0,l,nx);
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx;

% Nd = 1e16 * 1e6; % Const. 1/cm3 (100 cm/m)^3
% NetDoping = ones(1,nx).*Nd; % doping

% % Linear gradient doping profile
% A linear gradient in a semiconductor junction creates a 
% gradual change in doping concentration or electric field 
% strength along its length

% Nd_min = 1e16 * 1e6; % Minimum doping concentration (1e16 cm^-3)
% Nd_max = 20e16 * 1e6; % Maximum doping concentration (20e16 cm^-3)
% 
% gradient_slope = (Nd_max - Nd_min) / l; % Slope of the gradient
% 
% % Calculate doping profile
% NetDoping = Nd_min + gradient_slope * x;

% Define exponential gradient parameters
%An exponential gradient in a semiconductor junction involves a 
% dopant concentration or electric field strength that changes 
% rapidly over distance, following an exponential pattern

Nd_min = 1e16 * 1e6; % Minimum doping concentration (1e16 cm^-3)
Nd_max = 20e16 * 1e6; % Maximum doping concentration (20e16 cm^-3)
decay_constant = 0.1 * l; % Decay constant for the exponential gradient

% Calculate doping profile
gradient_factor = exp(decay_constant * (x - x(1)) / l);
NetDoping = Nd_min + (Nd_max - Nd_min) * gradient_factor;

x0 = l/2;
nw = l/20;
% npDisturbance = 1e16*1e6*exp(-((x-x0)/nw).^2);
npDisturbance = 0;

LVbc = 0;
RVbc = 0;

TStop = 14200000*1e-18;
PlDelt = 100000*1e-18;

% PlotYAxis = {[-1e-15 2e-15] [-2e-9 2e-9] [-1.5e-12 1.5e-12]...
%     [1e22 2e22] [0 1e22] [0 20e43]...
%     [-20e33 15e33] [-2.5e34 2e34] [-1.1e8 1.1e8] ...
%     [-1e8 1e8] [-10e-3 10e-3] [0 2e22]};


doPlotImage = 0;
PlotFile = 'Gau2CarRC.gif';