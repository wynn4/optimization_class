% This script constructs a contour plot for the fov optimization
clc
clear
close all

% height vs. focal length
res = 100;

% limits for zoomed out view
fl_min = 0.001;
fl_max = 0.03;
h_min = 0.0;
h_max = 35.0;

[fl,height] = meshgrid(fl_min:(fl_max - fl_min)/res:fl_max, h_min:(h_max - h_min)/res:h_max);

% limits for zoomed in view
fl_min = 0.001;
fl_max = 0.005;
h_min = 9.0;
h_max = 31.0;

[fl_zoom,height_zoom] = meshgrid(fl_min:(fl_max - fl_min)/res:fl_max, h_min:(h_max - h_min)/res:h_max);


res = 100;

fov = zeros(res+1);
target_area_pix = zeros(res+1);
target_area_pix_zoom = zeros(res+1);

% constants
ss_physical = 1/3;
F_safe = 2;
min_target_pixels = 800;

% optimums for the variables (from optimization)
ss_pix = 1114.286537365992;  % optimal pixel size
ts = 1.499999999828;  % optimal target size

h_opt_up = 29.999;
fl_opt_up = 0.004297954694;
h_opt_low = 13.99;
fl_opt_low = 0.002;
h_opt_mid = 22;
fl_opt_mid = 0.003148862;

% design variables at mesh points
% [fl,height] = meshgrid(fl_min:(fl_max - fl_min)/res:fl_max, h_min:(h_max - h_min)/res:h_max);
 
% equations
ss_w = ss_physical * sqrt(2)/2;  % physical sensor width (inches)
ss_w = ss_w * 0.0254;  % convert sensor width to meters
for i=1:length(fl)
    for j=1:length(fl)
        v = 2 * atan(ss_w/(2*fl(i,j)));  % angular field of view of the camera
        fov_w = 2 * (height(i,j) * tan(v/2));  % width of rectangular region camera can see
        fov_h = fov_w;  % height of rectangular region camera can see
        fov(i,j) = (fov_w * fov_h);  % area in square meters that camera can see
        
        u_target = (fl(i,j)/height(i,j)) * (ts/2);  % projection of the target onto the image plane (meters)
        v_target = u_target;  % same as above since target is square (meters)
        pix_size = ss_w/ss_pix;  % pixel size (meters)
        target_area_pix(i,j) = (2 * u_target/pix_size) * (2 * v_target/pix_size);  % area of target in pixels
    end
end

for i=1:length(fl_zoom)
    for j=1:length(fl_zoom)
        v = 2 * atan(ss_w/(2*fl_zoom(i,j)));  % angular field of view of the camera
        fov_w = 2 * (height_zoom(i,j) * tan(v/2));  % width of rectangular region camera can see
        fov_h = fov_w;  % height of rectangular region camera can see
        fov_zoom(i,j) = (fov_w * fov_h);  % area in square meters that camera can see
        
        u_target = (fl_zoom(i,j)/height_zoom(i,j)) * (ts/2);  % projection of the target onto the image plane (meters)
        v_target = u_target;  % same as above since target is square (meters)
        pix_size = ss_w/ss_pix;  % pixel size (meters)
        target_area_pix_zoom(i,j) = (2 * u_target/pix_size) * (2 * v_target/pix_size);  % area of target in pixels
    end
end


 
figure(1)
% [C,h] = contour(fl,height,fov,[500:100:2000],'k');
[C1,h1] = contour(fl,height,fov,[500, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000],'k');
clabel(C1,h1,'Labelspacing',250);
title('FOV Design Space Contour Plot');
xlabel('focal length (m)');
ylabel('height (m)');
hold on;
% solid lines to show constraint boundaries
contour(fl,height,(fl - 0.025),[0.0,0.0],'g-','LineWidth',1);
contour(fl,height,(-fl + 0.002),[0.0,0.0],'b-','LineWidth',1);
contour(fl,height,(-target_area_pix + F_safe * min_target_pixels),[0.0,0.0],'r-','LineWidth',1);
contour(fl,height,(height - 30),[0.0,0.0],'m-','LineWidth',1);
contour(fl,height,(height - 10),[0.0,0.0],'c-','LineWidth',1);
plot(fl_opt_up,h_opt_up,'k*','MarkerSize',12,'LineWidth',2)
plot(fl_opt_low,h_opt_low,'k*','MarkerSize',12,'LineWidth',2)
plot(fl_opt_mid,h_opt_mid,'k*','MarkerSize',12,'LineWidth',2)
% show a legend
legend('FOV (m^2)','fl<=25mm','fl>=2mm','target_pix>=800','height<=30m', ...
       'height>=10m','upper optimum','lower optimum','middle optimum', 'Location','SouthEast')
   
figure(2)
% [C,h] = contour(fl,height,fov,[500:100:2000],'k');
[C2,h2] = contour(fl_zoom,height_zoom,fov_zoom,[500, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000],'k');
clabel(C2,h2,'Labelspacing',250);
title('FOV Design Space Contour Plot (Zoomed View)');
xlabel('focal length (m)');
ylabel('height (m)');
hold on;
% solid lines to show constraint boundaries
%contour(fl,height,(fl - 0.025),[0.0,0.0],'g-','LineWidth',1);
contour(fl_zoom,height_zoom,(-fl_zoom + 0.002),[0.0,0.0],'b-','LineWidth',1);
contour(fl_zoom,height_zoom,(-target_area_pix_zoom + F_safe * min_target_pixels),[0.0,0.0],'r-','LineWidth',1);
contour(fl_zoom,height_zoom,(height_zoom - 30),[0.0,0.0],'m-','LineWidth',1);
contour(fl_zoom,height_zoom,(height_zoom - 10),[0.0,0.0],'c-','LineWidth',1);
plot(fl_opt_up,h_opt_up,'k*','MarkerSize',12,'LineWidth',2)
plot(fl_opt_low,h_opt_low,'k*','MarkerSize',12,'LineWidth',2)
plot(fl_opt_mid,h_opt_mid,'k*','MarkerSize',12,'LineWidth',2)
% show a legend
legend('FOV (m^2)','fl>=2mm','target_pix>=800','height<=30m', ...
       'height>=10m','upper optimum','lower optimum','middle optimum', 'Location','SouthEast')

