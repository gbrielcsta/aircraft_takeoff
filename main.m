clear all;  clc;

W = 130; % weight of aircraft (N)

% Define parameters
g = 9.81; % acceleration due to gravity (m/s^2)
mu = 0.1; % coefficient of friction
mu2 = 0.065; % coefficient of friction
rho = 1.225; % air density (kg/m^3)
S = 1.02; % wing area (m^2)
T0 = 38; % thrust at sea level (N)
a = -0.024;
b = -0.68;
TOd = 58;
h = 0.7;
SFh = 0.3;

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
f = @(t, y) (g/W) * ((a * y^2 + b * y + T0)-(CD * 0.5 * rho * S * y^2)- ((mu *((.1*W) - (CL * 0.5 * rho * S * y^2))) + (mu2 *((.90*W) - (CL * 0.5 * rho * S * y^2)))));

% Define initial conditions
V0 = 0;

% Define time
tspan = [0, 15];

% Solve ODE using ode45
[t, V] = ode45(f, tspan, V0);

% Integrate velocity to obtain distance
D = cumtrapz(t, V);

% Define required thrust
dt = .01;  % very important (dt<= .01)
U = Vto:dt:20;
CLreq = (2 * W)./(rho * S * U.^2);
CDreq = interp1(wing.CL, wing.CD, CLreq, 'spline');
Treq = W./(CLreq./CDreq);
T = a * U.^2 + b * U + T0;

% Define rate of climb
P = T.*U;
Preq = Treq.*U;
DeltaP = P - Preq;
Rc = DeltaP./ W;
theta = asin(Rc./U).* (180/pi);
thetato = interp1(U,theta,Vto,'spline');
Dto = interp1(V,D,Vto,'spline')
Dc = (h + SFh)./tan(thetato.*pi/180)

TO =  Dto + Dc

% Define parameters
to_time = interp1(V,t,Vto,'spline');
final_time = interp1(D,t,TOd,'spline');
final_velocity = interp1(D,V,TOd,'spline');
altitude = cumsum(Rc) * dt;
climbdist = cumsum(U) * dt;

% figure()
% plot(Dto+climbdist, altitude)
% hold on
% xlabel('Distance (m)')
% ylabel('Altitude (m)')
% title('Distance vs Altitude')
% xlim([0 200])
% grid minor

% Define time to climb
time0 = to_time;
climb_time = time0 + climbdist./Rc;

% figure()
% plot(climb_time, altitude)
% hold on
% xlabel('Time (s)')
% ylabel('Altitude (m)')
% title('Distance vs Altitude')
% xlim([0 200])
% grid minor

figure(1)
    plot(D, V)
    hold on
    xlabel('Distance (m)')
    ylabel('Velocity (m/s)')
    title('Velocity vs Distance')
    xlim([0 70])
    grid on
    grid minor


% Plot results    
%run graphs.m
