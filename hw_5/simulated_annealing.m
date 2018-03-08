clc
clear
close all

N = 100;
Ps = 0.8;
Pf = 1e-3;
delta = 0.5;

dE_vals = [];
f_vals = [];
T_vals = [];
x_states = zeros(100000,2);

% initial x value
x0 = [4, -4]';

f = get_f(x0);

Ts = -1/log(Ps);
Tf = -1/log(Pf);

F = (Tf/Ts)^(1/(N - 1));

count = 0;
x = x0;
T = Ts;
while T > Tf
    
    for i=1:10
        % perturb the current x
        xp = x + (rand(2,1) - [delta, delta]');
        xp = saturate(xp);
        if abs(xp(1)) > 5 || abs(xp(2)) > 5
            disp('bad!!!')
        end
        
        % compute f at the perturbed x
        fp = get_f(xp);
        
        % if fp is lower than our current f, then accept it and move on
        if fp < f
            % accept the perturbed design
            x = xp;
            
            % compute dE and add to the dE_vals array
            dE = abs(fp - f);
            dE_vals(length(dE_vals) + 1) = dE;
        else
            dE = fp - f;
            dE_vals(length(dE_vals) + 1) = dE;
            dE_avg = sum(dE_vals)/length(dE_vals);
            
            % T = F * T;
            
            P = exp(-dE/(dE_avg*T));
            
            % see if random number is less than P
            rnum = rand(1);
            if rnum < P
                % accept the perturbed design
                x = xp;
            else
                % don't accept and remove the last dE from the running average
                dE_vals = dE_vals(1:length(dE_vals)-1);
            end
            
        end
    end
    count = count + 1;
    x_states(count,:) = x';
    T = F * T;
    T_vals(length(T_vals) + 1) = T;
    
    % store function values from each loop
    f_vals(length(f_vals) + 1) = get_f(x);
    
end

iters = 1:length(f_vals);
x_states = x_states(1:length(f_vals),:);

figure(1), clf
plot(iters, f_vals)
xlabel('Iteration')
ylabel('Function value, f')

% call the contour plotter
plot_contours(x_states);
% axis([0 100 -1 12])

% figure(2), clf
% plot(iters, T_vals)
% xlabel('Iteration')
% ylabel('Temperature, T')

x


fzero = get_f([0, 0]')


function fval = get_f(x)
fval = 2 + 0.2*(x(1)^2) + 0.2*(x(2)^2) - cos(pi*x(1)) - cos(pi*x(2));
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
















