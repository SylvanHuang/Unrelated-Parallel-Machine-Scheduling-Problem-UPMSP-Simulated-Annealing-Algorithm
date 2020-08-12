function Interpretation=EAParseSolution(Solution,model)

    %% model
    ProcessTimePerHourJobMachine=model.ProcessTimePerHourJobMachine;
    
    NumberOfJobs=model.NumberOfJobs;
    NumberOfMachines=model.NumberOfMachines;
    
    NumberOfSplitForEachJob=model.NumberOfSplitForEachJob;
    
    RealNeededProducts=model.RealNeededProducts;
    
    SetupTimePerHour=model.SetupTimePerHour;
    PreparationTimePerHour=model.PreparationTimePerHour;
    
    PercentageOfScrap=model.PercentageOfScrap;
    PercentageOfStops=model.PercentageOfStops;
    
    ModelWorkingHoursShift=model.WorkingHours.Shift;
    
%     % MinimumEconomicalProduction: It should be considered beforehand
%     MinimumEconomicalProduction=model.MinimumEconomicalProduction;
    
    Rack=model.Rack;
    
    Crane=model.Crane;
    
    ParallelJobOperating = model.ParallelJobOperating;
	
    %% Solution
%     Permutation=Solution.Permutation;
    NumberOfProductForEachSplit=Solution.NumberOfProductForEachSplit;
    WorkingHours=Solution.WorkingHours;
    ListsOfJobsDedicated2EachMachine=Solution.ListsOfJobsDedicated2EachMachine;
    
    %% All Constraints 
    % 1- jobs are split 
    % 2- one split job cannot process at the same time on different machine
    % 3- there are only limitted crane for changing the FORM at a specific time 
    % DONE 4- the jobs that are at minimum depot level are in priority
    % DONE 5- Economical Production is the minimum amount of production 
    % 6- in night shift we cannot change the FORM from one product to another 
    % DONE 7- it may happen that a machine has different types of shift during
    % the week 
    % 8- Rack Constraint has to be considered 
	
    %%
    
    % 4- the jobs that are at minimum depot level are in priority
%     [UpdatedPermutation, UpdatedLists]=EBPriorityJobs2do(ListsOfJobsDedicated2EachMachine,model);
    
    % The better Lists is Updated
%     Solution.Permutation=UpdatedPermutation;
%     Solution.ListsOfJobsDedicated2EachMachine=UpdatedLists;
    
    %% $$$$$$$$$$$$$$$$******************$$$$$$$$$$$$$$$$$$$$$$$$$$
%     % 5- Economical Production is the minimum amount of production
%     AmendedPercentageOfWork=ListAmendment2(PercentageOfWork,model);
%     % The better Percentage of work is updated
%     Solution.PercentageOfWork=AmendedPercentageOfWork;
    
    %% calculate which part of a day, a machine cannot operate
    % based on the model.WorkingHours.Shift
    
    InoperativeWorkingHours=zeros(2, size(ModelWorkingHoursShift,2));
    InoperativeWorkingHours(1,:)=ModelWorkingHoursShift;
    for inop=1:size(ModelWorkingHoursShift,2)
        InoperativeWorkingHours(2,inop)=(24-ModelWorkingHoursShift(inop));
        % second row is related to the time that must be added 
        % InoperativeWorkingHours shows that from what time to 7 o'clock in
        % the morning a machine that follows that WorkingHours cannot
        % operate, for example 3.3 a.m. to 7 a.m.
    end
    
    %%
    % Time-based Simulation of JOBS
    % Each cell refers to a job, and each cell has as many rows as its
    % split and first column is start time, second column is finish time
    % and third column is the machine number which operates that job
    CellularSTFTMachineMatrix = cell(NumberOfJobs,1);
    for j = 1:NumberOfJobs
        CellularSTFTMachineMatrix{j} = zeros(NumberOfSplitForEachJob(j),3);
        
    end
    
%     StartTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
%     
%     FinishTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
%     
%     FromStart2FinishTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
    
    MaximumCompletionTimePerMachine=zeros(1,NumberOfMachines);
    
    % 1- When we want to change a frame
    % 2- Crane cannot work on night shifts
    % it means it cannot operate from 20.00 at night to 7.00 in the morning
    % CraneMatrix is a cell matrix; each cell is a crane and each matrix
    % has three column, first is start time and second is finish time and
    % third is the machine number
    CellularCraneMatrix = {zeros(1,3)};
    for CraneCount=1:(Crane.Count - 1)
        CellularCraneMatrix{CraneCount+1}=zeros(1,3);
    end
    
	%% Rack Status for each day
    % rows are jobs, columns are rack types, and the other dimention is
    % day, first dimention is initial status and the other 
