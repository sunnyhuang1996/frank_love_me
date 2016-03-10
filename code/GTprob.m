function logProb = GTprob(sentence, LM, type, delta, vocabSize)

    %logProb = -Inf;
    words = strsplit(' ', sentence);

    % TODO: the student implements the following
    logProb = 0;
    for i=1:(length(words) - 1)
        if isfield(LM.uni, words{i})
            unicount = LM.uni.(words{i});
        else
            unicount = 1;
        end
        if isfield(LM.bi.(words{i}), words{i+1})
            bicount = LM.bi.(words{i}).(words{i+1});
        else
            bicount = 1;
        end
        logProb = logprob + log2(unicount/bicount);
    end
return

