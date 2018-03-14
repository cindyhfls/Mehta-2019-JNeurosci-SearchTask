% Compare Real Data With Fitted Data
%%IMPORTANT!!%%
% 1-11 and 71-122 uses the screen 1600*900
% 12-70 uses the screen 1920*1080
% Using Priyanka's wrapped data
function CompareDataWithFit(data,allresult)
%% specify colormap
cmap = jet(128);
cmap = cmap([4:8:72,76:10:126],:);
%% specify screen sizes
ScreenL = 0;
ScreenT = 0;
ScreenR = 1;
ScreenB = 1;
%% Get all the distributions
fields=fieldnames(allresult);
BIC = arrayfun(@(i)allresult.(fields{i}).bic,1:numel(fieldnames(allresult)));
[~,bfit_idx] = min(BIC); % find out which model have the lowest BIC
if isnan(BIC(1))
   error('This neuron is corrupted')
end

fitX = linspace(0,1,100)';
fitY = linspace(0,1,100)';
[gridX,gridY] = meshgrid(fitX,fitY);
fitX = gridX(:);
fitY = gridY(:);
for i=1:length(fields)
    result = allresult.(fields{i});
    if contains(result.distributionName,'mixed')
        distribution = result.distributionName;
        k = result.k;
%         k = 1;  % for the original fits
        fitspkc(:,i) = mixedgaussian([fitX,fitY],result.fit_params,k); % x, and y in the same distribution
    else
        partitioncoef = getpartitioncoef(result.distributionName);
        fitspkc(:,i) = mixed_distribution([fitX,fitY],result.fit_params,result.distributionName,partitioncoef);
    end
end


for n = result.neuron % which neuron it is
    %% Either use Priyanka's wrapped data
    epoch = result.epoch; % 400 ms before bar viewing
    % epoch = 1010:1060; % 300 ms after bar viewing (taking into account the
    % sensory processing time)
    [X,Y,spkc,MaskValue]= get_xyspike_priyanka(data,n,epoch);
    fitspkc = fitspkc./(length(epoch)./100);
    spkc = spkc./(length(epoch)./100);
    %% Heat Map for Density of Diamonds
    binsize = .1; % 0.1 if normalized
    Xedges = ScreenL:binsize:ScreenR; % 10 pixel bins
    Yedges = ScreenT:binsize:ScreenB;
    [N,~,~,Xbins,Ybins] = histcounts2(X,Y,Xedges,Yedges);
    
    Nfr = N; % Now change the count to the firing rate
    for i = 1:size(Nfr,1)
        for j = 1:size(Nfr,2)
            Nfr(i,j)= mean(spkc(Xbins==i & Ybins ==j));
        end
    end
    Nfr(N==0)=NaN;
