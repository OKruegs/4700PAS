winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
% Set the default figure window style to either 'docked' or 'normal'.

set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% Set the default font size and font name for axes in figures.

% set(0,'defaultfigurecolor',[1 1 1])
% Uncomment to set the default background color of figures to white.

% clear VARIABLES;
clear
% Clear all variables in the workspace.

global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight
% Declare global variables.

dels = 0.75;
spatialFactor = 1;
% Initialize variables `dels` and `spatialFactor`.

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);
% Define constants related to electromagnetic waves.

tSim = 200e-15
f = 300e12;
lambda = c_c/f;
% Set simulation time, frequency, and wavelength.

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};
% Set spatial parameters for the simulation grid.

Reg.n = 1;
% Set the number of regions to 1.

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0; %adds inclusions
%epi{1}(125:150,55:95)= c_eps_0*11.3;

%added inclusion
epi{1}(1:20,80:150)= c_eps_0*11.3;
epi{1}(1:20,1:60)= c_eps_0*11.3;

epi{1}(181:200,80:150)= c_eps_0*8.3;
epi{1}(181:200,1:60)= c_eps_0*8.3;

epi{1}(120:160,80:150)= c_eps_0*8.3;
epi{1}(120:160,1:60)= c_eps_0*8.3;

epi{1}(50:90,80:150)= c_eps_0*11.3;
epi{1}(50:90,1:60)= c_eps_0*11.3;

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});
% Initialize material properties (permittivity, permeability, conductivity) for the simulation region.

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx
% Set time and space discretization parameters.

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];
% Set plotting parameters.

% Add multiple sources
bc{1}.NumS = 3; % Set the total number of sources

% Source 1
bc{1}.s(1).xpos = nx{1}/4 + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;


% Source 2
bc{1}.s(2).xpos = 3 * nx{1}/4 + 1;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;

% Source 3
bc{1}.s(3).xpos = nx{1}/2 + 1;
bc{1}.s(3).type = 'ss';
bc{1}.s(3).fct = @PlaneWaveBC;

% mag = -1/c_eta_0;
mag = 3;            % Magnitude of the source
phi = 0;            % Phase of the source in degrees
omega = f*2*pi;     % Angular frequency
betap = 0;          % Phase velocity
t0 = 30e-15;        % Time offset
st = -0.05;         % Temporal width of the source
s = 0;              % Skewness parameter (set to 0)
y0 = yMax/2;        % Initial y-position of the source
sty = 1.5*lambda;   % Spatial width of the source
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
bc{1}.s(2).paras = {mag, phi + 45, omega, betap, t0, -0.05, s, y0, sty, 's'};
bc{1}.s(3).paras = {mag, phi - 45, omega, betap, t0, -0.05, s, y0, sty, 's'};
% Set parameters for the plane wave source.

Plot.y0 = round(y0/dx);
% Set the initial position of the plane wave source.

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';
% Set the boundary conditions for the simulation domain.

pml.width = 20 * spatialFactor;
pml.m = 3.5;
% Set Perfectly Matched Layer (PML) parameters.

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;
% Set region parameters.

RunYeeReg
% Run the Yee grid simulation based on the specified parameters.

%3. b) Fundemental 2-Dimensional Yee finite difference time domain code





