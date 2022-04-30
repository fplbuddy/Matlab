function G = GStoG(GS)
if length(GS) == 1
    GS = convertStringsToChars(GS); % Making sure it is chars
end
under = strfind(GS,'_'); % Checking location of underscore
if length(under) == 2 % we have two underscorsed, so there are decimal points
    Start = str2double(GS(under(1)+1:under(2)-1)); % We be zero if < 1
    End = str2double(GS(under(2)+1:end)); % The actual number, now we only need power
    %div = ceil(log10(End))
    div = length(GS) - (under(2));
    G = Start + End/(10^div);
else
    G = str2double(GS(3:end));
end
end

