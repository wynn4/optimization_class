% This script constructs a contour plot for the fov optimization
clc
clear
close all

% height vs. focal length
res = 100;

% limits for zoomed out view
ss_pix_min = 500;
ss_pix_max = 2000;
ts_min = 0.4;
ts_max = 1.6;

[ss_pix,ts] = meshgrid(ss_pix_min:(ss_pix_max - ss_pix_min)/res:ss_pix_max, ts_min:(ts_max - ts_min)/res:ts_max);

target_area_pix = zeros(res+1);
rate_proc = zeros(res+1);
% fov = zeros(res+1);


% constants
ss_physical = 1/3;
F_safe = 2;
min_target_pixels = 800;

% optimums for the variables (from optimization)
%ss_pix = 1114.286537365992;  % optimal pixel size
%ts = 1.499999999828;  % optimal target size

height = 29.999;
fl = 0.004297954694;
% h_opt_low = 13.99;
% fl_opt_low = 0.002;
% h_opt_mid = 22;
% fl_opt_mid = 0.003148862;

% design variables at mesh points
% [fl,height] = meshgrid(fl_min:(fl_max - fl_min)/res:fl_max, h_min:(h_max - h_min)/res:h_max);
 
% equations
ss_w = ss_physical * sqrt(2)/2;  % physical sensor width (inches)
ss_w = ss_w * 0.0254;  % convert sensor width to meters
for i=1:length(ss_pix)
    for j=1:length(ss_pix)
        v = 2 * atan(ss_w/(2*fl));  % angular field of view of the camera
        fov_w = 2 * (height * tan(v/2));  % width of rectangular region camera can see
        fov_h = fov_w;  % height of rectangular region camera can see
        fov = (fov_w * fov_h);  % area in square meters that camera can see
        
        u_target = (fl/height) * (ts(i,j)/2);  % projection of the target onto the image plane (meters)
        v_target = u_target;  % same as above since target is square (meters)
        pix_size = ss_w/ss_pix(i,j);  % pixel size (meters)
        target_area_pix(i,j) = (2 * u_target/pix_size) * (2 * v_target/pix_size);  % area of target in pixels
        
        tpp = 8.0539e-8;  % time it takes to process each pixel (found from experimentation)
        t_proc = tpp * ss_pix(i,j)^2;  % time to process the image
        rate_proc(i,j) = 1/t_proc;  % rate at which images can be processed
    end
end




 
figure(1)
% [C,h] = contour(fl,height,fov,[500:100:2000],'k');
[C1,h1] = contour(ss_pix,ts,target_area_pix,[500, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000],'k');
clabel(C1,h1,'Labelspacing',250);
title('Target Size vs Sensor Width Contour');
xlabel('Image Sensor Width (pixels)');
ylabel('Target Size (m)');
hold on;

contour(ss_pix,ts,(ts - 1.5),[0.0,0.0],'b-','LineWidth',1);
contour(ss_pix,ts,(-rate_proc + 10),[0.0,0.0],'g-','LineWidth',1);
contour(ss_pix,ts,(ts - 0.5),[0.0,0.0],'m-','LineWidth',1);
plot(1114.3, 1.5, 'k*','MarkerSize',12,'LineWidth',2)

% show a legend
legend('target area (pixels)','target size<=1.5m','img_proc_rate>=10','target size>=0.5m', 'optimum')
   
