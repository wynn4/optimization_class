clc
clear
close all

all_designs = [];
f1 = [];
f2 = [];

count = 0;

% Look at all possible designs by brute-force
for i=1:4
    for j=1:6
        for k=1:2
            for l=1:5
                for m=1:3
                    for n=1:4
                        
                        % increment counter
                        count = count + 1;
                        
                        % fill out the design
                        design = [i, j, k, l, m, n];
                        
                        % check to see if design is feasible
                        check = get_amps(5, design);
                        
                        if check ~= -1
                            % add design to our giant matrix
                            all_designs = [all_designs; design];
                            
                            % add the fitness to our big fitness vector
                            f1 = [f1; 1/(compute_fitness(design))];
                            f2 = [f2; compute_fitness2(design)];
                        end
                        
                    end
                end
            end
        end
    end
end


% compute the maximin_values
maximin_vals = zeros(length(f1), 1);

for i = 1:length(f1)
    mins = [];
    for j = 1:length(f1)
        if i ~= j
            mins = [mins; min(f1(i)-f1(j), f2(i)-f2(j))];
        end
    end
    maximin_vals(i) = max(mins);
end

% make an array of just the pareto designs
pareto_designs = [];
for i = 1:length(maximin_vals)
    if maximin_vals(i) < 0
        pareto_designs = [pareto_designs; all_designs(i,:)];
    end
end

[rows, ~] = size(pareto_designs);

f1_pareto = zeros(rows, 1);
f2_pareto = zeros(rows, 1);

for i = 1:rows
    
    f1_pareto(i,1) = 1/compute_fitness(pareto_designs(i,:));
    f2_pareto(i,1) = compute_fitness2(pareto_designs(i,:));
    
end

plot(f1, f2, 'r*')
xlabel('1 / Flight Time')
ylabel('Propeller Disc Area')
hold on
plot(f1_pareto, f2_pareto, 'b*')
plot(f1_pareto, f2_pareto, 'b')
title('Design Space and Pareto Front (blue)')

% select pareto_design(3,:) as the 'best design'
pareto_row = 3;

% do some fancy printing stuff
max_flight_time = compute_fitness(pareto_designs(1,:));
pareto3_flight_time = compute_fitness(pareto_designs(pareto_row,:));

diff_ft = max_flight_time - pareto3_flight_time;
percent_ft = (diff_ft/max_flight_time) * 100;
percent_ft_str = num2str(percent_ft);

pareto1_area = compute_fitness2(pareto_designs(1,:));
pareto3_area = compute_fitness2(pareto_designs(pareto_row,:));

diff_area = pareto1_area - pareto3_area;
percent_area = (diff_area/pareto1_area) * 100;
percent_area_str = num2str(percent_area);

s1 = "Results in only a ";
s2 = "% decrease in flight time but yields a ";
s3 = "% decrease in propeller disc area";

s = strcat(s1, percent_ft_str, s2, percent_area_str, s3);

disp('Selecting pareto design: ')
disp(pareto_designs(3,:))
disp(s)
disp(newline)

flight_time = num2str(pareto3_flight_time * 60);
s4 = "Total flight time: ";
s5 = " minutes";
s = strcat(s4, flight_time, s5);
disp(s)
disp(newline)

area = num2str(pareto3_area);
s6 = "Total disc area: ";
s7 = " m^2";
s = strcat(s6, area, s7);
disp(s)


plot(f1_pareto(pareto_row), f2_pareto(pareto_row), 'b*', 'MarkerSize', 12, 'LineWidth', 3)

