    figure
    plt = solutions;
    for i =1:numel(params) % plot for each parameter
    subplot(size(params,1),size(params,2),i)
    pltcoords = sortrows([arrayfun(@(z)plt(z).X(i),1:length(solutions))',[plt(:).Fval]'],2,'descend');
    plot(1:length(pltcoords),pltcoords(:,1),'x');
    xlabel('index');
    ylabel(['params ',num2str(i)]);
    end


% visualize basins of attraction

possColors = 'k';

figure;hold on
for i = 1:size(solutions,2)
    i
%     % Plot start points
%     u = solutions(i).X0; 
% %     x0ThisMin = reshape([u{:}], 2, length(u));
%     x0ThisMin = [u{:}];
%     x0ThisMin = x0ThisMin(1:2);
%     plot(x0ThisMin(1), x0ThisMin(2), '.', ...
%         'MarkerSize',25);
    % Color of this line
    color = solutions(i).Fval;
    % Plot the basin with color i
    scatter(solutions(i).X(1), solutions(i).X(2),25,color);
    % pause(.5);
end % basin center marked with a *, start points with dots
hold off