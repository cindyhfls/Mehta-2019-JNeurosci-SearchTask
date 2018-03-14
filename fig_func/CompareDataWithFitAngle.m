% Compare Real Data With Fitted Data by neuron
% To-do: add in the fitted part
%%IMPORTANT!!%%
% 1-11 and 71-122 uses the screen 1600*900
% 12-70 uses the screen 1920*1080
% Using Priyanka's wrapped data
function CompareDataWithFitAngle(data,allresult)
%% Get all the distributions
fields=fieldnames(allresult);
BIC = arrayfun(@(i)allresult.(fields{i}).bic,1:numel(fieldnames(allresult)));
[~,bfit_idx] = min(BIC); % find out which model have the lowest BIC

fitX = linspace(0,1,100)';
fitY = linspace(0,1,100)';
fitTheta = linspace(-pi,pi,100)';

for i=1:length(fields)
    result = allresult.(fields{i});
    n = result.neuron; % which neuron it is
    epoch = result.epoch;
    [X,Y,spkc] = get_xyspike_priyanka(data,n,epoch);
    if n <12 || n >70
        fitTheta = atan2((900*Y-450),(1600*X-800)); % change the screen size and center values
    else
        fitTheta = atan2((1080*Y-540),(1920*X-960)); % change the screen size and center values
    end
    vars = [fitTheta];
    if contains([result.distributionName],'mixed')
        %         distribution = result.distribution{:};
        distributionName = result.distributionName;
        k = result.k;
        fitspkc(:,i) = mixedgaussian(vars,result.fit_params,k); % x, and y in the same distribution
    else
        partitioncoef = getpartitioncoef(result.distributionName);
        fitspkc(:,i) = mixed_distribution(vars,result.fit_params,result.distributionName,partitioncoef);
    end
    
end

% normalize spkc to spikes per second
fitspkc = fitspkc./(length(epoch)./100);
spkc = spkc./(length(epoch)./100);

divideint = 12;
edges = linspace(-pi,pi,divideint); % into 12 bins
[N,edges,bin] = histcounts(fitTheta,edges);
means = arrayfun(@(i)mean(spkc(bin==i)),1:divideint);
stes = arrayfun(@(i)ste(spkc(bin==i)),1:divideint);
smoothby = 1;
figure('position',[400,400,800,800]);hold on
hreal = plot(edges,smooth(means,smoothby),'.-');
plot(edges,smooth(means+stes,smoothby),'b:');
plot(edges,smooth(means-stes,smoothby),'b:');
%     hfit = plot(unique(fitTheta),arrayfun(@(i)mean(fitspkc(fitTheta==i,1)),unique(fitTheta)),'r-','LineWidth',2);
hfit = plot(unique(fitTheta),arrayfun(@(i)mean(fitspkc(fitTheta==i,bfit_idx)),unique(fitTheta)),'r','LineWidth',2);
allotherspkc = cell2mat(arrayfun(@(i)mean(fitspkc(fitTheta==i,setdiff(1:length(fields),bfit_idx)),1),unique(fitTheta),'UniformOutput',false));
for i = 1:size(allotherspkc,2)
    hfit(i+1) = plot(unique(fitTheta),allotherspkc(:,i),'Color',[0.45,0.45,0.45]); % in grey
end
hold off
DistNames = arrayfun(@(i)allresult.(fields{i}).distributionName,1:numel(fieldnames(allresult)));
title(['Neuron',num2str(n),' bestfit= ',DistNames{bfit_idx}]);
xlim([-pi,pi]);
xticks(linspace(-pi,pi,3));
xticklabels({'-\pi','0','\pi'})
xlabel('Angle from center of screen');
ylabel('Spikes per second');
legend([hreal,hfit(1),hfit(2)],{'Real Data', 'Best-fit','Other-fits'});
legend('boxoff','location','NW');
% print(gcf,['../temp_result/HeatMapNeuron',num2str(n)],'-bestfit','-dpdf');
% close all

end
