%% Cronbacha's alpha
function alpha = cronb(data)
n = size(data, 2);
alpha = n / (n-1) * (1 - sum(var(data)) / var(sum(data, 2)));
end