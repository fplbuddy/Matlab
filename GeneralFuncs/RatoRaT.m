function RaT = RatoRaT(Ra)
    if Ra == Inf % dealing with inf case
        RaT = '\infty';
    else
    power = floor(log10(Ra));
    Start = num2str(Ra/10^power);
    if power  == 0
        RaT = Start;
    elseif power  == 1
        RaT = [Start '\times' '10'];
    else  
        
        RaT = [Start '\times' '10^{' num2str(power) '}'];
    end
    end
try
% remove if 1 \times at start 
check = convertCharsToStrings(RaT(1:7));
if check == "1\times"
   RaT =  RaT(8:end);
end
catch
end
end