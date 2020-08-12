function Possibility = ELCraneFeasibility(CellularCraneMatrix, CraneNumber, time, SetupTime)

    CraneMat = sort( CellularCraneMatrix{CraneNumber} );
    
    T1 = time; 
    T2 = time + SetupTime; 
    
    for row=1:size(CraneMat, 1)
        
        if size(CraneMat, 1) == 1 || row == 1 || row == size(CraneMat, 1)
            
            if T2 <= CraneMat(row, 1) && row == 1
                
                Possibility = 1;
                return;
                
            elseif T1 >= CraneMat(row, 2) && row == size(CraneMat, 1)
                
                Possibility = 1;
                return;
                
            end
            
        end
        
        if size(CraneMat,1) > 1 && row < size(CraneMat,1)
            
            if T1 >= CraneMat(row, 2) && T2 <= CraneMat(row + 1, 1)
                
                Possibility = 1;
                return;
                
            end
            
        end
        
    end
    
    Possibility = 0;

end