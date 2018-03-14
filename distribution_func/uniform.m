% uniform
function output=uniform(vars,params)
% each column of vars and params should match!
% number of parameters should be in proportion to the number of variables
% numVars = size(vars,2); % each column is a variable
% numParams = size(params,2);
% if numParams ~= numVars % check columns of params
%         error('Input Error: The number of columns in parameter does not match with the number of columns of variables');
% % elseif size(params,1) ~=1 % check rows of params
% %     error('Input Error: Too many parameters!')
% end
% 
% params = params(1,:); % only take the first parameter if more are provided
% numObs = size(vars,1);
% 
% temp = arrayfun(@(n)params(n).* ones(numObs,1),1:numVars,'UniformOutput',false);
% output = sum(cell2mat(temp),2); 
output = 0; % added the intercept term in the umbrella code
% old code:
% if numel(params)==1
%     b=params(1);
%     y=b*ones(numObs,1);
% else
%     error('Number of parameters not equal to 1');
% end

end