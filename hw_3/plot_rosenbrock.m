function plot_rosenbrock(algoflag, num_iterations, x_vals)

% This script generates a contour plot
% of the Rosenbrock function f.

% get the data
if algoflag == 1
    data = x_vals(1:20,:);  % only plot first 20 steps for steepest descent
else
    data = x_vals(1:num_iterations,:);
end

if algoflag == 1
    method_str = 'Steepest Descent Path';
elseif algoflag == 2
    method_str = 'Conjugate Gradient Path';
elseif algoflag == 3
    method_str = 'Quasi-Newton BFGS Path'
else
    method_str = 'undefined method'
end

% plot window setup
X1_min = -2;
X1_max = 2;
X2_min = -2;
X2_max = 2;

X1_res = 100;
X2_res = 100;


% setup the meshgrid
[X1,X2] = meshgrid(X1_min:(X1_max - X1_min)/X1_res:X1_max, X2_min:(X2_max - X2_min)/X2_res:X2_max);

% evaluate the quadratic function at all the points in the meshgrid
f = 100*(X2 - X1.^2).^2 + (1 - X1).^2;


% create the contour plot
figure(1), clf
[C,h] = contour(X1,X2,f,[2, 4, 10, 20, 40, 60, 80, 100, 200, 300, 400, 600],'k');
hold on
clabel(C,h,'Labelspacing',250);
title('Rosenbrocks Function Contour Plot');
xlabel('X1');
ylabel('X2');
plot(1, 1, '*r', 'MarkerSize', 20, 'LineWidth', 2)
plot(data(:,1), data(:,2), 'm', 'LineWidth', 2)
legend('f (Rosenbrocks)','optimum', method_str)



end