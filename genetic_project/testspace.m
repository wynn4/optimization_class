clc
clear
close all

Thr = [7.06, 12.45, 19.91, 28.15, 40.99, 52.27, 65.41]';
Amp = [1.4, 2.9, 5.4, 8.6, 14.7, 21.7, 28.0]';

A = [ones(length(Thr),1), Thr, Thr.^2, Thr.^3];

x = A \ Amp;

% original data
plot(Thr, Amp)
hold on

thr_data = min(Thr):0.1:max(Thr);
%thr_data = 0:0.1:35;
amp_predict = x(1) + x(2)*thr_data + x(3)*thr_data.^2 + ...
              x(4)*thr_data.^3;

plot(thr_data, amp_predict)
legend('data', 'predicted')
