% Check if the steady state is ever more unstable to even partubations
%load('/Volumes/Samsung_T5/Olddata/masternew.mat')
AR = 'AR_2';

% Looping round types
types = string(fields(Data.(AR)));
for type=reshape(types,1,length(types))
   % Looping round Pr
   PrS_list = string(fields(Data.(AR).(type)));
   for PrS = reshape(PrS_list,1,length(PrS_list))
      % Looping round Ra
      RaS_list = string(fields(Data.(AR).(type).(PrS)));
      for RaS = reshape(RaS_list,1,length(RaS_list))
          try
          oddmax = max(real((Data.(AR).(type).(PrS).(RaS).sigmaodd)));
          evenmax = max(real((Data.(AR).(type).(PrS).(RaS).sigmaeven)));
          catch
              type
              PrS
              RaS
              stop
          end
          if oddmax < evenmax && evenmax > 0.01
              type
              PrS
              RaS
          end         
      end
       
   end
    
end
