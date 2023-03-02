clear all; close all; clc;

% Define parameters
g = 9.81; % acceleration due to gravity (m/s^2)
W = 150; % weight of aircraft (N)
mu = 0.1; % coefficient of friction between tires and runway
rho = 1.225; % air density (kg/m^3)
S = 1.80; % wing area (m^2)
CD = 0.09; % drag coefficient
CL = 0.90; % lift coefficient
CLmax = 1.90; % maximum lift coefficient
T0 = 35; % thrust at sea level (N)
a = -0.0014;
b = -0.40;

% Define stall velocity
Vs = (sqrt(2 * W/(rho * CLmax * S)));

% Define take-off velocity
Vto = 1.2*(sqrt(2 * W/(rho * CLmax * S)));

% Define ODE function
f = @(t, y) (g/W) * ((a * y^2 + b * y + T0)-(CD * 0.5 * rho * S * y^2)- mu *(W - (CL * 0.5 * rho * S * y^2)));

% Define initial conditions
V0 = 0;

% Define time
tspan = [0, 12];

% Solve ODE using ode45
[t, V] = ode45(f, tspan, V0);

% Integrate velocity to obtain distance
D = cumtrapz(t, V);

% Interpolate velocity to obtain distance
Dto = interp1(V,D,Vto,'spline');

% Define Theta in function of velocity
y = Vto:.1:30;
theta = (asin(((a .* y.^2 + b .* y + T0)./W) - (1./((CL * 0.5 * rho * S .* y.^2)./(CD * 0.5 * rho * S .* y.^2))))) * (180/pi);

% Define climb distance
Dc = 0.7./tan(theta.*pi/180);

% Define vertical velocity
Vv = tan(theta * (pi/180)) .* y;

% Plot results

figure()
plot(t, V)
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Velocity vs Time')

figure()
plot(t, D)
xlabel('Time (s)')
ylabel('Distance (m)')
title('Distance vs Time')

figure()
plot(D, V)
xlabel('Distance (m)')
ylabel('Velocity (m/s)')
title('Distance vs Velocity')
xlim([0 70])
grid minor


figure()
plot(y, theta)
xlabel('Velocity (m/s)')
ylabel('Theta (°)')
title('Velocity vs Theta')
xlim([0 70])
grid minor

figure()
plot(y, Vv)
xlabel('Velocity X (m/s)')
ylabel('Velocity Y (m/s)')
title('Velocity X vs Velocity Y')
xlim([0 35])
grid minor