% Input
%mm = 3000; Need somethinh which is indep of rate of output
SS = 0.65;
tt = 450;

if PrS == "Pr_30" && (RaS == "Ra_2e6" || RaS == "Ra_1_3e6")
   SS = 0.67;
   tt = 500;
end

% Getting data
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
signal = kpsmodes1(:,2);
t1 = kenergy(:,1);
t2 = kpsmodes1(:,1);
E = kenergy(:,2);
Ex = kenergy(:,6);
Ey = kenergy(:,5);
mm = mean(diff(t2));
mm = tt/mm;

% Removing ICS and making sure all same length
if length(t1) < length(t2)
    xupper = length(t1);
    t = t1;
    clear t2 t1
    t = t(xlower:xupper);
    Ex = Ex(xlower:xupper);
    Ey = Ey(xlower:xupper);
    E = E(xlower:xupper);
    signal = signal(xlower:xupper);
else
    xupper = length(t2);
    t = t2;
    clear t2 t1
    t = t(xlower:xupper);
    Ex = Ex(xlower:xupper);
    Ey = Ey(xlower:xupper);
    E = E(xlower:xupper);
    signal = signal(xlower:xupper);
end
ExE = Ex./E;
signal = movmean(signal,mm);
% Moving average
MovingAv = movmean(ExE,mm); 

% Add sign
MovingAv = MovingAv.*sign(signal);

% Finding where we are positive, negative or zero
pos = find(MovingAv > SS);
neg = find(MovingAv < -SS);
zero = find(MovingAv <= SS & MovingAv >= -SS);
dt = diff(t);
dt = [dt
    dt(end)]; % Add one last one to make it the same dimensions

% Reshaping
pos = reshape(pos, 1, length(pos));
neg = reshape(neg, 1, length(neg));
zero = reshape(zero, 1, length(zero));

% urms
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);

% Putting it into AllData
AllData.(ARS).(PrS).(RaS).calcs.pos = mat2cell( pos, 1,diff( [0, find(diff(pos) ~= 1), length(pos)] ) );
AllData.(ARS).(PrS).(RaS).calcs.neg = mat2cell( neg, 1,diff( [0, find(diff(neg) ~= 1), length(neg)] ) );
AllData.(ARS).(PrS).(RaS).calcs.zero = mat2cell( zero, 1,diff( [0, find(diff(zero) ~= 1), length(zero)] ) );
AllData.(ARS).(PrS).(RaS).urms = urms;
AllData.(ARS).(PrS).(RaS).maxval = max(abs(signal));
%TIP = size(AllData.(ARS).(PrS).(RaS).calcs.pos);
%TIN = size(AllData.(ARS).(PrS).(RaS).calcs.neg);
%TIZ = size(AllData.(ARS).(PrS).(RaS).calcs.zero);
%AllData.(ARS).(PrS).(RaS).calcs.posT = sum(dt(pos));
%AllData.(ARS).(PrS).(RaS).calcs.negT = sum(dt(neg));
%AllData.(ARS).(PrS).(RaS).calcs.zeroT = sum(dt(zero));
%AllData.(ARS).(PrS).(RaS).calcs.TIP = min([TIP(2) length(pos)]);
%AllData.(ARS).(PrS).(RaS).calcs.TIN = min([TIN(2) length(neg)]);
%AllData.(ARS).(PrS).(RaS).calcs.TIZ = min([TIZ(2) length(zero)]);
AllData.(ARS).(PrS).(RaS).calcs.pmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.pos);
AllData.(ARS).(PrS).(RaS).calcs.nmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.neg);
AllData.(ARS).(PrS).(RaS).calcs.zmean = MyMean(signal, t,AllData.(ARS).(PrS).(RaS).calcs.zero);
AllData.(ARS).(PrS).(RaS).calcs.psd = std(signal(pos));
AllData.(ARS).(PrS).(RaS).calcs.nsd = std(signal(neg));
AllData.(ARS).(PrS).(RaS).calcs.zsd = std(signal(zero));
% AllData.(ARS).(PrS).(RaS).calcs.pExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.pos);
% AllData.(ARS).(PrS).(RaS).calcs.nExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.neg);
AllData.(ARS).(PrS).(RaS).calcs.zExEmean = MyMean(ExE, t, AllData.(ARS).(PrS).(RaS).calcs.zero);
AllData.(ARS).(PrS).(RaS).calcs.sExEmean = MyMean(ExE, t, [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg]);
% AllData.(ARS).(PrS).(RaS).calcs.zExmean = MyMean(Ex, t, AllData.(ARS).(PrS).(RaS).calcs.zero);
% AllData.(ARS).(PrS).(RaS).calcs.sExmean = MyMean(Ex, t, [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg]);
% AllData.(ARS).(PrS).(RaS).calcs.zEymean = MyMean(E-Ex, t, AllData.(ARS).(PrS).(RaS).calcs.zero);
% AllData.(ARS).(PrS).(RaS).calcs.sEymean = MyMean(E-Ex, t, [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg]);

