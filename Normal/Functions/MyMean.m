function f = MyMean(s,t, parts)
    top = 0;
    bottom = 0;
    
    for i=1:length(parts)
       if size(parts{i}) == [1 0] % Check if empty     
       else
           signal = s(parts{i});
           time = t(parts{i});
           dt = diff(time);
           signal = signal(1:end-1);
           top = top + sum(dt.*signal);
           bottom = bottom + sum(dt);
       end
    end
    f = top/bottom;
end