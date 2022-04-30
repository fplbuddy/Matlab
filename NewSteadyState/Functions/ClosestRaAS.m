function RaAC = ClosestRaAS(RaA, RaAString_list)
    Results = zeros(length(RaAString_list), 1);
    for i=1:length(RaAString_list)
        RaACheck = RaAStoRaA(RaAString_list(i));
        Results(i) = abs(RaA - RaACheck);
    end
    [~,I] = min(Results);
    RaAC = RaAString_list(I);
end