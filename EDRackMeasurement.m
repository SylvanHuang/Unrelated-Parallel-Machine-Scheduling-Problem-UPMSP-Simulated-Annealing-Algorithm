function [Possibility, MostAvailRack, RackType, TimeShouldBeAdded2FinishTime, RackStatusDayOutput, LastRackStatusUpdateDayOutput] = ... 
    EDRackMeasurement(model, JobNumber, StartTimeJob, FinishTimeJob, NumberOfProduction, RackStatusDayInput, LastRackStatusUpdateDayInput)

    [TDayINI, ~, ~, ~] = ECGetTime(StartTimeJob);
    DayCount = TDayINI + 1;
    
%     TimeCount = StartTimeJob;
    %% 
    
    % output
    % 1- Possibility: is it possible to dedicate the job with JobConsumption
    % or not; 0 means it is not possible and 1 means it is possible
    % 2- TimeCount: the time of procedure (the start time); we need the
    % rack availability at the start time of activity
    % 3- MostAvailRack: the availability of Rack that RackType
    % 4- RackType
    
    % ******************$$$$$$$$$$$$$$$$$$$$$$$$$******************
    % 5- TimeShouldBeAdded2FinishTime: if the Possibility==0 then what is
    % the time should be added to finish time becuase of lack of RACK
    
    % 6- RackStatusDayOutput: the rack status for each day
    % 7- LastRackStatusUpdateDayOutput shows the last day that updated 
    % version of RackStatusDay based on rack consumption model.Rack.ConsumptionRatePerDay
    
    % input
    % 1- model
    % 2- DayCount: the day referes to the start time of the activity or job
    % 3- JobNumber: the number related to job
    % 4- StartTimeJob
    % 5- FinishTimeJob
    % 6- NumberOfProduction: the number of production that is going to be
    % produced (a percentage of needed product)
    % 7- RackStatusDayInput: the multiple dimentional matrix that referes
    % to the rack that is being used
    % 8- LastRackStatusUpdateDayInput: the last day that rack is updated;
    % from the first day to the LastRackStatusUpdateDayInput
    
    %% output
    
    % 1
    Possibility = 1;
    % 4
    TimeShouldBeAdded2FinishTime = 0;
    % 6
    LastRackStatusUpdateDayOutput = LastRackStatusUpdateDayInput;
    % 5
    RackStatusDayOutput = RackStatusDayInput;
    
    ConsumptionRatePerDay = model.Rack.ConsumptionRatePerDay;
    
    [RackType, MostAvailRack, NumberOfProductionCanBeStored] = ... 
            EERackInfoOnDayCount1(model,RackStatusDayOutput,DayCount,JobNumber);
    
    [MostAvailRack, NumberOfProductionCanBeStored] = ... 
            EERackInfoOnDayCount2(model,RackStatusDayOutput,DayCount,JobNumber);
	%% 
    CalculatedNeededRack=EFCCalculateNeededRack(model,NumberOfProduction,JobNumber,RackType);
    
    %% increase the rack availability of a certain day
    RackStatusDayOutput=EGConsumeRack(model,RackStatusDayOutput,DayCount);
    %% 
    if CalculatedNeededRack <= MostAvailRack
        Possibility = 1;
        
        % Update Rack
        RSDInput(JobNumber,RackType,DayCount)=RSDInput(JobNumber,RackType,DayCount) + CalculatedNeededRack;
        
        % output
        RackStatusDayOutput(:,:,DayCount) = RSDInput;
        
        % Update RSDInput for each day till the end 
        RackStatusDayOutput(:,:,DayCount:end) = ... 
            repmat(RSDInput,[1 1 size(RackStatusDayOutput(:,:,DayCount:end),3)]);
    end
    
    %% 
    if (CalculatedNeededRack > MostAvailRack) & (LastRackStatusUpdateDayOutput < DayCount)
        % first day by day assign CalculatedNeededRack in accordance with
        % the rack availability
        Counter=1;
        AssignedRack=0; 
        while (CalculatedNeededRack - AssignedRack > MostAvailRack) & (Counter<=(DayCount-LastRackStatusUpdateDayOutput))
            %% first calculation
            RSDInput = RackStatusDayOutput(:,:,DayCount);
            AccessibleRack = AllAvailability - sum(RSDInput);
            
            RackTypeTemp = find( AccessibleRack == max(AccessibleRack) );
            RandSelect = randperm(size(RackTypeTemp,2),1);
            
            RackType = RackTypeTemp(RandSelect);
            
            MostAvailRack = (AccessibleRack(RackType));
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if ( NumberOfProduction / model.Rack.Capacity(JobNumber,RackType) ) < 1
                CalculatedNeededRack = 1; 
            else 
                % May be a good judgment for "round" because under some 
                % circumstances it will be more than the actual number and in other
                % conditions it will be less
                CalculatedNeededRack = round (NumberOfProduction / model.Rack.Capacity(JobNumber,RackType));
            end
            
            % if for the first time is happening
            if (CalculatedNeededRack - AssignedRack > MostAvailRack)
                RSDInput = RackStatusDayOutput(:,:,DayCount);
                
                RSDInput(JobNumber,RackType) = RSDInput(JobNumber,RackType) + MostAvailRack;
                
                % Update RSDInput for each day till the end 
                RackStatusDayOutput(:,:,DayCount:end) = ... 
                    repmat(RSDInput,[1 1 size(RackStatusDayOutput(:,:,DayCount:end),3)]);
                
            else
                if CalculatedNeededRack <= MostAvailRack
                    
                    % Update Rack
                    RSDInput = RackStatusDayOutput(:,:,DayCount);
                
                    RSDInput(JobNumber,RackType) = RSDInput(JobNumber,RackType) + MostAvailRack;
                    % output
                    RackStatusDayOutput(:,:,DayCount) = RSDInput;
                    
                    % Update RSDInput for each day till the end 
                    RackStatusDayOutput(:,:,DayCount:end) = ... 
                        repmat(RSDInput,[1 1 size(RackStatusDayOutput(:,:,DayCount:end),3)]);
                    
                end
            end
            
            RackStatusDayOutput(:,:,DayCount:end) = ... 
                repmat(RSDInput,[1 1 size(RackStatusDayOutput(:,:,DayCount:end),3)]);
            
            if Counter == 1 
                [~, ThourFT, TMinuteFT, ~] = ECGetTime(FinishTimeJob);
                if TMinuteFT == 0 
                    DIFTIME = 24 - ThourFT; 
                else 
                    DIFTIME = 24 - (ThourFT + 1) + (1 - TMinuteFT);
                end 
                
                TimeShouldBeAdded2FinishTime  = TimeShouldBeAdded2FinishTime + DIFTIME;
            else 
                % add 24 hours
                TimeShouldBeAdded2FinishTime=TimeShouldBeAdded2FinishTime + 24;
            end
            
            %% Update 
            Possibility = 0;
            Counter = Counter + 1;
            DayCount = DayCount + 1;
            AssignedRack = AssignedRack + MostAvailRack;
            
        end
        
    end
    
    %% 
    if  CalculatedNeededRack > MostAvailRack & (LastRackStatusUpdateDayOutput > DayCount)
        Possibility = 0;
        
        
        
    end
    
    
    % Output
    LastRackStatusUpdateDayOutput = DayCount;
end
