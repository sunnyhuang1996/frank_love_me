function reLM = reconstruct(wordLM, numLM)

    reLM=struct();
    reLM.uni=helper(wordLM.uni, numLM.uni);
    reLM.bi=struct();

    bifields = fieldnames(wordLM.bi);
    for i=1:numel(bifields)
%         disp('the first word is ')
%         disp(bifields{i})
        reLM.bi.(bifields{i}) = helper(wordLM.bi.(bifields{i}), numLM.bi.(bifields{i}));
    end
save('~/reconsF.mat', 'reLM', '-mat'); 
end


 
function reLMuni = helper(wordLMuni, numLMuni)
    reLMuni = struct();
    unifields = fieldnames(wordLMuni);


    for i=1:numel(unifields)
        disp(1)
%         disp(unifields{i})
        %disp(wordLMuni.(unifields{i}))

        count = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i}))));
%         disp('count is :')
%         disp(num2str(wordLMuni.(unifields{i})))
%         disp(count)
        if isfield(numLMuni, strcat('n', num2str(wordLMuni.(unifields{i})+1)))
            countplus = numLMuni.(strcat('n', num2str(wordLMuni.(unifields{i})+1)));
%             disp('count+1 is :')
%             disp(countplus)
            frq = wordLMuni.(unifields{i});
%             disp('freq is :')
%             disp(frq)
            newcount = ((frq + 1) * countplus)/count;
            reLMuni.(unifields{i}) = newcount;
%             disp('new count is :')
%             disp(newcount)
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
        
        