% CreateHeatMap
%%IMPORTANT!!%% 
% 1-11 and 71-122 uses the screen 1600*900
% 12-70 uses the screen 1920*1080
% Using Priyanka's wrapped data
load('../input_data/data_searchTask_2017_fromPriyanka')
%%
ScreenL = 0;
ScreenT = 0;
ScreenR = 1;
ScreenB = 1;
for n = 3
%% Either use Priyanka's wrapped data
epoch = 961:1000; % 400 ms before bar viewing
% epoch = 1010:1060; % 300 ms after bar viewing (taking into account the
% sensory processing time)
[X,Y,spkc,MaskValue]= get_xyspike_priyanka(data,n,epoch);
% spkc = spkc(randperm(length(spkc)));
%% Or use my wrapped data (whole trial)
% [X,Y,spkr]=get_xyspike(data,n);
% ScreenL = min(X)*1.1;
% ScreenR = max(X)*1.1;
% ScreenT = min(Y)*1.1;
% ScreenB = max(Y)*1.1;
%% Heat Map for Density of Diamonds
binsize = 0.1;
Xedges = ScreenL:binsize:ScreenR; % 10 pixel bins
Yedges = ScreenT:binsize:ScreenB;
[N,Xedges,Yedges,Xbins,Ybins] = histcounts2(X,Y,Xedges,Yedges); 

Nfr = N; % Now change the count to the firing rate 
for i = 1:size(Nfr,1)
    for j = 1:size(Nfr,2)
        Nfr(i,j)= mean(spkc(Xbins==i & Ybins ==j));
    end
end
Nfr(N==0) = mean(spkc); % impute the mean for missing locations

Nval = N;
for i = 1:size(Nval,1)
    for j = 1:size(Nval,2)
        Nval(i,j)= mean(MaskValue(Xbins==i & Ybins ==j));
    end
end

%% Normalization as ratio to maximum and smooth??
N = N/max(N(:));
Nfr = Nfr/max(Nfr(:));
% Smooth
N = interp2(N,3);
Nfr = interp2(Nfr,3);
Nval = interp2(Nval,3);
%% Now we can plot 
disp(['Now plotting for neuron',num2str(n)])

figure('position',[400,400,800,800]);
subplot(3,2,1);
imagesc(flipud(Nfr'));colorbar
title('firing rate heat map(normalized to max)')
xlength = length(smooth(nanmean(flipud(Nfr'),1)));
ax=subplot(3,2,3);
plot(1:xlength,smooth(nanmean(flipud(Nfr'),1),10)); % over y
ax.YDir = 'reverse';
ax=subplot(3,2,2);
plot(smooth(nanmean(flipud(Nfr'),2),10),1:xlength); 
ax.YDir = 'reverse';

% ax=subplot(2,2,3);
% plot(1:ScreenR/binsize,smooth(nanmean(flipud(Nfr'),1),10)); % over y
% ax.YDir = 'reverse';
% ax=subplot(2,2,2);
% plot(smooth(nanmean(flipud(Nfr'),2),10),1:ScreenB/binsize); 
% ax.YDir = 'reverse';
subplot(3,2,4);
surf(Nfr');

subplot(3,2,5);
imagesc(flipud(N'));colorbar
title('density of diamonds he looked at')

subplot(3,2,6);
imagesc(flipud(Nval'));colorbar
title('mean value of diamonds he looked at')
% print(gcf,['../temp_result/HeatMapNeuron',num2str(n)],'-bestfit','-dpdf');
% close all
end



return


%% Some old code
figure('position',[100,400,640,360]);
imagesc(flipud(N'));colorbar
title(['Density of Diamonds (normalized to max), bin size = ',num2str(binsize)]);

figure('position',[600,400,640,360]);
imagesc(flipud(Nfr'));colorbar
title(['Firing Rate (normalized to max),bin size = ',num2str(binsize)] );

figure('position',[200,0,640,360]);
imagesc(flipud(Nval'));colorbar
title(['Value of diamonds (normalized to max),bin size = ',num2str(binsize)] );

% Scatter Plot
figure('position',[400,400,400,400])
scatter(X,Y,10,spkc,'filled');
alpha(.5);

% disp('Press any key to continue to next neuron...');
% pause;
% close all
% if n == 122
%     break
% end









