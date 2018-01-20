clc
clear
close all

% data(:,1) = C_d
% data(:,2) = C_d_R_p_term
data = [240, 2.4;
        120, 4.8;
        80, 7.2;
        49.5, 12.4;
        36.5, 17.9;
        26.5, 26.5;
        14.6, 58.4;
        10.4, 93.7;
        6.9, 173;
        5.3, 260;
        4.1, 410;
        2.55, 1020;
        2.0, 1800;
        1.5, 3750;
        1.27, 6230;
        1.07, 10700;
        0.77, 30800;
        0.65, 58500;
        0.55, 138000;
        0.5, 245000;
        0.46, 460000;
        0.42, 1680000;
        0.40, 3600000;
        0.385, 9600000];
    
    % this is a highly skewed dataset so we'll take the log of the data
    % and fit a curve to this data instead
    
    log_data = log(data);
    
    % split up into x and y data
    x_data = log_data(:,2);
    y_data = log_data(:,1);
    
    % 'A' matrix for 10th order polynomial
    A = [ones(length(x_data),1), x_data, x_data.^2, x_data.^3, x_data.^4,...
        x_data.^5, x_data.^6, x_data.^7, x_data.^8, x_data.^9, x_data.^10];
    
    % solve for coefficients of polynomial using pseudo-inverse
    x = A \ y_data;
    
    % visualize the curve fit of the data
    t = min(x_data):0.01:max(x_data);
    % t = 0:0.01:20;
    
    y = x(1) + x(2)*t + x(3)*t.^2 + x(4)*t.^3 + x(5)*t.^4 + x(6)*t.^5 +...
        x(7)*t.^6 + x(8)*t.^7 + x(9)*t.^8 + x(10)*t.^9 + x(11)*t.^10;
    
    plot(x_data, y_data, t, y)
    legend('data', 'curve-fit')
    xlabel('log(C_d R_p term)')
    ylabel('log(C_d)')
    title('log data plot')
    % looks pretty good
    
    
    