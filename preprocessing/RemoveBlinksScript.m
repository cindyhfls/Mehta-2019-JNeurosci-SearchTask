% FP14 is x
% FP15 is y
% FP16 is pupil
% Pupil size loses signal when blink or move, so I only used velocity and
% amplitude of change to elimate pupil data. 
% Saccade can mean fast change in position, so the I use the time in pupil to remove blinking in position data
% instead of setting a velocity/acceleration criteria for position
function EyeData = RemoveBlinksScript(FP14,FP15,FP16,ts,filter)
ts_step =1/1000;
x3 = FP14;
y3 = FP15;
pupil3 =FP16;
Time = ts(1)*ones(length(FP15),1)+ts_step*(1:length(FP15))';
if filter
        %% Third-pass: cut off x<-2000 and y<-1000 and 50 ms before and after that
%         figure
%         plot(FP14(1:100000),FP15(1:100000));
        xcutoff = -2000; % arbitrary eyeballed threshold
        ycutoff = -1000; % arbitrary eyeballed threshold
        cutofftime = 20; % 20 ms above and below (because sampling freq = 1000Hz, one row = 1ms)
        % cutoff with xthreshold
        idx = find(x3 <= xcutoff);
        x3(idx) = NaN; y3(idx) = NaN; pupil3(idx) = NaN;
        myidx =[idx(1);idx(diff(idx)~=1)];
        for i = 1:length(myidx)
            x3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
            y3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
            pupil3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
        end
        % same for ythreshold
        idx = find(y3 <= ycutoff); % xcutoff
        x3(idx) = NaN; y3(idx) = NaN; pupil3(idx) = NaN;
        myidx =[idx(1);idx(diff(idx)~=1)];
        for i = 1:length(myidx)
            try
                x3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
                y3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
                pupil3(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
            catch
                x3(myidx(i):myidx(i)+cutofftime) = NaN;
                y3(myidx(i):myidx(i)+cutofftime) = NaN;
                pupil3(myidx(i):myidx(i)+cutofftime) = NaN;
            end
        end
            
%         figure
%         plot(x3(1:100000),y3(1:100000));
        %% Use a more stringent threshold just for pupil size (pupil size changes as eye moves)
        pupil = pupil3;
        idx = find(pupil <= 300); % xcutoff
        pupil(idx) = NaN;
        myidx =[idx(1);idx(diff(idx)~=1)];
        for i = 1:length(myidx)
            try
                pupil(myidx(i)-cutofftime:myidx(i)+cutofftime) = NaN;
            catch
                pupil(myidx(i):myidx(i)+cutofftime) = NaN;
            end
        end
%         figure
%         plot(pupil3(1:100000));hold on
%         plot(pupil(1:100000)); hold off
else
    pupil = pupil3;
end
%% Save Data and time in a separate file
EyeData = [Time,x3,y3,pupil]; % time x y pupil
end

%% Old Code
% %% First-pass: remove rapid change in pupil size
% myvar = pupil3; 
% 
% % Pre-allocate memory
% Velocity = NaN(length(myvar),1);
% Acceleration = NaN(length(myvar),1);
% 
% % Get velocity first
% for i = 2:length(myvar) %#ok<*NODEF> %not 1 because I rely on i-1 for calculations
%         Velocity(i,1) = myvar(i,1) - myvar(i-1,1); 
% end
% myvar(:,2) = Velocity(:,1);
% 
% % Now get acceleration
% for i=2:length(myvar) %because we rely on i-2 for calculations
%         Acceleration(i,1) = myvar(i,2) - myvar(i-1,2); %#ok<*AGROW>
% end
% myvar(:,3) = Acceleration(:,1);
% 
% threshold = 40;
% cutoff = prctile(myvar,threshold);
% 
% newcol = size(myvar,2)+1;
% myvar(:,newcol) = myvar(:,1);
% % last column is myvar data with cutoffs applied
% for i = 1:length(myvar)    
%     if abs(myvar(i,1)) >= cutoff(1)
%         myvar(i,newcol) = NaN;
%     end
% %     if abs(myvar(i,2)) >= cutoff(2) %20
% %         myvar(i,newcol) = NaN;
% %     end
% %     if abs(myvar(i,3)) >= cutoff(3) %20
% %         myvar(i,newcol) = NaN;
% %     end
% end
% 
% % plot
% figure
% plot(myvar(1:100000,1));hold on
% plot(myvar(1:100000,newcol));hold off
% 
% pupil=myvar(:,newcol);

% % Select the output file for the processed data
% % Remove blinking in x-pos
% x = FP14;
% x(isnan(myvar(:,end)))=NaN;
% figure
% plot(FP14(1:10000));hold on
% plot(x(1:10000));hold off
% % Remove blinking in y-pos
% y = FP15;
% y(isnan(myvar(:,end)))=NaN;
% figure
% plot(FP15(1:10000));hold on
% plot(y(1:10000));hold off
%% Second Pass: Remove large dy/dx
% %% % figure
% % cmap = parula(5000);
% % scatter(x(1:5000),y(1:5000),10,cmap);
% % colorbar
% % 
% dy = NaN(length(y),1);
% dx = NaN(length(x),1);
% for i = 2:length(y) 
%     dy(i) = y(i,1) - y(i-1,1); 
%     dx(i) = x(i,1) - x(i-1,1); 
% end
% grad = dy./dx;
% y2 =y; x2=x;pupil2 = pupil;
% i= abs(grad)> prctile(grad,96); %This removes the huge movement in
% % y-direction, but I have decided that these might be important.
% % Because these are not blinking, they are just looking outside the
% % screen/very fast movement
% % We can go back and remove this later.
% y2(i) = NaN;
% x2(i) = NaN;
% pupil2(i) = NaN;
% 
% 
% figure
% plot(x(1:100000),y(1:100000));
% figure
% plot(x2(1:100000),y2(1:100000));