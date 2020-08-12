function RandSol=CACreateRandomSolution(model)
    
    NumberOfJobs = model.NumberOfJobs;
    NumberOfMachines = model.NumberOfMachines;
    Day = model.WorkingHours.Day;
    Shift = model.WorkingHours.Shift;
    
    FeasibleMachineListsForEachJob = model.FeasibleMachineListsForEachJob;
    
    % the two following parameters should be used for PercentageOfWork
    NumberOfSplitForEachJob = model.NumberOfSplitForEachJob;
    MinimumEconomicalProduction = model.MinimumEconomicalProduction;
    
    %% ListsOfJobsDedicated2EachMachine
    ListsOfJobsDedicated2EachMachine = cell(NumberOfMachines,1);
    
    JobsOrdering = randperm(NumberOfJobs);
    
    for j = JobsOrdering
        if NumberOfSplitForEachJob(j) == 0
            continue;
        end
        
        for NOSFEJ = 1:NumberOfSplitForEachJob(j)
            if size(FeasibleMachineListsForEachJob{j},2) < 2
                ListsOfJobsDedicated2EachMachine{FeasibleMachineListsForEachJob{j} (1,1)} = [ListsOfJobsDedicated2EachMachine{FeasibleMachineListsForEachJob{j} (1,1)}, j];
                continue;
            end
            
            RandMachine=FeasibleMachineListsForEachJob{j} (randperm(size(FeasibleMachineListsForEachJob{j},2),1));
            ListsOfJobsDedicated2EachMachine{RandMachine} = [ListsOfJobsDedicated2EachMachine{RandMachine}, j];
            
        end
    end
    
    %% Jobs permutation
    Permutation = [];
    for m = 1:NumberOfMachines
        if m == 1
            Permutation = [Permutation ListsOfJobsDedicated2EachMachine{m}];
            continue;
        end
        
        Permutation = [Permutation NumberOfJobs+m-1 ListsOfJobsDedicated2EachMachine{m}];
    end
    
    %% Number Of Product For Each Split
    NumberOfProductForEachSplit = cell(NumberOfJobs,1);
    
    for j = 1:NumberOfJobs
        if sum(model.OmittedJobs == j)
            NumberOfProductForEachSplit{j} = 0;
            continue;
        end
        
        if NumberOfSplitForEachJob(j) == 1
            if model.RealNeededProducts(j) >= MinimumEconomicalProduction(j)
                NumberOfProductForEachSplit{j} = model.RealNeededProducts(j);
                continue;
                
            else
                NumberOfProductForEachSplit{j} = MinimumEconomicalProduction(j);
                continue;
                
            end
        end
        
        % more than one split
        temp1 = randperm(NumberOfSplitForEachJob(j));
        temp2 = MinimumEconomicalProduction(j) * ones(1, NumberOfSplitForEachJob(j));
        temp2(1,end) = temp2(1,end) + (model.RealNeededProducts(j) - NumberOfSplitForEachJob(j)*MinimumEconomicalProduction(j));
        
        NumberOfProductForEachSplit{j} = temp2(temp1);
        
    end
    
    %% Shifts and working hours
    % Shifts and working hours should be acomponied by machines
    WorkingHoursDay = randi(Day,NumberOfMachines,1);
    
    WorkingHoursShift = randi([1 size(Shift,2)],NumberOfMachines,1);
    for j=1:size(Shift,2)
        WorkingHours2ndIndex = WorkingHoursShift == j;
        WorkingHoursShift(WorkingHours2ndIndex)=Shift(j);
        
    end
    
    WorkingHours = [WorkingHoursDay WorkingHoursShift];
    
    %% Output
    RandSol.Permutation=Permutation;
%     RandSol.PercentageOfWorkMachine=PercentageOfWorkMachine;
%     RandSol.PercentageOfWork=PercentageOfWork;
    RandSol.NumberOfProductForEachSplit=NumberOfProductForEachSplit;
    RandSol.WorkingHours=WorkingHours;
    RandSol.ListsOfJobsDedicated2EachMachine=ListsOfJobsDedicated2EachMachine;

end