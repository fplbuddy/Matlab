function resC = Closestres(res, res_list)
    N = restoN(res);
    Results = zeros(length(res_list), 1);
    for i=1:length(res_list)
        resCheck = restoN(res_list(i));
        Results(i) = abs(N - resCheck);
    end
    [~,I] = min(Results);
    resC = res_list(I);
end