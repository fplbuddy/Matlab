function positionMatrix = MakePositionMatrix(n,m)
positionMatrix = zeros(max(m),max(n)*2+1); % so columns give x, rows y, +1 as we can have 0.
for i=1:length(n)
    positionMatrix(m(i),n(i)+1+max(n)) = i;
end
end

