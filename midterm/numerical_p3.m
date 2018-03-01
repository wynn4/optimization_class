clc;
clear;


h = 0.0001;

x = 3;
dfdx = 2.5*(x^1.5) + log(x)

% compute forward difference
x_p = x + h;
f_p = get_f(x_p);
f = get_f(x);
dfdx_FD = (f_p - f)/h

% compute central difference
x_p = x + h;
x_m = x - h;
f_p = get_f(x_p);
f_m = get_f(x_m);
dfdx_CD = (f_p - f_m)/(2*h)

% compute complex step derivative
h = 1e-30;
x_p = x + h*i;
f_p = get_f(x_p);
dfdx_complex = (imag(f_p))/h

% error
% take complex step to be the 'true' derivative
dfdx_true = dfdx_complex;
error_FD = dfdx_true - dfdx_FD
error_CD = dfdx_true - dfdx_CD
error_complex = (dfdx_true - dfdx_complex)

% t = 0:0.01:10;
% f = (t.^(2.5)) + log(t);
% 
% plot(t,f)



function f = get_f(x)
f = x^(2.5) + log(x);
end