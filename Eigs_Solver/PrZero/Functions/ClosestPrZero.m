function PrC = ClosestPrZero(Pr, PrString)
    Results = zeros(length(PrString), 1);
    for i=1:length(PrString)
        PrCheck = PrStoPrZero(PrString(i));
        Results(i) = abs(log10(Pr) - log10(PrCheck));
    end
    [~,I] = min(Results);
    PrC = PrString(I);
end