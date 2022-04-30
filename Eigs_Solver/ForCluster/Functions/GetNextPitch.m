function [RaNext,Done] = GetNextPitch(A, thres)
Done = 0;
% Get rid of conjugates
rem = [];
for i = 1:length(A)
   sig = A(2,i);
   if imag(sig) > thres % If eigenvalue of complex part, then we remove it
      rem = [i rem]; 
   end
end
A(:,rem) = [];
% Find Ra with largest real part
sigs = A(2,:);
Ra_list = A(1,:);
[~,I] = max(real(sigs));
RaMax = Ra_list(I);

% Look towards the left first
RaLeft = RaMax - 0.01*10^(floor(log10(RaMax)));
GotLeftClose = ismember(RaLeft, Ra_list);
GotLeftFar = 0;
if not(GotLeftClose)
    for j = 2:10
        RaCheck = RaMax - j*0.01*10^(floor(log10(RaMax)));
        if ismember(RaCheck, Ra_list)
            GotLeftFar = 1; % We have one within 0.1 to the left
            break 
        end
    end
end
if not(GotLeftFar) && not(GotLeftClose)
    RaNext = RaMax - 0.1*10^(floor(log10(RaMax)));
    return
end

% Look towards right 
RaRight = RaMax + 0.01*10^(floor(log10(RaMax)));
GotRightClose = ismember(RaRight, Ra_list);
GotRightFar = 0;
if not(GotRightClose)
    for j = 2:10
        RaCheck = RaMax + j*0.01*10^(floor(log10(RaMax)));
        if ismember(RaCheck, Ra_list)
            GotRightFar = 1; % We have one within 0.1 to the right
            break 
        end
    end
end
if not(GotRightFar) && not(GotRightClose)
    RaNext = RaMax + 0.1*10^(floor(log10(RaMax)));
    return
end

% Get left close
if not(GotLeftClose)
    RaNext = RaMax - 0.01*10^(floor(log10(RaMax)));
    return
end

% Get right close
if not(GotRightClose)
    RaNext = RaMax + 0.01*10^(floor(log10(RaMax)));
    return
end

% Did not pick anything up
RaNext = RaMax;
Done = 1;

end

