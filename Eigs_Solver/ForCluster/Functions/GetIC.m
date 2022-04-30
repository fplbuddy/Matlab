function [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type,Search)
% Search is a string which decided how we want to search. Can be
% 1. CRa, cloests Ra in same Pr
% 2. CPr, cloests Pr in same Ra
% 3. Type, goes down in type, but with same Pr and Ra
% 4. Random, does the whole thing like before
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
if Search == "CRa"
    RaString = string(fieldnames(Data.(AR).(type).(PrS)));
    RaC = ClosestRa(Ra, RaString);
    PsiE = Data.(AR).(type).(PrS).(RaC).PsiE;
    ThetaE = Data.(AR).(type).(PrS).(RaC).ThetaE;
end
if Search == "CPr"
    PrString = string(fieldnames(Data.(AR).(type)));
    PrC = ClosestPr(Pr, PrString)
    RaString = string(fieldnames(Data.(AR).(type).(PrC)));
    RaC = ClosestRa(Ra, RaString);
    PsiE = Data.(AR).(type).(PrC).(RaC).PsiE;
    ThetaE = Data.(AR).(type).(PrC).(RaC).ThetaE;
end
if Search == "Type"
    types = TypesinPrandRa(Data,PrS,AR,RaS);
    typeC = Closesttype(type, types); % Getting closest type
    PsiE = Data.(AR).(typeC).(PrS).(RaS).PsiE;
    ThetaE = Data.(AR).(typeC).(PrS).(RaS).ThetaE;
    % Need to extend as we do note have the same type
    Nnew = convertStringsToChars(type); Nnew = Nnew(7:end); Nnew = str2num(Nnew);
    Nold = convertStringsToChars(typeC); Nold = Nold(7:end); Nold = str2num(Nold);
    [PsiE, ThetaE] = ExpandSteadyState2(PsiE,ThetaE,Nold, Nnew);
end
if Search == "Random"
    try % Tries closest Ra in same Pr
        RaString = string(fieldnames(Data.(AR).(type).(PrS)));
        RaC = ClosestRa(Ra, RaString);
        PsiE = Data.(AR).(type).(PrS).(RaC).PsiE;
        ThetaE = Data.(AR).(type).(PrS).(RaC).ThetaE;
    catch
        try % Tries closest Ra in closest Pr
            PrString = string(fieldnames(Data.(AR).(type)));
            PrC = ClosestPr(Pr, PrString)
            RaString = string(fieldnames(Data.(AR).(type).(PrC)));
            RaC = ClosestRa(Ra, RaString);
            PsiE = Data.(AR).(type).(PrC).(RaC).PsiE;
            ThetaE = Data.(AR).(type).(PrC).(RaC).ThetaE;
        catch % Goes down in type or if not AR
            try
                types = string(fieldnames(Data.(AR)));
                typeC = Closesttype(type, types); % Getting closest type
                PrString = string(fieldnames(Data.(AR).(typeC)));
                PrC = ClosestPr(Pr, PrString);
                RaString = string(fieldnames(Data.(AR).(typeC).(PrC)));
                RaC = ClosestRa(Ra, RaString);
                PsiE = Data.(AR).(typeC).(PrC).(RaC).PsiE;
                ThetaE = Data.(AR).(typeC).(PrC).(RaC).ThetaE;
                % Need to extend as we do note have the same type
                Nnew = convertStringsToChars(type); Nnew = Nnew(7:end); Nnew = str2num(Nnew);
                Nold = convertStringsToChars(typeC); Nold = Nold(7:end); Nold = str2num(Nold);
                [PsiE, ThetaE] = ExpandSteadyState2(PsiE,ThetaE,Nold, Nnew);
            catch % Just goes to AR2 as defult... will not get to this often!
                PsiE = Data.AR_2.(type).(PrC).(RaC).PsiE;
                ThetaE = Data.AR_2.(type).(PrC).(RaC).ThetaE;
            end
        end
    end
end
% fix length, note that this only works for when Nx = Ny = N and when
N = type(7:end); N = str2num(N);
if length(PsiE) == N^2/4
    [Rem,~,~,~] = GetRemKeep_nxny(N,N,1);
    PsiE(Rem) = [];
    ThetaE(Rem) = [];
end
clearvars -except PsiE ThetaE
end
