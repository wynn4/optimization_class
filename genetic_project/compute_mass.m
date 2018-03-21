function m_total = compute_mass(n, D, delta, mass_body, mass_motor, mass_battery, mass_arm)

% inputs
% n = number of motors/arms
% D = propeller Diameter (m)
% delta = desired clearance between adjacent spinning props (m)
% mass_body = mass of multirotor hub (center frame, autopilot, etc)(kg)
% mass_motor = mass of each individual motor (kg)
% mass_battery = battery mass (kg)
% mass_arm = mass per meter of the tube material used to make the arms (kg/m)

% Angle between arms
theta = 2*pi/n;

% Compute the required arm length
l_arm = (D + delta) / (2*sin(theta/2));

% Compute total mass
m_total = n*(l_arm * mass_arm) + mass_body + n*mass_motor + mass_battery;

end