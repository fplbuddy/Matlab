function PrC = ClosestPr(Pr, PrString)
    Results = zeros(length(PrString), 1);
    for i=1:length(PrString)
        PrCheck = PrStoPr(PrString(i));
        Results(i) = abs(Pr - PrCheck);
    end
    [~,I] = min(Results);
    PrC = PrString(I);
end