function RackStatusDayOutput = ... 
    EIReduceRackAvailability2Job(model, RackStatusDayInput, JobNumber, NumberOfProduction, DayCount)

    RackStatusDayOutput = RackStatusDayInput; 
    RSDO = RackStatusDayOutput(:,:,DayCount);
    
    AllAvailability = model.Rack.AllAvailability;
    
    AccessibleRack = AllAvailability - sum(RSDO);

    NOP = NumberOfProduction;
    
    % NOPCBS: Number Of Product Can Be Stored 
    NOPCBS=AccessibleRack.*(model.Rack.Capacity(JobNumber,:));
    
    for RT=1:size(AccessibleRack,2)
        NeededRackType = NOP/(model.Rack.Capacity(JobNumber,RT));
        
        if NOPCBS(RT) >= NOP
            RSDO(JobNumber,RT)=RSDO(JobNumber,RT)+ceil(NeededRackType);
            break;
        elseif NOPCBS(RT) < NOP
            RSDO(JobNumber,RT)=RSDO(JobNumber,RT)+AccessibleRack(RT);
            NOP = NOP - AccessibleRack(RT)*(model.Rack.Capacity(JobNumber,RT));
            
        end
        
    end

    %% output
    RackStatusDayOutput(:,:,DayCount) = RSDO;

end