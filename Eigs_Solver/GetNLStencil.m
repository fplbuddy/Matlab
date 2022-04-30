N = 88;
G = 2;

n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
len = length(n);
Afact1 = zeros(len, N^2);
Afact2 = zeros(len, N^2);
Fact1 = ones(len, N^2);
Fact2 = ones(len, N^2);
check = 0;
for i=1:len
    minst = m(i); ninst = n(i);
    OWW = checkeenew(N, ninst, minst);
    check = max(check, height(OWW));
    for j=1:height(OWW)
        n1 = OWW(j,1); m1 = OWW(j,2); n2 = OWW(j,3); m2 = OWW(j,4);
        Afact1(i,j) = A2(n1, m1, n2, m2, 1, G, minst);
        Afact2(i,j) = A2(n1, m1, n2, m2, 2, G, minst);
        Fact1(i,j) = steadypositionnew(N, n1, m1);
        Fact2(i,j) = steadypositionnew(N, n2, m2);       
    end   
end
Afact1 = Afact1(:,1:check);
Afact2 = Afact2(:,1:check);
Fact2 = Fact2(:,1:check);
Fact1 = Fact1(:,1:check);



%% Saving
NL.Afact1 = Afact1;
NL.Afact2 = Afact2;
NL.Fact1 = Fact1;
NL.Fact2 = Fact2;
save(['/Volumes/Samsung_T5/SomeStencils/' 'NL_' num2str(N)], 'NL', '-v7.3')
