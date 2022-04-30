function MyList = RemoveStringDuplicates(MyList)
rem = [];
for i=1:length(MyList)
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

