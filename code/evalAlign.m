%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 

% some of your definitions
trainDir     = '/u/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing/Task5';
fn_LME       = '~/lmtraineng';
fn_LMF       = '~/lmtrainfre';
lm_type      = '';
delta        = 0.1; %(float) smoothing parameter where 0<delta<=1 
vocabSize    = 35454; %(integer) the number of words in the vocabulary
numSentences = 30000;% 10000, 15000, 30000}; %(integer) The maximum number of training sentences to consider.
AMFEDir      = '~/AMFE';
maxIter      = 10;
p=1;

%[status, result] = unix('env LD_LIBRARY_PATH='''' curl -u "0011056e-c82a-4dea-8354-c697c607a580":"6izojpCZMrdJ" -X POST -F "text=Dans le monde reel, il n''y a rien de mal a cela." -F "source=fr" -F "target=en" "http://gateway.watsonplatform.net/language-translation/api/v2/translate"')


% Train your language models. This is task 2 which makes use of task 1
%LME = lm_train( trainDir, 'e', fn_LME );
%LMF = lm_train( trainDir, 'f', fn_LMF );

% Train your alignment model of French, given English 
%AMFE = align_ibm1(trainDir, numSentences, maxIter, AMFEDir);

% ... TODO: more  build moreeeeeeeeee models

% TODO: a bit more work to grab the English and French sentences. 
%       You can probably reuse your previous code for this  

%====================== Finishing vuilding model ===================

% upload test french and english data line by line

% test_text = {};
% ibm_translation = {};
% 
% fre_file = fopen(strcat(testDir, '.f'));
% i = 1;
% 
% while (~feof(fre_file))
%     test_text{i} = fgets(fre_file);
%     test_text{i} = regexprep( test_text{i}, '''', '''''');
%     curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "0011056e-c82a-4dea-8354-c697c607a580":"6izojpCZMrdJ" -X POST -F "text=%s" -F "source=fr" -F "target=en" "https://gateway.watsonplatform.net/language-translation/api/v2/translate"', test_text{i});
%     [status, ibm_translation{i}] = unix(curl_command);
%     i = i + 1;
% end  
% fclose(fre_file);

% for i=1:length(ibm_translation)
%     disp(ibm_translation{i})
% end
test_text = {};
fre_file = fopen(strcat(testDir, '.f'));
i = 1;

while (~feof(fre_file))
    test_text{i} = fgets(fre_file);
    test_text{i} = regexprep( test_text{i}, '''', '''''');
    i = i + 1;
end
fclose(fre_file);



LME = importdata('./modelE.mat');
AMFE = importdata('./am_30K.mat');

google_result = upload(strcat(testDir, '.google.e'), 'e');
hansard_result = upload(strcat(testDir, '.e'), 'e');
ibm_result = upload('./ibm.e', 'e');

reference = struct();
reference.google_result = google_result;
reference.hansard_result = hansard_result;
reference.ibm_result = ibm_result;

% correct = zeros(1, 25);
% total = zeros(1, 25);
% accuracy = zeros(1, 25);
% eng_result = {};
% 
% i=1;
% while i<=length(test_text)
%     disp(i)
%     fre = test_text{i};
%     % Decode the test sentence 'fre'
%     split_eng = decode2(fre, LME, AMFE, 'smooth', delta, vocabSize);
%     eng_result{i} = split_eng;
%     i= i+1;
% end
%         
% i = 1;    
% while i<= length(test_text)
%     %split_eng = strsplit(' ', eng);
%     %split_google = strsplit(' ', google_result{i});
%     %split_hansard = strsplit(' ', hansard_result{i});
%     split_eng = eng_result{i};
%     split_eng = strsplit(' ', split_eng);
%     for j=1:(length(split_eng)-p+1)
%         if p==1
%             target = split_eng{j};
%             if ismember(target, google_result{i}) || ismember(target, hansard_result{i}) || ismember(target, ibm_result{i})
%                 correct(i) = correct(i) + 1;
%             end
%         else
%             if p==2
%                 target = [split_eng{j}, ' ', split_eng{j+1}];
%                 disp(target)
%             elseif p==3
%                 target = [split_eng{j}, ' ', split_eng{j+1}, ' ', split_eng{j+2}];
%             end
%             if (~isempty(strfind(google_result{i}, target))) || (~isempty(strfind(hansard_result{i}, target))) || (~isempty(strfind(ibm_result{i}, target)))
%                 correct(i) = correct(i)+1;
%             end
%         end
%     end
%     total(i) = length(split_eng);  
%     i = i+1;
% end
% 
% accuracy = correct./total;


min_brevity = Inf(1,length(eng_result));

for i=1:length(eng_result)
    field = fieldnames(reference);
    for ref_index =1:numel(field)
        ref_len =  length(strsplit(' ', reference.(field{ref_index}){i}));
        disp(ref_len)
        if abs(min_brevity(i) - length(eng_result{i})) > abs(length(eng_result{i}) - ref_len)
            min_brevity(i) = ref_len;
        end
    end
    if min_brevity(i) >= length(eng_result{i})

       min_brevity(i) =  exp(1-(min_brevity(i) / length(eng_result{i})));
    else
       min_brevity(i) = 1;
    end
end

disp(min_brevity)