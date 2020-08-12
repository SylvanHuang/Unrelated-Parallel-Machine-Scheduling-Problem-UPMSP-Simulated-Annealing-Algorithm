function xnew = GCSelectAJobAssign2AnotherMachineThenReordeBasedOnPersistency(x,model)

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
        
        %%
        % Randomly select a machine and then reorder the job on the same
        % machine based on the persistency of three inventory
        
        q = xnew.ListsOfJobsDedicated2EachMachine{RandMachine2};
        
        AllThreeInventory = model.Inventory.BronzeInitialDepot + ...
                        model.Inventory.CustomerInitialDepot + ...
                        model.Inventory.Panel;
        
        Persistency = AllThreeInventory ./ model.Need.WholeRequirement(:,1);
        
        Temp = zeros(2,size(q,2));
        
        Temp(1,:) = q;
        
        for job = 1:size(q,2)
            Temp(2,job) = Persistency(Temp(1,job));
            
        end
        
        [~, Ind] = sort(Temp(2,:));
        
        xnew.ListsOfJobsDedicated2EachMachine{RandMachine2} = Temp(1,Ind);
        
        
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