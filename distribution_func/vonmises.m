function output = vonmises(vars, params)
%VONMISES evaluate von mises function, inputs in RADIANS
%
% y = VONMISES(x, params) evaluates at x using the given params, where
% params(1) is min val, params(2) is max val, params(3) is kappa (width
% parameter) and params(4) is preferred orientation
%
% NOTE that this formulation of the von mises function removes some
% 'couplings' between terms that would otherwise make optimizing it
% difficult. For example, min and max are used rather than min and
% amplitude. This way the max val is easy to bound at 1.0 for bernoulli
% likelihoods. Notice also that the exp(cos()) term has likewise been normalized
% to range in [0,1]. This is easy to derive noting that cos() is in [-1,1]
% and plugging in those bounds to 'remap' it
%
% ranges [exp(-k), exp(k)]
% now subtract min, divide by max-min to get to [0,1]
%
% (exp(k*cos(...)) - exp(-k)) / (exp(k) - exp(-k))
% now multiply by exp(+k) in all 4 terms
%
% (exp(k*cos(...))exp(k) - 1) / (exp(2k) - 1)
% (exp(k*(cos(...)+1)) - 1) / (exp(2*k) - 1)

numVars = size(vars,2); % each column is a variable
numParams = size(params,2); 
if numParams ~= numVars
    error('Input Error: The number of columns in parameter does not match with the number of columns of variables');
% elseif size(params,1) ~=4 % check rows of params
%     error('Input Error: Too many/few parameters!')
end
params = params(1:3,:); % only take the first two parameters if more are provided

% x in angles, it seems that when maxval = minval, the function is equal to
% uniform
myfun = @(x,a,k,theta) a * (exp(k*(cos(x - theta)+1)) - 1) / (exp(2*k) - 1);

temp = arrayfun(@(n)myfun(vars(:,n),params(1,n),params(2,n),params(3,n)),1:numVars,'UniformOutput',false);
output = sum(cell2mat(temp),2); 

% minval = params(1);
% maxval = params(2);
% k = params(3); % variance
% theta = params(4); % mean angle

end