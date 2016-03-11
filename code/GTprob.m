function logProb = GTprob(sentence, reconsF)
words = strsplit(' ', sentence);

logProb = 0;
for i=1:(length(words)-1)
    unicount = 1;
    bicount=1;
    if (isfield(reconsF.uni, words{i}))
        unicount = reconsF.uni.(words{i});
    end
    
    if (isfield(reconsF.bi, words{i}))
        if (isfield(reconsF.bi.(words{i}), words{i+1}))
            bicount = reconsF.bi.(words{i}).(words{i+1});
        end   
    end
    logProb = logProb + log2(bicount/unicount);
end
return
