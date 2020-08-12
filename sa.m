tic;
clc;
clear;
close all;

global NFE;
NFE=0;

%% Problem Definition

model=AACreateModel_ExcelRead();         % Create Model of the Problem

% ParallelJobOperating
model.ParallelJobOperating = ones(size(model.ParallelJobOperating));

CostFunction=@(Solution) DAMyCost(Solution,model);       % Cost Function

nVar=model.nVar;                    % Number of Decision Variables

VarSize=[1 nVar];                   % Size of Decision Variables Matrix

%% SA Parameters

% MaxIt=450;      % Maximum Number of Iterations

% MaxIt2=15;      % Maximum Number of Inner Iterations

prompt = {'Enter Maximum Iteration: ','Enter Maximum Inner Iteration: :'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'450','10'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

MaxIt = ceil(str2double(answer(1)));

MaxIt2 = ceil(str2double(answer(2)));

% if MaxIt < 450 
%     MaxIt = 450;
% end
% 
% if MaxIt2 < 10 
%     MaxIt2 = 10;
% end

T0=100;          % Initial Temperature

alpha=0.99;     % Temperature Damping Rate

%% Initialization

% Create Initial Solution
% xKanban
xKanban = CACreateRandomSolution(model);
[xKanban.Cost, xKanban.Inter] = CostFunction(xKanban);

% xBestCompletionTime
xBestCompletionTime = CACreateRandomSolution(model);
[xBestCompletionTime.Cost, xBestCompletionTime.Inter] = CostFunction(xBestCompletionTime);

% Update Best Solution Ever Found
BestSol = xKanban;

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt,1);

% Array to Hold NFEs
nfe = zeros(MaxIt,1);

% Set Initial Temperature
T=T0;

%% SA Main Loop

for it=1:MaxIt
    for it2=1:MaxIt2
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % xKanban             %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Create Neighbor
        clear xnew;
        xnew = xKanban;
        xnew = GACreateNeighbor(xnew,model);
        [xnew.Cost, xnew.Inter] = CostFunction(xnew);
        
        %% 
%         xnew = CACreateRandomSolution(model);
%         [xnew.Cost xnew.Inter] = CostFunction(xnew);
        %% 
        if xnew.Cost(2) <= xKanban.Cost(2)
            
            if ~(it > (MaxIt - 30))
                % xnew is better, so it is accepted
                xKanban=xnew;
                
            elseif xnew.Cost(1) <= xKanban.Cost(1)
                xKanban=xnew;
            end
            
%         elseif xnew.Cost(2) == xKanban.Cost(2)
%             
%             if xnew.Cost(1) <= xKanban.Cost(1)
%                 xKanban=xnew;
%             end
            
        else 
            % xnew is not better, so it is accepted conditionally
            delta1 = xnew.Cost(2) - xKanban.Cost(2);
            p1 = exp(-delta1/T);
            
            if rand <= p1
                xKanban = xnew;
            end
            
        end
        
        % Update Best Solution
        if xKanban.Cost(2) <= BestSol.Cost(2)
            BestSol = xKanban;
        end
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % xBestCompletionTime %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Create Neighbor
        clear xnew;
        xnew = xBestCompletionTime;
        xnew = GACreateNeighbor(xnew,model);
        [xnew.Cost, xnew.Inter] = CostFunction(xnew);
        
        %% 
%         xnew = CACreateRandomSolution(model);
%         [xnew.Cost xnew.Inter] = CostFunction(xnew);
        %% 
        if xnew.Cost(1) <= xBestCompletionTime.Cost(1)
            % xnew is better, so it is accepted
            xBestCompletionTime = xnew;
            
%         else 
%             % xnew is not better, so it is accepted conditionally
%             delta2 = xnew.Cost(1) - xBestCompletionTime.Cost(1);
%             p2 = exp(-delta2/T);
%             
%             if rand <= p2
%                 xBestCompletionTime = xnew;
%             end
            
        end
        
% %         % Update Best Solution
% %         if xKanban.Cost(2) <= BestSol.Cost(2)
% %             BestSol = xKanban;
% %         end
        
        
        
    end
    
    % Store Best Cost
    BestCost(it) = BestSol.Cost(2);
    
    % Store NFE
    nfe(it) = NFE;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
    % Reduce Temperature
    T = alpha*T;
    
