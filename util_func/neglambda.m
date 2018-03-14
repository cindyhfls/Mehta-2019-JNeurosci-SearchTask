% The nonlinear constraint function for fmincon solver to based on lambda>0
function nlambda = neglambda(vars,params,distributions)

nlambda = -mixed_distribution(vars,params,distributions);

% numVars = size(data,2); % how many columns?
% %perhaps poisson is a better description?
% temp = cell2mat(arrayfun(@(var) distribution(data(:,var),params(:,var)),1:numVars,'UniformOutput',false));
% nlambda=-sum(temp,2);

end