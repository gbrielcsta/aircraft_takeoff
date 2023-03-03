clear all; close all; clc;

W_values = 100:1:130;
results = cell(length(W_values), 2); % initialize cell array to store results

for i = 1:length(W_values)
    W = W_values(i);
    [TO] = calculate_takeoff(W);
    %disp(['W = ', num2str(W), ', TO = ', num2str(TO)]);
    results{i, 1} = W;
    results{i, 2} = TO;
end
data = cell2mat(results);

plot(data(:,2),data(:,1))



