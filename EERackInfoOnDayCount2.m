function [MostAvailRack, NumberOfProductionCanBeStored] = ... 
            EERackInfoOnDayCount2(model,RackStatusDay,DayCount,JobNumber) 

    AllAvailability = model.Rack.AllAvailability;
    
    RSD = RackStatusDay(:,:,DayCount);
    
    AccessibleRack = AllAvailability - sum(RSD);
    
    NOPCBS=zeros(1,size(AccessibleRack,2));
    for RT=1:size(AccessibleRack,2)
        
        NOPCBS(RT)=AccessibleRack(RT)*(model.Rack.Capacity(JobNumber,RT));
        
    end
    
    MostAvailRack = AccessibleRack;
    
    NumberOfProductionCanBeStored = sum(NOPCBS);

end
