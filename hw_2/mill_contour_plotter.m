% This script constructs a contour plot for the mill optimization
clc
clear
close all

% pipe dia vs. slury velocity
% D = pipe dia
% V = slury velocity

% lower and upper bounds for D and V

% limits for zoomed out view
D_min = 0.1;
D_max = 1.0;
V_min = 0.5;
V_max = 100;

% limits for zoomed in view
% D_min = 0.1;
% D_max = 1.0;
% V_min = 0.5;
% V_max = 100;


D_res = 1000;
V_res = 1000;

% constants and analysis variables
L = 15*5280;  % pipe length (ft)
W = 12.67;  % flowrate of limestone (lbm/sec)
als = 0.01;  % avg lump size of limestone before grinding (ft)
        
gamma = 168.5;  % limestone density (lb_m/ft^3)
rho_w = 62.4;  % water density (lb_m/ft^3)
g = 32.17;  % gravity (ft/s^2)
g_c = 32.17;  % conversion factor
mu = 7.392e-4;  % water viscosity (lb_m/ft-sec)
S = gamma/rho_w;  % specific gravity of the limestone

% optimums for the variables (from optimization)
d = 0.000500000000023;
Q_w = 0.112789317537217;
% c_slur = 0.399999999936593;
rho = 1.048399999932725e+02;
D_opt = 0.181875031098594;
V_opt = 7.235702059824295;
 
% analysis variables

 
% design variables at mesh points
[D,V] = meshgrid(D_min:(D_max - D_min)/D_res:D_max, V_min:(V_max - V_min)/V_res:V_max);
 
% equations
P_g = 218*W*((1/sqrt(d)) - (1/sqrt(als)));

Q = 0.25*pi*(D.^2).*V;
Q_l = W/gamma;
c_slur = Q_l./Q;

Cd_Rp_term = 4*g*rho_w*(d^3)*((gamma - rho_w)/(3*(mu^2)));
C_d = cd_lookup(Cd_Rp_term);
V_c = ((40*g*(S-1)*c_slur.*D)/(sqrt(C_d))).^0.5;

R_w = rho_w*V.*D/mu;

[rows,cols] = size(R_w);
f_w = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols
        if R_w(i,j) <= 10e5
            f_w(i,j) = 0.3164/(R_w(i,j)^0.25);
        else
            f_w(i,j) = 0.0032 + 0.221*(R_w(i,j)^-0.237);
        end
    end
end

fric = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols
        fric(i,j) = f_w(i,j)*((rho_w/rho)+150*c_slur(i,j)*(rho_w/rho)*(g*D(i,j)*(S-1)/((V(i,j)^2)*sqrt(C_d)))^1.5);
    end
end


% fric = f_w.*((rho_w/rho)+150*c_slur*(rho_w/rho)*(g.*D*(S-1)./((V.^2)*sqrt(C_d))).^1.5);
delta_p = (fric*rho*L.*(V.^2))./(D*2*g_c);
P_f = delta_p.*Q;

% COST STUFF
initial_cost = 300*(P_g/550) + 200*(P_f/550);
hrs_per_year = 8*300;  % 8 hrs per day, 300 days per year
yearly_operating_cost = 0.07*(P_g/550)*hrs_per_year + 0.05*(P_f/550)*hrs_per_year;
ir = 0.07;
n = 7;  % number of years

P = yearly_operating_cost*(((1 + ir)^n - 1)/(ir*(1 + ir)^n));

cost = initial_cost + P;

figure(1)
[C,h] = contour(D,V,cost,200000:200000:1000000,'k');
clabel(C,h,'Labelspacing',250);
title('Limestone Mill Design Contour Plot');
xlabel('pipe diameter, D (ft)');
ylabel('slurry velocity, V (ft/s)');
hold on;
% solid lines to show constraint boundaries
contour(D,V,(D),[0.5,0.5],'g-','LineWidth',2);
contour(D,V,(-V + 1.1*V_c),[0.0,0.0],'b-','LineWidth',2);
contour(D,V,(c_slur),[0.4,0.4],'r-','LineWidth',2);
plot(D_opt,V_opt,'r*','MarkerSize',12,'LineWidth',1)
% show a legend
legend('cost','D<0.5','V>1.1*Vc','c<0.4','optimal')

