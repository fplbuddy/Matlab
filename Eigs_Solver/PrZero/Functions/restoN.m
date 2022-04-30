function N = restoN(res)
    res = convertStringsToChars(res);
    N = res(3:end); N = str2num(N);
end