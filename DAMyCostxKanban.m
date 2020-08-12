function [Z, Interpretation]=DAMyCostxKanban(Solution,model)

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
    
    %% 
    % show Results 1
    % lateness and the amount
    temp2 = CummulativeNeed - CumulativeProductionPerDay;
    [row, col] = find(temp2>0);
    
    [row, Ind] = sort(row);
    col = col(Ind);
    
    disp([char(9)]);
    disp(['Job Number' 9 'Day' 9 'Number of Delay']);
    
    for rowsize = 1:size(row)
        
        disp([9 num2str(row(rowsize)) 9 num2str(col(rowsize)) 9 num2str(temp2(row(rowsize),col(rowsize)))]);
        
    end
    
    %% 
    % show Results 2
    % lateness and the amount
    temp2 = CummulativeNeed - CumulativeProductionPerDay;
    [row, col] = find(temp2>0);
    
%     [col, Ind] = sort(col);
%     row = col(Ind);
    
    disp([char(9)]);
    disp(['Job Number' 9 'Day' 9 'Number of Delay']);
    
    for rowsize = 1:size(row)
        
        disp([9 num2str(row(rowsize)) 9 num2str(col(rowsize)) 9 num2str(temp2(row(rowsize),col(rowsize)))]);
        
    end
    
    %% 
    % show Result 3
    % jobs and the amount
    disp([char (10)]);
    disp(['Job Number' 9 'Number of production']);
    for JOB = 1:model.NumberOfJobs
        
        if sum(model.OmittedJobs == Job) || sum(cell2mat(Solution.NumberOfProductForEachSplit(JOB))) == 0
            continue;
        end
        
        disp([9 num2str(JOB) 9 9 num2str(cell2mat(Solution.NumberOfProductForEachSplit(JOB)))]);
        
    end
    
    %% 
    % show result 4
    disp([char (10)]);
    disp('Omitted Jobs are: ');
    disp([num2str(model.OmittedJobs)]);

end