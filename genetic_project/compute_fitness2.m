function fitness = compute_fitness2(design)

% Fitness will be rotor disc area
% Lower values are better for wind resistance

% Rotor disc area will be computed as A = n * (pi * (D/2)^2).

% INPUTS:
% design = [motor_code, prop_blade_code, n_blades_code, n_cells_code,
%           n_motors_code, bat_cap_code]


% first check to see if we even have motor data for the given design
check = get_amps(5, design);

if check == -1
    fitness = 999;
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
        fitness = 999;
        return
end

% Get the number of propeller blades
n_blade_code = design(3);

switch n_blade_code
    
    case 1
        n_blades = 2;
        
    case 2
        n_blades = 3;
        
    otherwise
        fitness = 999;
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
        fitness = 999;
        return
end


% compute the rotor disc area
A = n * (pi * (D/2)^2);

if n_blades == 3
    A = A * 1.5;
end



% fitness
fitness = A;

end