% Load Data
DataFileName = 'data_searchTask_2017_fromPriyanka.mat';
if ~exist('data','var')
    load(fullfile('../input_data/',DataFileName),'data');
end

epoch = 941:960; % change me %  %961 start of diamond fixation, %1001 start of bar fixation
% plot normalized data
count = 1;
while count<14
    figure('position',[400,400,800,800]);
    for neuron = 10*(count-1)+1:10*count
        remd = neuron-10*(count-1);
        try
            subplot(5,2,remd);hold on
            [theta,spkc] = get_egocentric_tuning(data,neuron,epoch);
%             [X,Y,spkc] = get_xyspike_priyanka(data,neuron,epoch);
        catch
            return % stop if there is no more to plot
        end

        
%         if neuron <12 || neuron >70
%             theta = atan2((900*Y-450),(1600*X-800)); % change the screen size and center values
%         else
%             theta = atan2((1080*Y-540),(1920*X-960)); % change the screen size and center values
%         end
        
        divideint = 12; %into 12 bins
        edges = linspace(-pi,pi,divideint);
        [N,edges,bin] = histcounts(theta,edges);
        means = arrayfun(@(i)mean(spkc(bin==i)),1:divideint);
        stes = arrayfun(@(i)ste(spkc(bin==i)),1:divideint);
        
        
        smoothby = 1;                 
        plot(edges,smooth(means,smoothby),'b.-');
        plot(edges,smooth(means+stes,smoothby),'b:');
        plot(edges,smooth(means-stes,smoothby),'b:');  
        
%         %plot also the random effect
%         for j = 1:10
%             spkc = spkc(randperm(length(spkc)));
%             for i = 1:divideint
%                 temp(i) = mean(spkc(bin==i));
%             end
%             means(j,:) = temp;
%             %         plot(edges,smooth(means,smoothby),'-','Color',[.45,.45,.45]);
%         end
%         
%         randbound = means(1:10,:);
%         %         randbound = quantile(means,[0.025,0.975]);
%         for k = 1:10
%         plot(edges,smooth(randbound(k,:),smoothby),'--');%,'Color',[.45,.45,.45]
%         end
        %         plot(edges,smooth(randbound(2,:),smoothby),'--','Color',[.45,.45,.45]);

        xlim([-pi,pi]);
        xticks(linspace(-pi,pi,3));
        xticklabels({'-pi','0','pi'});
        title(['Neuron ',num2str(neuron)]);
        hold off
        
        %     figure
        %     plot(bin,spkc,'ro');
        % sanity check: plot all data to see if the tuning was biased by the
        % difference in number of samples.
        
    end
%     print(gcf,['temp_result/angletuning',num2str(count)],'-dpdf','-bestfit');
    count = count+1;
end
