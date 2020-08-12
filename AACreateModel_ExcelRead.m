function model=AACreateModel_ExcelRead()

    [FileName, PathName] = uigetfile('*.xlsx','Select the excel file input ');
    
    disp(['FileName is: ' FileName]);
    disp(['FilePath is: ' PathName]);
    disp(char(10));
    
	addpath(PathName);
    
    model.FileName = FileName;
    model.PathName = PathName;
    
%     clear FileName PathName;
    
    %% 
    % Number Of Machines; Number Of Jobs
    
    sheet = 'RudimentaryInformation';
%     [ndata, text, alldata] = xlsread(filename, sheet);
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('NumberOfMachines', txt);
    
    [truefalse2, index2] = ismember('NumberOfJobs', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet char(10) ... 
              'Number Of Machines; Number Of Jobs' char(10)]);
        return;
    end
    
    model.NumberOfMachines = cell2mat(row(index1,2));
    
    model.NumberOfJobs = cell2mat(row(index2,2));
    
    % CLEAR 
    clear sheet num txt row truefalse1 index1 truefalse2 index2;
    
    %% 
    % Process Time
    % Process Time per products, Columns are Machines, 
    %                            Rows are Jobs or Products 
    % Row 2, Column 3: 69 units of second product are produced in one hour 
    %                  if they are processed by 3rd machine 
    sheet = 'ProcessTime';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Machine01', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10) ... 
              'Job01, Machine01']);
        return;
    end
    
    % Job01
    [I1, J1] = ind2sub(size(row),index1);
    
    % Machine01
    [I2, J2] = ind2sub(size(row),index2);
    
    model.NamesOfJobs = (row(I1:I1+model.NumberOfJobs-1,J1:-1:J1-2));
    
%     model.NamesOfJobs = [];
    
    model.NamesOfMachines = (row(I2:-1:I2-1,J2:J2+model.NumberOfMachines-1));
    
    model.ProcessTimePerHourJobMachine = cell2mat(row(I1:I1+model.NumberOfJobs-1,J1+1:J1+1+model.NumberOfMachines-1));
    
    % NaN
    if sum(isnan(model.ProcessTimePerHourJobMachine(:))) > 0
        disp(['There is at least one empty cell in sheet ' sheet char(10) ... 
              'And it is replaced with zero.']);
    end
    model.ProcessTimePerHourJobMachine(isnan(model.ProcessTimePerHourJobMachine(:))) = 0;
    
    if size(model.ProcessTimePerHourJobMachine,1) ~= model.NumberOfJobs
        disp(['Matrix of ProcessTimePerHourJobMachine has: ' num2str(size(model.ProcessTimePerHourJobMachine,1)) ' rows,' char(10) ... 
              'NumberOfJobs is: ' num2str(model.NumberOfJobs) ... 
              char(10) 'THERE IS A MAJOR ERROR ... ' ... 
              char(10) 'The number of products are not the same.']);
         
         return;
    end
    
