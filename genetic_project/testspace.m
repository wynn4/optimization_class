clc
clear
close all

% Thr = [7.06, 12.45, 19.91, 28.15, 40.99, 52.27, 65.41]';
% Amp = [1.4, 2.9, 5.4, 8.6, 14.7, 21.7, 28.0]';
% 
% A = [ones(length(Thr),1), Thr, Thr.^2, Thr.^3];
% 
% x = A \ Amp;
% 
% % original data
% plot(Thr, Amp)
% hold on
% 
% thr_data = min(Thr):0.1:max(Thr);
% %thr_data = 0:0.1:35;
% amp_predict = x(1) + x(2)*thr_data + x(3)*thr_data.^2 + ...
%               x(4)*thr_data.^3;
% 
% plot(thr_data, amp_predict)
% legend('data', 'predicted')
% global loops
% 
% for i = 1:5
%     if i == 4
%         i = 1;
%     end
%     loops = loops + 1
%     
%     if loops > 50
%         break
%     end
% end
all_designs = zeros(2880,6);
all_fitnesses = zeros(2880,1);

count = 0;

for i=1:4
    for j=1:6
        for k=1:2
            for l=1:5
                for m=1:3
                    for n=1:4
                        % increment the counter
                        count = count + 1;
                        
                        % fill out the design
                        design = [i, j, k, l, m, n];
                        
                        % add design to our giant matrix
                        all_designs(count,:) = design;
                        
                        % add the fitness to our big fitness vector
                        all_fitnesses(count) = compute_fitness(design);
                        
                    end
                end
            end
        end
    end
end

% sort all_fitnesses in descending order and get the index
[sorted, index] = sort(all_fitnesses, 'descend');

bestIndex = index(1);

best_design = all_designs(bestIndex,:)
fitness = compute_fitness(best_design)
