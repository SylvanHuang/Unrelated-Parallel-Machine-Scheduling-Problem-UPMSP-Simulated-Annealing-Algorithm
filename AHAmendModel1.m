function NewModel = AHAmendModel1(model)

    % Update model.NumberOfSplitForEachJob + model.nVar
    % Create a new parameter: NeededProduct
    % Please refer to Excel Sheet InventoryMinimumDepot to know how
    % calculate these above 3 parameters
    
    NewModel = model;
    
    %% 
    %
    NewModel.RealNeededProducts = zeros(NewModel.NumberOfJobs,1);
    NewModel.RealNeededProducts = NewModel.Need.WholeRequirement - ... 
                           NewModel.Inventory.CustomerInitialDepot - ... 
                           NewModel.Inventory.BronzeInitialDepot - ... 
                           NewModel.Inventory.Panel + ... 
                           NewModel.Inventory.MinimumDepot;
	
    %% 
    % NewModel.OmittedJobs
	NewModel.OmittedJobs = ones(NewModel.NumberOfJobs,1);
    NewModel.OmittedJobs = (1:NewModel.NumberOfJobs)' .* NewModel.OmittedJobs;
    
    temp = (NewModel.RealNeededProducts <= 0);
    
    NewModel.OmittedJobs = temp .* NewModel.OmittedJobs;
    
    NewModel.OmittedJobs(NewModel.OmittedJobs == 0) = [];
    
    %% 
    % NewModel.NumberOfSplitForEachJob
    for j = 1:NewModel.NumberOfJobs
        if sum(NewModel.OmittedJobs == j)
            NewModel.NumberOfSplitForEachJob(j) = 0;
            continue;
        end
        
        NewModel.NumberOfSplitForEachJob(j) = floor(NewModel.RealNeededProducts(j) ./ NewModel.MinimumEconomicalProduction(j));
        if NewModel.NumberOfSplitForEachJob(j) == 0
            NewModel.NumberOfSplitForEachJob(j) = 1;
        end
        
    end
    
    %% 
    % nVar
    % Without any use
    NewModel.nVar = sum(NewModel.NumberOfSplitForEachJob) + NewModel.NumberOfMachines - 1;

end