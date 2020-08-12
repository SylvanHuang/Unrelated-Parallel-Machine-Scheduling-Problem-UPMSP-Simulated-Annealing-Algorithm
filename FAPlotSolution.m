function FAPlotSolution(Solution,model)

    
    
    %% 
    % PLOT
    H=1;
    h=0.75;
    
    NumberOfCranes = model.Crane.Count;
    
    Colors=hsv(model.NumberOfJobs + NumberOfCranes + 1);
    % 1 is for days of the week
    
    
    %% 
% % % % % % % % %     for NOPD = 1:NumberOfPossibleDay
% % % % % % % % %         
% % % % % % % % %         %% 
% % % % % % % % %         % termination condition
% % % % % % % % %         if sum(MachineProcedure(:,1)) - sum(MachineProcedure(:,2)) == NumberOfMachines
% % % % % % % % %             
% % % % % % % % % %             disp(['The Last Processing Day is: ' num2str(NOPD)]);
% % % % % % % % %             break;
% % % % % % % % %             
% % % % % % % % %         end
% % % % % % % % %         
% % % % % % % % %         DayCount = NOPD;
% % % % % % % % %         %%
% % % % % % % % %         for m=1:NumberOfMachines
% % % % % % % % %             
% % % % % % % % %             %% PLOT
% % % % % % % % %             % 
% % % % % % % % %             y1=(m)*H;
% % % % % % % % %             y2=y1+h;
% % % % % % % % %             
% % % % % % % % %             %%
% % % % % % % % %             if MachineProcedure(m,1) > MachineProcedure(m,2)
% % % % % % % % %                 continue;
% % % % % % % % %             end
% % % % % % % % %             
% % % % % % % % %             %% 
% % % % % % % % %             [TDayMachine, ~, ~, ~]=ECGetTime(MachineTimeCount(m));
% % % % % % % % %             if TDayMachine > DayCount
% % % % % % % % %                 continue;
% % % % % % % % %             end
% % % % % % % % %             
% % % % % % % % %             %% 
% % % % % % % % %             for j=MachineProcedure(m,1):size(ListsOfJobsDedicated2EachMachine{m},2)
% % % % % % % % %                 
% % % % % % % % %                 %% 
% % % % % % % % %                 % MachineProcedure
% % % % % % % % %                 MachineProcedure(m,1) = MachineProcedure(m,1) + 1;
% % % % % % % % %                 
% % % % % % % % %                 %% 
% % % % % % % % %                 JobNumber=ListsOfJobsDedicated2EachMachine{m}(j);
% % % % % % % % %                 WhichSplit=SplitCounter(JobNumber);
% % % % % % % % %                 NumberOfProduction=(NeededProductPerWeek(JobNumber) * ... % NeededProductPerWeek
% % % % % % % % %                                 PercentageOfWorkForEachSplit(JobNumber, WhichSplit));
% % % % % % % % %                 
% % % % % % % % %                 %% NumberOfProduction
% % % % % % % % %                 if NumberOfProduction == 0
% % % % % % % % %                     SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
% % % % % % % % %                     continue;
% % % % % % % % %                 end
% % % % % % % % %                 
% % % % % % % % %                 %% Jobs Without $ RACK $ Constraint
% % % % % % % % %                 if ~sum(Rack.JobsWithoutConstraint == JobNumber)
% % % % % % % % %                     [~, NumberOfProductionCanBeStored] = ... 
% % % % % % % % %                                     EERackInfoOnDayCount2(model,RackStatusDay,DayCount,JobNumber);
% % % % % % % % %                     
% % % % % % % % %                     if NumberOfProductionCanBeStored < NumberOfProduction
% % % % % % % % %                         MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
% % % % % % % % % %                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
% % % % % % % % %                         break;
% % % % % % % % %                     end
% % % % % % % % %                 end
% % % % % % % % %                 
% % % % % % % % %                 %% Crane
% % % % % % % % %                 
% % % % % % % % %                 % if PreviousJob(m) ~= JobNumber; it means we do not need
% % % % % % % % %                 if (PreviousJob(m) ~= 0 && PreviousJob(m) ~= JobNumber) || ... 
% % % % % % % % %                     (PreviousJob(m) == 0 && SplitCounter(JobNumber) > 1 && sum(FinishTime(JobNumber,:)) > 1) 
% % % % % % % % %                     %% 
% % % % % % % % %                     MachineNumber = m;
% % % % % % % % %                     
% % % % % % % % %                     [Possibility, CraneType, EarliestTime] = ... 
% % % % % % % % %                         EHCraneCalculation(model, MachineNumber, CellularCraneMatrix, ... 
% % % % % % % % %                         JobNumber, FinishTime, PreviousJob(m), DayCount);
% % % % % % % % %                     % and above function 
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
% % % % % % % % %                     
% % % % % % % % %                     % and below till  "elseif PreviousJob(m) ~= 0 &&
% % % % % % % % %                     % PreviousJob(m) == JobNumber"
% % % % % % % % %                     
% % % % % % % % %                     %% Earlist $ CRANE $ Time in DayCount
% % % % % % % % %                     
% % % % % % % % %                     if Possibility == 0 
% % % % % % % % %                         % Crane 
% % % % % % % % %                         MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
% % % % % % % % % %                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
% % % % % % % % %                         break;
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     %% 
% % % % % % % % %                     % Calculate Start Time, Finish Time Crane Time
% % % % % % % % %                     if (PreviousJob(m) == 0 && ...
% % % % % % % % %                        SplitCounter(JobNumber) > 1 && sum(FinishTime(JobNumber,:)) > 1)
% % % % % % % % %                         SetupTime = 60/60;
% % % % % % % % %                         PrepTime = 0;
% % % % % % % % %                     else
% % % % % % % % %                         SetupTime = SetupTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
% % % % % % % % %                         PrepTime = PreparationTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     CellularCraneMatrix{CraneType} = [CellularCraneMatrix{CraneType}; ... 
% % % % % % % % %                                                       EarliestTime EarliestTime + SetupTime MachineNumber];
% % % % % % % % %                     
% % % % % % % % %                     %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     %% 
% % % % % % % % %                     % PLOT
% % % % % % % % %                     x1=CellularCraneMatrix{CraneType}(end,1);
% % % % % % % % %                     x2=CellularCraneMatrix{CraneType}(end,2);
% % % % % % % % %                     
% % % % % % % % %                     X=[x1 x2 x2 x1];
% % % % % % % % %                     Y=[y1 y1 y2 y2];
% % % % % % % % %                     
% % % % % % % % %                     C=Colors(NumberOfJobs + CraneType,:);
% % % % % % % % %                     C=(C+[1 1 1])/2;
% % % % % % % % %                     
% % % % % % % % %                     fill(X,Y,C);
% % % % % % % % %                     hold on;
% % % % % % % % %                     
% % % % % % % % %                     xm=(x1+x2)/2;
% % % % % % % % %                     ym=(y1+y2)/2;
% % % % % % % % %                     text(xm,ym,num2str(CraneType),... 
% % % % % % % % %                         'FontWeight','bold',... 
% % % % % % % % %                         'HorizontalAlignment','center',... 
% % % % % % % % %                         'VerticalAlignment','middle', ...
% % % % % % % % %                         'Rotation', 90); 
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                                                   
% % % % % % % % %                                                   
% % % % % % % % %                                                   
% % % % % % % % %                     StartTime(JobNumber,SplitCounter(JobNumber)) = EarliestTime + SetupTime + PrepTime;
% % % % % % % % %                     
% % % % % % % % %                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
% % % % % % % % %                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
% % % % % % % % %                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
% % % % % % % % %                         (NeededProductPerWeek(JobNumber, 1) * ... % NeededProductPerWeek 
% % % % % % % % %                         PercentageOfWorkForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % PercentageOfWorkForEachSplit 
% % % % % % % % %                         ProcessTimePerHourJobMachine(JobNumber, m); 
% % % % % % % % %                     
% % % % % % % % %                     %% 
% % % % % % % % %                     % one working day: if it passes one working day there
% % % % % % % % %                     % should be add a corresponding hour to the FinishTime
% % % % % % % % %                     [TdayST, ~, ~, ~] = ECGetTime( StartTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     [TdayFT, ~, ~, ~]=ECGetTime( FinishTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     NumberOfDay = TdayFT - TdayST;
% % % % % % % % %                     if TdayFT - TdayST > 0 
% % % % % % % % %                         
% % % % % % % % %                         [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
% % % % % % % % %                         FinishTime( JobNumber, SplitCounter(JobNumber) ) = ...
% % % % % % % % %                             FinishTime( JobNumber, SplitCounter(JobNumber) ) + ... 
% % % % % % % % %                             NumberOfDay * InoperativeWorkingHours(row+1,column);
% % % % % % % % %                         
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     %% 
% % % % % % % % %                     % PLOT
% % % % % % % % %                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     X=[x1 x2 x2 x1];
% % % % % % % % %                     Y=[y1 y1 y2 y2];
% % % % % % % % %                     
% % % % % % % % %                     C=Colors(JobNumber,:);
% % % % % % % % %                     C=(C+[1 1 1])/2;
% % % % % % % % %                     
% % % % % % % % %                     fill(X,Y,C);
% % % % % % % % %                     hold on;
% % % % % % % % %                     
% % % % % % % % %                     xm=(x1+x2)/2;
% % % % % % % % %                     ym=(y1+y2)/2;
% % % % % % % % %                     text(xm,ym,num2str(JobNumber),...
% % % % % % % % %                         'FontWeight','bold',...
% % % % % % % % %                         'HorizontalAlignment','center',...
% % % % % % % % %                         'VerticalAlignment','middle');
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     %% update Rack Status 
% % % % % % % % %                     % if the product needs to be stored in racks 
% % % % % % % % %                     if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
% % % % % % % % %                         RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     %% Calculation
% % % % % % % % %                     
% % % % % % % % %                     PreviousJob(m) = JobNumber;
% % % % % % % % %                     
% % % % % % % % %                     MachineTimeCount(m) = FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
% % % % % % % % %                     
% % % % % % % % %                 elseif PreviousJob(m) ~= 0 && PreviousJob(m) == JobNumber
% % % % % % % % %                     %% 
% % % % % % % % %                     % without crane constraint
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     
% % % % % % % % %                     StartTime(JobNumber,SplitCounter(JobNumber)) = FinishTime(JobNumber, SplitCounter(JobNumber) - 1);
% % % % % % % % %                     
% % % % % % % % %                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
% % % % % % % % %                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
% % % % % % % % %                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
% % % % % % % % %                         (NeededProductPerWeek(JobNumber, 1) * ... % NeededProductPerWeek 
% % % % % % % % %                         PercentageOfWorkForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % PercentageOfWorkForEachSplit 
% % % % % % % % %                         ProcessTimePerHourJobMachine(JobNumber, m); 
% % % % % % % % %                     
% % % % % % % % %                     %% 
% % % % % % % % %                     % one working day: if it passes one working day there
% % % % % % % % %                     % should be add a corresponding hour to the FinishTime
% % % % % % % % %                     [TdayST, ~, ~, ~] = ECGetTime( StartTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     [TdayFT, ~, ~, ~]=ECGetTime( FinishTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     NumberOfDay = TdayFT - TdayST;
% % % % % % % % %                     if TdayFT - TdayST > 0 
% % % % % % % % %                         
% % % % % % % % %                         [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
% % % % % % % % %                         FinishTime( JobNumber, SplitCounter(JobNumber) ) = ...
% % % % % % % % %                             FinishTime( JobNumber, SplitCounter(JobNumber) ) + ... 
% % % % % % % % %                             NumberOfDay * InoperativeWorkingHours(row+1,column);
% % % % % % % % %                         
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     %% 
% % % % % % % % %                     % PLOT
% % % % % % % % %                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     X=[x1 x2 x2 x1];
% % % % % % % % %                     Y=[y1 y1 y2 y2];
% % % % % % % % %                     
% % % % % % % % %                     C=Colors(JobNumber,:);
% % % % % % % % %                     C=(C+[1 1 1])/2;
% % % % % % % % %                     
% % % % % % % % %                     fill(X,Y,C);
% % % % % % % % %                     hold on;
% % % % % % % % %                     
% % % % % % % % %                     xm=(x1+x2)/2;
% % % % % % % % %                     ym=(y1+y2)/2;
% % % % % % % % %                     text(xm,ym,num2str(JobNumber),...
% % % % % % % % %                         'FontWeight','bold',...
% % % % % % % % %                         'HorizontalAlignment','center',...
% % % % % % % % %                         'VerticalAlignment','middle');
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     %% update Rack Status 
% % % % % % % % %                     % if the product needs to be stored in racks 
% % % % % % % % %                     if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
% % % % % % % % %                         RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     %% Calculation
% % % % % % % % %                     
% % % % % % % % %                     PreviousJob(m) = JobNumber;
% % % % % % % % %                     
% % % % % % % % %                     MachineTimeCount(m) = FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
% % % % % % % % %                     
% % % % % % % % %                 else 
% % % % % % % % %                     %% 
% % % % % % % % %                     % without crane constraint
% % % % % % % % %                     StartTime(JobNumber,SplitCounter(JobNumber)) = MachineTimeCount(m);
% % % % % % % % %                     
% % % % % % % % %                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
% % % % % % % % %                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
% % % % % % % % %                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
% % % % % % % % %                         (NeededProductPerWeek(JobNumber, 1) * ... % NeededProductPerWeek 
% % % % % % % % %                         PercentageOfWorkForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % PercentageOfWorkForEachSplit 
% % % % % % % % %                         ProcessTimePerHourJobMachine(JobNumber, m); 
% % % % % % % % %                     
% % % % % % % % %                     %% 
% % % % % % % % %                     % one working day: if it passes one working day there
% % % % % % % % %                     % should be add a corresponding hour to the FinishTime
% % % % % % % % %                     [TdayST, ~, ~, ~] = ECGetTime( StartTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     [TdayFT, ~, ~, ~]=ECGetTime( FinishTime(JobNumber,SplitCounter(JobNumber)) - 7);
% % % % % % % % %                     NumberOfDay = TdayFT - TdayST;
% % % % % % % % %                     if (TdayFT - TdayST > 0 ) || ...
% % % % % % % % %                        (PreviousJob(m) == 0 && FinishTime(JobNumber,SplitCounter(JobNumber)) >= 24)
% % % % % % % % %                         if PreviousJob(m) == 0
% % % % % % % % %                             NumberOfDay = 1;
% % % % % % % % %                         end
% % % % % % % % %                         [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
% % % % % % % % %                         FinishTime( JobNumber, SplitCounter(JobNumber) ) = ...
% % % % % % % % %                             FinishTime( JobNumber, SplitCounter(JobNumber) ) + ... 
% % % % % % % % %                             NumberOfDay * InoperativeWorkingHours(row+1,column);
% % % % % % % % %                         
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% % % % % % % % %                     %% 
% % % % % % % % %                     % PLOT
% % % % % % % % %                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     X=[x1 x2 x2 x1];
% % % % % % % % %                     Y=[y1 y1 y2 y2];
% % % % % % % % %                     
% % % % % % % % %                     C=Colors(JobNumber,:);
% % % % % % % % %                     C=(C+[1 1 1])/2;
% % % % % % % % %                     
% % % % % % % % %                     fill(X,Y,C);
% % % % % % % % %                     hold on;
% % % % % % % % %                     
% % % % % % % % %                     xm=(x1+x2)/2;
% % % % % % % % %                     ym=(y1+y2)/2;
% % % % % % % % %                     text(xm,ym,num2str(JobNumber),...
% % % % % % % % %                         'FontWeight','bold',...
% % % % % % % % %                         'HorizontalAlignment','center',...
% % % % % % % % %                         'VerticalAlignment','middle');
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     
% % % % % % % % %                     %% update Rack Status 
% % % % % % % % %                     % if the product needs to be stored in racks 
% % % % % % % % %                     if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
% % % % % % % % %                         RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
% % % % % % % % %                     end
% % % % % % % % %                     
% % % % % % % % %                     %% Calculation
% % % % % % % % %                     
% % % % % % % % %                     PreviousJob(m) = JobNumber;
% % % % % % % % %                     
% % % % % % % % %                     MachineTimeCount(m) = FinishTime(JobNumber,SplitCounter(JobNumber));
% % % % % % % % %                     
% % % % % % % % %                     SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
% % % % % % % % %                     
% % % % % % % % %                 end
% % % % % % % % %                 
% % % % % % % % %                 %% 
% % % % % % % % %                 % Calculate DayCount of the last Job on machine 
% % % % % % % % %                 [DayCountMachine, ~, ~, ~] = ECGetTime( FinishTime(JobNumber,SplitCounter(JobNumber) - 1) );
% % % % % % % % %                 
% % % % % % % % %                 if DayCountMachine ~= DayCount
% % % % % % % % %                     break;
% % % % % % % % %                 end
% % % % % % % % %                 
% % % % % % % % %             end
% % % % % % % % %             
% % % % % % % % %         end
% % % % % % % % %         %%
% % % % % % % % %         % Update Rack; INCREASE rack availability and put that matrix one
% % % % % % % % %         % day ahead 
% % % % % % % % %         RackStatusDay = EGNextDayRack(model.Rack.ConsumptionRatePerDay, RackStatusDay, DayCount);
% % % % % % % % %         
% % % % % % % % %     end
% % % % % % % % %     MaximumCompletionTime = max(FinishTime);
    
    
    
	    %% model
    ProcessTimePerHourJobMachine=model.ProcessTimePerHourJobMachine;
    
    NumberOfJobs=model.NumberOfJobs;
    NumberOfMachines=model.NumberOfMachines;
    
    NumberOfSplitForEachJob=model.NumberOfSplitForEachJob;
    
    RealNeededProducts=model.RealNeededProducts;
    
    SetupTimePerHour=model.SetupTimePerHour;
    PreparationTimePerHour=model.PreparationTimePerHour;
    
    PercentageOfScrap=model.PercentageOfScrap;
    PercentageOfStops=model.PercentageOfStops;
    
    ModelWorkingHoursShift=model.WorkingHours.Shift;
    
%     % MinimumEconomicalProduction: It should be considered beforehand
%     MinimumEconomicalProduction=model.MinimumEconomicalProduction;
    
    Rack=model.Rack;
    
    Crane=model.Crane;
	
    %% Solution
%     Permutation=Solution.Permutation;
    NumberOfProductForEachSplit=Solution.NumberOfProductForEachSplit;
    WorkingHours=Solution.WorkingHours;
    ListsOfJobsDedicated2EachMachine=Solution.ListsOfJobsDedicated2EachMachine;
    
    %% All Constraints 
    % 1- jobs are split 
    % 2- one split job cannot process at the same time on different machine
    % 3- there are only limitted crane for changing the FORM at a specific time 
    % DONE 4- the jobs that are at minimum depot level are in priority
    % DONE 5- Economical Production is the minimum amount of production 
    % 6- in night shift we cannot change the FORM from one product to another 
    % DONE 7- it may happen that a machine has different types of shift during
    % the week 
    % 8- Rack Constraint has to be considered 
	
    %%
    
    % 4- the jobs that are at minimum depot level are in priority
%     [UpdatedPermutation, UpdatedLists]=EBPriorityJobs2do(ListsOfJobsDedicated2EachMachine,model);
    
    % The better Lists is Updated
%     Solution.Permutation=UpdatedPermutation;
%     Solution.ListsOfJobsDedicated2EachMachine=UpdatedLists;
    
    %% $$$$$$$$$$$$$$$$******************$$$$$$$$$$$$$$$$$$$$$$$$$$
%     % 5- Economical Production is the minimum amount of production
%     AmendedPercentageOfWork=ListAmendment2(PercentageOfWork,model);
%     % The better Percentage of work is updated
%     Solution.PercentageOfWork=AmendedPercentageOfWork;
    
    %% calculate which part of a day, a machine cannot operate
    % based on the model.WorkingHours.Shift
    
    InoperativeWorkingHours=zeros(2, size(ModelWorkingHoursShift,2));
    InoperativeWorkingHours(1,:)=ModelWorkingHoursShift;
    for inop=1:size(ModelWorkingHoursShift,2)
        InoperativeWorkingHours(2,inop)=(24-ModelWorkingHoursShift(inop));
        % second row is related to the time that must be added 
        % InoperativeWorkingHours shows that from what time to 7 o'clock in
        % the morning a machine that follows that WorkingHours cannot
        % operate, for example 3.3 a.m. to 7 a.m.
    end
    
    %%
    % Time-based Simulation of JOBS
    % Each cell refers to a job, and each cell has as many rows as its
    % split and first column is start time, second column is finish time
    % and third column is the machine number which operates that job
    CellularSTFTMachineMatrix = cell(NumberOfJobs,1);
    for j = 1:NumberOfJobs
        CellularSTFTMachineMatrix{j} = zeros(NumberOfSplitForEachJob(j),3);
        
    end
    
%     StartTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
%     
%     FinishTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
%     
%     FromStart2FinishTime=zeros(NumberOfJobs,NumberOfSplitForEachJob);
    
    MaximumCompletionTimePerMachine=zeros(1,NumberOfMachines);
    
    % 1- When we want to change a frame
    % 2- Crane cannot work on night shifts
    % it means it cannot operate from 20.00 at night to 7.00 in the morning
    % CraneMatrix is a cell matrix; each cell is a crane and each matrix
    % has three column, first is start time and second is finish time and
    % third is the machine number
    CellularCraneMatrix = {zeros(1,3)};
    for CraneCount=1:(Crane.Count - 1)
        CellularCraneMatrix{CraneCount+1}=zeros(1,3);
    end
    
	%% Rack Status for each day
    % rows are jobs, columns are rack types, and the other dimention is
    % day, first dimention is initial status and the other 
%     NumberOfPossibleDay=9999999;
%     NumberOfPossibleDay=99999;
    NumberOfPossibleDay=999;
    RackStatusDay=repmat(zeros(size(Rack.Initial)),[1 1 NumberOfPossibleDay]);
    RackStatusDay(:,:,1)=model.Rack.Initial;
    PreviousJob=zeros(NumberOfMachines,1);
    
    % Production per day must be stored
    % this matrix will be used to evaluate KANBAN Matrix
    ProductionPerDay=zeros(NumberOfJobs,NumberOfPossibleDay);
    
    % the finish time of last job on a machine before switching to another 
    % job 
    MachineTimeCount=7*ones(NumberOfMachines,1);
    
    % first column is the first job number that has to be done on the
    % machine; and second column is the comulative jobs that has to be done
    % by machine
    MachineProcedure=ones(NumberOfMachines,2);
    for m=1:NumberOfMachines
        MachineProcedure(m,2)=size(ListsOfJobsDedicated2EachMachine{m},2);
    end
    
    %% 
    SplitCounter=ones(NumberOfJobs,1);
    
    %% 
    for NOPD = 1:NumberOfPossibleDay
        
        %% 
        % termination condition
        if sum(MachineProcedure(:,1)) - sum(MachineProcedure(:,2)) == NumberOfMachines
            
%             disp(['The Last Processing Day is: ' num2str(NOPD)]);
            break;
            
        end
        
        DayCount = NOPD;
        %%
        for m=1:NumberOfMachines
            
            %% PLOT
            % 
            y1=(m)*H;
            y2=y1+h;
            
            %%
            if MachineProcedure(m,1) > MachineProcedure(m,2)
                continue;
            end
            
            %% 
            [TDayMachine, ~, ~, ~]=ECGetTime(MachineTimeCount(m));
            if TDayMachine > DayCount
                continue;
            end
            
            %% 
            for j=MachineProcedure(m,1):size(ListsOfJobsDedicated2EachMachine{m},2)
                
                %% 
                % MachineProcedure
                MachineProcedure(m,1) = MachineProcedure(m,1) + 1;
                
                %% 
                JobNumber=ListsOfJobsDedicated2EachMachine{m}(j);
                WhichSplit=SplitCounter(JobNumber);
%                 NumberOfProduction=(RealNeededProducts(JobNumber) * ... % RealNeededProducts
%                                 NumberOfProductForEachSplit(JobNumber, WhichSplit));
                NumberOfProduction=Solution.NumberOfProductForEachSplit{JobNumber} (WhichSplit);
                
                %% NumberOfProduction
                if NumberOfProduction == 0
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    continue;
                end
                
                %% Jobs Without $ RACK $ Constraint
                if ~sum(Rack.JobsWithoutConstraint == JobNumber)
                    [~, NumberOfProductionCanBeStored] = ... 
                                    EERackInfoOnDayCount2(model,RackStatusDay,DayCount,JobNumber);
                    
                    if NumberOfProductionCanBeStored < NumberOfProduction
                        MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
%                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
                        break;
                    end
                end
                
                %% Crane
                
                % if PreviousJob(m) ~= JobNumber; it means we do not need
                if (PreviousJob(m) ~= 0 && PreviousJob(m) ~= JobNumber) || ... 
                    (PreviousJob(m) == 0 && SplitCounter(JobNumber) > 1 && sum(CellularSTFTMachineMatrix{JobNumber} (:,2)) > 1) 
                    %% 
                    MachineNumber = m;
                    
                    [Possibility, CraneType, EarliestTime] = ... 
                        EHCraneCalculation(model, MachineNumber, CellularCraneMatrix, ... 
                        JobNumber, CellularSTFTMachineMatrix, PreviousJob(m), DayCount);
%                         JobNumber, FinishTime, PreviousJob(m), DayCount);
                    % and above function 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 
                    
                    % and below till  "elseif PreviousJob(m) ~= 0 &&
                    % PreviousJob(m) == JobNumber"
                    
                    %% Earlist $ CRANE $ Time in DayCount
                    
                    if Possibility == 0 
                        % Crane 
                        MachineProcedure(m,1) = MachineProcedure(m,1) - 1;
%                         SplitCounter(JobNumber) = SplitCounter(JobNumber) - 1;
                        break;
                    end
                    
                    %% 
                    % Calculate Start Time, Finish Time Crane Time
                    if (PreviousJob(m) == 0 && ...
                       SplitCounter(JobNumber) > 1 && sum(CellularSTFTMachineMatrix{JobNumber} (:,2)) > 1)
                        SetupTime = 60/60;
                        PrepTime = 0;
                    else
                        SetupTime = SetupTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
                        PrepTime = PreparationTimePerHour(PreviousJob(m),JobNumber,MachineNumber);
                    end
                    
                    CellularCraneMatrix{CraneType} = [CellularCraneMatrix{CraneType}; ... 
                                                      EarliestTime EarliestTime + SetupTime MachineNumber];
                    
                    %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    %% 
                    % PLOT
                    x1=CellularCraneMatrix{CraneType}(end,1);
                    x2=CellularCraneMatrix{CraneType}(end,2);
                    
                    X=[x1 x2 x2 x1];
                    Y=[y1 y1 y2 y2];
                    
                    C=Colors(NumberOfJobs + CraneType,:);
                    C=(C+[1 1 1])/2;
                    
                    fill(X,Y,C);
                    hold on;
                    
                    xm=(x1+x2)/2;
                    ym=(y1+y2)/2;
                    text(xm,ym,num2str(CraneType),... 
                        'FontWeight','bold',... 
                        'HorizontalAlignment','center',... 
                        'VerticalAlignment','middle', ...
                        'Rotation', 90); 
                    
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = EarliestTime + SetupTime + PrepTime;
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = EarliestTime + SetupTime + PrepTime;
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                        NumberOfProduction / ...
                        ProcessTimePerHourJobMachine(JobNumber, m); 
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if TdayFT - TdayST > 0 
                        
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ...
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    
                    %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    %% 
                    % PLOT
%                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
                    x1=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1);
                    
%                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
                    x2=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    X=[x1 x2 x2 x1];
                    Y=[y1 y1 y2 y2];
                    
                    C=Colors(JobNumber,:);
                    C=(C+[1 1 1])/2;
                    
                    fill(X,Y,C);
                    hold on;
                    
                    xm=(x1+x2)/2;
                    ym=(y1+y2)/2;
                    text(xm,ym,num2str(JobNumber),...
                        'FontWeight','bold',...
                        'HorizontalAlignment','center',...
                        'VerticalAlignment','middle');
                    
                    
                    
                    
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                elseif PreviousJob(m) ~= 0 && PreviousJob(m) == JobNumber
                    %% 
                    % without crane constraint
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2);
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = FinishTime(JobNumber, SplitCounter(JobNumber) - 1);
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                        NumberOfProduction / ...
                        ProcessTimePerHourJobMachine(JobNumber, m); 
                    
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if TdayFT - TdayST > 0 
                        
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ...
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    
                    %% 
                    % PLOT
%                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
                    x1=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1);
                    
%                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
                    x2=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    X=[x1 x2 x2 x1];
                    Y=[y1 y1 y2 y2];
                    
                    C=Colors(JobNumber,:);
                    C=(C+[1 1 1])/2;
                    
                    fill(X,Y,C);
                    hold on;
                    
                    xm=(x1+x2)/2;
                    ym=(y1+y2)/2;
                    text(xm,ym,num2str(JobNumber),...
                        'FontWeight','bold',...
                        'HorizontalAlignment','center',...
                        'VerticalAlignment','middle');
                    
                    
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                else 
                    %% 
                    % without crane constraint
                    
                    % Start Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) = MachineTimeCount(m);
%                     StartTime(JobNumber,SplitCounter(JobNumber)) = MachineTimeCount(m);
                    
                    % Finish Time
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ... 
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) + ...
                        (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
                         NumberOfProduction / ... % NumberOfProductForEachSplit 
                        ProcessTimePerHourJobMachine(JobNumber, m); 
%                     FinishTime(JobNumber,SplitCounter(JobNumber)) = ... 
%                         StartTime(JobNumber,SplitCounter(JobNumber)) + ... 
%                         (1 + PercentageOfScrap(JobNumber, m)) * ... % PercentageOfScrap 
%                         (RealNeededProducts(JobNumber, 1) * ... % RealNeededProducts 
%                         NumberOfProductForEachSplit(JobNumber, SplitCounter(JobNumber))) / ... % NumberOfProductForEachSplit 
%                         ProcessTimePerHourJobMachine(JobNumber, m); 
                    
                    % Machine Number
                    CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),3) = m;
                    
                    % ProductionPerDay
                    ProductionPerDay(JobNumber,DayCount) = NumberOfProduction;
                    
                    %% 
                    % one working day: if it passes one working day there
                    % should be add a corresponding hour to the FinishTime
                    [TdayST, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1) - 7);
                    [TdayFT, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) - 7);
                    NumberOfDay = TdayFT - TdayST;
                    if (TdayFT - TdayST > 0 ) || ...
                       (PreviousJob(m) == 0 && CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) >= 24)
                        if PreviousJob(m) == 0
                            NumberOfDay = 1;
                        end
                        [row, column] = find( InoperativeWorkingHours == WorkingHours(m,2) );
                        CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) = ...
                            CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2) + ... 
                            NumberOfDay * InoperativeWorkingHours(row+1,column);
                        
                    end
                    
                    
                    %% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                    %% 
                    % PLOT
