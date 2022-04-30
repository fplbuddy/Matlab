function pos = steadypositionnew(N, ninst, minst)
% works one the exp versions of thete and psi
    pos = (minst-1)*(N/2) + floor((N/2+ninst)/2)+1;
end

