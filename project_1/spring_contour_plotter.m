% This script constructs a contour plot for the spring optimization
clc
clear
close all

% coil dia vs. wire dia
% d = wire dia
% D = coil dia

% lower and upper bounds for d and D

% limits for zoomed out view
d_min = 0.0;
d_max = 0.21;
D_min = 0.3;
D_max = 1.0;

% limits for zoomed in view
% d_min = 0.02;
% d_max = 0.08;
% D_min = 0.3;
% D_max = 0.75;


d_res = 200;
D_res = 200;

% constants
G = 12e6;
Q = 150e3;
w = 0.18;
Se = 45e3;
Sf = 1.5;

% optimums for the variables (from optimization)
hf = 1.3691;
n = 7.5928;
d_opt = 0.0724;
D_opt = 0.6776;

 
% analysis variables
h0 = 1.0;           % preloaded height (in)
delta0 = 0.4;       % deflection (in)
hdef = h0 - delta0; % deflected spring height (in)
delta_x = (hf - h0);
 
% design variables at mesh points
[d,D] = meshgrid(d_min:(d_max - d_min)/d_res:d_max, D_min:(D_max - D_min)/D_res:D_max);
 
% equations
Sy = 0.44*(Q./d.^w);
k = G*d.^4./(8*(D.^3)*n);
F = k*delta_x;
K = ((4*D-d)./(4*(D-d)))+0.62*(d./D);
hs = n*d;
F_min = k*(hf - h0);
F_max = k*(hf - (h0 - delta0));
F_hs = k.*(hf - hs);
Tau_min = 8*F_min.*D.*K ./ (pi*(d.^3));
Tau_max = 8*F_max.*D.*K ./ (pi*(d.^3));
Tau_m = (Tau_max + Tau_min) ./ 2;
Tau_a = (Tau_max - Tau_min) ./ 2;
Tau_hs = 8*F_hs.*D.*K ./ (pi*(d.^3));
 
figure(1)
[C,h] = contour(d,D,F,1:3:13,'k');
clabel(C,h,'Labelspacing',250);
title('Spring Design Contour Plot');
xlabel('wire diameter, d (in)');
ylabel('coil diameter, D (in)');
hold on;
% solid lines to show constraint boundaries
contour(d,D,(Tau_hs - Sy),[0.0,0.0],'g-','LineWidth',2);
contour(d,D,(Tau_a - Se/Sf),[0.0,0.0],'r-','LineWidth',2);
contour(d,D,(Tau_a + Tau_m - Sy./Sf),[0.0,0.0],'b-','LineWidth',2);
contour(d,D,(D./d),[16.0,16.0],'m-','LineWidth',2);
contour(d,D,(D./d),[4.0,4.0],'c-','LineWidth',2);
contour(d,D,(d),[0.2,0.2],'-','color',[0.96, 0.46, 0.25],'LineWidth', 2)
contour(d,D,(d),[0.01,0.01],'-','color',[0.7, 0.1, 0.9],'LineWidth', 2)
contour(d,D,(D+d),[0.75,0.75],'-','color',[0.0, 0.44, 0.14],'LineWidth', 2)
contour(d,D,(-hdef+hs+0.05),[0.0,0.0],'-','color',[0.04, 0.32, 0.54],'LineWidth', 2)
plot(d_opt,D_opt,'r*','MarkerSize',12,'LineWidth',1)
% show a legend
legend('force','T hs-Sy<0','Ta-Se/Sf<0','Ta+Tm-Sy/Sf<0','D/d<16', ...
       'D/d>4','d<0.2','d>0.01','D+d<0.75','-hdef+hs+0.05<0','optimal')

