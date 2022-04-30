function [PsiE, ThetaE] = GetICnss_nxny(RaA, Pr, Data, type,G,lowPrScaling,varargin)
[GCS,GCS2,GCS3] = ClosestG(G, Data); % 2 us up, 3 is down
if isempty(varargin)
    PrS = PrtoPrS(Pr);
    %first try same Ra and Pr in on off in G
    try
        error % DONT WANT TO DO THIS AT THE MOMENT
        PrS = PrtoPrS(Pr);
        RaAS = RaAtoRaAS(RaA);
        PsiE = Data.(GCS3).(type).(PrS).(RaAS).PsiE;
        ThetaE = Data.(GCS3).(type).(PrS).(RaAS).ThetaE;
        scalingcheck = Data.(GCS3).(type).(PrS).(RaAS).lowPrScaling;
    catch
        try % Tries closest Ra in same Pr
            RaAString = string(fieldnames(Data.(GCS).(type).(PrS)));
            RaAC = ClosestRaAS(RaA, RaAString);
            PsiE = Data.(GCS).(type).(PrS).(RaAC).PsiE;
            ThetaE = Data.(GCS).(type).(PrS).(RaAC).ThetaE;
            scalingcheck = Data.(GCS).(type).(PrS).(RaAC).lowPrScaling;
        catch
            try % Tries closest Ra in closest Pr
                PrString = string(fieldnames(Data.(GCS).(type)));
                PrC = ClosestPr(Pr, PrString);
                RaAString = string(fieldnames(Data.(GCS).(type).(PrC)));
                RaAC = ClosestRaAS(RaA, RaAString);
                PsiE = Data.(GCS).(type).(PrC).(RaAC).PsiE;
                ThetaE = Data.(GCS).(type).(PrC).(RaAC).ThetaE;
                scalingcheck = Data.(GCS).(type).(PrC).(RaAC).lowPrScaling;
                'Tries closest Ra in closest Pr'
            catch % Goes down in type
                try
                    types = string(fieldnames(Data.(GCS)));
                    [typeC,~] = Closesttypenss(type, types); % Getting closest type
                    PrString = string(fieldnames(Data.(GCS).(typeC)));
                    PrC = ClosestPr(Pr, PrString);
                    RaAString = string(fieldnames(Data.(GCS).(typeC).(PrC)));
                    RaAC = ClosestRaAS(RaA, RaAString);
                    PsiEold = Data.(GCS).(typeC).(PrC).(RaAC).PsiE;
                    ThetaEold = Data.(GCS).(typeC).(PrC).(RaAC).ThetaE;
                    scalingcheck = Data.(GCS).(typeC).(PrC).(RaAC).lowPrScaling;
                    [Nxnew,Nynew] = typetoNxNy(type);
                    [Nxold,Nyold] = typetoNxNy(typeC);
                    [~,~,nnew,mnew,~] = GetRemKeepnss_nxny(Nxnew,Nynew);
                    [~,~,nold,mold,~] = GetRemKeepnss_nxny(Nxold,Nyold);
                    PsiE = zeros(length(nnew),1);
                    ThetaE = zeros(length(nnew),1);
                    for i=1:length(nold) % looping round the old stuff
                        PsiInst =  PsiEold(i); ThetaInst =  ThetaEold(i);
                        ninst = nold(i); minst = mold(i);
                        for j=1:length(nnew) % not see if exists in new
                            ncheck = nnew(j); mcheck = mnew(j);
                            if ncheck == ninst && mcheck == minst
                                PsiE(j) = PsiInst;
                                ThetaE(j) = ThetaInst;
                                break
                            end
                        end
                    end
                catch
                    hej = 'Error with IC'
                end
            end
        end
    end
    
    
else
    if varargin{1} == "32" % use 32
        typeC = "N_32x32";
        PrString = string(fieldnames(Data.(GCS2).(typeC)));
        PrC = ClosestPr(Pr, PrString);
        RaAString = string(fieldnames(Data.(GCS2).(typeC).(PrC)));
        RaAC = ClosestRaAS(RaA, RaAString);
        PsiEold = Data.(GCS2).(typeC).(PrC).(RaAC).PsiE;
        ThetaEold = Data.(GCS2).(typeC).(PrC).(RaAC).ThetaE;
        scalingcheck = Data.(GCS2).(typeC).(PrC).(RaAC).lowPrScaling;
        [Nxnew,Nynew] = typetoNxNy(type);
        [Nxold,Nyold] = typetoNxNy(typeC);
        [~,~,nnew,mnew,~] = GetRemKeepnss_nxny(Nxnew,Nynew);
        [~,~,nold,mold,~] = GetRemKeepnss_nxny(Nxold,Nyold);
        PsiE = zeros(length(nnew),1);
        ThetaE = zeros(length(nnew),1);
        for i=1:length(nold) % looping round the old stuff
            PsiInst =  PsiEold(i); ThetaInst =  ThetaEold(i);
            ninst = nold(i); minst = mold(i);
            for j=1:length(nnew) % not see if exists in new
                ncheck = nnew(j); mcheck = mnew(j);
                if ncheck == ninst && mcheck == minst
                    PsiE(j) = PsiInst;
                    ThetaE(j) = ThetaInst;
                    break
                end
            end
        end
    end
end
% fix the scaling
PsiE = PsiE*Pr^(scalingcheck-lowPrScaling);
ThetaE = ThetaE*Pr^(scalingcheck-lowPrScaling);


end
