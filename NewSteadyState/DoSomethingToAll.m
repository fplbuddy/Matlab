GS_list = string(fields(Data)); % Getting aspect
for i=1:length(GS_list)
    GS = GS_list(i);
    type_list =  string(fields(Data.(GS))); % getting types
    G = GStoG(GS);
    RaC = pi^4*(4+G^2)^3/(4*G^4);
    for j=1:length(type_list)
        type = type_list(j);
        PrS_list = string(fields(Data.(GS).(type))); % getting PrS
        for k=1:length(PrS_list)
            PrS = PrS_list(k);
            Pr = PrStoPr(PrS);
            RaAS_list = string(fields(Data.(GS).(type).(PrS)));
            for l=1:length(RaAS_list)
                RaAS =  RaAS_list(l);
                %here is where we want the change
                Data.(GS).(type).(PrS).(RaAS).lowPrScaling = 0;
            end      
        end
        
    end
    
    
end

function structOut = renamefield(structIn, oldField, newField)
structIn.(newField) = structIn.(oldField);
structOut = rmfield(structIn,oldField);
end