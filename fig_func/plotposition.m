%% plot eye position
%%
startoffset = 1000; % 100 is the startoffset to set up PSTH and eye position
for i = 7% trial number
    for c = 1
        endTrial = ceil([mydata(c).var{i,7}]*100+startoffset)
        % find the end trial stamp by converting it from seconds to 10 ms and add 2 s offset
        figure
        plot(mydata(c).EyeX(i,startoffset:endTrial),mydata(c).EyeY(i,startoffset:endTrial),'o-');
        xlim([-2000,2000]) % estimated screen from rough calculation
        ylim([-1600,2300]) % estimated screen from rough calculation
        %% plot real position of offers and center dot
        endTrial = ceil([mydata(c).var{i,7}]*100+startoffset);
        % find the end trial stamp by converting it from seconds to 10 ms and add 2 s offset
        centerpos=[mydata(c).var{i,1}]';
        realpos = mydata(c).var{i,5};
        openpos = mydata(c).var{i,5}(mydata(c).var{i,2},:);
        figure
        plot(realpos(:,1),realpos(:,2),'bd',centerpos(1),centerpos(2),'r+');hold on
        for k = 1:length(openpos)
        plot(openpos(k,1),openpos(k,2),'d','MarkerFaceColor','none');
        end
        ylim([0,centerpos(2)*2]);
        xlim([0,centerpos(1)*2]);
%         %% Live plot of spkc
%         figure;hold on
%         for timechange = 1:118
%             timewindow = [1:10]+10*timechange;
%             eyeX = mydata(c).EyeX(i,timewindow);
%             eyeY = mydata(c).EyeY(i,timewindow);
%             spkc = mydata(c).psth(i,timewindow);
%             scatter(eyeX,eyeY,10,spkc,'filled');alpha(.5);
%             pause(.1)
%             colorbar
%         end   
%         %% 
%         c=10
%         time = 1:length([mydata(c).psth(:)]);
%         figure;hold on
%         while time<=length([mydata(c).psth(:)])
%         spkc = [mydata(c).psth(time)];
%         eyeX = [mydata(c).EyeX(time)];
%         eyeY = [mydata(c).EyeY(time)];
%         plot(eyeX,eyeY,'ko','MarkerSize',1); alpha(.5)
%                 xlim([-2000,2000]) % estimated screen from rough calculation
%                 ylim([-1600,2300]) % estimated screen from rough calculation
%         figure
%         plot(eyeX(spkc~=0),eyeY(spkc~=0),'ro','MarkerSize',1);alpha(.5);
%                 xlim([-2000,2000]) % estimated screen from rough calculation
%                 ylim([-1600,2300]) % estimated screen from rough calculation
%         time = time+10000;
%         pause(.5)
%         end
%         hold off

    end
end 


