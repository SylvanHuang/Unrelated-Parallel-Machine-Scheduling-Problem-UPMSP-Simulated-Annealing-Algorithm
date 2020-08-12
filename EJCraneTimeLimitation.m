function Possibility = EJCraneTimeLimitation (CraneTimeLimitation, CraneTime)

    %% 
    % Possibility: 1 means possible, 0 means not possible 
    % CraneTimeLimitation: model.Crane.TimeLimit 
    % CraneTime: Possible Crane Time 
    
    Possibility = 0; 
    
    TimeLimitation = [(CraneTimeLimitation(1,1) + 1) : 24, ... 
                       0 : (CraneTimeLimitation(1,2) - 1)]; 
    
    [~,hour,~,~]=ECGetTime(CraneTime); 
    
    if sum( hour == TimeLimitation ) ~= 1 
        Possibility = 1; 
    end 

end