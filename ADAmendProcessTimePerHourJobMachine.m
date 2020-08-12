function [ProcessTimePerHourJobMachine1, FeasibleJobsListsOnEachMachine, FeasibleMachineListsForEachJob] = ...
        ADAmendProcessTimePerHourJobMachine(ProcessTimePerHourJobMachine,NumberOfJobs,NumberOfMachines)
    
    % Each 0 should change to 0.5
    % Creating a list of feasible jobs on each machine
    ProcessTimePerHourJobMachine1=ProcessTimePerHourJobMachine;
    FeasibleJobsListsOnEachMachine=cell(NumberOfMachines,1);
    FeasibleMachineListsForEachJob=cell(NumberOfJobs,1);
    
    for m=1:NumberOfMachines
        for j=1:NumberOfJobs
            
            temp=ProcessTimePerHourJobMachine1(j,m);
            if temp <= 0 
                ProcessTimePerHourJobMachine1(j,m)=0.5;
            else
                FeasibleJobsListsOnEachMachine{m}=[FeasibleJobsListsOnEachMachine{m} j];
                FeasibleMachineListsForEachJob{j}=[FeasibleMachineListsForEachJob{j} m];
            end
        end
    end

end