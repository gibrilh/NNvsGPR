% Training Data Generation using LHS + Abaqus
clc;
clear;
close all;

% User settings
nSamples = 400;
rho = 2700; 

% Output CSV filename
csvFileName = 'MaintenancePlate_TrainingData.csv';

% Delete old CSV at each launch
if exist(csvFileName, 'file')
    delete(csvFileName);
    fprintf('Old CSV file deleted: %s\n', csvFileName);
end

% Design variable bounds
% Variables: [W1, W2, R, t]
lb = [0.3, 0.1, 0.03, 0.01];
ub = [0.7, 0.15, 0.07, 0.02];

nVar = numel(lb);

% Generate LHS samples
lhsUnit = lhsdesign(nSamples, nVar, 'criterion', 'maximin', 'iterations', 100);
X = lb + (ub - lb) .* lhsUnit;

% Create CSV header
fid = fopen(csvFileName, 'w');

fprintf(fid, 'SampleID,W1_m,W2_m,R_m,t_m,Mass_kg,MaxVonMisesStress_MPa,AbaqusRuntime_s\n');
fclose(fid);

% Loop over all samples and append each result immediately
totalStart = tic;

for i = 1:nSamples
    W1 = X(i,1);
    W2 = X(i,2);
    R  = X(i,3);
    t  = X(i,4);

    fprintf('\nSample %d / %d\n', i, nSamples);
    fprintf('W1 = %.6f, W2 = %.6f, R = %.6f, t = %.6f\n', W1, W2, R, t);

    % Compute mass
    massVal = rho * t * (4*W1^2 - 4*W2^2 + (4 - pi)*R^2);

    try
        % Run Abaqus model and extract stress + runtime
        [maxVMStress, scriptRuntime] = MaintenancePlate_StressExtract_Function(W1, W2, R, t);
    catch ME
        warning('Sample %d failed: %s', i, ME.message);
        maxVMStress = NaN;
        scriptRuntime = NaN;
    end

    % Append one line to CSV
    fid = fopen(csvFileName, 'a');

    fprintf(fid, '%d,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f,%.8f\n', ...
        i, W1, W2, R, t, massVal, maxVMStress, scriptRuntime);

    fclose(fid);

end

totalElapsed = toc(totalStart);

fprintf('\nAll samples processed.\n');
fprintf('Total elapsed wall-clock time = %.2f seconds\n', totalElapsed);
