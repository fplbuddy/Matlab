% Copyright (c) 2011 Thomas Schaffter
%
% Author: Thomas Schaffter (firstname.name@gmail.com)
% Version: June 15, 2011
%
% UNFOLD_STRUCTURE Unfold and show the content of the given structure.
%    UNFOLD_STRUCTURE(STRUCT) shows recursively the content of the
%    given structure STRUCT. Clean and generic implementation which
%    can be easily extended, e.g. for structures containing cells.
%
%    Usage: unfold_structure(myStructure);
%
% function strucdecomp = unfold_structure(struct, strucdecomp,root)
% 
%     if nargin < 3 % IF we have not given root, it uses structure as root
%         root = inputname(1);
%     end
%     
%     names = fieldnames(struct);
%     for i=1:length(names)
%         
%         value = struct.(names{i});
%         if isstruct(value)
%             strucdecomp = unfold_structure(value, strucdecomp,[root '.' names{i}]);
%         else
%             %disp([root '.' names{i} ': ' num2str(value)]);
%             strucdecomp = [strucdecomp convertCharsToStrings([root '.' names{i}])];
%         end
%     end
% end

function Data = unfold_structure(d2,Data)

    
    names = fieldnames(d2);
    for i=1:length(names)
        value = d2.(names{i});
        if not(isfield(Data,names{i}))
            'hej'
            names{i}
            Data.(names{i}) = value;
        end
        
        if isstruct(value)
        Data = unfold_structure(value,Data.(names{i}));
        end
end