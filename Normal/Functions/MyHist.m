function [x,y] = MyHist(signal, AllData, ARS, PrS, RaS, sn, zn)
PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
Zero = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1);

edges = [];
sdf = 1;

% The 2*All data is there due to error when outputting time series
if PosShear
   sd =  2*AllData.(ARS).(PrS).(RaS).calcs.psd;
   m = 2*AllData.(ARS).(PrS).(RaS).calcs.pmean;
   edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];   
end
if Zero
    sd =  2*AllData.(ARS).(PrS).(RaS).calcs.zsd;
    m = 2*AllData.(ARS).(PrS).(RaS).calcs.zmean;
    edges = [linspace(m - sd*sdf, m + sd*sdf, zn) edges];
end
if NegShear
    sd =  2*AllData.(ARS).(PrS).(RaS).calcs.nsd;
    m = 2*AllData.(ARS).(PrS).(RaS).calcs.nmean;
    edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];
end
edges = [min(signal) edges max(signal)];

% Checking that we do not overlap
d = sign(diff(edges));
while sum(d) == length(d)
   Oldedges = edges;
   edges = [];
   sdf = sdf + 1;
   if PosShear
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.psd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.pmean;
       edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];
   end
   if Zero
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.zsd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.zmean;
       edges = [linspace(m - sd*sdf, m + sd*sdf, zn) edges];
   end
   if NegShear
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.nsd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.nmean;
       edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];
   end
   edges = [min(signal) edges max(signal)];
   d = sign(diff(edges));
   if sum(d) ~= length(d)
       edges = Oldedges;
       sdf = sdf -1;
   end
   
end

% Extending middle bit
if Zero
Zadd = 1;
d = sign(diff(edges));
while sum(d) == length(d) 
   Oldedges = edges;
   edges = [];
   Zadd = Zadd + 1;
   if PosShear
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.psd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.pmean;
       edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];
   end
   if Zero
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.zsd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.zmean;
       edges = [linspace(m - sd*(sdf+Zadd), m + sd*(sdf+Zadd), zn) edges];
   end
   if NegShear
       sd =  2*AllData.(ARS).(PrS).(RaS).calcs.nsd;
       m = 2*AllData.(ARS).(PrS).(RaS).calcs.nmean;
       edges = [linspace(m - sd*sdf, m + sd*sdf, sn) edges];
   end
   edges = [min(signal) edges max(signal)];
   d = sign(diff(edges));
   if sum(d) ~= length(d) 
       edges = Oldedges;
   end
end
end

% Filling the bins
y = zeros(1,length(edges)-1);
for i=1:length(signal)
   inst = signal(i);
   stop = 0;
   for j=1:length(edges)-1
      bottom = edges(j);
      top = edges(j+1);
      if inst >= bottom && inst < top
          y(j) = y(j) + 1;
          stop = 1;
      end
      %if inst == edges(end) && not(stop)
      %    y(end) = y(end) + 1; 
      %end
   end
   
    
end

x = [];
for i=1:length(edges)-1
    x(i) = (edges(i) + edges(i+1))/2;
end

dx = diff(edges);

y = y/length(signal);
y = y./dx;
end