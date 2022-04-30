function Data = StartBranch(Data,Pr, AR,G, Ra)
RaS = RatoRaS(Ra);
PrS = PrtoPrS(Pr);
types_list = Gettypes_list(Data,PrS, AR);
type = types_list(end); % Get the largest N that we have
typec = convertStringsToChars(type);
N = str2double(typec(7:end));
thresh = -200;
RaS_list = string(fields(Data.(AR).(type).(PrS)));
RaS_list = OrderRaS_list(RaS_list);
%RaSMax = RaS_list(end); % Getting largest Ra we have
%RaSSecond = RaS_list(end-1); % Getting second largest Ra we have
%RaSThird = RaS_list(end-2); % Getting third largest Ra we have
I = find(RaS_list == RaS);
RaSMax = RaS; % We actually want the max one to be the same as where we start in branch
RaSSecond = RaS_list(I-1);
RaSThird = RaS_list(I-2);

sigmaoddMax = Data.(AR).(type).(PrS).(RaSMax).sigmaodd;
sigmaoddMax(real(sigmaoddMax)<thresh) = []; % Only keeping the eigs that are signigificnaly close to the imag axis
HowMany = length(sigmaoddMax); % Checking how many eigs we have;
sigmaoddSecond = Data.(AR).(type).(PrS).(RaSSecond).sigmaodd;
sigmaoddSecond = sort(sigmaoddSecond,'ComparisonMethod','real');
sigmaoddSecond = sigmaoddSecond(end-HowMany+1:end);
scaleDownImag = abs(thresh/max(imag(sigmaoddMax)))/2; % Scaling down the imaginary part
sigmaoddMax = real(sigmaoddMax) + 1i*imag(sigmaoddMax)*scaleDownImag;
sigmaoddSecond = real(sigmaoddSecond) + 1i*imag(sigmaoddSecond)*scaleDownImag;
% Going to search for pairs in increasingly large circles.
pairs = [];
for r=0.1:0.1:abs(thresh)
    HowMany = length(sigmaoddMax);
    if HowMany == 0
        break
    end
    remMax = [];
    remSecond = [];
    for i = 1:HowMany      
        soM = sigmaoddMax(i);
        diff = sigmaoddSecond - soM;
        diff = abs(diff);
        [m,I] = min(diff);
        if m < r % Then there exists an eig that is close enough
            remMax = [remMax i];
            remSecond = [remSecond I];
            ind = size(pairs,1);
            % Adding the data to pairs, with the correct imag part
            pairs(ind+1,2) = real(soM) + 1i*imag(soM)/scaleDownImag; 
            pairs(ind+1,1) = real(sigmaoddSecond(I)) + 1i*imag(sigmaoddSecond(I))/scaleDownImag;
        end
    end
% removing stuff we have taken
sigmaoddSecond(remSecond) = [];  
sigmaoddMax(remMax) = [];  
end
% Working out real dif in pairs
rem = [];
for i = 1:size(pairs,1)
    pairs(i,3) = real(pairs(i,2) - pairs(i,1));
    if pairs(i,3) < 0
        rem = [rem i];
    end
end
pairs(rem,:) = []; % remove ones that are going backwards
for i = 1:size(pairs,1)
    pairs(i,4) = abs(real(pairs(i,2))/pairs(i,3)); % Working out how much extra we need
end
[~,I] = min(pairs(:,4)); % Checking where we have the minumum
OWWMax = pairs(I,2)
stop
OWWSecond = pairs(I,1);
if imag(OWWMax) < 0 % Making sure complex bit it positive for convenction
    OWWMax = conj(OWWMax);  OWWSecond = conj(OWWSecond); 
end
% Saving data
Data.(AR).(type).(PrS).(RaSMax).sigmaoddbranch = OWWMax;
Data.(AR).(type).(PrS).(RaSSecond).sigmaoddbranch = OWWSecond;
Data.(AR).(type).(PrS).(RaSMax).TJ = RaStoRa(RaSMax)/RaStoRa(RaSSecond);
Data.(AR).(type).(PrS).(RaSMax).LJ = RaStoRa(RaSSecond)/RaStoRa(RaSThird);
% Solve linear system to get the eigenvector
PsiE = Data.(AR).(type).(PrS).(RaSMax).PsiE;
ThetaE = Data.(AR).(type).(PrS).(RaSMax).ThetaE;
M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, RaStoRa(RaSMax), Pr);
% try % see if we have a guess for xodd we can use
%     xodd = GetClosestPrWithSomething(Data,AR, type, PrS, 'xoddbranch', RaSMax);
%     % Get guess of eigenfunction
%     [xodd,~] = eigs(M,1,OWWMax+0.1+10*1i,'StartVector', xodd,'Tolerance',1e-10); % adding a little bit to OWWMax so that matrix is not singular
%     Data.(AR).(type).(PrS).(RaSMax).xoddbranch = xodd;
% catch % solve the wholse system if not
    [xodd,eigs] = eig(M);
    clear M
    eigs = diag(eigs);
    [~,I] = min(abs(eigs-OWWMax)); % Getting position of eig we want
    xodd = xodd(:,I); % Getting associated eigenvector
    Data.(AR).(type).(PrS).(RaSMax).xoddbranch = xodd;
end
