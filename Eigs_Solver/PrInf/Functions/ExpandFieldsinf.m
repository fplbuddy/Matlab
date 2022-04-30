function ThetaEexp = ExpandFieldsinf(Rem,ThetaE)
ThetaEexp = ThetaE;
for i=1:length(Rem)
   add = Rem(i);
   ThetaEexp = [ThetaEexp(1:add-1); 0; ThetaEexp(add:end)]; 
end
end



