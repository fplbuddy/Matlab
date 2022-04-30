function M = hofp(Data, PrS, AR,type)
    M = [];
    RaS_list = string(fields(Data.(AR).(type).(PrS)));
    RaS_list = OrderRaS_list(RaS_list);
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        ind = width(M);
        Ra = RaStoRa(RaS);
        sigmaodd = Data.(AR).(type).(PrS).(RaS).sigmaodd;
        [~,I] = max(real(sigmaodd));
        sig = abs(imag(sigmaodd(I)));
        M(1,ind+1) = Ra; M(2,ind+1) = sig;
    end
    % order so that Ra is increasing
    Ra = M(1,:);
    sigs = M(2,:);
    [Ra, I] = sort(Ra);
    M = [Ra; sigs(I)]; 
end

