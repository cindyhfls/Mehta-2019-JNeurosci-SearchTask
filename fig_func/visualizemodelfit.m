% To-do: add in variance normalization?
% This is to visualize the model bics in bar charts?

loadresult = false;
%% Load Data and Result
if loadresult
    ResultFileName = 'XYResult2.mat';
    load(fullfile('../temp_result/',ResultFileName),'result');
    fields=fieldnames(result);
    DataFileName = result(1).(fields{1}).DataName;
    load(fullfile('../input_data/',DataFileName),'data');
end
%% If just uniform/vonmises
%% Calculate the proportion of uniform/non-uniform tuning
for k = 1:length(re)
result = re(k).rep;
bic_uniform = cell2mat(arrayfun(@(i)result(i).uniform.bic,[1:length(result)]','UniformOutput',false));
bic_vonmises =  cell2mat(arrayfun(@(i)result(i).vonmises.bic,[1:length(result)]','UniformOutput',false));
sig_idx = find(bic_vonmises<bic_uniform);
re(k).sig_idx = sig_idx;
re(k).num_sig = length(sig_idx);
re(k).epoch = result(1).uniform.epoch([1,end]);
end
%% Plot the number of significant neurons over time
num_sig = arrayfun(@(k)re(k).num_sig,1:length(re));
prop_sig = num_sig/122; % out of 122 neurons
time = 955:10:1045;
eventstr = [961,1001];
eventname = {'diamond fixation','bar view'};
figure;hold on
plot(time,prop_sig,'o-')
eventy = ylim ;
for i = 1:length(eventstr)
plot([eventstr(i),eventstr(i)],eventy,'k-');
text(eventstr(i),eventy(2),eventname{i});
end
hold off
ylabel('proportion of significant neurons')
title('Proportion of neurons signficantly tuned to gaze angle');
print(gcf,'../temp_result/propneurongazeangle','-dpdf');
%% Calculate the uniform/non-uniform
fields=fieldnames(result);
fit_outcome = NaN(length(data),length(fields));
ub = arrayfun(@(iR)result(iR).(fields{1}).bic,1:length(data));
for iR = 1:length(data)
fit_outcome(iR,:) = arrayfun(@(i)result(iR).(fields{i}).bic-ub(iR),1:length(fields));%/var(iR,1);
end
[~,idx] = min(fit_outcome,[],2);
TotalNum = 122;
bary = arrayfun(@(i)sum(idx==i),1:length(fields))/TotalNum; 
Uniform = bary(1)
NonUniform = 1-bary(1)
%% Plot Each Neuron
count = 1;
while count<14
    figure('position',[400,400,800,800]);
    for iR = 10*(count-1)+1:10*count
        remd = iR-10*(count-1);
        try
            subplot(5,2,remd)
            ub (iR,1);
        catch
            return % stop if there is no more to plot
        end
          
        bar(2:length(fields), fit_outcome(iR,2:length(fields) ) );
        title(['Neuron ',num2str(iR)])
        xticklabels(fields(2:end));
        xtickangle(45);
    end
%     print(gcf,['../temp_result/anglemodelBICs',num2str(count)],'-depsc')
    count = count+1;
end

%% Plot histogram for population
figure
[~,idx] = min(fit_outcome,[],2);
TotalNum = 122;
bary = arrayfun(@(i)sum(idx==i),1:length(fields))/TotalNum; % five distributions, how many cells have the bestfit in each
subplot(2,1,1);
bar(bary);
bar(1:length(bary),bary);
xticks(1:length(bary));
xticklabels(fields)
xtickangle(45);
title('Angle best model counts by BIC');
for i = 1:length(bary)
    text(i,bary(i)+1,num2str(bary(i)));
end
subplot(2,1,2);
bar([1,2],[bary(1),sum(bary(2:end))],.4);
for i = 1:2
    text(i,bary(i)+.5,num2str([bary(1),sum(bary(2:end))]));
end
xticklabels({'Uniform','Non-uniform'});
title('Angle best model counts by BIC');
disp(sum(bary(2:end)));

% print(gcf,'../temp_result/anglemodelBICs_bestfitcounts','-depsc')

