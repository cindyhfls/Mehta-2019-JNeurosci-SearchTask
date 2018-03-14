n = 10;
idx=1;
count = 1;

data = mydata(n);

L = size(data.var,1); %total number of trials
tempfun = @(i)data.var{i,5}(data.var{i,2},:);
MaskPos=cell2mat(arrayfun(tempfun,[1:L]','UniformOutput',false));

CenterXY = data.var{1,1};
% diamond position
% theta = atan2(MaskPos(:,2)-CenterXY(2),MaskPos(:,1)-CenterXY(1));

% all eye position
theta= atan2(data.EyeY-CenterXY(2),data.EyeX-CenterXY(1));
psth = data.psth;
divideint = 5;
[N,edges,bin] = histcounts(theta,divideint);
% figure;hold on
% for k = 1:length(bin)
% histogram(psth(bin ==k),'Normalization','pdf');
% end
% hold off


sz = numel(data.EyeX(:,1000:1200));
clr = reshape(psth(:,1000:1200),[],1);
clr = clr*100; % convert to spks/s
x = reshape(data.EyeX(:,1000:1200),[],1);
y = reshape(data.EyeY(:,1000:1200),[],1);

binsize = 100;
Xedges = min(x):binsize:max(x); % 10 pixel bins
Yedges = min(y):binsize:max(y);

[N,Xedges,Yedges,Xbins,Ybins] = histcounts2(x,y,Xedges,Yedges); 

Nfr = N; % Now change the count to the firing rate 
for i = 1:size(Nfr,1)
    for j = 1:size(Nfr,2)
        Nfr(i,j)= mean(clr(Xbins==i & Ybins ==j));
    end
end
Nfr(N==0) = NaN; % impute the mean for missing locations

cmap = jet(128);
cmap = cmap([4:8:72,76:10:126],:);


figure;colormap(cmap)
subplot(2,1,1)
imagesc(flipud(Nfr'));title('firing rate (spk/s)')
subplot(2,1,2)
imagesc(flipud(N'));title('time spent at position')
