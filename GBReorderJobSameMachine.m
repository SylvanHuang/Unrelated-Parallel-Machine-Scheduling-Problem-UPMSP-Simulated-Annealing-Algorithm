function xnew = GBReorderJobSameMachine(x,model)

    % Randomly select a machine and then reorder the job on the same machine
    
    xnew = x;
    
    RandMachine = randperm(model.NumberOfMachines,1);
    
    q = xnew.ListsOfJobsDedicated2EachMachine{RandMachine};
    
    qnew = GB2CreateNeighbor(q);
    
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