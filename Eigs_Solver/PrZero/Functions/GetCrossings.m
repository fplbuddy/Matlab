function RaA_list = GetCrossings(M)
% M is the full one
sigs = M(2,:);
signs = sign(sigs);
di = diff(signs); % tells us location of crissings
RaA_list = [];
for i = 1:length(di)
   d = di(i);
   if d ~= 0 
      Mtrun = M(1:2,i:i+1);
      RaANew = GetNextRaANonLinear(Mtrun);
      RaA_list = [RaA_list RaANew];   
   end

end

end

