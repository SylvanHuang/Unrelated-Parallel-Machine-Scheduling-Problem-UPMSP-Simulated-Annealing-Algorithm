function [Z, Interpretation]=DAMyCost(Solution,model)

    global NFE;
    NFE = NFE+1;
    
    Interpretation = EAParseSolution(Solution,model);
    
    Z1 = Interpretation.Cmax;
    
    CummulativeNeed=model.Need.CummulativeSummation;
    LostProfitPerDay = model.LostProfitPerDay;
    
    ProductionPerDay=Interpretation.ProductionPerDay;
    
    %%
    %
    ProductionPerDay(:,1) = model.Inventory.CustomerInitialDepot + ... 
                            model.Inventory.BronzeInitialDepot + ... 
                            model.Inventory.Panel;
    
    %%
    %
    CumulativeProductionPerDay=cumsum(ProductionPerDay,2);
    
    Z2 = 0;
    
%     SizeNeed = size(CummulativeNeed,2);
%     
%     SizeProduction = size(ProductionPerDay,2);
%     
%     if SizeNeed > SizeProduction
%         ProductionPerDay = [ProductionPerDay, zeros(size(ProductionPerDay,1),SizeNeed-SizeProduction)];
%         
%         CumulativeProductionPerDay=cumsum(ProductionPerDay,2);
%         
%     else
%         CummulativeNeed = [CummulativeNeed, ones(size(SizeNeed,1),SizeProduction-SizeNeed).*CummulativeNeed(:,end)];
%         
%     end
    
    for Day=1:size(CummulativeNeed,2)
        for Job=1:size(CummulativeNeed,1)
            
            if sum(model.OmittedJobs == Job) || CummulativeNeed(Job,Day) == 0
                continue;
            end
            
            temp1 = CummulativeNeed(Job,Day) - CumulativeProductionPerDay(Job,Day);
            
            if temp1 >= 0
                Z2 = Z2 + (temp1 * LostProfitPerDay(Job));
            end
            
        end
        
    end
    
    Z = [Z1 Z2];

end