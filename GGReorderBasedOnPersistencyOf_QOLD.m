function qnew = GGReorderBasedOnPersistencyOf_QOLD(qold,model)

    % machine based on the persistency of three inventory
    q = qold;
    
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

end