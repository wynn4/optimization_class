function fitness = compute_fitness(design)

% Fitness will be predicted flight time
% Higher values are better

% Flight time will be computed as capacity of the battery in amp hours
% (Ah) divided by current (Amps) required to maintain hover. (h = Ah /
% Amps).

% INPUTS:
% design = [motor_code, prop_blade_code, n_blades_code, n_cells_code,
%           n_motors_code, bat_cap_code]

% Constants accross all designs:
mass_body = 5;  % mass of the central hub of the multirotor (kg)
delta = 0.05;  % clearance between adjacent propellers (meters)
mass_arm = 0.5;  % mass per meter of material used to construct arms (kg/m)

% first check to see if we even have motor data for the given design
check = get_amps(5, design);

if check == -1
    fitness = 0;
    return
end

% Get the mass of the motor for the given design
motor_code = design(1);

switch motor_code
    % mass_motor (kg)
    
    case 1
        mass_motor = 0.445;
        
    case 2
        mass_motor = 0.415;
        
    case 3
        mass_motor = 0.360;
        
    case 4
        mass_motor = 0.360;
        
    otherwise
        fitness = 0;
        return
end

% Get the propeller diameter for the given design
prop_blade_code = design(2);

switch prop_blade_code
    % D = propeller diameter (meters)
    
    case 1
        D = 30.5 * 0.0254;  % convert inches to meters
        
    case 2
        D = 27.5 * 0.0254;
        
    case 3
        D = 24.5 * 0.0254;
        
    case 4
        D = 21.5 * 0.0254;
        
    case 5
        D = 18.5 * 0.0254;
        
    case 6
        D = 15.5 * 0.0254;
        
    otherwise
        fitness = 0;
        return
end

% Get the number of battery cells for the given design
n_cells_code = design(4);

switch n_cells_code
    % (int) n_cells = number of LiPo cells
    
    case 1
        n_cells = 4;
        
    case 2
        n_cells = 6;
        
    case 3
        n_cells = 8;
        
    case 4
        n_cells = 10;
        
    case 5
        n_cells = 12;
        
    otherwise
        fitness = 0;
        return
end

% Get the number of motors for the given design
n_motors_code = design(5);

switch n_motors_code
    % (int) n = number of motors
    
    case 1
        n = 4;
        
    case 2
        n = 6;
        
    case 3
        n = 8;
        
    otherwise
        fitness = 0;
        return
end

% Get the battery capacity for the given design
bat_cap_code = design(6);

switch bat_cap_code
    
    % bat_cap = battery capacity in amp hours (Ah)
    case 1
        bat_cap = 23;
        
    case 2
        bat_cap = 22;
        
    case 3
        bat_cap = 17;
        
    case 4
        bat_cap = 16;
        
    otherwise
        fitness = 0;
        return
end

if bat_cap == 23
    cell_mass = 0.413;
elseif bat_cap == 22
    cell_mass = 0.422;
elseif bat_cap == 17
    cell_mass = 0.321;
elseif bat_cap == 16
    cell_mass = 0.310;
else
    fitness = 0;
    return
end

% compute battery mass
mass_battery = cell_mass * n_cells;

% compute total mass of multirotor design
mass_total = compute_mass(n, D, delta, mass_body, mass_motor, mass_battery, mass_arm);

% compute hover thrust (equal to total_weight)
thrust_total = mass_total * 9.81;

% compute required thrust per motor
thrust_motor = thrust_total / n;

% compute current draw (Amps) per motor
amps_motor = get_amps(thrust_motor, design);

% compute total current draw
amps = amps_motor * n;


% finally, compute fitness or total flight time (hours)
flight_time = bat_cap / amps;

fitness = flight_time;

end