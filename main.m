clear all;  clc; close all;

% Define parameters
g = 9.81; % acceleration due to gravity (m/s^2)
W = 150; % weight of aircraft (N)
mu = 0.1; % coefficient of friction between tires and runway
rho = 1.225; % air density (kg/m^3)
S = 1.02; % wing area (m^2)
T0 = 40; % thrust at sea level (N)
a = -0.0242;
b = -0.6843;

% Read plane/wing data
wing = readtable('T1-13_0 m_s-Panel.txt');
CD = wing.CD(21); % drag coefficient
CL = wing.CL(21); % lift coefficient
CLmax = wing.CL(51); % maximum lift coefficient

% Define stall velocity
Vs = (sqrt(2 * W/(rho * CLmax * S)));

% Define take-off velocity
Vto = 1.2 * (sqrt(2 * W/(rho * CLmax * S)));

% Define ODE function
f = @(t, y) (g/W) * ((a * y^2 + b * y + T0)-(CD * 0.5 * rho * S * y^2)- mu *(W - (CL * 0.5 * rho * S * y^2)));

% Define initial conditions
V0 = 0;

% Define time
tspan = [0, 15];

% Solve ODE using ode45
[t, V] = ode45(f, tspan, V0);

% Integrate velocity to obtain distance
D = cumtrapz(t, V);

% Define required thrust
U = Vs:.1:25;
CLreq = (2 * W)./(rho * S * U.^2);
CDreq = interp1(wing.CL, wing.CD, CLreq, 'spline');
Treq = W./(CLreq./CDreq);
T = a * U.^2 + b * U + T0;

% Plot results    
% run graphs.m
