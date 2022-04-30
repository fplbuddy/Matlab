function res = Myerase(sta,erlist)
    res = sta;
    for i=1:length(erlist)
        res = erase(res,erlist(i));
    end
end