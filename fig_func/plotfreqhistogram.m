% What is the resultant vector length, i.e. the spike count at 30 deg/60
% deg etc.
% divideint = 12; %into 12 bins
% edges = linspace(-pi,pi,divideint);
% [N,edges,bin] = histcounts(theta,edges);
% % N is the frequency count
% means = arrayfun(@(i)mean(spkc(bin==i)),1:divideint-1);
% stes = arrayfun(@(i)ste(spkc(bin==i)),1:divideint-1);
% 
% alpha = arrayfun(@(i)sum(spkc(bin==i)),1:divideint-1);
% w = arrayfun(@(i)sum(bin==i),1:divideint-1);
% 
% % w = means;
% d = 2*pi/divideint; % 30 degrees
% alpha = cell(length(theta),1);
% for i = 1:length(theta)
%     alpha{i} = repmat(theta(i),spkc(i),1);
% end
% alpha = cell2mat(alpha);
% 
% 
% r = circ_r(edges,alpha./w,NaN);
%     alpha	sample of angles in radians
%     [w		number of incidences in case of binned angle data]
%     [d    spacing of bin centers for binned data, if supplied
%           correction factor is used to correct for bias in
%           estimation of r, in radians (!)]



%% Plot Frequency Histogram For Gaze Angle/saccade direction
if ~exist('data','var')
    load('../input_data/data_searchTask_2017_fromPriyanka')
end
epoch = 931:961;  % CHANGE ME%
startneuron = 1;
egocentric = true;

for count = 1:ceil(length(data)/5)
    figure
    for neuron = startneuron:startneuron+4
        % which theta?
        if egocentric
            % saccade direction?
            [theta,spkc] = get_egocentric_tuning(data,neuron,epoch);
        else
            % or gaze direction
            [~,~,spkc,theta]= get_xyspike_priyanka(data,neuron,epoch);
        end
        % convert to spike rate spikes/s
        spkc = spkc./(length(epoch)*0.01);
        divideint = 12; %into 12 bins, 30 deg each
        edges = linspace(-pi,pi,divideint);
        [N,edges,bin] = histcounts(theta,edges);
        alpha = arrayfun(@(i)sum(spkc(bin==i)),1:divideint-1);
        w = arrayfun(@(i)sum(bin==i),1:divideint-1);
        subplot(2,5,neuron-startneuron+1)
        polarhistogram('BinEdges',edges,'BinCounts',alpha./w,'Normalization','probability');
        %     circ_plot(alpha,'hist',[],divideint,true,true,'linewidth',2,'color','r')
        title(['neuron',num2str(neuron),': spike count']);
        subplot(2,5,5+(neuron-startneuron+1))
        circ_plot(theta,'hist',[],divideint,true,true,'linewidth',2,'color','r');
        title(['neuron',num2str(neuron),': frequecy count']);
    end
    startneuron = startneuron+5;
end