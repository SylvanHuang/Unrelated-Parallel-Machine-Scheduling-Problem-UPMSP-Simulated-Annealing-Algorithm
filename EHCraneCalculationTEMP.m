function [Possibility, CraneType, EarliestCraneTime] = ... 
    EHCraneCalculation(model, MachineNumber, SplitCounter, CellularCraneMatrix, ... 
    JobNumber, StartTimeJob, FinishTimeJob, PreviousJobNumber, ... 
    FinishTimePreviousJobNumber, DayCount) 

    %%
    % one of the important points is a crane EarliestTime should be within
    % a defined DayCount 
    
    % Possibility == 0; It means that on that day we can not process the
    % new job, and the other means we can and the earliest time is
    % calculated
    
    %% SORT CellularCraneMatrix
    for CCM=1:size(CellularCraneMatrix,2)
        if size (CellularCraneMatrix{CCM},1) > 1
            CellularCraneMatrix{CCM}=sort(CellularCraneMatrix{CCM});
        end
    end
    
    %% EarliestCraneTime
    ECTime = zeros(1,size(CellularCraneMatrix,2));
    for CCM = 1:size(CellularCraneMatrix,2)
        ECTime(CCM) = CellularCraneMatrix{CCM}(end,2);
        
    end
    
    EarliestCraneTime = max(ECTime);
    TempFind = find(ECTime == EarliestCraneTime);
    CraneType = randperm(size(TempFind,2),1);
    
    %% 
    
    [TDay, ~, ~, ~]=ECGetTime(FinishTimePreviousJobNumber);
    
    DayCountPJ = TDay + 1; % DayCountPJ: DayCount Previous Job
    
    if DayCountPJ > DayCount
        Possibility = 0;
        CraneType = 0;
        EarliestCraneTime = inf;
        return;
    end
    
    if JobNumber == PreviousJobNumber
        Possibility = 1; 
        CraneType = 0; 
        EarliestCraneTime = FinishTimeJob(PreviousJobNumber,SplitCounter(PreviousJobNumber)); 
        return; 
    end
    
    % JobNumber ~= PreviousJobNumber
    if SplitCounter(JobNumber) == 1
        Possibility = 0;
        % Crane Time 
        FTJOLD = max( FinishTimeJob(PreviousJobNumber,:) );
        STOLD2NEW = model.SetupTimePerHour(PreviousJobNumber,JobNumber,MachineNumber);
        
        for CraneNumber = 1:size(CellularCraneMatrix,2)
            for CraneTime = 1:size(CellularCraneMatrix{CraneNumber},1)
                % if there is only one row then 
                
                if FTJOLD + STOLD2NEW <= CellularCraneMatrix{CraneNumber}(CraneTime,1) & CraneTime == 1
                    
                    % If EarliestCraneTime obeys model.Crane.TimeLimit
%                     Possibility = 1;
                    CraneType = CraneNumber;
                    EarliestCraneTime = FTJOLD;
                    Possibility = IJCraneTimeLimitation (model.Crane.TimeLimit(CraneNumber,:), EarliestCraneTime);
                    if Possibility == 1
                        return;
                    end
                    
                end
                
                if FTJOLD >= CellularCraneMatrix{CraneNumber}(CraneTime,2) & CraneTime == size(CellularCraneMatrix{CraneNumber},1)
                    
                    % If EarliestCraneTime obeys model.Crane.TimeLimit
%                     Possibility = 1;
                    CraneType = CraneNumber;
                    EarliestCraneTime = CellularCraneMatrix{CraneNumber}(CraneTime,2);
                    Possibility = IJCraneTimeLimitation (model.Crane.TimeLimit(CraneNumber,:), EarliestCraneTime);
                    if Possibility == 1
                        return;
                    end
                    
                end
                
                if size(CellularCraneMatrix{CraneNumber},1) > 1 & ... 
                        CraneTime ~= size(CellularCraneMatrix{CraneNumber},1)
                    
                    if FTJOLD >= CellularCraneMatrix{CraneNumber}(CraneTime,2) & ...
                            CellularCraneMatrix{CraneNumber}(CraneTime+1,1) - CellularCraneMatrix{CraneNumber}(CraneTime,2) >= STOLD2NEW
                        
                        % If EarliestCraneTime obeys model.Crane.TimeLimit
%                         Possibility = 1;
                        CraneType = CraneNumber;
                        EarliestCraneTime = CellularCraneMatrix{CraneNumber}(CraneTime,2);
                        Possibility = IJCraneTimeLimitation (model.Crane.TimeLimit(CraneNumber,:), EarliestCraneTime);
                        if Possibility == 1
                            return;
                        end
                        
                    end
                    
                end
                
            end
            
            if CraneNumber == size(CellularCraneMatrix,2) & CraneTime == size(CellularCraneMatrix{CraneNumber},1)
                
                Possibility = 0;
                CraneType = 0;
                EarliestCraneTime = inf;
                return;
                
            end
            
        end
        
%         Possibility = 1; 
%         CraneType = 0; 
%         EarliestCraneTime = FinishTimeJob(PreviousJobNumber,SplitCounter(PreviousJobNumber)); 
        
        return;
    end
    
    % if SplitCounter(JobNumber) > 1 
    % Max Finish Time Job Number 
    MaxFTJN = max(FinishTimeJob(JobNumber));
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    a=1;
    
    % if the possibility is 0 then what is the first time a crane can do
    % the job
    
    % 

end