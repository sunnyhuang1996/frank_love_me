function cLM = countapperance(LM)

global CSC401_A2_DEFNS

cLM=struct();
cLM.uni = struct();
cLM.bi = struct();

unifields = fieldnames(LM.uni);
bifields = fieldnames(LM.bi);

for i=1:numel(unifields)
    if ~isfield(cLM.uni, strcat('n', num2str(LM.uni.(unifields{i}))))
        cLM.uni.(strcat('n', num2str(LM.uni.(unifields{i})))) = 1;
    else
        cLM.uni.(strcat('n', num2str(LM.uni.(unifields{i})))) = cLM.uni.(strcat('n', num2str(LM.uni.(unifields{i}))))+1;
    end
end

for i=1:numel(bifields)
    if ~isfield(cLM.bi, bifields{i})
        cLM.bi.(bifields{i}) = struct();
    end
    subfields = fieldnames(LM.bi.(bifields{i}));
    for j=1:numel(subfields)
        if ~isfield(cLM.bi.(bifields{i}), strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j}))))
            cLM.bi.(bifields{i}).(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j})))) = 1;
        
        else
            cLM.bi.(bifields{i}).(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j})))) = cLM.bi.(bifields{i}).(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j}))))+1;
            disp(num2str(LM.bi.(bifields{i}).(subfields{j})))
        end
    end
end
save('./countapp.mat', 'cLM', '-mat');