%%
% kappa = AllData.(ARS).(PrS).(RaS).kappa;
% tnu = kenergy(:,1);
% Ik = kenergy(:,4);
% % Need to calculate how long each time step is
% StepLength = zeros(1, length(tnu)-1);
% New = tnu(1); % To initiate loop
% for i=1:length(StepLength)
%     Old = New;
%     New = tnu(i+1);
%     StepLength(i) = New - Old;
% end
% 
% StepLength = StepLength(xlower:end);
% tnu = tnu(xlower:end);
% Ik = Ik(xlower:end);
% % Calculate Nu at each stage
% Nut = zeros(1, length(StepLength));
% for i= 1:length(Nut)
%     Nut(i) = 1 + pi*2*Ik(i)/kappa; % We neeed to multipy with the dimensional stuff here
% end
% % Calculate average
% Nu = 0;
% for i=1:length(Nut)
%     Nu = Nut(i)*StepLength(i) + Nu;
% end
% Nu = (Nu/(tnu(end)-tnu(1)));
% AllData.(ARS).(PrS).(RaS).calcs.Nu = Nu;


%% Calculation means where we make sure mean is 0 for reversals
signal = kpsmodes1(:,2); signal = signal(xlower:end);
t = kpsmodes1(:,1); t = t(xlower:end);
if not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1) && not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1)
    SectionKeeper = [];
    
    HMS = length([AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg AllData.(ARS).(PrS).(RaS).calcs.zero]);
    if sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1; HMS = HMS -1; end % Delete one if we dont have one in 0
    
    data = zeros(HMS, 5); % First columns is how long the section is and second is the type. Needs to be in order
    % Build data
    SearchValue = 1;
    remove = []; % used for zeros
    for i=1:HMS
        got = 0;
        for j=1:length(AllData.(ARS).(PrS).(RaS).calcs.pos) % Checking if pos
            Check = AllData.(ARS).(PrS).(RaS).calcs.pos{j};
            if Check(1) == SearchValue
                data(i,1) = length(Check);
                data(i,2) = 1;
                data(i,3) = i;
                SearchValue = Check(end) + 1;
                got = 1;
                SectionKeeper = [SectionKeeper AllData.(ARS).(PrS).(RaS).calcs.pos(j)];
            end
        end
        if not(got)
            for j=1:length(AllData.(ARS).(PrS).(RaS).calcs.neg) % Checking if neg
                Check = AllData.(ARS).(PrS).(RaS).calcs.neg{j};
                if Check(1) == SearchValue
                    data(i,1) = length(Check);
                    data(i,2) = -1;
                    data(i,3) = i;
                    SearchValue = Check(end) + 1;
                    got = 1;
                    SectionKeeper = [SectionKeeper AllData.(ARS).(PrS).(RaS).calcs.neg(j)];
                end
            end
        end
        if not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1) && not(got)
            for j=1:length(AllData.(ARS).(PrS).(RaS).calcs.zero) % Checking if zero
                Check = AllData.(ARS).(PrS).(RaS).calcs.zero{j};
                if Check(1) == SearchValue
                    remove = [i remove];
                    SearchValue = Check(end) + 1;
                    SectionKeeper = [SectionKeeper AllData.(ARS).(PrS).(RaS).calcs.zero(j)];
                end
            end
        end
    end
    
    % remove zeros
    for i=1:length(remove)
        loc = remove(i);
        data(loc,:) = [];
    end
    
    % Add the length stuff in column 4
    sd = size(data);
    sd = sd(1);
    for i=1:sd
        data(i,4) = data(i,1);
        KG = 1;
        % go up
        if not(i == 1)
            for j=1:(i-1)
                if data(i - j, 2) == data(i, 2) && KG
                    data(i,4) = data(i,4) + data(i - j, 1);
                else
                    KG = 0;
                end
            end
        end
        KG = 1;
        % go down
        if not(i == sd)
            for j=1:(sd - i)
                if data(i + j, 2) == data(i, 2) && KG
                    data(i,4) = data(i,4) + data(i + j, 1);
                else
                    KG = 0;
                end
            end
        end
    end
    % Locate which shift we want
    for i=1:sd
        if i < sd
            if not(data(i, 2) == data(i+1, 2)); data(i, 5) = min([data(i, 4) data(i+1, 4)]); end
        end
    end
    % Finding location where biggest region is
    [Tc, Ind] = max(data(:,5));
    
    % Getting the left sections we want
    LeftSections = [data(Ind,3)];
    KG = 1;
    if not(Ind == 1)
        for j=1:(Ind-1)
            if data(Ind - j, 2) == data(Ind, 2) && KG
                LeftSections = [data(Ind - j, 3) LeftSections];
            else
                KG = 0;
            end
        end
    end
    
    % Getting the rigiht sections we want
    RightSections = [data(Ind+1,3)];
    KG = 1;
    if not(Ind+1 == sd)
        for j=1:(sd - Ind -1)
            if data(Ind+1 + j, 2) == data(Ind+1, 2) && KG
                RightSections = [RightSections data(Ind+1 + j, 3)];
            else
                KG = 0;
            end
        end
    end
    
    
    % Checking if we want to cut right
    CR = 0;
    if data(Ind+1, 4) > data(Ind, 4); CR = 1; end
    
    if CR
        RightCut = [];
        LastBit = 0;
        Left = Tc;
        for i=1:length(RightSections)
            Section = RightSections(i);
            if Left > 0
                if Left < length(SectionKeeper{Section})
                    LastBit = Left;
                end
                Left = Left - length(SectionKeeper{Section});
                RightCut = [RightCut Section];
            end
        end
        RightSections =  RightCut;
    else
        LeftCut = [];
        LastBit = 0;
        Left = Tc;
        for i=length(LeftSections):-1:1
            Section = LeftSections(i);
            if Left > 0
                if Left < length(SectionKeeper{Section})
                    LastBit = Left;
                end
                Left = Left - length(SectionKeeper{Section});
                LeftCut = [Section LeftCut];
            end
        end
        LeftSections =  LeftCut;
    end
    
    % Getting the zero sections
    ZeroSections = [];
    for i=min(LeftSections):max(RightSections)
        if not(ismember(i, LeftSections)) && not(ismember(i, RightSections))
            ZeroSections = [i ZeroSections];
        end
    end
    
    AllPointsWeWant = [];
    % Getting the zero points
    for i=1:length(ZeroSections)
        Section = ZeroSections(i);
        AllPointsWeWant = [AllPointsWeWant SectionKeeper{Section}];
    end
    
    if CR
        for i=1:length(LeftSections)
            Section = LeftSections(i);
            AllPointsWeWant = [AllPointsWeWant SectionKeeper{Section}];
        end
        for i=1:length(RightSections)-1
            Section = RightSections(i);
            AllPointsWeWant = [AllPointsWeWant SectionKeeper{Section}];
        end
        % last one
        Section =  RightSections(end);
        add =  SectionKeeper{Section};
        AllPointsWeWant = [AllPointsWeWant add(1:LastBit)];
        
    else
        for i=1:length(RightSections)
            Section = RightSections(i);
            AllPointsWeWant = [AllPointsWeWant SectionKeeper{Section}];
        end
        for i=length(LeftSections):-1:2
            Section = LeftSections(i);
            AllPointsWeWant = [AllPointsWeWant SectionKeeper{Section}];
        end
        % last one
        Section =  LeftSections(1);
        add =  SectionKeeper{Section};
        AllPointsWeWant = [AllPointsWeWant add((length(add)-LastBit):end)];
    end
    
    AllPointsWeWant = sort(AllPointsWeWant);
    
    signal = signal(AllPointsWeWant); t =  t(AllPointsWeWant);
    AllData.(ARS).(PrS).(RaS).calcs.PWW = AllPointsWeWant;
end

AllData.(ARS).(PrS).(RaS).calcs.mean = MyMeanEasy(signal,t);
AllData.(ARS).(PrS).(RaS).calcs.sd = std(signal);

