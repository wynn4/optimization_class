clc
clear
close all

all_designs = zeros(2880,6);
all_fitnesses = zeros(2880,2);

count = 0;

% Look at all possible designs by brute-force
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
                        all_fitnesses(count, 1) = 1/(compute_fitness(design));
                        all_fitnesses(count, 2) = compute_fitness2(design);
                        
                    end
                end
            end
        end
    end
end

% % sort all_fitnesses in descending order and get the index
% [sorted, index] = sort(all_fitnesses, 'descend');
% 
% bestIndex = index(1);
% 
% best_design = all_designs(bestIndex,:)
% fitness = compute_fitness(best_design)

plot(all_fitnesses(:,1), all_fitnesses(:,2), 'r*')
xlabel('1/flight time')
ylabel('disc area')