function [TO] = calculate_takeoff(W)

% Define parameters
g = 9.81; % acceleration due to gravity (m/s^2)
mu = 0.06; % coefficient of friction between tires and runway
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
U = Vto:.1:25;
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
Dto = interp1(V,D,Vto,'spline');
Dc = (h + SFh)./tan(thetato.*pi/180);

TO =  Dto + Dc;

% Define parameters
to_time = interp1(V,t,Vto,'spline');
final_time = interp1(D,t,TOd,'spline');
final_velocity = interp1(D,V,TOd,'spline');

end