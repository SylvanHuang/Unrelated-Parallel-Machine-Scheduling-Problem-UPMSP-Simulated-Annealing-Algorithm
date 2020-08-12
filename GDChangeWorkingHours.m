function xnew = GDChangeWorkingHours(x,model)

    xnew = x;
    
    RandMachine = randperm(model.NumberOfMachines,1);
    
    RandShift = model.WorkingHours.Shift(randperm(size(model.WorkingHours.Shift,2),1));
    
    xnew.WorkingHours(RandMachine,2) = RandShift;

end