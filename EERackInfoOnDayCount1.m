function [RackType, MostAvailRack, NumberOfProductionCanBeStored] = ... 
            EERackInfoOnDayCount1(model,RackStatusDay,DayCount,JobNumber) 

    AllAvailability = model.Rack.AllAvailability;
    
    RSD = RackStatusDay(:,:,DayCount);
    
    AccessibleRack = AllAvailability - sum(RSD);
    
    NOPCBS=zeros(1,size(AccessibleRack,2));
    for RT=1:size(AccessibleRack,2)
        
        NOPCBS(RT)=AccessibleRack(RT)*(model.Rack.Capacity(JobNumber,RT));
        
    end
    
    RackTypeTemp = find( NOPCBS == max(NOPCBS) );
    RandSelect = randperm(size(RackTypeTemp,2),1);
    
    RackType = RackTypeTemp(RandSelect);
    
    MostAvailRack = (AccessibleRack(RackType(RandSelect)));
    
    NumberOfProductionCanBeStored = NOPCBS(RackType(RandSelect));

end
