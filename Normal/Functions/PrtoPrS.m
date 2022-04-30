function PrS = PrtoPrS(Pr)
PrS = ['Pr_' num2str(floor(Pr))];

n=0;
while (floor(Pr*10^n)~=Pr*10^n)
    n=n+1;
end

if n > 0
   dec = num2str(Pr-floor(Pr), n);
   dec = dec(3:end);
   PrS = [PrS '_' dec];
end

      
end

