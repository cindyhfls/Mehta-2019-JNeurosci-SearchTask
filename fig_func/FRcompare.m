%% Get FR difference for ITI and Trial
load('../input_data/data_wrapped_Cindy.mat','mydata')
%% Plot from 1:400, where 200 is the completion of fixation
epochOI =1:400; binWidth =10;
c=1;
psth = [mydata(c).psth(:,1:400)];
figure;
smoothBy = 10;x = epochOI *binWidth;
h = plot(x,smooth(nanmean(psth),smoothBy),'b');
%%
startoffset = 200; % the startoffset to set up PSTH and eye position

numNeurons = length(mydata);
FR_trial = NaN(600,numNeurons);
FR_ITI = NaN(600,numNeurons);

for c = 1:numNeurons
endTrial = ceil([mydata(c).var{:,7}]*100+startoffset);
ITIstart = ceil([mydata(c).var{:,11}]*100+startoffset);

% chop off the end of too long trials
% get FR during each trial
numTrials = size(mydata(c).var,1);
for i = 1:numTrials
    try
        FR_trial(i,c) = sum(mydata(c).psth(i,startoffset:ITIstart(i)))/length(startoffset:ITIstart(i));
    catch
        FR_trial(i,c) = NaN;
    end
    try
        FR_ITI(i,c) = sum(mydata(c).psth(i,ITIstart(i)+50:ITIstart(i)+349))/300;
    catch
        FR_ITI(i,c) = NaN;
    end
end
end

nanmean(FR_ITI(:))
nanmean(FR_trial(:))

figure
hs1 = [histcounts(FR_ITI(:),0:0.01:0.6),0];
hs2 = [histcounts(FR_trial(:),0:0.01:0.6),0];
bar(0:0.01:0.6,hs1);hold on
bar(0:0.01:0.6,-hs2);hold on
plot(nanmean(FR_ITI(:)),1000,'v',nanmean(FR_trial(:)),-1000,'^');
legend('ITI','trial');
xlabel('FR')

return
%% Eye Movement During ITI
figure
for i = 1:numTrials
    plot(mydata(c).EyeX(i,1:startoffset),mydata(c).EyeY(i,1:startoffset),'o-');
    xlim([-2000,2000]) % estimated screen from rough calculation
    ylim([-1600,2300]) % estimated screen from rough calculation
    pause(.1);
end