%     NumberOfPossibleDay=9999999;
%     NumberOfPossibleDay=99999;
    NumberOfPossibleDay=999;
    RackStatusDay=repmat(zeros(size(Rack.Initial)),[1 1 NumberOfPossibleDay]);
    RackStatusDay(:,:,1)=model.Rack.Initial;
    PreviousJob=zeros(NumberOfMachines,1);
    
    % Production per day must be stored
    % this matrix will be used to evaluate KANBAN Matrix
    ProductionPerDay=zeros(NumberOfJobs,NumberOfPossibleDay);
    
    % the finish time of last job on a machine before switching to another 
    % job 
    MachineTimeCount=7*ones(NumberOfMachines,1);
    
    % first column is the first job number that has to be done on the
    % machine; and second column is the comulative jobs that has to be done
    % by machine
    MachineProcedure=ones(NumberOfMachines,2);
    for m=1:NumberOfMachines
        MachineProcedure(m,2)=size(ListsOfJobsDedicated2EachMachine{m},2);
    end
    
    %% 
    SplitCounter=ones(NumberOfJobs,1);
    
    %% 
    for NOPD = 1:NumberOfPossibleDay
        
        %% 
        % termination condition
        if sum(MachineProcedure(:,1)) - sum(MachineProcedure(:,2)) == NumberOfMachines
            
%             disp(['The Last Processing Day is: ' num2str(NOPD)]);
            break;
            
        end
        
        DayCount = NOPD;
        %%
        for m=1:NumberOfMachines
            %%
            if MachineProcedure(m,1) > MachineProcedure(m,2)
                continue;
            end
            
            %% 
            [TDayMachine, ~, ~, ~]=ECGetTime(MachineTimeCount(m));
            if TDayMachine > DayCount
                continue;
            end
            
            %% 
            for j=MachineProcedure(m,1):size(ListsOfJobsDedicated2EachMachine{m},2)
                
                %% 
                % MachineProcedure
                MachineProcedure(m,1) = MachineProcedure(m,1) + 1;
                
                %% 
                JobNumber=ListsOfJobsDedicated2EachMachine{m}(j);
                WhichSplit=SplitCounter(JobNumber);
%                 NumberOfProduction=(RealNeededProducts(JobNumber) * ... % RealNeededProducts
%                                 NumberOfProductForEachSplit(JobNumber, WhichSplit));
                NumberOfProduction=Solution.NumberOfProductForEachSplit{JobNumber} (WhichSplit);
                
                %% NumberOfProduction
                if NumberOfProduction == 0
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    continue;
                end
                
                %% Jobs Without $ RACK $ Constraint
                if ~sum(Rack.JobsWithoutConstraint == JobNumber)
                    [~, NumberOfProductionCanBeStored] = ... 
                                    EERackInfoOnDayCount2(model,RackStatusDay,DayCount,JobNumber);
                    
                    if NumberOfProductionCanBeStored < NumberOfProduction
                        MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
%                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
                        break;
                    end
                end
                
                %% Crane
                
                % if PreviousJob(m) ~= JobNumber; it means we do not need
                if (PreviousJob(m) ~= 0 && PreviousJob(m) ~= JobNumber) || ... 
                    (PreviousJob(m) == 0 && SplitCounter(JobNumber) > 1 && sum(CellularSTFTMachineMatrix{JobNumber} (:,2)) > 1) 
                    %% 
                    MachineNumber = m;
                    
                    [Possibility, CraneType, EarliestTime] = ... 
                        EHCraneCalculation(model, MachineNumber, CellularCraneMatrix, ... 
                        JobNumber, CellularSTFTMachineMatrix, PreviousJob(m), DayCount);
%                         JobNumber, FinishTime, PreviousJob(m), DayCount);
                    % and above function 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    
                    % and below till  "elseif PreviousJob(m) ~= 0 &&
                    % PreviousJob(m) == JobNumber"
                    
                    %% Earlist $ CRANE $ Time in DayCount
                    
                    if Possibility == 0 
                        % Crane 
                        MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
