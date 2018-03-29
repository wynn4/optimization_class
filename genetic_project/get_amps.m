function amps = get_amps(thrust, design)

% thrust is the required thrust in Newtons for each motor given the design
% design is an array of the design variable integer representations
% design = [motor_code, prop_blade_code, n_blades_code, n_cells_code,
%           n_motors_code, bat_cap_code]

% get the first 4 elements of design that represent the power system
design = design(1:4);

% convert to a number code
str = sprintf('%d%d%d%d', design(1), design(2), design(3), design(4));
design_code = str2double(str);


switch design_code
    case 1312
        Thr = [2.75, 5.69, 9.90, 14.81, 19.81, 25.6, 33.73]';
        Amp = [0.5, 1.2, 2.4, 4.2, 6.4, 9.4, 13.1]';
    case 16
        
    otherwise
        disp('infeasible')
end

% plot(T,A)

% A matrix for LS polynomial curve fit
A = [ones(length(Thr),1), Thr, Thr.^2, Thr.^3, Thr.^4];

% solve for coefficients of polynomial using pseudo-inverse
x = A \ Amp;

amps = -1;
end