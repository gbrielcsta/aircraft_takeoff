% Interpolate velocity to obtain distance
Dto = interp1(V,D,Vto,'spline');

% Define Theta in function of velocity
y = Vto:.1:30;
theta = (asin(((a .* y.^2 + b .* y + T0)./W) - (1./((CL * 0.5 * rho * S .* y.^2)./(CD * 0.5 * rho * S .* y.^2))))) * (180/pi);

% Define climb distance
Dc = 0.7./tan(theta.*pi/180);

% Define vertical velocity
Vv = tan(theta * (pi/180)) .* y;