%                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
                        break;
                    end
                    
                    %% 
                    % Calculate Start Time, Finish Time Crane Time
                    if (PreviousJob(m) == 0 && ...
                       SplitCounter(JobNumber) > 1 && sum(CellularSTFTMachineMatrix{JobNumber} (:,2)) > 1)
                        SetupTime = 60/60;
                        PrepTime = 0;
                    else
                        SetupTime = SetupTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
                        PrepTime = PreparationTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
                    end
                    
                    CellularCraneMatrix{CraneType} = [CellularCraneMatrix{CraneType}; ... 
                                                      EarliestTime EarliestTime + SetupTime MachineNumber];
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = EarliestTime + SetupTime + PrepTime;
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = EarliestTime + SetupTime + PrepTime;
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                        NumberOfProduction / ...
                        ProcessTimePerHourJobMachine(JobNumber, m); 
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
%                     ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if TdayFT - TdayST > 0 
                        
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ...
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    % Line 256
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,TdayFT) = ProductionPerDay(JobNumber,TdayFT) + NumberOfProduction;
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                elseif PreviousJob(m) ~= 0 && PreviousJob(m) == JobNumber
                    %% 
                    % without crane constraint
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2);
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = FinishTime(JobNumber, SplitCounter(JobNumber) - 1);
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                        NumberOfProduction / ...
                        ProcessTimePerHourJobMachine(JobNumber, m); 
                    
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
%                     ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if TdayFT - TdayST > 0 
                        
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ...
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    % Line 321
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,TdayFT) = ProductionPerDay(JobNumber,TdayFT) + NumberOfProduction;
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                else 
                    %% 
                    % without crane constraint
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = MachineTimeCount(m);
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = MachineTimeCount(m);
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                         NumberOfProduction / ... % NumberOfProductForEachSplit 
                        ProcessTimePerHourJobMachine(JobNumber, m); 
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
%                     ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if (TdayFT - TdayST > 0 ) || ...
                       (PreviousJob(m) == 0 && CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) >= 24)
                        if PreviousJob(m) == 0
                            NumberOfDay = 1;
                        end
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    % &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    % Line 376
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,TdayFT) = ProductionPerDay(JobNumber,TdayFT) + NumberOfProduction;
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                end
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                %%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % model.ParallelJobOperating %%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [~,col]=find(ParallelJobOperating(JobNumber,:)==0);
                % col gives PrecedingJobs number
                
                StartTimeJobNumber = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 1);
                FinishTimeJobNumber = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2);
                ProcessTimeJobNumber = FinishTimeJobNumber - StartTimeJobNumber;
                
                MaxFinishTimePrecedingJobs = 0;
                
                if size(col,2) > 0
                    FinishTimeCollection = 0;
                    
                    for FTC= 1:size(col,2)
                        FinishTimeCollection = [FinishTimeCollection; (CellularSTFTMachineMatrix{col(FTC)} (:,2))];
                        
                    end
                    
                    MaxFinishTimePrecedingJobs = max(FinishTimeCollection);
                    
                    
                    
                    
                    if StartTimeJobNumber < MaxFinishTimePrecedingJobs
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 1) = MaxFinishTimePrecedingJobs;
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2) = MaxFinishTimePrecedingJobs + ProcessTimeJobNumber;
                    
                    
                       if MaximumCompletionTimePerMachine(m) < (CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2))
                            MaximumCompletionTimePerMachine(m) = (CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2));
                        end
                    end
                    
                    
                    
                end
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                %% 
                % Calculate DayCount of the last Job on machine 
                [DayCountMachine, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2) );
                
                if DayCountMachine ~= DayCount
                    break;
                end
                
            end
            
            if MaximumCompletionTimePerMachine(m) < max(CellularSTFTMachineMatrix{JobNumber} (:,2))
                MaximumCompletionTimePerMachine(m) = max(CellularSTFTMachineMatrix{JobNumber} (:,2));
            end
            
        end
        %%
        % Update Rack; INCREASE rack availability and put that matrix one
        % day ahead 
        RackStatusDay = EGNextDayRack(model.Rack.ConsumptionRatePerDay, RackStatusDay, DayCount);
        
    end
%     MaximumCompletionTimePerMachine = max(FinishTime);
    
    %% output
%     Interpretation.Lists=UpdatedLists;
%     Interpretation.StartTime=StartTime;
%     Interpretation.PreparationTime=FromStart2FinishTime;
%     Interpretation.FinishTime=FinishTime;
    Interpretation.MaximumCompletionTime=MaximumCompletionTimePerMachine;
    Interpretation.Cmax=max(MaximumCompletionTimePerMachine);
    
    if NOPD < size(model.Need.DaysOfTheWeek,2)
        NOPD = size(model.Need.DaysOfTheWeek,2) + 1;
    end
    
%     Interpretation.RackStatusDay=RackStatusDay(:,:,1:NOPD);
%     Interpretation.ProductionPerDay=ProductionPerDay(:,1:NOPD);
    
    Interpretation.RackStatusDay=RackStatusDay(:,:,1:7);
    Interpretation.ProductionPerDay=ProductionPerDay(:,1:7);
    
    Interpretation.CellularSTFTMachineMatrix=CellularSTFTMachineMatrix;
    
    Interpretation.CellularCraneMatrix=CellularCraneMatrix;

end
