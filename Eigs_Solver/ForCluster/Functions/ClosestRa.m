function RaC = ClosestRa(Ra, RaString)
    RaString(RaString=="cross") = [];
    RaString(RaString=="secondcross") = [];
    RaString(RaString=="AdditionalData") = [];
    Results = zeros(length(RaString), 1);
    for i=1:length(RaString)
        RaCheck = RaStoRa(RaString(i));
        Results(i) = abs(Ra - RaCheck);
    end
    [~,I] = min(Results);
    RaC = RaString(I);
end