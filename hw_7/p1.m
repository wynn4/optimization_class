% clc
% clear

x = [-0.592, -1.162]';

f = get_f(x)

gradf = get_gradf(x)

g = get_g(x)

gradg = get_gradg(x)

H = bfgs(H_old, gamma, delta_x)

x0 = [0, 0, 1, 1];

x = fsolve(@myfun2, x0)

function f = get_f(x)
f = x(1)^4 - 2*x(2)*x(1)^2 + x(2)^2 + x(1)^2 - 2*x(1) + 5;
end

function gradf = get_gradf(x)
gradf = zeros(2,1);
gradf(1) = 4*x(1)^3 - 4*x(2)*x(1) + 2*x(1) -2;
gradf(2) = -2*x(1)^2 + 2*x(2);
end

function g = get_g(x)
g = -(x(1) + 0.25)^2 + 0.75*x(2);
end

function gradg = get_gradg(x)
gradg = zeros(2,1);
gradg(1) = -2*x(1) - 0.5;
gradg(2) = 0.75;
end

% bfgs hessian update
function H_new = bfgs(H_old, gamma, delta_x)

H_new = H_old + ((gamma*gamma')/(gamma'*delta_x)) - ((H_old*delta_x*delta_x'*H_old)/(delta_x'*H_old*delta_x));
end

function F = myfun(x)
F(1) = -1.7837 + 4.0140*x(1) - 1.2066*x(2) - x(3)*(-1.2046);
F(2) = 0.6930 - 1.2066*x(1) + 1.9993*x(2) - x(3)*(0.75);
F(3) = -0.0098 - 1.2046*x(1) + 0.75*x(2);
end

function F = myfun2(x)
F(1) = 18.5986*x(1) + 5.1292*x(2) -0.6840*x(4) - 6.7655;
F(2) = 5.1292*x(1) + 2.1836*x(2) - 0.75*x(4) - 3.0249;
F(3) = 0.230*x(4) - 0.2;
F(4) = 0.6840*x(1) + 0.75*x(2) - 1*x(3) -1.2185;
end