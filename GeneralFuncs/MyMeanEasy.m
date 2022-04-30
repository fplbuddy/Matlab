function f = MyMeanEasy(s,t)
    dt = diff(t);
    s = s(1:end-1);
    f = sum(dt.*s)/sum(dt);
end