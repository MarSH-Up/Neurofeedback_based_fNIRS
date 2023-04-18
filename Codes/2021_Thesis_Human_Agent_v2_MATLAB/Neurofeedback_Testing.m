
Cycles = 5;
Perido_Time = 30;
Pcycles = ones(Cycles);
Last = 0;
for Time = 1:(Perido_Time*Cycles)  
    temp = 0;

    for i = 1:Cycles
        Pcycles(i) = i;
        Pcycles(i) = i*Perido_Time;
        %We should fine a random criteria to change the setpoint, not just
        %time, or the moment B changes. For now works to demostrate the
        %control without fNIRS
         if (Time == Pcycles(i)) && (Time < (Pcycles(i)+1))

            disp("Time")
            disp(Time)
            
            temp = r;
            disp("Setpoint")
            disp(temp)

        else 
            temp = Last;
        end 
        
    end
    min = 0;
    max = 8;
    r = min + rand(1)*(max-min);
    
    Setpoint = temp;
    Last = Setpoint;
end 
