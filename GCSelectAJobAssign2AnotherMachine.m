function xnew = GCSelectAJobAssign2AnotherMachine(x,model)

    % Randomly select a machine and then assign the job to another machine
    % if possible
    
    % 1- select a machine
    % 2- select a job randomly
    % 3- is it possible to assign to another machine
    % 4- select another machine randomly
    % 5- if YES then assign
    
    xnew = x;
    
    RandMachine = randperm(model.NumberOfMachines,1);
    
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
        
%         % extra
%         xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = GB2CreateNeighbor(xnew.ListsOfJobsDedicated2EachMachine{RandMachine2});
        
        NewSize = size(xnew.ListsOfJobsDedicated2EachMachine{RandMachine2},2);
        
        if NewSize > 1
            
            RandPose = randperm(NewSize - 1,1);
            
            Newq = xnew.ListsOfJobsDedicated2EachMachine{RandMachine2};
            
            % 
            Newq = [Newq(1:RandPose - 1) Newq(NewSize) Newq(RandPose:NewSize - 1)];
            
            
            xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = Newq;
            
        end
        
        
%         % extra
%         % machine based on the persistency of three inventory
%         xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = ... 
%             GGReorderBasedOnPersistencyOf_QOLD(xnew.ListsOfJobsDedicated2EachMachine{RandMachine2},model);
        
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