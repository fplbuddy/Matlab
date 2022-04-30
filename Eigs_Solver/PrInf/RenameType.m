ARs = string(fieldnames(PrInfData));
for i=1:length(ARs)
   AR = ARs(i); 
   types = string(fieldnames(PrInfData.(AR)));
   for j=1:length(types)
       type = types(j);
       PrInfData.(AR) = rnfield(PrInfData.(AR),cellstr(type),cellstr(extend(type)));
    end

end



function y = extend(x)
    x = convertStringsToChars(x);
    ext = x(3:end);
    y = [x 'x' ext];
    y = convertCharsToStrings(y);
end