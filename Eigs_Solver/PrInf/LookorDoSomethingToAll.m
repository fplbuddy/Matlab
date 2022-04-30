AR_list = string(fields(PrInfData));
for i=1:length(AR_list)
   AR = AR_list(i);
   type_list =   string(fields(PrInfData.(AR)));
   for j=1:length(type_list)
      type =  type_list(j);
      RaS_list = string(fields(PrInfData.(AR).(type)));
      for k=1:length(RaS_list)
          RaS = RaS_list(k);
          try
          if PrInfData.(AR).(type).(RaS).dxmin > 1e-10
             AR
             type
             RaS
          end
          catch
          end
      end
       
   end 
end