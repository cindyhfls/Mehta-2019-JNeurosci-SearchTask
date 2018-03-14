% %Sep 12
close all
clear
load('../input_data/data_wrapped_Cindy.mat','mydata');
numneuron=size(mydata,2);
%% params:
binWidth = 10; % in ms, of psth
epochOI = 500:1500;
eventTs = 10.*100.*binWidth;
eventStr = {'Center Fixation Complete'};
%%
% load('../input_data/data_searchTask_2017_fromPriyanka')
% numneuron=size(data,2);
% binWidth = 10; % in ms, of psth
% epochOI = 931:1060;
% eventTs = [961,1000].*binWidth;
% eventStr = {'Fixation on Diamond','Bar Appear'};
%% pull out psth's

smoothBy = 10;

divideint = 5;
edges = linspace(-pi,pi,divideint);

m = NaN(length(data),length(epochOI),divideint-1);
se = NaN(length(data),length(epochOI),divideint-1);
count = NaN(length(data),2);

x = epochOI*binWidth;


for c = 1:length(data)
    psth = data(c).psth(:,epochOI)*(1000/binWidth);
    
    % normalize within cell (zscore to mean and std of FR across trials):
    psth = (psth - nanmean(nanmean(psth,2)))./nanste(nanmean(psth,2));
    %     theta = get_egocentric_tuning(data,c,epochOI);
%     [~,~,~,theta]=get_xyspike_priyanka(data,c,epochOI);
    [~,~,bin] = histcounts(theta,edges);
    for q = 1:divideint-1
%         idx = bin == q;
idx = ones(size(psth));
        m(c,:,q) = nanmean(psth(idx,:));
        count(c,q) = sum(idx);
        se(c,:,q) = nanste(psth(idx,:)); % just one neuron
    end
end
%% plot psth


clr = 'rgbcmy';

figure('position',[400,400,1000,1000]);
startneuron = 1;
for c = startneuron:startneuron+9
    count = c-startneuron+1;
    subplot(5,2,count);hold on
    for q = 1:divideint-1
        h(q)= plot(x,smooth(m(c,:,q),smoothBy),clr(q));
        plot(x,smooth(m(c,:,q)+se(c,:,q),smoothBy),'--','Color',clr(q)); % just one neuron
        plot(x,smooth(m(c,:,q)-se(c,:,q),smoothBy),'--','Color',clr(q));
        %         h(q)= plot(x,smooth(nanmean(m(:,:,q)),smoothBy),clr(q));
        %         plot(x,smooth(nanmean(m(:,:,q))+nanste(m(:,:,q)),smoothBy),'--','Color',clr(q)); % all neurons
        %         plot(x,smooth(nanmean(m(:,:,q))-nanste(m(:,:,q)),smoothBy),'--','Color',clr(q));
    end
    %     % set(h,'LineWidth',1.5)
    
    
    %     h1 = ttest(m(:,:,1),m(:,:,2));
    %     plot(x(h1==1),ones(sum(h1),1).*-.9,'.k')
    
    
    
    ylabel('firing rate (normalized)');
    xlabel('time in trial(ms)');
    title (['Neuron',num2str(c)]);
    
    tmp = ylim;
    for i = 1:length(eventTs)
        plot([eventTs(i),eventTs(i)],[tmp],'k')
        text(eventTs(i)+20,tmp(2),eventStr{i},...
            'FontSize',10)
    end
    hold off
%     if c == 10
%         legend(['Gaze angles (from center of the screen), bin = ',num2str(divideint-1)],'location','southoutside')
%     end
end
print(gcf,['../temp_result/psth',num2str(startneuron)],'-fillpage','-dpdf')
return
