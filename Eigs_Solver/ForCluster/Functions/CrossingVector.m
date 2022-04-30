function v = CrossingVector(M)
% Takes M and returns crossing vector
sigmas = M(2,:);
s = sign(sigmas);
d = diff(s);
v = [];
for i=1:length(d)
   dinst = d(i);
   if dinst ~= 0
       ind = length(v)+1;
       Minst = [M(1,i) M(1,i+1) ; M(2,i) M(2,i+1)];    
       [~,RaNew] = GetNextRaNonLinear(Minst);
       v(ind) = RaNew;
   end
end

end

