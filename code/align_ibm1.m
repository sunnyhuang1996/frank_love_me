function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
% 
%  This function implements the training of the IBM-1 word alignment algorithm. 
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing 
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider. 
%       maxIter      : (integer) The maximum number of iterations of the EM 
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a 
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
% 
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz
  
  global CSC401_A2_DEFNS
  
  AM = struct();
  
  % Read in the training data
  [eng, fre] = read_hansard(trainDir, numSentences);
  % Initialize AM uniformly 
  AM = initialize(eng, fre);

  % Iterate between E and M steps
  %for iter=1:maxIter,
  %  AM = em_step(AM, eng, fre);
  %end

  % Save the alignment model
  %save( fn_AM, 'AM', '-mat'); 

  end





% --------------------------------------------------------------------------------
% 
%  Support functiontrainDir, numSentences, maxIter, fn_AMs
%
% --------------------------------------------------------------------------------

function [eng, fre] = read_hansard(mydir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of 
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
    eng = {};
    fre = {};
    
    E_file_list = dir([mydir, '*.e']);
    line_counter = 1;

    for index = 1:length(E_file_list)
    
        eng_file_name = E_file_list(index).name;
        fre_file_name = strrep(eng_file_name, '.e', '.f');
        fre_file = fopen([mydir, fre_file_name]);
        eng_file = fopen([mydir, eng_file_name]);

        while (~feof(eng_file)) && (line_counter <= numSentences)
            curr_eng_line = fgets(eng_file);
            eng{line_counter} = {strsplit(' ', preprocess(curr_eng_line, 'e'))};
            curr_fre_line = fgets(fre_file);
            fre{line_counter} = {strsplit(' ', preprocess(curr_fre_line, 'f'))};
            line_counter = line_counter + 1;
        end
    
        if (line_counter > numSentences)
            fclose(eng_file);
            fclose(fre_file);
            break
        end
        
        fclose(eng_file);
        fclose(fre_file);
        
    end

end



function AM = initialize(eng, fre)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
    AM = struct(); % AM.(english_word).(foreign_word)
    storage = struct();
    
    for line_index=1:length(eng)

        for element_index=1:length(eng{line_index})
            if  ~isfield(AM, eng{line_index}{element_index})
               
                AM.eng{line_index}{element_index} = struct();
                storage.eng{line_index}{element_index} = {};
            end  
            storage.eng{line_index}{element_index} = [storage.eng{line_index}{element_index}, fre{line_index}];
            
        end
        
    end
    
    eng_words = fieldnames(storage); 
    for i = 1:numel(eng_words)
        
        [fre_word, ~, label] = unique(storage.(eng_words{i}));
        count = sum(bsxfun(@eq, label(:), 1:max(label)));
        for index = 1:length(fre_word)
            AM.eng_words{i}.word{index} = count{index} / length(storage.eng_words{i});
        end
    end
    
    AM.SENTSTART.SENTSTART = 1;
    AM.SENTEND.SENTEND = 1;
    
    

end

function t = em_step(t, eng, fre)
% 
% One step in the EM algorithm.
%
  
  % TODO: your code goes here
end


