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
delta        = 0.00001; %(float) smoothing parameter where 0<delta<=1 
vocabSize    = 35454; %(integer) the number of words in the vocabulary
numSentences = 1000;% 10000, 15000, 30000}; %(integer) The maximum number of training sentences to consider.
AMFEDir      = '~/AMFE';
maxIter      = 10;

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
LME = importdata('~/modelE.mat');
AMFE = importdata('~/frank_love_me/code/am.mat');

google_result = upload(strcat(testDir, '.google.e'), 'e');
hansard_result = upload(strcat(testDir, '.e'), 'e');
ibm_result = upload('~/ibm.e', 'e');

correct = zeros(1, 25);
total = zeros(1, 25);
accuracy = zeros(1, 25);
eng_result = {};

i=1;
while i<=length(test_text)
    disp(i)
    fre = test_text{i};
    % Decode the test sentence 'fre'
    split_eng = decode(fre, LME, AMFE, 'smooth', delta, vocabSize);
    eng_result{i} = split_eng;
    i= i+1;
end
        
i = 1;    
while i<= length(test_text)
    %split_eng = strsplit(' ', eng);
    %split_google = strsplit(' ', google_result{i});
    %split_hansard = strsplit(' ', hansard_result{i});
    split_eng = eng_result{i};
    for j=1:(length(split_eng)-p+1)
        if p==1
            target = split_eng{j};
        elseif p==2
            target = strcat(split_eng{j}, ' ', split_eng{j+1});
        elseif p==3
            target = strcat(split_eng{j}, ' ', split_eng{j+1}, ' ', split_eng{j+2});
        end
        
        if (~isempty(strfind(google_result{i}, target))) || (~isempty(strfind(hansard_result{i}, target))) || (~isempty(strfind(ibm_result{i}, target)))
            correct(i) = correct(i)+1;
        end
    end
    total(i) = length(split_eng);  
    i = i+1;
end

accuracy = correct./total;
