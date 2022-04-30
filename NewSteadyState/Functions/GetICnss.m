function [PsiE, ThetaE] = GetICnss(RaA, Pr, Data, type,G,varargin)
[GCS,GCS2,GCS3] = ClosestG(G, Data); % 2 us up, 3 is down
if isempty(varargin)
    PrS = PrtoPrS(Pr);
    %first try same Ra and Pr in on off in G
    try
        %error % DONT WANT TO DO THIS AT THE MOMENT
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
            catch % Goes down in type
                try
                    types = string(fieldnames(Data.(GCS)));
                    [typeC,los] = Closesttypenss(type, types); % Getting closest type
                    PrString = string(fieldnames(Data.(GCS).(typeC)));
                    PrC = ClosestPr(Pr, PrString);
                    RaAString = string(fieldnames(Data.(GCS).(typeC).(PrC)));
                    RaAC = ClosestRaAS(RaA, RaAString);
                    PsiE = Data.(GCS).(typeC).(PrC).(RaAC).PsiE;
                    ThetaE = Data.(GCS).(typeC).(PrC).(RaAC).ThetaE;
                    [Nxnew,Nynew] = typetoNxNy(type);
                    [Nxold,~] = typetoNxNy(typeC);
                    if los == 's'
                        % Need to extend as we do note have the same type
                        [PsiE, ThetaE] = ExpandSteadyStatenss(PsiE,ThetaE,Nxold, Nxnew);
                    else
                        [~,~,n,m,~] = GetRemKeepnss(Nxold);
                        rem = [];
                        for i=1:length(n)
                            ninst = n(i); minst = m(i);
                            if ninst^2/Nxnew^2 + minst^2/(4*Nynew^2) > 1/9
                                rem = [rem i];
                            end
                        end
                        PsiE(rem) = [];
                        ThetaE(rem) = [];
                    end
                catch
                    hej = 'Error with IC'
                end
            end
        end
    end
    
    
    clearvars -except PsiE ThetaE
else
    if varargin{1} == "32" % use 32
        typeC = "N_32x32";
        los = 's';
        PrString = string(fieldnames(Data.(GCS2).(typeC)));
        PrC = ClosestPr(Pr, PrString);
        RaAString = string(fieldnames(Data.(GCS2).(typeC).(PrC)));
        RaAC = ClosestRaAS(RaA, RaAString);
        PsiE = Data.(GCS2).(typeC).(PrC).(RaAC).PsiE;
        ThetaE = Data.(GCS2).(typeC).(PrC).(RaAC).ThetaE;
        [Nxnew,Nynew] = typetoNxNy(type);
        [Nxold,~] = typetoNxNy(typeC);
        if los == 's'
            % Need to extend as we do note have the same type
            [PsiE, ThetaE] = ExpandSteadyStatenss(PsiE,ThetaE,Nxold, Nxnew);
        else
            [~,~,n,m,~] = GetRemKeepnss(Nxold);
            rem = [];
            for i=1:length(n)
                ninst = n(i); minst = m(i);
                if ninst^2/Nxnew^2 + minst^2/(4*Nynew^2) > 1/9
                    rem = [rem i];
                end
            end
            PsiE(rem) = [];
            ThetaE(rem) = [];
        end
        
        
    end
end
end
