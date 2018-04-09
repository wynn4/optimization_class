function new_chromosome = dynamic_mutation(chromosome, p_mutation, j, M, beta)

num_genes = length(chromosome);

% Compute alpha (eq. 6.9)
alpha = (1-((j-1)/M))^beta;

% minimum value for all genes is 1
x_min = 1;

for i=1:num_genes
    
    % pick a random number to decide if mutation occurs
    val = rand(1);
    
    if val <= p_mutation
        % mutate the current gene
    else
        % skip to the next gene without mutating
        continue
    end
    
    switch i
        case 1
            x_max = 4;
        case 2
            x_max = 6;
        case 3
            x_max = 2;
        case 4
            x_max = 5;
        case 5
            x_max = 3;
        case 6
            x_max = 4;
        otherwise
            disp("Error. Number of genes does not match number of cases.")
    end
    
    % pick a random number between the min and max allowed values for the
    % current gene
    r = random_number_between_two_values(x_min, x_max);
    
    % get the gene's current value
    x = chromosome(1, i);
    
    % eq 6.8
    if r <= x
        chromosome(1,i) = x_min + ((r - x_min)^alpha)*((x - x_min)^(1-alpha));
    else
        chromosome(1,i) = x_max - ((x_max - r)^alpha)*((x_max - x)^(1-alpha));
    end
    
    % round to the nearest integer value
    chromosome(1,i) = round(chromosome(1,i));
    
    % saturate just in case
    chromosome(1,i) = saturate(chromosome(1,i), x_max, x_min);
end

new_chromosome = chromosome;

end


function r = random_number_between_two_values(x_min, x_max)

r = x_min + (x_max - x_min) .* rand(1);

end

function rval = saturate(val, max, min)

if val > max
    rval = max;
elseif val < min
    rval = min;
else
    rval = val;
end

end