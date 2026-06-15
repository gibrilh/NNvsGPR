% Pareto Design Validation Against Abaqus

clc;
clear;
close all;

% Define selected Pareto designs [W1, W2, R, t]
% Replace these values with your actual selected designs

designs = [
    0.595, 0.100, 0.070, 0.020;   % GPR Lowest stress
    0.300, 0.150, 0.064, 0.010;   % GPR Lowest mass
    0.300, 0.100, 0.070, 0.019;   % GPR Optimal compromise
    0.700, 0.100, 0.070, 0.020;   % NN Lowest stress
    0.300, 0.150, 0.065, 0.010;   % NN Lowest mass
    0.303, 0.100, 0.070, 0.020;   % NN Optimal compromise
];

labels = {
    'GPR - Lowest Stress';
    'GPR - Lowest Mass';
    'GPR - Optimal Compromise';
    'NN  - Lowest Stress';
    'NN  - Lowest Mass';
    'NN  - Optimal Compromise';
};

% Predicted values from surrogates (MPa)
predicted = [24.01; 100.989; 30.591; 25.75; 87.29; 30.15];

% Run Abaqus for each design
nDesigns = size(designs, 1);
abaqus_stress = zeros(nDesigns, 1);
runtimes = zeros(nDesigns, 1);

for i = 1:nDesigns
    W1 = designs(i,1);
    W2 = designs(i,2);
    R  = designs(i,3);
    t  = designs(i,4);
    
    fprintf('\nRunning design %d / %d: %s\n', i, nDesigns, labels{i});
    
    [abaqus_stress(i), runtimes(i)] = MaintenancePlate_StressExtract_Function(W1, W2, R, t);
    
    fprintf('Predicted: %.4f MPa | Abaqus: %.4f MPa\n', predicted(i), abaqus_stress(i));
end

% Compute percentage errors
errors = abs((predicted - abaqus_stress) ./ abaqus_stress) * 100;

% Display results table
fprintf('\n%-35s %-15s %-15s %-15s\n', 'Design', 'Predicted', 'Abaqus', 'Error (%)');
fprintf('%s\n', repmat('-', 1, 80));
for i = 1:nDesigns
    fprintf('%-35s %-15.4f %-15.4f %-15.4f\n', labels{i}, predicted(i), abaqus_stress(i), errors(i));
end

fprintf('\nWorst-case error: %.4f %%\n', max(errors));
fprintf('Mean error: %.4f %%\n', mean(errors));