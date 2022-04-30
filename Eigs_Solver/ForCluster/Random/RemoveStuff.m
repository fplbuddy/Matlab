PrS_list = ["Pr_8"];
RaS_list = ["Ra_1_41e6" "Ra_2e6" "Ra_2_86e6" "Ra_4e6"];
fn_list = ["LJ" "TJ" "Deltaeven" "Deltaodd" "sigmaevenbranch" "sigmaoddbranch" "xevenbranch" "xoddbranch"];
for i =1:length(PrS_list)
    PrS = PrS_list(i);
    for i=1:length(RaS_list)
        RaS = RaS_list(i);
        for i=1:length(fn_list)
            fn = fn_list(i);
            try
            Data.AR_2.OneOne172.(PrS).(RaS) = rmfield(Data.AR_2.OneOne172.(PrS).(RaS), fn);  
            catch
            end
        end
    end
end