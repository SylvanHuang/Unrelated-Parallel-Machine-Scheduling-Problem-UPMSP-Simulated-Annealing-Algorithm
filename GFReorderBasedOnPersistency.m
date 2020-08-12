function xnew = GFReorderBasedOnPersistency(x,model)

    % Randomly select a machine and then reorder the job on the same
    % machine based on the persistency of three inventory
    
    xnew = x;
    
    RandMachine = randperm(model.NumberOfMachines,1);
    
    q = xnew.ListsOfJobsDedicated2EachMachine{RandMachine};
    
    %%
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
    
    qnew = Temp(1,Ind);
    %%
%     qnew = GB2CreateNeighbor(q);
    
    xnew.ListsOfJobsDedicated2EachMachine{RandMachine} = qnew;
    
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
    

end