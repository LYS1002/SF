%% read data
data = readtable('.\data0.xlsx');
N = table2array(data(:, 11));
data = table2array(data(:, 12:end-1));

%% Cronbacha's alpha
alpha = zeros(5, 1);
for i = 1:5
    alpha(i) = cronb(data(:, get_index(i)));
end
fprintf('Cronbacha alpha:\n')
fprintf('corporate image: %f\n', alpha(1));
fprintf('service quality: %f\n', alpha(2));
fprintf('price: %f\n', alpha(3));
fprintf('customer complaint: %f\n', alpha(4));
fprintf('customer loyalty: %f\n\n', alpha(5));

fprintf('Mean:\n')
disp(mean(data))
fprintf('\n')

%% Coefficient of variation method
% calculate second weight
coeff = std(data) ./ mean(data);
w2 = [coeff(1:3)/sum(coeff(1:3)), coeff(4:12)/sum(coeff(4:12)), coeff(13:14)/sum(coeff(13:14)), coeff(15:18)/sum(coeff(15:18)), coeff(19:22)/sum(coeff(19:22))];

% calculate first weight
w1 = zeros(1, 5);
for i = 1:5
    data_i = data(:,get_index(i));
    data_i = data_i(:);
    w1(i) = std(data_i) / mean(data_i);
end
w1 = w1 / sum(w1); 

fprintf('Weight:\n')
fprintf('first factor:\n')
disp(w1)
fprintf('second factor:\n')
disp(w2)
fprintf('\n')

%% Fuzzy evaluation
% 
H = 1:5;
sample2 = data(N>=3, :);
Nsample = size(sample2, 1); % number of samples
n2 = size(data, 2); % number of factors
R = zeros(n2, 5); % degree of membership
for i = 1:n2
    for j = 1:5
        R(i, j) = sum(sample2(:, i) == j);
    end
end
R = R / Nsample;

% corporate image
R1 = R(1:3, :);
B1 = w2(1:3)*R1;
EB1 = B1*H';
CSI1 = (EB1 - 1)/4;

% service quality
R2 = R(4:12, :);
B2 = w2(4:12)*R2;
EB2 = B2*H';
CSI2 = (EB2 - 1)/4;

% price
R3 = R(13:14, :);
B3 = w2(13:14)*R3;
EB3 = B3*H';
CSI3 = (EB3 - 1)/4;

% customer complaint
R4 = R(15:18, :);
B4 = w2(15:18)*R4;
EB4 = B4*H';
CSI4 = (EB4 - 1)/4;

% customer loyalty
R5 = R(19:22, :);
B5 = w2(19:22)*R5;
EB5 = B5*H';
CSI5 = (EB5 - 1)/4;

% output
fprintf('CCSI:\n')
fprintf('corporate image: %f\n', CSI1);
fprintf('service quality: %f\n', CSI2);
fprintf('price: %f\n', CSI3);
fprintf('customer complaint: %f\n', CSI4);
fprintf('customer loyalty: %f\n', CSI5);

%% all
R0 = zeros(5, 5);
for i = 1:5
    for j = 1:5
        sample1 = sample2(:, get_index(i));
        sample1 = sample1(:);
        R0(i, j) = sum(sample1 == j) / (size(get_index(i), 2) * Nsample);
    end
end
B0 = w1*R0;
EB0 = B0*H';
CSI0 = (EB0 - 1)/4;
fprintf('All: %f\n', CSI0)

