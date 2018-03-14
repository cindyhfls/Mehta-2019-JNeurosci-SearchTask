function visualizefitparams(varargin)

plt = varargin{1};

figure
if strcmp(varargin{2},'gs') % if uses the global optimization toolbox
    params = plt(1).X;
    repeat = length(plt);
    for i =1:numel(params) % plot for each parameter
        subplot(size(params,2),size(params,1),i)
        pltcoords = sortrows([arrayfun(@(z)plt(z).X(i),1:repeat)',cell2mat({plt(:).Fval})'],2,'descend');
        plot(1:length(pltcoords),pltcoords(:,1),'o');
        xlabel('index');
        ylabel(['params ',num2str(i)]);
    end
else % plot the result
    params = plt(1).params;
    repeat = length(plt);
    for i =1:numel(params) % plot for each parameter
        subplot(size(params,2),size(params,1),i)
        pltcoords = sortrows([arrayfun(@(z)plt(z).params(i),1:repeat)',[plt(:).nll]'],2,'descend');
        plot(1:length(pltcoords),pltcoords(:,1),'o');
        xlabel('index');
        ylabel(['params ',num2str(i)]);
    end
end

end