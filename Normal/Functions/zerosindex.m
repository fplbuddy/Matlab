function zci = zerosindex(v)
    % Returns Zero-Crossing Indices Of Argument Vector
    zci = find(v(:).*circshift(v(:), [-1 0]) <= 0); 
    zci(end) = []; % Last one comes out weird for some reason
end
