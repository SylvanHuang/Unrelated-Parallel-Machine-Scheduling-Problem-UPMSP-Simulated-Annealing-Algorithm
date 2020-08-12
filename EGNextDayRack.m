function RackStatusDayOutput = EGNextDayRack(ConsumptionRatePerDay, RackStatusDayInput, DayCount)

    RackStatusDayOutput = RackStatusDayInput;
    
    RackStatusDayOutput(:,:,DayCount+1) = RackStatusDayInput(:,:,DayCount) - ConsumptionRatePerDay;
    
    RSDO=RackStatusDayOutput(:,:,DayCount+1);
    
    RSDO (RSDO < 0) = 0;
    
    RackStatusDayOutput(:,:,DayCount+1) = RSDO;

end