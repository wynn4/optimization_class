clc
clear
close all

% This script generates a contour plot
% of the quadratic function f.

X1_min = -5;
X1_max = 5;
X2_min = -5;
X2_max = 5;

X1_res = 100;
X2_res = 100;


% setup the meshgrid
[X1,X2] = meshgrid(X1_min:(X1_max - X1_min)/X1_res:X1_max, X2_min:(X2_max - X2_min)/X2_res:X2_max);

% evaluate the quadratic function at all the points in the meshgrid
f = 12 + 6*X1 - 5*X2 + 4*X1.^2 -2*X1.*X2 + 6*X2.^2;
%f = X1.^2 + X2.^2;


% create the contour plot
figure(1)
[C,h] = contour(X1,X2,f,0:10:100,'k');
hold on
clabel(C,h,'Labelspacing',250);
title('Quadratic Contour Plot');
xlabel('X1');
ylabel('X2');
plot(-0.6745, 0.3023, '*r')
plot(1,1, '*b')