%     Nfr(N==0) = mean(spkc); % impute the mean for missing locations
    
    Nval = N;
    for i = 1:size(Nval,1)
        for j = 1:size(Nval,2)
            Nval(i,j)= mean(MaskValue(Xbins==i & Ybins ==j));
        end
    end
    
    % do a separate one for fitted distribution
    % [Nfit,~,~,Xbins,Ybins] = histcounts2(fitX,fitY,Xedges,Yedges);
    % Nfitfr = Nfit; % Now change the count to the fitted firing rate
    % for i = 1:size(Nfitfr,1)
    %     for j = 1:size(Nfitfr,2)
    %         Nfitfr(i,j)= mean(fitspkc(Xbins==i & Ybins ==j));
    %     end
    % end
    % Nfitfr(N==0) = mean(fitspkc); % impute the mean for missing locations
    
    
    %% Marginalize across x and y
    Nfrmag = NaN([size(N),max(N(:))]); % Now change the count to the firing rate
    for i = 1:size(Nfrmag,1)
        for j = 1:size(Nfrmag,2)
            temp = spkc(Xbins==i & Ybins ==j);
            Nfrmag(i,j,1:length(temp))=temp;
        end
    end
    
    % marginalize to see distribution across x and y (and some weird
    % correction because of the way imagesc is plotted)
    magx = nanmean(reshape(Nfrmag,size(Nfrmag,1),[]),2);
    stex = nanste(reshape(Nfrmag,size(Nfrmag,1),[])')';
    magy = flipud(nanmean(reshape(permute(Nfrmag,[2,1,3]),size(Nfrmag,2),[]),2));
    stey = real(nanste(reshape(permute(Nfrmag,[2,1,3]),size(Nfrmag,2),[])')');
    stey = flipud(stey);
    %% Normalization as ratio to maximum and smooth??
    % N = N/max(N(:));
    % Nfr = Nfr/max(Nfr(:));
    % Nfitfr = Nfitfr/max(Nfitfr(:));
    % Smooth
    smoothby = 3; % a factor, how many divisions between the neareast two points do you want,
    % the larger the value, the more smooth, 0 means no smooth
    N = interp2(N,smoothby);
    Nfr = interp2(Nfr,smoothby);
    % Nfitfr = interp2(Nfitfr,smoothby);
    Nval = interp2(Nval,smoothby);
    templength = length(magx);
    % smooth by interpolation
    magx = interp1(magx,linspace(1,templength,length(N)));
    magy = interp1(magy,linspace(1,templength,length(N)));
    stex = interp1(stex,linspace(1,templength,length(N)));
    stey = interp1(stey,linspace(1,templength,length(N)));
    %% Now we can plot
    disp(['Now plotting for neuron',num2str(n)])
    smoothBy = 10;
    figure('position',[400,400,800,800]);
    subplot(3,2,1);
    imagesc(flipud(Nfr'));colormap(cmap)
    xticklabels({});yticklabels({});
    colorbar
    title('firing rate heat map') % removed (normalized to max)
    % xlength = length(smooth(magx,smoothBy));
    ax1=subplot(3,2,3);hold on
    % hfit = plot(fitX,smooth(fitspkc,smoothBy),'r.');alpha(.5)
    hfit = plot(unique(fitX),arrayfun(@(i)mean(fitspkc(fitX==i,bfit_idx),1),unique(fitX)),'r','LineWidth',2);
    allotherspkc = cell2mat(arrayfun(@(i)mean(fitspkc(fitX==i,setdiff(1:length(fields),bfit_idx)),1),unique(fitX),'UniformOutput',false));
    for i = 1:size(allotherspkc,2)
        hfit(i+1) = plot(unique(fitX),allotherspkc(:,i),'Color',[0.45,0.45,0.45]); % in grey
    end
    hreal = plot(linspace(0,1,length(N)),smooth(magx,smoothBy),'b-'); % over y
    plot(linspace(0,1,length(N)),smooth(magx+stex,smoothBy),'--b');
    plot(linspace(0,1,length(N)),smooth(magx-stex,smoothBy),'--b');
    % plot(1:xlength,smooth(nanmean(flipud(Nfr'),1),smoothBy)); % over y
    % plot(1:xlength,smooth(nanmean(flipud(Nfr'))+nanste(flipud(Nfr')),smoothBy),'--b');
    % plot(1:xlength,smooth(nanmean(flipud(Nfr'))-nanste(flipud(Nfr')),smoothBy),'--b');
    % sz = length(N)-1;
    ax1.YDir = 'reverse';
    title(fields{bfit_idx});
    ylabel('Firing Rate (spikes/second)');
    hold off % over y
    % hfit = plot(1:xlength,smooth(nanmean(flipud(Nfitfr'),1),smoothBy),'r-');
    
    %     legend([hreal,hfit(1),hfit(2)],{allresult.(fields{bfit_idx}).distributionName,'real data','others'});
    legend([hreal,hfit(1),hfit(2)],{'real data','best-fit','others'});
    
    ax2=subplot(3,2,2);hold on
    hreal = plot(smooth(magy,smoothBy),linspace(0,1,length(N)),'b-'); % over y
    plot(smooth(magy+stey,smoothBy),linspace(0,1,length(N)),'--b');
    plot(smooth(magy-stey,smoothBy),linspace(0,1,length(N)),'--b');
    % plot(smooth(nanmean(flipud(Nfr'),2),smoothBy),1:xlength);  %over x
    % plot(smooth(nanmean(flipud(Nfr'),2)+nanste(flipud(Nfr))',smoothBy),1:xlength,'--b');  %over x
    % plot(smooth(nanmean(flipud(Nfr'),2)-nanste(flipud(Nfr))',smoothBy),1:xlength,'--b');  %over x
    % hfit2 = plot(smooth(nanmean(flipud(Nfitfr'),2),smoothBy),1:xlength,'r-');
    hfit2 = plot(arrayfun(@(i)mean(fitspkc(fitY==i,bfit_idx)),unique(fitY)),unique(fitY),'r','LineWidth',2);
   for i = 1:size(allotherspkc,2)
        hfit2(i+1) = plot(allotherspkc(:,i),unique(fitY),'Color',[0.45,0.45,0.45]); % in grey
   end
    % hfit2 = plot(smooth(fitspkc,smoothBy),sz*fitY,'r-'); hold off
    ax2.YDir = 'reverse';
    title(fields{bfit_idx});
%     legend(hfit2(1),[result.distributionName,' fit']);
    legend([hreal,hfit2(1),hfit2(2)],{'real data','best-fit','others'});
    xlabel('Firing Rate (spikes/second)');
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
    
    % figure;
    % subplot(2,2,1);
    % imagesc(flipud(N'));colorbar
    % title('density of diamonds he looked at')
    % xlength = length(smooth(nanmean(flipud(N'),1)));
    % ax1=subplot(2,2,3);hold on
    % plot(1:xlength,smooth(nanmean(flipud(N'),1),10),'r-'); % over y
    % ax1.YDir = 'reverse';
    % ax2=subplot(2,2,2);hold on
    % plot(smooth(nanmean(flipud(N'),2),10),1:xlength,'r-');  %over x
    % ax2.YDir = 'reverse';
    
    
    % print(gcf,['../temp_result/HeatMapNeuron',num2str(n)],'-bestfit','-dpdf');
    % close all
end



return