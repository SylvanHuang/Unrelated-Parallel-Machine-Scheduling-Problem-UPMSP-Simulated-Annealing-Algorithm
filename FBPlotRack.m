function FBPlotRack(BestSol,model)

RackStatusDay = BestSol.Inter.RackStatusDay;

MaxDAY = ECGetTime(max(max(BestSol.Inter.StartTime)));

% Learn about API authentication here: https://plot.ly/matlab/getting-started
% Find your api_key here: https://plot.ly/settings/api

%bins
x = 1:size(RackStatusDay,3);

y=zeros(2,max(x));

for i=1:max(x)
    y(:,i) = (sum(RackStatusDay(:,:,i)))';
end

y = y(:,1:MaxDAY);

%data
% y1 = [75.99,91.92,105.71,...
%        123.23,131.69,...
%        150.67,179.33,203.12,...
%        226.55,249.63,281.42];
y1 = y(1,:);

%data
% y2 = [55.2,61.972,65.71,...
%        76.23,87.669,...
%        91.7,103.23,124.21,...
%        130.55,135.63,145.22];
y2 = y(2,:);

% % % % % % %create MATLAB bar chart
% % % % % % % fig = figure;
% % % % % % bar(x, y1, 'r');
% % % % % % hold on
% % % % % % bar(x, y2,'b');
% % % % % % 
% % % % % % %add legend
% % % % % % legend('group1','group2');
% % % % % % 
% % % % % % hold off;

% Y = [1.0 0.5 0.7
%      2.0 1.5 2.0
%      5.0 4.0 5.0
%      4.0 4.0 4.5
%      3.0 2.0 2.0];

% fig = figure;
bar(y','group');

end