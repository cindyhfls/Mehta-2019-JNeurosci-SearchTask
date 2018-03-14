% Calculate the Akaike Weights from a Vector of AIC values
% the akaike weights are the probability that the candidate model is the
% best among the set of candidate models
% Ref: https://www.rdocumentation.org/packages/qpcR/versions/1.4-0/topics/akaike.weights
% Ref: https://link.springer.com/content/pdf/10.3758/BF03206482.pdf
% Ref: http://onlinelibrary.wiley.com/store/10.1002/9781118856406.app5/asset/app5.pdf;jsessionid=C425337BF0271458B45CDDB3E40F1212.f02t03?v=1&t=jeomfyx5&s=2b76fccc41d548a50381f27438fe16309a1b204c
% Need to load result
function [evidenceratio,alleviratio,AICw,BICw] = CalculateWeights(result)
numNeuron = length(result);
fields = fieldnames(result);
numModel = length(fields);
AIC = NaN(numNeuron,numModel);
BIC = NaN(numNeuron,numModel);
for k = 1:numModel % each model
    AIC(:,k) = cell2mat(arrayfun(@(i)result(i).(fields{k}).aic,[1:length(result)]','UniformOutput',false));
    BIC(:,k) = cell2mat(arrayfun(@(i)result(i).(fields{k}).bic,[1:length(result)]','UniformOutput',false));
end

delta_AIC= AIC-min(AIC,[],2);
delta_BIC= BIC-min(BIC,[],2);

temp= exp(-.5*delta_AIC);
denominator = sum(temp,2);
AICw = exp(-.5*delta_AIC)./denominator;

temp= exp(-.5*delta_BIC);
denominator = sum(temp,2);
BICw = exp(-.5*delta_BIC)./denominator;

% how much more likely is one of the non-uniform models better than the
% uniform one
uniw = BICw(:,strcmp(fields,'uniform'));
nonuniw = BICw(:,~strcmp(fields,'uniform'));

alleviratio = nonuniw./uniw;

evidenceratio = max(alleviratio,[],2);

end