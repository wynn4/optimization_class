function parents = roulette_selection(generation, roulette_exponent)

% Get the number of chromosomes (designs) in the generation
[gen_size, ~] = size(generation);

% Initialize a column vector to hold generation fitness data
fitnesses = zeros(gen_size, 1);

% Initialize a column vector to hold the widths on the roulette wheel that
% each design occupies
widths = zeros(gen_size, 1);

for i = 1:gen_size
    % Get the fitness for each chromosome
    fitnesses(i) = compute_fitness(generation(i,:));
end

for i = 1:gen_size
    % Normalize all of the fitnesses to sum to 1
    widths(i) = fitnesses(i)^(roulette_exponent)/sum(fitnesses.^roulette_exponent);
end

% Pick a random value between 0 and 1
val = rand(1);

% Here we make a sliding window defined by a left and right bound that
% represents the current segment or bin (whose width is widths(i)) of our 
% roulette wheel.  If the random value we picked earlier falls into the
% current segment, then we select the design corresponding to this segment
% to be a parent chromosome.

% Initilize the bounds
left = 0;
right = 0;

for i=1:gen_size
    
    % Define the left side of the current bin of width = widths(i)
    if i ~= 1
        left = left + widths(i-1);
    end
    
    % Define the right side of the current bin of width = widths(i)
    right = right + widths(i);
    
    if left <= val && val <= right
        break
    end
    
end

% fitnesses
% widths
parents = generation(i,:);
end










