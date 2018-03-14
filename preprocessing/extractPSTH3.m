function [psth,meanTrialDuration] = extractPSTH3( Strobed,SPK,startStrobe,binSize,strobesFr,omVars)
%This function extract psth from raw data
%   Strobed & SPK are read from raw data directly for each cell
%   startStrobe indicates desired aligning point
%   binSize indicates step/time bin size 0.01s=10ms looks good

% figure(1)
% plot(Strobed(:,1)); % first column, time when the strobe occured
% title('time points when strobes occured', 'fontSize', 14);
% % Stribed(:,2): second colunm, actual strobe code
% figure(2)
% plot(SPK);%time when the spike occured
% title('time points when  spikes occured', 'fontSize', 14);

trialStartStrobe=find(Strobed(:,2)==startStrobe);% define start strobes of each trial
temp=[trialStartStrobe(1);strobesFromVars];
clear trialStartStrobe
trialStartStrobe=temp;
trialStartTimes=Strobed(trialStartStrobe,1);% find the time of each trial starts
% plot(trialStartTimes);
% figure(3)
% plot(diff(trialStartTimes));
% title('diff startTime of every 2 trials', 'fontSize', 14);

meanTrialDuration=mean(diff(trialStartTimes));



for trialNum=1:length(trialStartTimes)
    trialStartTime=trialStartTimes(trialNum);% start time of each trial
    startat=trialStartTime-3; % 3s before actual start time
    stopat=trialStartTime+7; % 7s after actual start time
    spikes=SPK(SPK>startat&SPK<stopat);% SPKs are actually time stamps
    spikes=spikes-startat;
%      keyboard;
%     plot(spikes);% define spks into a previous 5s to post 10s duration in terms of time stamps
%     hline(startat+5);%plotting actual starting time
    rasterrow=histc(spikes,0:myvar:10);
    raster(trialNum,:)=rasterrow;
    
end

psth=raster;

% a=size(psth,1)-1;
% a=size(psth,1);


b=size(psth,2)-1;
psth=psth(:,1:b);

% figure(4)
% imagesc(raster);
% colormap gray;
% colorbar;
% vline(500);% plot starting times 0.1s bins 5s has 50 bins
% 
% figure(5)
plot(smooth(mean(raster),50));
% % axis([xmin xmax ymin ymax])
% 
xlim([1 999])
vline(300);
vline(400);
ylabel('SPK per bin', 'fontSize', 14);
xlabel('bins', 'fontSize', 14);


end

