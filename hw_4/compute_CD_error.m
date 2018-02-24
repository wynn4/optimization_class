clc
clear

% compute the constraint derivative error between the three methods

% load the data
fdDC = load('fdDC.mat');
cdDC = load('cdDC.mat');
complexDC = load('complexDC.mat');

% since complex step was evaluated with step size of 1e-20, we'll
% treat it as the true derivative

error_fd = norm(complexDC.DC - fdDC.DC)

error_cd = norm(complexDC.DC - cdDC.DC)

error_complex = norm(complexDC.DC - complexDC.DC)