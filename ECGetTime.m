function [TDay Thour TMinute TMinute2]=ECGetTime(PureTime)

    [q1,~]=deconv(PureTime,24);
    TDay=floor(q1) + 1;
    
%     TDay=mod(PureTime,24);
    
    [q2,~]=deconv(PureTime-24*(TDay-1),1);
    Thour=floor(q2);
    
    TMinute=PureTime - (24*(TDay-1)) - Thour;
    
    TMinute2=TMinute*60;

end
