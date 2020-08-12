function CalculatedNeededRack=EFCCalculateNeededRack(model,NumberOfProduction,JobNumber,RackType)

    if ( NumberOfProduction / model.Rack.Capacity(JobNumber,RackType) ) < 1
        CalculatedNeededRack = 1; 
    else 
        % May be a good judgment for "round" because under some 
        % circumstances it will be more than the actual number and in other
        % conditions it will be less
        CalculatedNeededRack = round (NumberOfProduction / model.Rack.Capacity(JobNumber,RackType));
    end

end