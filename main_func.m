clear all; close all; clc;

W_values = 20:1:160;
results = cell(length(W_values), 2); % initialize cell array to store results

for i = 1:length(W_values)
    W = W_values(i);
    [TO] = calculate_takeoff(W);
    results{i, 1} = W;
    results{i, 2} = TO;
end
data = cell2mat(results);

figure()
plot(data(:,1),data(:,2))
grid on
grid minor

