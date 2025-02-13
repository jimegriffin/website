function [screened_samples, VarNames, prob] = screened(samples, VarNames, threshold)

numbofits = size(samples, 1);

PIP = mean(samples);

screened_samples = samples(:, PIP > threshold);
VarNames = VarNames(PIP > threshold);

check1 = sum(samples(:, PIP < threshold), 2);
prob = 1 - sum(check1 > 0) / numbofits;