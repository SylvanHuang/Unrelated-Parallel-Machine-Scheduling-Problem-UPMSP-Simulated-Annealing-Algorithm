function xnew = LocalSearch01(x,model)

    % Select the machine which has the longest operating time and then change the order of jobs
    
    RandMaxTimeMachine = x.Inter.MaximumCompletionTime;
    
    temp1 = find(RandMaxTimeMachine==max(RandMaxTimeMachine));
    
    RandMachine = temp1(randperm(size(temp1,2),1));
    
    
    
    xnew = x;
    
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