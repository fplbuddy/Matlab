function Nu = CalculateNusselt(Data,G,Ra,Pr,N)
GS = ['AR_' num2str(G)];
RaS = RatoRaS(Ra);
PrS = PrtoPrS(Pr);
type = ['OneOne' num2str(N)];
PsiE = Data.(GS).(type).(PrS).(RaS).PsiE;
ThetaE = Data.(GS).(type).(PrS).(RaS).ThetaE;
[~,~,n,~] = GetRemKeep_nxny(N,N,1);
bigsum = 0;
two = 2;
for i=1:length(n)
    ninst = n(i);
    %if ninst == 0
    %    two = 1;
    %else
    %    two = 2;
    %end    
    bigsum = bigsum + 1i*two*PsiE(i)*ThetaE(i)*2*pi*ninst/(2*G);
end

Nu = 1 + bigsum;
end