%     % Error
%     if size(model.ProcessTimePerHourJobMachine,2) ~= model.NumberOfMachines
%         disp(['Matrix of ProcessTimePerHourJobMachine has: ' num2str(size(model.ProcessTimePerHourJobMachine,2)) ' columns,' char(10) ... 
%               'NumberOfMachines is: ' num2str(model.NumberOfMachines) ... 
%               char(10) 'THERE IS A MAJOR ERROR ... ' ... 
%               char(10) 'The number of machines are not the same.']);
%          
%          return;
%     end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
   	% Amend function
    [model.ProcessTimePerHourJobMachine, model.FeasibleJobsListsOnEachMachine, model.FeasibleMachineListsForEachJob] = ... 
        ADAmendProcessTimePerHourJobMachine(model.ProcessTimePerHourJobMachine,model.NumberOfJobs,model.NumberOfMachines);
    
    %% 
    % NeededProductPerWeek and DAY
    sheet = 'NeededProduct';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('WholeRequirement', txt);
    
    [truefalse3, index3] = ismember('Saturday', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 || truefalse3 ==0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % WholeRequirement
    [~, J2] = ind2sub(size(row),index2);
    
    % Saturday
    [~, J3] = ind2sub(size(row),index3);
    
    model.Need.WholeRequirement = cell2mat(row(I1:I1+model.NumberOfJobs-1,J2));
    
    model.Need.DaysOfTheWeek = cell2mat(row(I1:I1+model.NumberOfJobs-1,J3:J3+6));
    
    % NaN
    if sum(isnan(model.Need.WholeRequirement(:))) > 0
        disp(['There is at least one empty cell in "NeededProduct sheet".' char(10) ... 
              'And it is replaced with zero.']);
    end
    model.Need.WholeRequirement(isnan(model.Need.WholeRequirement(:))) = 0;
    
    if sum(isnan(model.Need.DaysOfTheWeek(:))) > 0
        disp(['There is at least one empty cell in "NeededProduct sheet".' char(10) ... 
              'And it is replaced with zero.']);
    end
    model.Need.DaysOfTheWeek(isnan(model.Need.DaysOfTheWeek(:))) = 0;
    
    if sum((sum(model.Need.DaysOfTheWeek,2)) ~= model.Need.WholeRequirement) > 0
        disp(['There is at least one product in sheet ' sheet char(10) ... 
              'that the summation of need per day is not equal to WholeRequirement.' char(10) ...
              'And the summation of need per day is replaced with the WholeRequirement.']);
    end
    
    for j = 1:model.NumberOfJobs
        
        if (sum(model.Need.DaysOfTheWeek(j,:))) ~= model.Need.WholeRequirement(j)
             model.Need.WholeRequirement(j) = (sum(model.Need.DaysOfTheWeek(j),2));
        end
        
    end
    
    % Cummulative Summation
    model.Need.CummulativeSummation = cumsum(model.Need.DaysOfTheWeek, 2);
    
    if sum(model.Need.WholeRequirement == model.Need.CummulativeSummation(:,end)) ~= model.NumberOfJobs
        model.Need.WholeRequirement = model.Need.CummulativeSummation(:,end);
        
        disp(['model.Need.WholeRequirement = model.Need.CummulativeSummation(:,end)' char(10)]);
        
    end
    
%     % NeededProductPerWeek
%     model.NeededProductPerWeek = model.Need.WholeRequirement;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 truefalse3 index3 I1 J2 J3 j;
    
    %% 
    % Lost Profit Per Day
    % If a need is not satisfied, how much we lose
    
    sheet = 'LostProfitPerDay';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('CostPerDay', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % CostPerDay
    [~, J2] = ind2sub(size(row),index2);
    
    model.LostProfitPerDay = cell2mat(row(I1:I1+model.NumberOfJobs-1,J2));
    
    % NaN
    if sum(isnan(model.LostProfitPerDay(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'And it is replaced with zero.']);
    end
    model.LostProfitPerDay(isnan(model.LostProfitPerDay(:))) = 0;
    
    if size(model.LostProfitPerDay,1) ~= model.NumberOfJobs
        disp(['Matrix of LostProftPerDay has: ' num2str(size(model.LostProfitPerDay,1)) ' rows,' char(10) ... 
              'NumberOfJobs is: ' num2str(model.NumberOfJobs) ... 
              char(10) 'THERE IS A MAJOR ERROR ... ' ... 
              char(10) 'The number of products are not the same.']);
         
         return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %%
    % Setup Time
    % setup time of machines when one job is shifted to another
    model.SetupTimePerHour = zeros(model.NumberOfJobs, model.NumberOfJobs, model.NumberOfMachines);
    
    for m = 1:model.NumberOfMachines
        
        sheet = strcat('SetupTimeMachine',num2str(m));
        
        [~,txt,row] = xlsread(FileName,sheet);
    
        [truefalse1, index1] = ismember('Job01', txt);
        
        if truefalse1 == 0 
            disp(['There is a problem with excel sheet ' sheet char(10)]);
            return;
        end
        
        % Job01
        % first "Job01" is found
        [I, J] = ind2sub(size(row),index1);
        
        model.SetupTimePerHour(:,:,m) = cell2mat(row(I:I+model.NumberOfJobs-1,J+1:J+1+model.NumberOfJobs-1));
        
        % NaN
        tempST = model.SetupTimePerHour(:,:,m);
        if sum(isnan(tempST(:))) > 0
            disp(['There is at least one empty cell in ' sheet '.' char(10) ... 
                'And it is replaced with zero.']);
        end
        
        tempST(isnan(tempST(:))) = 0;
        
        % diagonal elements
        if sum(tempST(logical(eye(size(tempST))))) ~= 0
            tempST(logical(eye(size(tempST)))) = 0;
        
            disp(['The summation of diagonal elements of matrix SetupTime of sheet ' sheet ' is not zero.' char(10)...
                  'The program amended the matrix.']);
              
        end
        
        % Symmetric between elements
        for j1 = 1:model.NumberOfJobs
            
            for j2 = 1:model.NumberOfJobs
                
                if tempST(j1, j2) ~= tempST(j2, j1)
                    
%                     disp(['The setup time of ' '(' num2str(j1) ', ' num2str(j2) ')= ' num2str(tempST(j1, j2)) ' and' char(10)... 
%                           'the setup time of ' '(' num2str(j2) ', ' num2str(j1) ')= ' num2str(tempST(j2, j1)) ' are not equal.']);
                    
                    if tempST(j1, j2) < tempST(j2, j1)
                        tempST(j1, j2) = tempST(j2, j1);
                        continue;
                    end
                    tempST(j2, j1) = tempST(j1, j2);
                end
                
            end
            
        end
        
        model.SetupTimePerHour(:,:,m) = tempST/60;
        
    end
    
    clear sheet num txt row truefalse1 index1 I J m j1 j2 tempST;
    
    %% 
    % Preparation Time
    
    model.PreparationTimePerHour = zeros(model.NumberOfJobs, model.NumberOfJobs, model.NumberOfMachines);
    
    for m = 1:model.NumberOfMachines
        
        sheet = strcat('PreparationTimeMachine',num2str(m));
        
        [~,txt,row] = xlsread(FileName,sheet);
        
        [truefalse1, index1] = ismember('Job01', txt);
        
        if truefalse1 == 0 
            disp(['There is a problem with excel sheet ' sheet char(10)]);
            return;
        end
        
        % Job01
        % first "Job01" is found
        [I, J] = ind2sub(size(row),index1);
        
        model.PreparationTimePerHour(:,:,m) = cell2mat(row(I:I+model.NumberOfJobs-1,J+1:J+1+model.NumberOfJobs-1));
        
        % NaN
        tempPT = model.PreparationTimePerHour(:,:,m);
        if sum(isnan(tempPT(:))) > 0
            disp(['There is at least one empty cell in ' sheet '.' char(10) ... 
                'And it is replaced with zero.']);
        end
        
        tempPT(isnan(tempPT(:))) = 0;
        
        % diagonal elements
        if sum(tempPT(logical(eye(size(tempPT))))) ~= 0
            tempPT(logical(eye(size(tempPT)))) = 0;
        
            disp(['The summation of diagonal elements of matrix SetupTime of sheet ' sheet ' is not zero.' char(10)...
                  'The program amended the matrix.']);
              
        end
        
        % Symmetric between elements
        for j1 = 1:model.NumberOfJobs
            
            for j2 = 1:model.NumberOfJobs
                
                if tempPT(j1, j2) ~= tempPT(j2, j1)
                    
%                     disp(['The setup time of ' '(' num2str(j1) ', ' num2str(j2) ')= ' num2str(tempPT(j1, j2)) ' and' char(10)... 
%                           'the setup time of ' '(' num2str(j2) ', ' num2str(j1) ')= ' num2str(tempPT(j2, j1)) ' are not equal.']);
                    
                    if tempPT(j1, j2) < tempPT(j2, j1)
                        tempPT(j1, j2) = tempPT(j2, j1);
                        continue;
                    end
                    tempPT(j2, j1) = tempPT(j1, j2);
                end
                
            end
            
        end
        
        model.PreparationTimePerHour(:,:,m) = tempPT/60;
        
    end
    
    % Amend Setup Time 
    % data may not be true
    % Put 777 in places that setup time did not define
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     model.PreparationTimePerHour(model.PreparationTimePerHour == 0) = 10*max(max(max(model.PreparationTimePerHour)));
    
    clear sheet num txt row truefalse1 index1 I J m j1 j2 tempPT;
    
    %%
    % Percentage of Scrap
	% First Approach: Each job on eacg machine has a percentage of scrap
    % Rows are jobs or products, and Columns are machines
    % Row 1, Column 2: 0.0620 is the percentage of Scrap if first product
    %                  or job is produced on the 2nd machine, in other
    %                  words, in each 100 produced units, 6.2% of them are
    %                  scrap
    
    sheet = 'PercentageOfScrap';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, ~] = ismember('Machine01', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, J1] = ind2sub(size(row),index1);
    
    % Machine01
%     [I2, J2] = ind2sub(size(row),index2);
    
    model.PercentageOfScrap = cell2mat(row(I1:I1+model.NumberOfJobs-1,J1+1:J1+1+model.NumberOfMachines-1));
    
    % NaN
    if sum(isnan(model.PercentageOfScrap(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'And it is replaced with zero.']);
    end
    model.PercentageOfScrap(isnan(model.PercentageOfScrap(:))) = 0;
    
    if size(model.PercentageOfScrap,1) ~= model.NumberOfJobs
        disp(['Matrix of PercentageOfScrap has: ' num2str(size(model.PercentageOfScrap,1)) ' rows,' char(10) ... 
              'NumberOfJobs is: ' num2str(model.NumberOfJobs) ... 
              char(10) 'THERE IS A MAJOR ERROR ... ' ... 
              char(10) 'The number of products are not the same.']);
         
         return;
    end
    
    % Amend model.PercentageOfScrap
    model.PercentageOfScrap = model.PercentageOfScrap / 100;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Percentage of Stops
    % First Approach: each job on each machine has a Percentage of stops
    % Rows are jobs or products, and Columns are machines
    % Row 1, Column 2: 0.0600 is the percentage of Stops if first product
    %                  or job is produced on the 2nd machine, in other
    %                  words, in each 100 HOURS, 6.00% of them are
    %                  the Stops, So 94 HOURS are available for production 
    
    sheet = 'PercentageOfStops';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, ~] = ismember('Machine01', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, J1] = ind2sub(size(row),index1);
    
    % Machine01
%     [I2, J2] = ind2sub(size(row),index2);
    
    model.PercentageOfStops = cell2mat(row(I1:I1+model.NumberOfJobs-1,J1+1:J1+1+model.NumberOfMachines-1));
    
    % NaN
    if sum(isnan(model.PercentageOfStops(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'And it is replaced with zero.']);
    end
    model.PercentageOfStops(isnan(model.PercentageOfStops(:))) = 0;
    
    if size(model.PercentageOfStops,1) ~= model.NumberOfJobs
        disp(['Matrix of PercentageOfScrap has: ' num2str(size(model.PercentageOfStops,1)) ' rows,' char(10) ... 
              'NumberOfJobs is: ' num2str(model.NumberOfJobs) ... 
              char(10) 'THERE IS A MAJOR ERROR ... ' ... 
              char(10) 'The number of products are not the same.']);
         
         return;
    end
    
    % Amend model.PercentageOfScrap
    model.PercentageOfStops = model.PercentageOfStops / 100;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Minimum Economical Production
    
    sheet = 'MinimumEconomicalProduction';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('MinimumProduction', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % CostPerDay
    [~, J2] = ind2sub(size(row),index2);
    
    model.MinimumEconomicalProduction = cell2mat(row(I1:I1+model.NumberOfJobs-1,J2));
    
    % NaN
    if sum(isnan(model.MinimumEconomicalProduction(:))) > 0 || ... 
            sum((model.MinimumEconomicalProduction(:)) == 0) > 0
        disp(['There is at least one empty cell or zero in ' sheet ' sheet.' char(10) ... 
              'And it is replaced with max(model.MinimumEconomicalProduction(:)).']);
    end
    model.MinimumEconomicalProduction(isnan(model.MinimumEconomicalProduction(:))) = max(model.MinimumEconomicalProduction(:));
    model.MinimumEconomicalProduction((model.MinimumEconomicalProduction(:)) == 0) = max(model.MinimumEconomicalProduction(:));
    
    if size(model.MinimumEconomicalProduction,1) ~= model.NumberOfJobs
        disp(['Matrix of LostProftPerDay has: ' num2str(size(model.MinimumEconomicalProduction,1)) ' rows,' char(10) ... 
              'NumberOfJobs is: ' num2str(model.NumberOfJobs) ... 
              char(10) 'THERE IS A MAJOR ERROR ... ' ... 
              char(10) 'The number of products are not the same.']);
         
         return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Number of Split
    % Number of split for each job is based on the division of "Needed
    % Product Per Week" into "Economical Production" of the product
    model.NumberOfSplitForEachJob = ceil(model.Need.WholeRequirement ./ model.MinimumEconomicalProduction);
    model.NumberOfSplitForEachJob(model.NumberOfSplitForEachJob == 0) = 1;
    
%     model.NumberOfSplitForEachJob = max(model.NumberOfSplitForEachJob);
    
    %% 
    % nVar
    % Without any use
    model.nVar = sum(model.NumberOfSplitForEachJob) + model.NumberOfMachines - 1;
    
    %% 
    % Working Hours
    % as a sum, 2 Working Shifts a day, without Overtime equals to 19.3 hours a day
    %                                   19.3 (9.8 hours for a day + 9.5 hours for a night)
    % as a sum, 2 Working Shifts a day, with Overtime equals to 20.3 hours a day
    %                                   20.3 ([9.8 + 1] hours for a day + 9.5 hours for a night)
    % as a sum, 3 Working Shifts a day, equals to 23 hours a day and it is not
    %                                   allowed to have Overtime
    %                                   23 (7.66 + 7.66 + 7.66)
%     WorkingHours.Day = [6 7];
%     WorkingHours.Shift = [19.3 20.3 23];     % OR WorkingHours.Shift = [19.3 20.3]; 
    
    %% 
    % Day-WorkingHours
    sheet = 'Day-WorkingHours';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Type', txt);
    
    [truefalse2, index2] = ismember('Name', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Type
    [I1, J1] = ind2sub(size(row),index1);
    
    % Name
    [I2, J2] = ind2sub(size(row),index2);
    
    model.WorkingHours.Day = cell2mat(row(I2, (J2+1):(J2+( cell2mat(row(I1, J1+1)) ))));
    
    % NaN
    if sum(isnan(model.WorkingHours.Day(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'Fix the problem ...' char(10)]);
          return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Shift-WorkingHours
    sheet = 'Shift-WorkingHours';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Type', txt);
    
    [truefalse2, index2] = ismember('Name', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Type
    [I1, J1] = ind2sub(size(row),index1);
    
    % Name
    [I2, J2] = ind2sub(size(row),index2);
    
    model.WorkingHours.Shift = cell2mat(row(I2, (J2+1):(J2+( cell2mat(row(I1, J1+1)) ))));
    
    % NaN
    if sum(isnan(model.WorkingHours.Shift(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'Fix the problem ...' char(10)]);
          return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Crane Constraint 
    % one crane is only available 
    % there is a time limitation to use crane 
    
%     Crane.TimeLimit=[20 7]; 
% %                      20 7]; 
%     
%     Crane.Count=size(Crane.TimeLimit,1); 
    
    sheet = 'Crane';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('NumberOfCrane', txt);
    
    [truefalse2, index2] = ismember('Constraint', txt);
    
    if truefalse1 == 0 || truefalse2 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Type
    [I1, J1] = ind2sub(size(row),index1);
    
    % Name
    [I2, J2] = ind2sub(size(row),index2);
    
    model.Crane.Count = cell2mat(row(I1, J1+1));
    
    model.Crane.TimeLimit = cell2mat(row(I2:I2+model.Crane.Count-1, J2+1:J2+2));
    
    % NaN
    if sum(isnan(model.Crane.TimeLimit(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'Fix the problem ...' char(10)]);
          return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2;
    
    %% 
    % Inventory 
    % Inventory.Depot: is the availibily of each product at DEPOT
    % Inventory.Constraint: is the maximum level of each product at DEPOT
    % ALWAYS (Inventory.Depot + Production) < = (Inventory.Constraint)
    % Inventory.Depot & Inventory.Constraint both have 1 column and rows
    %     are the same as the number of products
    
    sheet = 'InitialDepot&PanelDepot';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Customer Initial Depot', txt);
    
    [truefalse3, index3] = ismember('Bronze Initial Depot', txt);
    
    [truefalse4, index4] = ismember('Panel Depot', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 || truefalse3 == 0 || truefalse4 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % Customer Initial Depot
    [~, J2] = ind2sub(size(row),index2);
    
    % Bronze Initial Depot
    [~, J3] = ind2sub(size(row),index3);
    
    % Panel Depot
    [~, J4] = ind2sub(size(row),index4);
    
    
    % model.Inventory.CustomerInitialDepot
    model.Inventory.CustomerInitialDepot = cell2mat(row( I1:I1+model.NumberOfJobs-1, J2 ));
    
    % NaN
    if sum(isnan(model.Inventory.CustomerInitialDepot(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
          return;
    end
    
    model.Inventory.CustomerInitialDepot(isnan(model.Inventory.CustomerInitialDepot(:))) = 0;
    
    
    % model.Inventory.BronzeInitialDepot
    model.Inventory.BronzeInitialDepot = cell2mat(row( I1:I1+model.NumberOfJobs-1, J3 ));
    
    % NaN
    if sum(isnan(model.Inventory.BronzeInitialDepot(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
          return;
    end
    
    model.Inventory.BronzeInitialDepot(isnan(model.Inventory.BronzeInitialDepot(:))) = 0;
    
    
    % model.Inventory.Panel
    model.Inventory.Panel = cell2mat(row( I1:I1+model.NumberOfJobs-1, J4 ));
    
    % NaN
    if sum(isnan(model.Inventory.Panel(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
          return;
    end
    
    model.Inventory.Panel(isnan(model.Inventory.Panel(:))) = 0;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 truefalse3 index3 truefalse4 index4 I1 J1 I2 J2 I3 J3 I4 J4;
    
    %% 
    % Minimum Inventory 
    sheet = 'InventoryMinimumDepot';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Minimum Level Of Each Product', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % Minimum Level Of Each Product
    [~, J2] = ind2sub(size(row),index2);
    
    % model.Inventory.MinimumDepot
    model.Inventory.MinimumDepot = cell2mat(row( I1:I1+model.NumberOfJobs-1, J2 ));
    
    % NaN
    if sum(isnan(model.Inventory.MinimumDepot(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
          return;
    end
    
    model.Inventory.MinimumDepot(isnan(model.Inventory.MinimumDepot(:))) = 0;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2 I3 J3;
    
    %% 
    % 
    sheet = 'ConsumptionRateOfInventory';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Rate', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % Rate
    [~, J2] = ind2sub(size(row),index2);
    
    % model.Inventory.ConsumptionRatePerDay
    model.Inventory.ConsumptionRatePerDay = cell2mat(row( I1:I1+model.NumberOfJobs-1, J2 ));
    
    % NaN
    if sum(isnan(model.Inventory.ConsumptionRatePerDay(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
          return;
    end
    
    model.Inventory.ConsumptionRatePerDay(isnan(model.Inventory.ConsumptionRatePerDay(:))) = 0;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2 I3 J3;
    
    %% 
    % Update model.NumberOfSplitForEachJob + model.nVar
    % Create a new parameter: NeededProduct
    % Please refer to Excel Sheet InventoryMinimumDepot to know how
    % calculate these above 3 parameters
    
    model = AHAmendModel1(model);
	
    %% 
    % Panel (OR Rack)
    
    sheet = 'NumberOfPanel';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Types of Panels', txt);
    
    [truefalse2, index2] = ismember('Panel01', txt);
    
    [truefalse3, index3] = ismember('Number of Each', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 || truefalse3 == 0
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Types of Panels
    [I1, ~] = ind2sub(size(row),index1);
    
    % Panel01
    [I2, ~] = ind2sub(size(row),index2);
    
    % Number of Each
    [~, J3] = ind2sub(size(row),index3);
    
    model.Rack.Types = cell2mat(row(I1, J3));
    
    model.Rack.AllAvailability = cell2mat(row(I2:I2+model.Rack.Types-1, J3))';
    
    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    prompt = {'Enter Rack Coefficient: '};
    dlg_title = 'Input';
    num_lines = 1;
    def = {'10'};
    Coefficient = cell2mat(inputdlg(prompt, dlg_title, num_lines, def));
    
    Coefficient = str2double(Coefficient);
    
    if Coefficient < 1
        Coefficient = 1;
    end
    
    model.Rack.AllAvailability = ceil(Coefficient * model.Rack.AllAvailability);
    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    % NaN
    if sum(isnan(model.Rack.Types(:))) > 0
        disp(['All types of panel in ' sheet ' sheet is unknown.' char(10) ... 
              'Fix the problem ...' char(10)]);
          return;
    end
    
    % NaN
    if sum(isnan(model.Rack.AllAvailability(:))) > 0
        disp(['The number of each panel in ' sheet ' sheet is unknown.' char(10) ... 
              'Fix the problem ...' char(10)]);
          return;
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 truefalse3 index3 I1 J1 I2 J2;
    
    %% 
    % 
    % model.Panel.Initial: number of panels that have been used per product
    
    sheet = 'PanelInitial';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Panel01', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % Panel01
    [~, J2] = ind2sub(size(row),index2);
    
    % model.Panel.Initial
    model.Rack.Initial = cell2mat(row( I1:I1+model.NumberOfJobs-1, J2:J2+model.Rack.Types-1 ));
    
    % NaN
    if sum(isnan(model.Rack.Initial(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
        return; 
    end
    
    model.Rack.Initial(isnan(model.Rack.Initial(:))) = 0;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2 I3 J3;
    
    %% 
    % model.Panel.Capacity: 
    
    sheet = 'PanelCapacity';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    [truefalse2, index2] = ismember('Panel01', txt);
    
    if truefalse1 == 0 || truefalse2 == 0 
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, ~] = ind2sub(size(row),index1);
    
    % Panel01
    [~, J2] = ind2sub(size(row),index2);
    
    % model.Panel.Initial
    model.Rack.Capacity = cell2mat(row( I1:I1+model.NumberOfJobs-1, J2:J2+model.Rack.Types-1 ));
    
    % NaN
    if sum(isnan(model.Rack.Capacity(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with zero.' char(10)]);
        return; 
    end
    
    model.Rack.Capacity(isnan(model.Rack.Capacity(:))) = 0;
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 truefalse2 index2 I1 J1 I2 J2 I3 J3;
    
    %% 
    % model.ParallelJobOperating
    
    sheet = 'ParallelJobOperating';
    
    [~,txt,row] = xlsread(FileName,sheet);
    
    [truefalse1, index1] = ismember('Job01', txt);
    
    if truefalse1 == 0 
        disp(['There is a problem with excel sheet ' sheet '.' char(10)]);
        return;
    end
    
    % Job01
    [I1, J1] = ind2sub(size(row),index1);
    
    % model.ParallelJobOperating
    model.ParallelJobOperating = cell2mat(row( I1:I1+model.NumberOfJobs-1, J1+1:J1+1+model.NumberOfJobs-1 ));
    
    % NaN
    if sum(isnan(model.ParallelJobOperating(:))) > 0
        disp(['There is at least one empty cell in ' sheet ' sheet.' char(10) ... 
              'and it is replaced with one.' char(10)]);
        return; 
    end
    
    model.ParallelJobOperating(isnan(model.ParallelJobOperating(:))) = 1;
    
    % Make it a symmetric matrix 
    [I2, J2] = find(model.ParallelJobOperating==0);
    
    if size(I2) > 0
        for Job = 1:size(I2)
            model.ParallelJobOperating(J2(Job), I2(Job)) = 0;
            
        end
    end
    
    % CLEAR
    clear sheet num txt row truefalse1 index1 I1 J1 I2 J2 Job;
    
    %%
    %
    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    tempJWC=sum(model.Rack.Capacity,2);
    model.Rack.JobsWithoutConstraint=(find(tempJWC==0))';
    
    
    % The number of racks which available after one day
    model.Rack.ConsumptionRatePerDay= zeros(size(model.Rack.Capacity));
    for RT=1:model.Rack.Types
        for j=1:model.NumberOfJobs
            if model.Rack.Capacity(j, RT) ~= 0
                model.Rack.ConsumptionRatePerDay(j, RT) = model.Rack.ConsumptionRatePerDay(j)/model.Rack.Capacity(j, RT);
                
                if model.Rack.ConsumptionRatePerDay(j, RT) < 1
                    model.Rack.ConsumptionRatePerDay(j, RT) = ceil(model.Rack.ConsumptionRatePerDay(j, RT));
                    
                else
                    model.Rack.ConsumptionRatePerDay(j, RT) = round(model.Rack.ConsumptionRatePerDay(j, RT));
                    
                end
            end
        end
    end

    model.Rack.ConsumptionRatePerDay=model.Rack.ConsumptionRatePerDay; % Inventory.ConsumptionRatePerDay;
    
    %%
    % Nothing Left 
    
    
    
    
%     a = 1;
    
    
    
    
    %% 
%     s = strcat(s1,s2) ...
%     string = [row{3}]


















































































% %     %% Initial Status of system
% %     
% % %     exist name returns the status of name:
% % %         0 name does not exist.
% % %         1 name is a variable in the workspace.
% % %         2 One of the following is true:
% % %             name exists on your MATLAB® search path as a file with extension .m.
% % %             name is the name of an ordinary file on your MATLAB search path.
% % %             name is the full pathname to any file
% % % 
% % %     if exist('InitialSol.mat', 'file') == 2
% % %         answer=ABAreYouRunningForTheFirstTime();
% % %         switch answer 
% % %             case 0  % No
% % %                 PassageOfTime=ACAskPassageOfTime();
% % %                 if PassageOfTime==0 % 0 means Saturday at 7 O'Clock
% % %                     tempSol=load('InitialSol.mat');
% % %                     InitialStatus.Sol=tempSol.InitialSol;
% % %                     InitialStatus.PassageOfTimeInHour=[];
% % %                 else 
% % %                     tempSol=load('InitialSol.mat');
% % %                     InitialStatus.Sol=tempSol.InitialSol;
% % %                     InitialStatus.PassageOfTimeInHour=PassageOfTime;
% % %                 end
% % %             case 1  % Yes
% % %                 InitialStatus.Sol=[];
% % %                 InitialStatus.PassageOfTimeInHour=[];
% % %             case 2  % Cancel
% % %                 InitialStatus.Sol=[];
% % %                 InitialStatus.PassageOfTimeInHour=[];
% % %         end
% % %     else
% % %         % Be careful in ParseSolution.m $#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
% % %         InitialStatus.Sol=[];
% % %         InitialStatus.PassageOfTime=[];
% % %     end
% %     





% %     %% output
% % %     model.InitialStatus=InitialStatus;
% %     
% %     model.ProcessTimePerHourJobMachine = ProcessTimePerHourJobMachine;

% %     model.FeasibleJobsLists=FeasibleJobsLists;
% %     
% %     model.NumberOfSplitForEachJob = NumberOfSplitForEachJob;
% %     
% %     model.NeededProductPerWeek = NeededProductPerWeek;
% %     
% % %     model.SetupTimePerMinute = SetupTimePerMinute;
% % %     model.PreparationTimePerMinute = PreparationTimePerMinute;
% %     model.SetupTimePerHour = SetupTimePerMinute/60;
% %     model.PreparationTimePerHour = PreparationTimePerMinute/60;
% %     
% %     model.nVar = NumberOfJobs+NumberOfMachines - 1;
% %     
% %     model.PercentageOfScrap = PercentageOfScrap;
% %     model.PercentageOfStops = PercentageOfStops;
% %     model.WorkingHours = WorkingHours;
% %     model.Inventory = Inventory;
% %     
% %     model.MinimumEconomicalProduction = MinimumEconomicalProduction;
% %     
% %     model.Rack.Types=RackTypes;
% %     model.Rack.AllAvailability=RackAllAvailability;
% %     model.Rack.Initial=RackInitial;
% %     model.Rack.Capacity=RackCapacity;
% %     model.Rack.JobsWithoutConstraint=JobsWithoutConstraint;
% %     model.Rack.ConsumptionRatePerDay=ConsumptionRatePerDay; % Inventory.ConsumptionRatePerDay;
% %     
% %     model.Crane=Crane;
% %     
% %     %% SAVE model
% %     save('InitialModel.mat','model');

end
