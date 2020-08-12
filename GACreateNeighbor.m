function xnew = GACreateNeighbor(x,model)

    xnew = x;
    
    NumberOfNeighbors = 11;
    
    RandSelect = randperm(NumberOfNeighbors,1);
    
%     RandSelect = 11;
    
    switch RandSelect
        case  1 % Create Random Solution

            xnew = CACreateRandomSolution(model);
            return;
            
        case 2 % Randomly select a machine and then reorder the job on the same machine

            xnew = GBReorderJobSameMachine(x,model);
            return;
            
        case 3 % Randomly select a machine and then assign the job to another machine if possible

            xnew = GCSelectAJobAssign2AnotherMachine(x,model);
            return;
            
        case 4 % Randomly Change working shift

            xnew = GDChangeWorkingHours(x,model);
            return;
            
        case 5 % Randomly Select a job and then if it has more than two split then change the orther of NumberOfProductForEachSplit

            xnew.NumberOfProductForEachSplit = GEChangePercentageOfWorkForEachSplit(x,model);
            return;
        
        case 6 % Select the machine which has the longest operating time and then change the order of jobs or assign a job to another machine if possible
        
            RandLocalSearch = rand;
        
            if RandLocalSearch <= 0.5
                % Select the machine which has the longest operating time and then change the order of jobs
                xnew = LocalSearch01(x,model);
                return;
                
            elseif RandLocalSearch <= 1
                % Select the machine which has the longest operating time and then assign a random job to another machine if possible
                xnew = LocalSearch02(x,model);
                return;
                
            end
            
        case 7 % two local search at the same time
            % localSearch1 then localSearch2
            xnew = LocalSearch01(x,model);
            xnew = LocalSearch02(xnew,model);
            return;
            
        case 8 % two CreatNeighbor at the same time
            % 2 then 3
            xnew = GBReorderJobSameMachine(x,model);
            xnew = GCSelectAJobAssign2AnotherMachine(xnew,model);
            return;
            
        case 9 % reorder base on the persistency of products inventory
            xnew = GFReorderBasedOnPersistency(x,model);
            return;
            
        case 10 
            % Randomly select a machine and then assign the job to another
            % machine if possible 
            % then reorder base on the persistency of products inventory 
            xnew = GCSelectAJobAssign2AnotherMachineThenReordeBasedOnPersistency(x,model);
            return;
            
        case 11
            
            NumberOfNeighbors2 = 4;
            
            RandSelectNeighbors2 = randperm(NumberOfNeighbors2,1);
            
            switch RandSelectNeighbors2
            
                case 1
                % Randomly select a machine and then reorder the job on the same machine
                    xnew = GBReorderJobSameMachine(x,model);
                    return; 
                case 2
                % Randomly Change working shift
                    xnew = GDChangeWorkingHours(x,model);
                    return;
                case 3
                % Randomly select a machine and then assign the job to another machine if possible
                    xnew = GCSelectAJobAssign2AnotherMachine(x,model);
                    return;
                    
                case 4
                    % Select the machine which has the longest operating time and then change the order of jobs or assign a job to another machine if possible
        
                    RandLocalSearch = rand;
                    
                    if RandLocalSearch <= 0.5
                        % Select the machine which has the longest operating time and then change the order of jobs
                        xnew = LocalSearch01(x,model);
                        return;
                        
                    elseif RandLocalSearch <= 1
                        % Select the machine which has the longest operating time and then assign a random job to another machine if possible
                        xnew = LocalSearch02(x,model);
                        return;
                        
                    end
                    
            end
            
    end


end

% function xnew = GACreateNeighbor(x,model)
% 
%     xnew = x;
%     
%     NumberOfNeighbors = 5;
%     
%     RandSelect = randperm(NumberOfNeighbors,1);
%     
% %     RandSelect = 5;
%     
%     switch RandSelect
%         case 1 % Create Random Solution
%             
%             xnew = CACreateRandomSolution(model);
%             
%         case 2 % Randomly select a machine and then reorder the job on the same machine
%             
%             xnew = GBReorderJobSameMachine(x,model);
%             
%         case 3 % Randomly select a machine and then assign the job to another machine if possible
%             
%             xnew = GCSelectAJobAssign2AnotherMachine(x,model);
%             
%         case 4 % Randomly Change working shift
%             
%             xnew = GDChangeWorkingHours(x,model);
%             
%         case 5  % Randomly Select a job and then if it has more than two split then change the orther of NumberOfProductForEachSplit
%             
%             xnew.NumberOfProductForEachSplit = GEChangePercentageOfWorkForEachSplit(x,model);
%             
% %         case 6
% %             
% %             
% %         case 7
%             
%             
%             
%     end
% 
% end