function reLM = reconstruct(wordLM, numLM)

reLM=struct();
reLM.uni=struct();
reLM.bi=struct();

unifields = fieldnames(wordLM.uni);
bifields = fieldnames(wordLM.bi);

for i=1:numel(unifields)
    disp(unifields{i})
    disp(LM.uni.(unifields{i}))
    
    count = numLM.uni.(strcat('n', num2str(wordLM.uni.(unifields{i}))));
    if isfield(numLM.uni, strcat('n', num2str(wordLM.uni.(unifields{i})+1)))
        countplus = numLM.uni.(strcat('n', num2str(wordLM.uni.(unifields{i})+1)));
        newcount = (wordLM.uni.(unifields{i}) + count)/countplus;
        reLM.uni.(unifields{i}) = newcount;
    else
        reLM.uni.(unifields{i}) = wordLM.uni.(unifields{i});
    end
end