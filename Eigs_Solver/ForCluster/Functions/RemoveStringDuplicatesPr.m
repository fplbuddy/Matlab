function MyList = RemoveStringDuplicatesPr(MyList, maxPr, minPr)
rem = [];
for i=1:length(MyList) % remove  when not in rage
    check = MyList(i);
    Pr = PrStoPr(check);
    if Pr > maxPr || Pr < minPr
        rem = [rem i];
    end
end
MyList(rem) = [];
rem = []; 
for i=1:length(MyList) % do the standard remove
    check = MyList(i);
    for j=i+1:length(MyList)
       checkwith = MyList(j);
       if checkwith == check
           rem = [rem j];
       end
    end
end
MyList(rem) = [];
end