% %     % Plot Solution
% %     figure(1);
% % %     subplot(4,3,[1:9])
% %     FAPlotSolution(BestSol,model);
% %     h=title('Best Kanban Production Planning');
% %     set(h,'color', 'black','fontsize',14);
% %     pause (0.000001);
% % %     subplot(4,3,[10:12])
% % %     FBPlotRack(BestSol,model);
% %     pause (0.000001);
    
    
    % Plot Solution
    figure(1);
    subplot(2,1,1)
    FAPlotSolution(BestSol,model);
    h=title('Best Kanban Production Planning');
    set(h,'color', 'black','fontsize',14);
    pause (0.001);
    subplot(2,1,2)
    FAPlotSolution(xBestCompletionTime,model);
    h=title('Best Completion Time Production Planning');
    set(h,'color', 'black','fontsize',14);
    pause (0.001);
    

end

%% Best Cost
[TDay, Thour, ~, TMinute2] = ECGetTime(BestSol.Cost(1)-7);
disp(['The Best Solution is ' num2str(BestSol.Cost(1)) '; ' char(10) char(10) char(10)...
      'The Number of Day is: ' num2str(TDay) char(10) ... 
      'The Number of Hour is: ' num2str(Thour) char(10) ... 
      'The Number of Minute is: ' num2str(TMinute2)]);

%% Results

figure(2);
plot(nfe,BestCost,'LineWidth',2);
xlabel('NFE');
ylabel('Best Cost');
h=title('Best Kanban Production Planning COST');
set(h,'color', 'black','fontsize',14);

% % % best Completion time
% % figure(3);
% % FAPlotSolution(xBestCompletionTime,model);
% % h=title('Best Completion Time Production Planning');
% % set(h,'color', 'red','fontsize',14);

% %% Save the last result
% 
% answer=DoYouWantToSaveTheBestAnswer(BestSol);

%%
% xKanban
figure(3);
FAPlotSolution(xKanban,model);
[~, ~]=DAMyCostxKanban(xKanban,model);



%%
%
toc;



% 
% if exist('PreBestSol.mat', 'file') == 2
%     
%     PreBestSol = load('PreBestSol.mat');
%     
%     if PreBestSol.BestSol.Cost < BestSol.Cost
%         % Plot Solution
%         figure(3);
%         subplot(4,3,[1:9])
%         FAPlotSolution(PreBestSol.BestSol,model);
%         pause (0.000001);
%         subplot(4,3,[10:12])
%         FBPlotRack(PreBestSol.BestSol,model);
%         pause (0.000001);
%         
%     else
%         % Plot Solution
%         figure(3);
%         subplot(4,3,[1:9])
%         FAPlotSolution(PreBestSol.BestSol,model);
%         pause (0.000001);
%         subplot(4,3,[10:12])
%         FBPlotRack(PreBestSol.BestSol,model);
%         pause (0.000001);
%         
%         save('PreBestSol.mat','BestSol');
%     end
%     
% else
%     
%     save('PreBestSol.mat','BestSol');
%     
% end













% return;


% 
% 
% 
% if exist('PreBestSol.mat', 'file') == 2 && exist('xBestCompletionTime.mat', 'file') == 2 
%     
%     PreBestSol = load('PreBestSol.mat');
%     
%     xBestCompletionTime = load('xBestCompletionTime.mat');
%     
%     if PreBestSol.BestSol.Cost(2) < BestSol.Cost(2)
%         % Plot Solution
%         figure(3);
% %         subplot(4,3,[1:9])
%         FAPlotSolution(PreBestSol.BestSol,model);
%         pause (0.000001);
% %         subplot(4,3,[10:12])
% %         FBPlotRack(PreBestSol.BestSol,model);
% %         pause (0.000001);
%         
%     else
%         % Plot Solution
%         figure(3);
% %         subplot(4,3,[1:9])
%         FAPlotSolution(PreBestSol.BestSol,model);
%         pause (0.000001);
% %         subplot(4,3,[10:12])
% %         FBPlotRack(PreBestSol.BestSol,model);
% %         pause (0.000001);
%         
%         save('PreBestSol.mat','BestSol');
%         
%         save('xBestCompletionTime.mat','xBestCompletionTime');
%         
%     end
%     
% else
%     
%     save('PreBestSol.mat','BestSol');
%     
%     save('xBestCompletionTime.mat','xBestCompletionTime');
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% load('BestSol.mat');
% load('xBestCompletionTime.mat');
% % Plot Solution
% figure(4);
% subplot(2,1,1)
% FAPlotSolution(BestSol,model);
% h=title('Best Kanban Production Planning');
% set(h,'color', 'black','fontsize',14);
% pause (0.000001);
% subplot(2,1,2)
% FAPlotSolution(xBestCompletionTime,model);
% h=title('Best Completion Time Production Planning');
% set(h,'color', 'black','fontsize',14);
% pause (0.000001);
% 
% 
% 
% 



