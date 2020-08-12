function [Possibility, CraneType, EarliestCraneTime] = ... 
    EHCraneCalculation(model, MachineNumber, CellularCraneMatrix, ... 
    JobNumber, CellularSTFTMachineMatrix, PreviousJobNumber, DayCount) 
%     JobNumber, FinishTimeJob, PreviousJobNumber, DayCount) 
%     FinishTimeJob == CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2)
    %% 
    % In first day, the other part is processing on another machine and at
    % the same the job is first on both machine 
    if PreviousJobNumber == 0 
        PreviousJobNumber = 12;
        if sum(CellularSTFTMachineMatrix{PreviousJobNumber} (:,2)) > 0
            SetupTime = 0;
        else
            SetupTime = 60/60;
        end
        % $$$$$$$$$$$$$$$$
    end
    %% 
    % SORT CellularCraneMatrix
    for CCM=1:size(CellularCraneMatrix,2)
        if size (CellularCraneMatrix{CCM},1) > 1
            CellularCraneMatrix{CCM}=sort(CellularCraneMatrix{CCM});
        end
    end
    %% 
    % LowerBound: is the maximum FinishTime between the other parts of
    % JobNumber and the PreviousJobNumber 
    % LowerBound is related to Jobs and the start point of a day
    LowerBound = zeros(1, model.Crane.Count);
    
    % UpperBound: is the minimum time between a time that a crane can work
    % and the finish point of a day 
    UpperBound = zeros(1, model.Crane.Count);
    
    for CraneNumber=1:model.Crane.Count
        LowerBound(CraneNumber) = max( [ (CellularSTFTMachineMatrix{JobNumber} (:,2))' ... 
                                         (CellularSTFTMachineMatrix{PreviousJobNumber} (:,2))' ... 
                                         ( (DayCount - 1) * 24 + 7 ) ... 
                                         ( (DayCount - 1) * 24 + model.Crane.TimeLimit(CraneNumber, 2) ) ] );
        
        UpperBound(CraneNumber) = min( [ ( DayCount * 24 ) ... 
                                         ( (DayCount - 1) * 24 + model.Crane.TimeLimit(CraneNumber, 1) ) ] );
    end
    
    %% 
    % 
    TempCraneNumber = 0;
    for CraneNumber=1:model.Crane.Count
        if LowerBound(CraneNumber) > UpperBound(CraneNumber)
            TempCraneNumber = TempCraneNumber + 1;
        end
        if TempCraneNumber == model.Crane.Count
            Possibility = 0;
            CraneType = 0; 
            EarliestCraneTime = inf;
            return;
        end
    end
    
    %% 
    [TDayMIN, ~, ~, ~]=ECGetTime(min(LowerBound));
    if TDayMIN > DayCount
        Possibility = 0;
        CraneType = 0; 
        EarliestCraneTime = inf;
        return;
    end
    
    %% 
    % EarliestPossibleCraneTime 
    EPCT = 9999 * ones(1, model.Crane.Count);
    for CraneNumber=1:model.Crane.Count
        if PreviousJobNumber ~= 0
            SetupTime = model.SetupTimePerHour(PreviousJobNumber,JobNumber,MachineNumber);
        end
        
        for time=LowerBound(CraneNumber):0.083333:UpperBound(CraneNumber)
            
            Possibility = ELCraneFeasibility(CellularCraneMatrix, CraneNumber, time, SetupTime);
            
            if Possibility == 1
                
                EPCT(CraneNumber) = time;
                break;
            end
        end
        
    end
    
    %% 
    % OUTPUT
    EarliestCraneTime = min(EPCT);
    
    [TDayMIN, ~, ~, ~]=ECGetTime(EarliestCraneTime);
    if TDayMIN > DayCount
        Possibility = 0; 
        CraneType = 0; 
        EarliestCraneTime = inf; 
        return; 
    end
    
    CT = find(EPCT == EarliestCraneTime);
    RandSelect = randperm(size(CT,2),1);
    CraneType = CT(RandSelect);
    
    Possibility = 1;

end