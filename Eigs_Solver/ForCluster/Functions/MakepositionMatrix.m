function positionMatrix = MakepositionMatrix(n,m)
positionMatrix = zeros(max(m),max(n)+1); % so columns give x, rows y, +1 as we can have 0.
for i=1:length(n)
    positionMatrix(m(i),n(i)+1) = i;
end
end

