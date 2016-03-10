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
%delta        = TODO; %(float) smoothing parameter where 0<delta<=1 
%vocabSize    = TODO; %(integer) the number of words in the vocabulary
%numSentences = 1000;% 10000, 15000, 30000}; %(integer) The maximum number of training sentences to consider.
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

test_text = {};
ibm_translation = {};

fre_file = fopen(strcat(testDir, '.f'));
i = 1;

while (~feof(fre_file))
    test_text{i} = fgets(fre_file);
    test_text{i} = regexprep( test_text{i}, '''', '''''');
    curl_command = sprintf('env LD_LIBRARY_PATH='''' curl -u "0011056e-c82a-4dea-8354-c697c607a580":"6izojpCZMrdJ" -X POST -F "text=%s" -F "source=fr" -F "target=en" "https://gateway.watsonplatform.net/language-translation/api/v2/translate"', test_text{i});
    [status, ibm_translation{i}] = unix(curl_command);
    i = i + 1;
end  
fclose(fre_file);

for i=1:length(ibm_translation)
    disp(ibm_translation{i})
end
google_result = upload(strcat(testDir, '.google.e'), 'e');
hansard_result = upload(strcat(testDir, '.e'), 'e');

google_correct = 0;
hansard_correct = 0;
total = 0;

i=1;
while i<= length(test_text)
    fre = test_text{i};
    % Decode the test sentence 'fre'
    eng = decode(fre, LME, AMFE, 'smooth', delta, vocabSize);
    
    split_eng = strsplit(' ', eng);
    split_google = strsplit(' ', google_result{i});
    split_hansard = strsplit(' ', hansard_result{i});
    
    google_correct = google_correct + sum(cellfun(@strcmp, split_eng, split_google));
    hansard_correct = hansard_correct + sum(cellfun(@strcmp, split_eng, split_hansard));
    total = total + length(split_eng);   
end

google_score = google_correct/total;
hansard_score = hansard_correct/total;

% TODO: perform some analysis
% add BlueMix code here 