%                     x1=StartTime(JobNumber,SplitCounter(JobNumber));
                    x1=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),1);
                    
%                     x2=FinishTime(JobNumber,SplitCounter(JobNumber));
                    x2=CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    X=[x1 x2 x2 x1];
                    Y=[y1 y1 y2 y2];
                    
                    C=Colors(JobNumber,:);
                    C=(C+[1 1 1])/2;
                    
                    fill(X,Y,C);
                    hold on;
                    
                    xm=(x1+x2)/2;
                    ym=(y1+y2)/2;
                    text(xm,ym,num2str(JobNumber),...
                        'FontWeight','bold',...
                        'HorizontalAlignment','center',...
                        'VerticalAlignment','middle');
                    
                    
                    
                    
                    %% update Rack Status 
                    % if the product needs to be stored in racks 
                    if ~sum(Rack.JobsWithoutConstraint == JobNumber) 
                        RackStatusDay = EIReduceRackAvailability2Job(model, RackStatusDay, JobNumber, NumberOfProduction, DayCount);
                    end
                    
                    %% Calculation
                    
                    PreviousJob(m) = JobNumber;
                    
                    MachineTimeCount(m) = CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber),2);
                    
                    SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
                    
                end
                
                %% 
                % Calculate DayCount of the last Job on machine 
                [DayCountMachine, ~, ~, ~] = ECGetTime( CellularSTFTMachineMatrix{JobNumber} (SplitCounter(JobNumber) - 1, 2) );
                
                if DayCountMachine ~= DayCount
                    break;
                end
                
            end
            
            if MaximumCompletionTimePerMachine(m) < max(CellularSTFTMachineMatrix{JobNumber} (:,2))
                MaximumCompletionTimePerMachine(m) = max(CellularSTFTMachineMatrix{JobNumber} (:,2));
            end
            
        end
        %%
        % Update Rack; INCREASE rack availability and put that matrix one
        % day ahead 
        RackStatusDay = EGNextDayRack(model.Rack.ConsumptionRatePerDay, RackStatusDay, DayCount);
        
    end
