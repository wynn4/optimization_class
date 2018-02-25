clc
clear
close all

x = [0.015, 0.5, 10.0, 1.5];

[function_values, function_jacobians, constraint_values, constraint_jacobians] = objcon(x);

function_values
function_jacobians

constraint_values
constraint_jacobians


% ------------Objective and Non-linear Constraints------------
function [function_vals, function_jacobians, constraint_vals, constraint_jacobians] = objcon(x)

% set objective/constraints here

% make design variables valder objects (things we'll adjust to find optimum)
d = valder(x(1),[1,0,0,0]);  % wire dia (in)
D = valder(x(2),[0,1,0,0]);  % coil dia (in)
n = valder(x(3),[0,0,1,0]);  % num coils
hf = valder(x(4),[0,0,0,1]); % free height (no load) (in)

% other analysis variables (constants that the optimization won't touch)
h0 = 1.0;           % preloaded height (in)
delta0 = 0.4;       % deflection (in)
hdef = h0 - delta0; % deflected spring height (in)
G = 12e6;
Q = 150e3;
w = 0.18;
Se = 45e3;
Sf = 1.5;

% delta_x = 0.4;  % not sure if this is right??
delta_x = (hf - h0);  % maybe this insteadc = zeros(9,1);???

% analysis functions
k = G*d^4/(8*D^3*n);
F = k*delta_x;
K = ((4*D-d)/(4*(D-d)))+0.62*(d/D);
% Tau = (8*F*D/pi*d^3)*K;
hs = n*d;
F_min = k*(hf - h0);
% F_max = F_min + delta0*k;
F_max = k*(hf - (h0 - delta0));
F_hs = k*(hf - hs);
Tau_min = 8*F_min*D*K/(pi*(d^3));
Tau_max = 8*F_max*D*K/(pi*(d^3));
Tau_m = (Tau_max + Tau_min)/2;
Tau_a = (Tau_max - Tau_min)/2;
Tau_hs = 8*F_hs*D*K/(pi*(d^3));
Sy = 0.44*(Q/d^w);

function_vals = [k.val, F.val, K.val, hs.val, F_min.val, F_max.val, ...
                 F_hs.val, Tau_min.val, Tau_max.val, Tau_m.val, Tau_a.val, ...
                 Tau_hs.val, Sy.val]';
function_jacobians = [k.der; F.der; K.der; hs.der; F_min.der; F_max.der; ...
                      F_hs.der; Tau_min.der; Tau_max.der; Tau_m.der; Tau_a.der; ...
                      Tau_hs.der; Sy.der];

% objective function (what we're trying to optimize)
% f = -F;  % maximize Force

% inequality constraints (c<=0)
c1 = Tau_hs - Sy;
c2 = Tau_a - Se/Sf;
c3 = Tau_a + Tau_m - Sy/Sf;
c4 = (D/d) - 16;
c5 = -(D/d) + 4;
c6 = d - 0.2;
c7 = -d + 0.01;
c8 = D + d - 0.75;
c9 = -hdef + hs + 0.05;

constraint_vals = [c1.val, c2.val, c3.val, c4.val, c5.val,...
                   c6.val, c7.val, c8.val, c9.val]';

constraint_jacobians = [c1.der; c2.der; c3.der; c4.der; c5.der;...
                        c6.der; c7.der; c8.der; c9.der];

end




