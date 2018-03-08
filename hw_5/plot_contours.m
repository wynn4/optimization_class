function plot_contours(x_states)

% This script generates a contour plot
% of the function f.

X1_min = -5;
X1_max = 5;
X2_min = -5;
X2_max = 5;

X1_res = 100;
X2_res = 100;


% setup the meshgrid
[X1,X2] = meshgrid(X1_min:(X1_max - X1_min)/X1_res:X1_max, X2_min:(X2_max - X2_min)/X2_res:X2_max);

% evaluate the function at all the points in the meshgrid

f = 2 + 0.2*(X1.^2) + 0.2*(X2.^2) - cos(pi.*X1) - cos(pi.*X2);


% create the contour plot
figure(2), clf
[C,h] = contour(X1,X2,f,0:1:12,'k');
hold on
clabel(C,h,'Labelspacing',250);
title('Simulated Annealing Contour Plot Path');
xlabel('X1');
ylabel('X2');
plot(0, 0, '*r')
plot(x_states(:,1), x_states(:,2))

% create a 2D plot
x12d = -5:0.01:5;
f2d = 2 + 0.2*(x12d.^2) + 0.2*(0^2) - cos(pi.*x12d) - cos(pi*0);

figure(3), clf
plot(x12d, f2d)

end