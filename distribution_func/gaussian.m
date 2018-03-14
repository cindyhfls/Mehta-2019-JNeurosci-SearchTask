% Gaussian
function output = gaussian(vars,params)

numVars = size(vars,2); % each column is a variable
numParams = size(params,2); 
if numParams ~= numVars % check columns of params
    error('Input Error: The number of columns in parameter does not match with the number of columns of variables');
% elseif size(params,1) ~=4 % check rows of params
%     error('Input Error: Too many/few parameters!')
end
params = params(1:3,:); % only take the first four parameters if more are provided

myfun = @(x,a,mu,sigma)a * normpdf(x,mu,sigma); % original gaussian function with scaling factor

temp = arrayfun(@(n)myfun(vars(:,n),params(1,n),params(2,n),params(3,n)),1:numVars,'UniformOutput',false);
output = sum(cell2mat(temp),2); 

% if numel(params) ==4
%     % single Gaussian
%     a = params(1);
%     b = params(2);
%     mu = params(3);
%     sigma = params(4);
%     y = a * normpdf(x,mu,sigma)+b;
% end

end