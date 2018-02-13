% This script constructs a contour plot for the fov optimization
clc
clear
close all

% height vs. focal length

% limits for zoomed out view
fl_min = 0.001;
fl_max = 0.03;
h_min = 10.0;
h_max = 30.0;

% limits for zoomed in view
% fl_min = 0.0;
% fl_max = 0.21;
% h_min = 10.0;
% h_max = 30.0;


res = 100;

fov = zeros(res+1);

% constants
ss_physical = 1/3;

% optimums for the variables (from optimization)
ss_pix = 1114.286537365992;  % optimal pixel size
ts = 1.499999999828;  % optimal target size

% design variables at mesh points
[fl,height] = meshgrid(fl_min:(fl_max - fl_min)/res:fl_max, h_min:(h_max - h_min)/res:h_max);
 
% equations
ss_w = ss_physical * sqrt(2)/2;  % physical sensor width (inches)
ss_w = ss_w * 0.0254;  % convert sensor width to meters
for i=1:length(fl)
    for j=1:length(fl)
        v = 2 * atan(ss_w/(2*fl(i,j)));  % angular field of view of the camera
        fov_w = 2 * (height(i,j) * tan(v/2));  % width of rectangular region camera can see
        fov_h = fov_w;  % height of rectangular region camera can see
        fov(i,j) = fov_w * fov_h;  % area in square meters that camera can see
    end
end


 
figure(1)
[C,h] = contour(fl,height,fov,[500:100:2000],'k');
clabel(C,h,'Labelspacing',250);
title('Spring Design Contour Plot');
xlabel('focal length (m)');
ylabel('height (m)');
hold on;
% solid lines to show constraint boundaries
contour(fl,height,(fl - 0.025),[0.0,0.0],'g-','LineWidth',2);
contour(fl,height,(-fl + 0.0012),[0.0,0.0],'b-','LineWidth',2);
% contour(d,D,(Tau_a - Se/Sf),[0.0,0.0],'r-','LineWidth',2);
% contour(d,D,(Tau_a + Tau_m - Sy./Sf),[0.0,0.0],'b-','LineWidth',2);
% contour(d,D,(D./d),[16.0,16.0],'m-','LineWidth',2);
% contour(d,D,(D./d),[4.0,4.0],'c-','LineWidth',2);
% contour(d,D,(d),[0.2,0.2],'-','color',[0.96, 0.46, 0.25],'LineWidth', 2)
% contour(d,D,(d),[0.01,0.01],'-','color',[0.7, 0.1, 0.9],'LineWidth', 2)
% contour(d,D,(D+d),[0.75,0.75],'-','color',[0.0, 0.44, 0.14],'LineWidth', 2)
% contour(d,D,(-hdef+hs+0.05),[0.0,0.0],'-','color',[0.04, 0.32, 0.54],'LineWidth', 2)
% plot(d_opt,D_opt,'r*','MarkerSize',12,'LineWidth',1)
% % show a legend
% legend('force','T hs-Sy<0','Ta-Se/Sf<0','Ta+Tm-Sy/Sf<0','D/d<16', ...
%        'D/d>4','d<0.2','d>0.01','D+d<0.75','-hdef+hs+0.05<0','optimal')

