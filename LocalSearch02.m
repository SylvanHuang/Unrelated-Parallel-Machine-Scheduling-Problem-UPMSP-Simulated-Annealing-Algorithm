function xnew = LocalSearch02(x,model)

    % Select the machine which has the longest operating time and then assign a random job to another machine if possible
    
    RandMaxTimeMachine = x.Inter.MaximumCompletionTime;
    
    temp1 = find(RandMaxTimeMachine==max(RandMaxTimeMachine));
    
    RandMachine = temp1(randperm(size(temp1,2),1));
    
    
    
    
    xnew = x;
    
    q = xnew.ListsOfJobsDedicated2EachMachine{RandMachine};
    
    if size(q,2)>=1
        RandJobPos = randperm(size(q,2),1);
        RandJobName = q(RandJobPos);
        
        PossibleMachine=zeros(1,model.NumberOfMachines);
        
        for m = 1:model.NumberOfMachines
            
            if sum(RandJobName == model.FeasibleJobsListsOnEachMachine{m})
                
                PossibleMachine(m) = 1;
                
            end
            
        end
        
        if sum(PossibleMachine) == 1
            return;
        end
        
        PossMach = find(PossibleMachine == 1);
        
        RandMachine2 = PossMach(randperm(size(PossMach,2),1));
        
        while RandMachine == RandMachine2
            RandMachine2 = PossMach(randperm(size(PossMach,2),1));
        end
        
        %% Remove Job from Previous Machine
        xnew.ListsOfJobsDedicated2EachMachine{RandMachine}(RandJobPos) = [];
        
        
        %% Add Job to the other Machine
        xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = [xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} RandJobName];
        
        if rand >= 0.5
            % 
            xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = ... 
                GGReorderBasedOnPersistencyOf_QOLD(xnew.ListsOfJobsDedicated2EachMachine{RandMachine2},model);
            
        end
        
        %% Amend Permutation
        MachineNumber = model.NumberOfJobs + 1;
        xnew.Permutation = [];
        for m = 1:model.NumberOfMachines
            
            if m ~= model.NumberOfMachines
                
                xnew.Permutation = [xnew.Permutation xnew.ListsOfJobsDedicated2EachMachine{m} MachineNumber];
                
                MachineNumber = MachineNumber + 1;
                
            else
                
                xnew.Permutation = [xnew.Permutation xnew.ListsOfJobsDedicated2EachMachine{m}];
                
            end
            
        end
        
    else
        return
    end

end