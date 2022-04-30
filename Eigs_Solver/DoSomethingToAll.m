types = string(fields(Data.AR_2));
for i=1:length(types)
    type = types(i);
    Pr_list = string(fields(Data.AR_2.(type)));
    for j=1:length(Pr_list)
        PrS = Pr_list(j);
        Ra_list = string(fields(Data.AR_2.(type).(PrS)));
        for k=1:length(Ra_list)
           RaS = Ra_list(k);
           if isfield(Data.AR_2.(type).(PrS).(RaS),"sigmaodd")
            sigs = Data.AR_2.(type).(PrS).(RaS).sigmaodd;
            sigsr = real(sigs);
            sigs(sigsr<-200) = [];
            Data.AR_2.(type).(PrS).(RaS).sigmaodd = sigs;
           end
           if isfield(Data.AR_2.(type).(PrS).(RaS),"sigmaeven")
            sigs = Data.AR_2.(type).(PrS).(RaS).sigmaeven;
            sigsr = real(sigs);
            sigs(sigsr<-200) = [];
            Data.AR_2.(type).(PrS).(RaS).sigmaeven = sigs;
           end
           
           
           
            
        end
        
    end
end