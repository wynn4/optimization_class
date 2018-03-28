clc
clear

x0 = [-0.25, -1.1, 1];

x = fsolve(@myfun, x0)



function F = myfun(x)
F(1) = -2*x(1) - x(3);
F(2) = -1 -x(3)*2*x(2);
F(3) = x(1) + x(2)^2 -1;
end