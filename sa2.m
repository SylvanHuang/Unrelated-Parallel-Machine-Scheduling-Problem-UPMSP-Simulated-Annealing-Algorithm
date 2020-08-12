tic;
clc;
clear;
close all;

global NFE;
NFE=0;

%% Problem Definition

model=AACreateModel_ExcelRead();         % Create Model of the Problem

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

nPop=4;         % Population Size

nMove=6;        % Number of Neighbors per Individual

%% Initialization

% Create Empty Structure for Individuals
empty_individual.Permutation=[];
empty_individual.NumberOfProductForEachSplit=[];
empty_individual.WorkingHours=[];
empty_individual.ListsOfJobsDedicated2EachMachine=[];
empty_individual.Cost=[];
empty_individual.Inter=[];

% Create Population Array
pop=repmat(empty_individual,nPop,1);

% Initialize Best Solution
BestSol.Cost=[inf, inf];

% Initialize Population
for i=1:nPop
    
    % Initialize Position
    CRS = CACreateRandomSolution(model);
    
    pop(i).Permutation=CRS.Permutation;
    pop(i).NumberOfProductForEachSplit=CRS.NumberOfProductForEachSplit;
    pop(i).WorkingHours=CRS.WorkingHours;
    pop(i).ListsOfJobsDedicated2EachMachine=CRS.ListsOfJobsDedicated2EachMachine;
    
    % Evaluation
    [pop(i).Cost, pop(i).Inter]=CostFunction(pop(i));
    
    % Update Best Solution
    if pop(i).Cost(2)<=BestSol.Cost(2)
        BestSol=pop(i);
    end
    
end

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Intialize Temp.
T=T0;

% Array to Hold NFEs
nfe = zeros(MaxIt,1);

%% SA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxIt2
        
        % Create and Evaluate New Solutions
        newpop=repmat(empty_individual,nPop,nMove);
        for i=1:nPop
            for j=1:nMove
                
                % Create Neighbor
                CRS = GACreateNeighbor(pop(i),model);
                [CRS.Cost, CRS.Inter]=CostFunction(pop(i));
                
                newpop(i,j).Permutation=CRS.Permutation;
                newpop(i,j).NumberOfProductForEachSplit=CRS.NumberOfProductForEachSplit;
                newpop(i,j).WorkingHours=CRS.WorkingHours;
                newpop(i,j).ListsOfJobsDedicated2EachMachine=CRS.ListsOfJobsDedicated2EachMachine;
                newpop(i,j).Cost=CRS.Cost;
                
                % Evaluation
                [newpop(i,j).Cost, newpop(i,j).Inter]=CostFunction(newpop(i,j));
                
            end
        end
        newpop=newpop(:);
        
        % Sort Neighbors
        SortPop=zeros(size(newpop,1),1);
        for SPop=1:size(newpop,1)
            SortPop(SPop)=newpop(SPop).Cost(2);
        end
        [~, SortOrder]=sort(SortPop);
        newpop=newpop(SortOrder);
        
        for i=1:nPop
            
            if newpop(i).Cost(2)<=pop(i).Cost(2)
                pop(i)=newpop(i);
                
            else
                DELTA=(newpop(i).Cost(2)-pop(i).Cost(2))/pop(i).Cost(2);
                P=exp(-DELTA/T);
                if rand<=P
                    pop(i)=newpop(i);
                end
            end
            
            % Update Best Solution Ever Found
            if pop(i).Cost(2)<=BestSol.Cost(2)
                BestSol=pop(i);
            end
        
        end

    end
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost(2);
    
    % Store NFE
    nfe(it) = NFE;
    
    % Display Iteration Information
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
    % Update Temp.
    T=alpha*T;
    
    % Plot Best Solution
    figure(1);
    FAPlotSolution(BestSol,model);
    pause(0.01);
    
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

toc;


%%
% xKanban
figure(3);
FAPlotSolution(BestSol,model);
[~, ~]=DAMyCostxKanban(BestSol,model);