%     MaximumCompletionTimePerMachine = max(FinishTime);
    
    %% output
%     Interpretation.Lists=UpdatedLists;
%     Interpretation.StartTime=StartTime;
%     Interpretation.PreparationTime=FromStart2FinishTime;
%     Interpretation.FinishTime=FinishTime;
%     Interpretation.MaximumCompletionTime=MaximumCompletionTimePerMachine;
%     Interpretation.Cmax=max(MaximumCompletionTimePerMachine);
%     
%     Interpretation.RackStatusDay=RackStatusDay(:,:,1:NOPD);
%     Interpretation.ProductionPerDay=ProductionPerDay(:,1:NOPD);
%     
%     Interpretation.CellularSTFTMachineMatrix=CellularSTFTMachineMatrix;
%     
%     Interpretation.CellularCraneMatrix=CellularCraneMatrix;
    
    
    
    
    
    
    
    
    
    
    %% 
    % PLOT
    % Cmax
    hold on;
    Cmax=max(MaximumCompletionTimePerMachine);
    plot([Cmax Cmax],[0 (NumberOfMachines+1)*H],'r:','LineWidth',2.5);
    text(Cmax,(NumberOfMachines+1)*H,['C_{max} = ' num2str(Cmax)],...
        'FontWeight','bold',...
        'HorizontalAlignment','right',...
        'VerticalAlignment','top',...
        'Color','red');
    
    %% 
    % Days of Week
    
    ST_day=[7
            24 + 7
            48 + 7
            72 + 7
            96 + 7
            120 + 7
            144 + 7];
    FT_day=[24 + 7
            48 + 7
            72 + 7
            96 + 7
            120 + 7
            144 + 7
            168 + 7];
    
    y1_day=(0)*H;
    y2_day=y1_day+h;
    list_day={'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
    for day=1:size(ST_day)
        
        x1_day=ST_day(day);
        x2_day=FT_day(day);
        
        X_day=[x1_day x2_day x2_day x1_day];
        Y_day=[y1_day y1_day y2_day y2_day];
        
        C_day=Colors(end,:);
        C_day=(C_day+[1 1 1])/2;
        
        fill(X_day,Y_day,C_day);
        hold on;
        
        xm_day=(x1_day+x2_day)/2;
        ym_day=(y1_day+y2_day)/2;
        
        text(xm_day,ym_day,list_day{day},...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'VerticalAlignment','middle');
        
    end
    
    % Crane
    for CraneNumber = 1:NumberOfCranes
        
        if size(Solution.Inter.CellularCraneMatrix{CraneNumber}) == 1
            continue;
        end
        
        for row = 2:size(Solution.Inter.CellularCraneMatrix{CraneNumber})
            
            
            
        end
        
    end
    
    % 
    hold off;
    grid on;
    
    

end
%     %%
%     % Parameters
%     StartTime = BestSol.Inter.StartTime;
%     FinishTime = BestSol.Inter.FinishTime;
%     
%     NumberOfJobs = model.NumberOfJobs;
%     NumberOfMachines = model.NumberOfMachines;
%     NumberOfSplitForEachJob = model.NumberOfSplitForEachJob;
%     
%     PercentageOfWorkForEachSplit = BestSol.PercentageOfWorkForEachSplit;
%     
%     NumberOfCranes = model.Crane.Count;
%     
%     NeededProductPerWeek = model.NeededProductPerWeek;
%     
%     ListsOfJobsDedicated2EachMachine = BestSol.ListsOfJobsDedicated2EachMachine;
%     
%     MaximumDay = ECGetTime(BestSol.Cost);
%     
%     MachineProcedure=ones(NumberOfMachines,2);
%     for m=1:NumberOfMachines
%         MachineProcedure(m,2)=size(ListsOfJobsDedicated2EachMachine{m},2);
%     end
%     
%     MachineTimeCount=7*ones(NumberOfMachines,1);
%     
%     SplitCounter=ones(NumberOfJobs,1);
%     
%     H=1;
%     h=0.75;
%     
%     Colors=hsv(NumberOfJobs + NumberOfCranes + 1);
%     % 1 is for days of the week
%     
%     %% 
%     % 
% %     hold on;
%     
%     %% 
%     % Plot JOBS
%     
%     for NOPD = 1:MaximumDay
%         
%         %%%
%         
%         %% 
%         % termination condition
%         if sum(MachineProcedure(:,1)) - sum(MachineProcedure(:,2)) == NumberOfMachines
%             
% %             disp(['The Last Processing Day is: ' num2str(NOPD)]);
%             break;
%             
%         end
%         
%         DayCount = NOPD;
%         %%
%         for m=1:NumberOfMachines
%             
%             y1=(m)*H;
%             y2=y1+h;
%             
%             %%
%             if MachineProcedure(m,1) > MachineProcedure(m,2)
%                 continue;
%             end
%             
%             %% 
%             [TDayMachine, ~, ~, ~]=ECGetTime(MachineTimeCount(m));
%             if TDayMachine > DayCount
%                 continue;
%             end
%             
%             %% 
%             for j=MachineProcedure(m,1):size(ListsOfJobsDedicated2EachMachine{m},2)
%                 
%                 %% 
%                 % MachineProcedure
%                 MachineProcedure(m,1) = MachineProcedure(m,1) + 1;
%                 
%                 %% 
%                 JobNumber=ListsOfJobsDedicated2EachMachine{m}(j);
%                 WhichSplit=SplitCounter(JobNumber);
%                 NumberOfProduction=(NeededProductPerWeek(JobNumber) * ... % NeededProductPerWeek
%                                 PercentageOfWorkForEachSplit(JobNumber, WhichSplit));
%                 
%                 %% NumberOfProduction
%                 if NumberOfProduction == 0
%                     SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
%                     continue;
%                 end
%                 
%                 %%
%                 
%                 
%                 %% 
%                 % Plot Job
%                 
%                 
%                 x1=StartTime(JobNumber,WhichSplit);
%                 x2=FinishTime(JobNumber,WhichSplit);
%                 
%                 X=[x1 x2 x2 x1];
%                 Y=[y1 y1 y2 y2];
%                 
%                 C=Colors(JobNumber,:);
%                 C=(C+[1 1 1])/2;
%                 
%                 fill(X,Y,C);
%                 hold on;
%                 
%                 xm=(x1+x2)/2;
%                 ym=(y1+y2)/2;
%                 text(xm,ym,num2str(JobNumber),...
%                     'FontWeight','bold',...
%                     'HorizontalAlignment','center',...
%                     'VerticalAlignment','middle');
%                 
%                 
%                 %% 
%                 % Calculate DayCount of the last Job on machine 
%                 [DayCountMachine, ~, ~, ~] = ECGetTime( FinishTime(JobNumber,SplitCounter(JobNumber)) );
%                 
%                 % 
%                 SplitCounter(JobNumber) = SplitCounter(JobNumber) + 1;
%                 
%                 if DayCountMachine ~= DayCount
%                     break;
%                 end
%                 
%             end
%             
%         end
%         
%         %%%
%         
%     end
%     
%     %%
%     % Cmax
%     Cmax=BestSol.Cost;
%     plot([Cmax Cmax],[0 (NumberOfMachines+1)*H],'r:','LineWidth',2.5);
%     text(Cmax,(NumberOfMachines+1)*H,['C_{max} = ' num2str(Cmax)],...
%         'FontWeight','bold',...
%         'HorizontalAlignment','right',...
%         'VerticalAlignment','top',...
%         'Color','red');
%     
%     %% 
%     % Plot Cranes
%     
%     for CraneNumber = 1:NumberOfCranes
%         
%         if size(BestSol.Inter.CellularCraneMatrix{CraneNumber}) == 1
%             continue;
%         end
%         
%         for row = 2:size(BestSol.Inter.CellularCraneMatrix{CraneNumber})
%             
%             
%             
%         end
%         
%     end
%     
%     %% 
%     % Days of Week
%     
%     ST_day=[7
%             24 + 7
%             48 + 7
%             72 + 7
%             96 + 7
%             120 + 7
%             144 + 7];
%     FT_day=[24 + 7
%             48 + 7
%             72 + 7
%             96 + 7
%             120 + 7
%             144 + 7
%             168 + 7];
%     
%     y1_day=(0)*H;
%     y2_day=y1_day+h;
%     list_day={'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
%     for day=1:size(ST_day)
%         
%         x1_day=ST_day(day);
%         x2_day=FT_day(day);
%         
%         X_day=[x1_day x2_day x2_day x1_day];
%         Y_day=[y1_day y1_day y2_day y2_day];
%         
%         C_day=Colors(end,:);
%         C_day=(C_day+[1 1 1])/2;
%         
%         fill(X_day,Y_day,C_day);
%         hold on;
%         
%         xm_day=(x1_day+x2_day)/2;
%         ym_day=(y1_day+y2_day)/2;
%         
%         text(xm_day,ym_day,list_day{day},...
%             'FontWeight','bold',...
%             'HorizontalAlignment','center',...
%             'VerticalAlignment','middle');
%         
%     end
%     
%     %%
%     % 
%     hold off;
%     grid on;
