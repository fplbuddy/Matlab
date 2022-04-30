%% set up
clearvars -except AllData
Steps = 3;
n = 1000;
modelist = BuildModeList(n);
modelist = AddToModelise(8,15,modelist);
modelist = AddToModelise(-8,15,modelist);
%modelist = AddToModelise(0,1,modelist);
%% loop
for i=1:Steps
    gotlist = GetGotList(modelist);
    emptyarray = BuildArray(gotlist);
    [modelist, FilledArray] = Step(emptyarray, modelist);
end


%% Functions
function pos = posfind(x,y,n)
    pos = (y-1)*(1+2*n) + abs(x) + 1;
    if sign(x) == -1
        pos = pos + n;
    end
    pos = round(pos); % To make sure it is an integer
end

function [x,y] = findmode(pos,n)
    y = ceil(pos/(2*n+1));
    rem = pos - (y-1)*(2*n+1);
    if rem <= n + 1
        x = rem-1;
    else 
        x = -(rem - n -1);
    end
end

function [x1, y1, x2, y2] = modeadd(a,b,c,d)
    x1 = a + c;
    x2 = x1;
    y1 = b + d;
    y2 = abs(b - d);
end

function modelist = BuildModeList(n)
    modelist = strings(2,(2*n+1)*n);
    for y = 1:n
        i = (y-1)*(1+2*n) + 1;
        modelist(1,i) = convertCharsToStrings(['(0,' num2str(y) ')']);
        for x = 1:n
            j = i + x;
            k = i + x + n;
            modelist(1,j) = convertCharsToStrings(['(' num2str(x) ',' num2str(y) ')']);
            modelist(1,k) = convertCharsToStrings(['(-' num2str(x) ',' num2str(y) ')']);
        end
    end
end

function modelist = AddToModelise(x,y,oldmodelist)
    modelist = oldmodelist;
    length = size(oldmodelist);
    length = length(2);
    n = roots([2 1 -length]);
    n = max(n);
    pos = posfind(x,y,n);
    if not(oldmodelist(2,pos) == "x")
        modelist(2,pos) = "x";
    end
end

function [x,y] = StrToMode(TheString)
    TheChar = convertStringsToChars(TheString);
    Comma = strfind(TheChar, ',');
    x = str2num(TheChar(2:(Comma-1)));
    y = str2num(TheChar((Comma+1):(length(TheChar)-1)));
end

function gotlist = GetGotList(modelist)
    length = size(modelist);
    length = length(2);
    gotlist = [];
    for i=1:length
        if modelist(2,i) == "x"
            gotlist = [gotlist modelist(1,i)];
        end
    end
end

function emptyarray = BuildArray(gotlist)
    emptyarray = strings(length(gotlist)+1,length(gotlist)+1);
    emptyarray(2:end, 1) = gotlist;
    emptyarray(1, 2:end) = gotlist;
end

function [modelist, filledarray] = Step(emptyarray, oldmodelist)
    modelist = oldmodelist;
    filledarray = emptyarray;
    NumberOfModes = size(emptyarray);
    NumberOfModes = NumberOfModes(1) -1;
    for i=1:NumberOfModes
        mode1 = emptyarray(1,i + 1);
        for j=1:i
            mode2 = emptyarray(j+1,1);
            % Get mode in x,y form
            [a,b] = StrToMode(mode1);
            [c,d] = StrToMode(mode2);
            % Doing the addition
            [x1, y1, x2, y2] = modeadd(a,b,c,d);
            % Filling in array
            modelist = AddToModelise(x1,y1,modelist); % Adding to modelist
            add = ['(' num2str(x1) ',' num2str(y1) ')'];
            if not(y2 == 0)
                add = [add '/' '(' num2str(x2) ',' num2str(y2) ')'];
                modelist = AddToModelise(x2,y2,modelist); % Adding to modelist
            end
            add = convertCharsToStrings(add);
            filledarray(j+1,i+1) = add;
        end
    end

end
