function reLM = reconstruct(wordLM, numLM)

    reLM=struct();
    reLM.uni=helper(wordLM.uni, numLM.uni);
    reLM.bi=struct();

    bifields = fieldnames(wordLM.bi);
    for i=1:numel(bifields)
        reLM.bi.(bifields{i}) = helper(wordLM.bi.(bifields{i}), numLM.bi.(bifields{i}));
    end
save('./recons.mat', 'reLM', '-mat'); 
end


 
function reLMuni = helper(wordLMuni, numLMuni)
    reLMuni = struct();
    unifields = fieldnames(wordLMuni);

    for i=1:numel(unifields)
        count = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i}))));
        if isfield(numLMuni, strcat('n', num2str(wordLMuni.(unifields{i})+1)))
            countplus = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i})+1)));
            frq = wordLMuni.(unifields{i});
            newcount = ((frq + 1) * countplus)/count;
            reLMuni.(unifields{i}) = newcount;
        else
            reLMuni.(unifields{i}) = wordLMuni.(unifields{i});
        end
    end
end
