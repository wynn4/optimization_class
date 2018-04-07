clc
clear
close all

% Algorithm Tuning Params
N = 10;                 % Generation size
n_gen = 10;             % Number of generations
p_crossover = 0.3;      % Probability that crossover occurs
p_mutation = 0.01;      % Probability that mutation occurs
roulette_exponent = 2;  % Fitness pressure (larger exponents give designs
                        % with greatest fitness a greater chance of being
                        % selected as parents)

% Other Params
n_genes = 6;         % Number of genes (design variables) per chromosome

% ---------------------
% Chromosome Definition
% ---------------------
% A chromosome for this problem is defined by 6 integer design variables:

% Variable 1: Motor
%     Values: 1, 2, 3, or 4 corresponding to four different brushles DC
%             motors available from a manufacturer
%
% Variable 2: Propeller Blade
%     Values: 1, 2, 3, 4, 5, or 6 corresponding to six available propeller
%             blade profiles
%
% Variable 3: Number of Propeller Blades
%     Values: 1, or 2 corresponding to 2 or 3 propeller blades per motor
%
% Variable 4: Number of LiPo Battery Cells
%      Values: 1, 2, 3, 4, or 5 corresponding to 4, 6, 8, 10, or 12 lithium
%              polymer battery cells (each nominally 3.7 volts)
%
% Variable 5: Number of Motors
%     Values: 1, 2, or 3 corresponding to 4 (quadcopter), 6 (hexacopter),
%             or 8 (octocopter) motors and arms
%
% Variable 6: Battery Capacity
%     Values: 1, 2, 3, or 4 corresponding to 23, 22, 17, and 16 amp hour
%             (Ah) capacities available from a battery manufacurer
%
% -------------------------
% End Chromosome Definition
% -------------------------

% Memory Allocation
generation = zeros(N, n_genes);

% Randomly select the first generation
feasible = zeros(N,1);
for i = 1:N
    while ~feasible(i)
        for j = 1:n_genes
            switch j
                case 1
                    generation(i,j) = randi(4);
                case 2
                    generation(i,j) = randi(6);
                case 3
                    generation(i,j) = randi(2);
                case 4
                    generation(i,j) = randi(5);
                case 5
                    generation(i,j) = randi(3);
                case 6
                    generation(i,j) = randi(4);
                otherwise
                    disp("Error. Number of genes does not match number of cases.")
                    return
            end
        end
        
        % Check to see if the current chromosome is feasible
        check_feasible = get_amps(1, generation(i,:));
        
        if check_feasible == -1
            feasible(i) = 0;
            % disp("bad design")
        else
            feasible(i) = 1;
        end
        
    end
end

disp(generation)

% SELECTION STEP:

% Pick two designs from the current generation to become parents
parents = roulette_selection(generation, roulette_exponent)
















