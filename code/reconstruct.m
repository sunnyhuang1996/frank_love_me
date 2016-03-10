function reLM = reconstruct(wordLM, numLM)

    reLM=struct();
    reLM.uni=helper(wordLM.uni, numLM.uni);
    reLM.bi=struct();

    bifields = fieldnames(wordLM.bi);
    for i=1:numel(bifields)
        reLM.bi.(bifields{i}) = helper(wordLM.bi.(bifields{i}), numLM.bi.(bifields{i}));
    end
end


 
function reLMuni = helper(wordLMuni, numLMuni)
    reLMuni = struct();
    unifields = fieldnames(wordLMuni);


    for i=1:numel(unifields)
        disp(unifields{i})
        disp(wordLMuni.(unifields{i}))

        count = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i}))));
        if isfield(numLMuni, strcat('n', num2str(wordLMuni.(unifields{i})+1)))
            countplus = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i})+1)));
            newcount = (wordLMuni.(unifields{i}) + count)/countplus;
            reLMuni.(unifields{i}) = newcount;
        else
            reLMuni.(unifields{i}) = wordLMuni.(unifields{i});
        end
    end
    %reLMuni.apperance0time = 1;
end

% unifields = fieldnames(wordLM.uni);
% bifields = fieldnames(wordLM.bi);
% 
% for i=1:numel(unifields)
%     disp(unifields{i})
%     disp(LM.uni.(unifields{i}))
%     
%     count = numLM.uni.(strcat('n', num2str(wordLM.uni.(unifields{i}))));
%     if isfield(numLM.uni, strcat('n', num2str(wordLM.uni.(unifields{i})+1)))
%         countplus = numLM.uni.(strcat('n', num2str(wordLM.uni.(unifields{i})+1)));
%         newcount = (wordLM.uni.(unifields{i}) + count)/countplus;
%         reLM.uni.(unifields{i}) = newcount;
%     else
%         reLM.uni.(unifields{i}) = wordLM.uni.(unifields{i});
%     end
% end



% for i=1:numel(bifields)
%     subfields = fieldnames(LM.bi.(bifields{i}));
%     for j=1:numel(subfields)
%         count = numLM.bi.(bifields{i}).(strcat('n', num2str(wordLM.bi.(bifields{i}).(subfields{j}))));
%         if isfield(
%         
%         
%         
%         if ~isfield(cLM.bi.(bifields{i}), strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j}))))
%             cLM.bi.(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j})))) = 1;
%         else
%             cLM.bi.(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j})))) = cLM.bi.(strcat('n', num2str(LM.bi.(bifields{i}).(subfields{j}))))+1;
%         end
%     end
% end
        
        