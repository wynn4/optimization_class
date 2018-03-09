clc
clear
close all

% tuning params
N = 50;
Ps = 0.6;
Pf = 1e-4;
delta = 1.25;
num_inner_loops = 3;

global nfun;
nfun = 0;

% arrays to hold data
dE_vals = [];
f_vals = [];
% T_vals = [];
T_vals = zeros(1,100000);
x_states = zeros(100000,2);

% initial x value
x0 = [4, 3]';
x_states(1,:) = x0;

% compute starting and final temperatures
Ts = -1/log(Ps);
Tf = -1/log(Pf);

% compute F
F = (Tf/Ts)^(1/(N - 1));

% initialization
f = get_f(x0);
f_vals(1) = f;
count = 0;
x = x0;
T = Ts;
incount = 0;
% while we haven't reached Tf...
while T > Tf
    
    for i=1:num_inner_loops
        
        incount = incount + 1;
        T_vals(incount) = T;
        
        % perturb the current x
        if count > 0.8*N
            xp = x + randn(2,1)*delta*0.1;  % if we're close to the end, make delta very small
        else
            xp = x + randn(2,1)*delta;  % the regular perturbation
        end
        
        
        % saturate xp s.t. -5 < xp < 5
        xp = saturate(xp);
        
        % compute f at the perturbed x
        fp = get_f(xp);
        
        % if fp is lower than our current f, then accept it and move on
        if fp < f
            % accept the perturbed design
            x = xp;
            f = get_f(x);
            
            % compute dE and add to the dE_vals array
            dE = abs(fp - f);
            dE_vals(length(dE_vals) + 1) = dE;
        else
            % compute dE
            dE = abs(fp - f);
            
            % check to see if we have more than one value to average
            if isempty(dE_vals)
                dE_avg = dE;
            else
                % compute the average dE
                dE_avg = sum(dE_vals)/length(dE_vals);
            end
            
            % compute probability of selecting a worse desing
            P = exp(-dE/(dE_avg*T));
            
            % see if random number is less than P
            rnum = rand(1);
            if rnum < P
                % accept the perturbed design
                x = xp;
                f = get_f(x);
                
                % add the 'accepted' dE value to the array
                dE_vals(length(dE_vals) + 1) = dE;
            else
                % don't accept and we keep the current design
                x = x;
                % f = get_f(x);
            end
            
        end
        
    end
    
    % decrease the temperature
    T = F * T;
    
    % increment the outer loop counter
    count = count + 1;
    
    % store function values from each loop
    f_vals(length(f_vals) + 1) = get_f(x);
    % T_vals(length(T_vals) + 1) = T;
    x_states(count + 1,:) = x';
    
end

iters = 1:length(f_vals);
x_states = x_states(1:length(f_vals),:);

figure(1), clf
plot(iters, f_vals)
xlabel('Iteration (outer loops)')
ylabel('Function value, f')
title('Function Value vs Iterations')

iters = 1:incount;
T_vals = T_vals(1:incount);
figure(2), clf
plot(iters, T_vals)
xlabel('Iteration (inner loops)')
ylabel('Temperature, T')
title('Temperature vs Iterations')

% call the contour plotter
plot_contours(x_states);




x
f = get_f(x)

if abs(x(1)) < 0.1 && abs(x(2)) < 0.1
    disp('Success')
else
    disp('Failed to converge to global optimum.')
end

nfun

function fval = get_f(x)
global nfun
fval = 2 + 0.2*(x(1)^2) + 0.2*(x(2)^2) - cos(pi*x(1)) - cos(pi*x(2));
nfun = nfun + 1;
end

function x_sat = saturate(x)

if x(1) > 5
    x(1) = 5;
elseif x(1) < -5
    x(1) = -5;
else
    x(1) = x(1);
end
    
if x(2) > 5
    x(2) = 5;
elseif x(2) < -5
    x(2) = -5;
else
    x(2) = x(2);
end

x_sat = x;
    
end
















