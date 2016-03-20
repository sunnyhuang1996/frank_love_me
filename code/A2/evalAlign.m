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
AMFEDir      = '~/AMFE';
maxIter      = 10;

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

test_text = {};
fre_file = fopen(strcat(testDir, '.f'));
i = 1;

while (~feof(fre_file))
    test_text{i} = fgets(fre_file);
    test_text{i} = regexprep( test_text{i}, '''', '''''');
    i = i + 1;
end
fclose(fre_file);

AMFE_name = {'./am.mat', './am_10K.mat', './am_15K.mat', './am_30K.mat'};

LME = importdata('./modelE.mat');

google_result = upload(strcat(testDir, '.google.e'), 'e');
hansard_result = upload(strcat(testDir, '.e'), 'e');
ibm_result = upload('./ibm.e', 'e');

reference = struct();
reference.google_result = google_result;
reference.hansard_result = hansard_result;
reference.ibm_result = ibm_result;

precision = zeros(3, 25, 4);
min_brevity = Inf(4, 25);

% 4 alignment model in total
for align_model = 1:length(AMFE_name)
    correct = zeros(3, 25);
    total = zeros(3, 25);
    AMFE = importdata(AMFE_name{align_model});
    eng_result = {};

    i=1;
    % 25 test sentences
    while i<=length(test_text)
        fre = test_text{i};
        % Decode the test sentence 'fre'
        split_eng = decode2(fre, LME, AMFE, 'smooth', delta, vocabSize);
        eng_result{i} = split_eng;
        i= i+1;
    end

    % unigram, bigram, trigram
    for p =1:3

        i = 1;    
        while i<= length(test_text)
            
            split_eng = eng_result{i};
            split_eng = strsplit(' ', split_eng);
            for j=1:(length(split_eng)-p+1)
                if p==1
                    target = split_eng{j};
                    if ismember(target, strsplit(' ', google_result{i})) || ismember(target, strsplit(' ', hansard_result{i})) || ismember(target, strsplit(' ', ibm_result{i}))
                        correct(p, i) = correct(p, i) + 1;
                    end
                else
                    if p==2
                        target = [split_eng{j}, ' ', split_eng{j+1}];
                    elseif p==3
                        target = [split_eng{j}, ' ', split_eng{j+1}, ' ', split_eng{j+2}];
                    end
                    if (~isempty(strfind(google_result{i}, target))) || (~isempty(strfind(hansard_result{i}, target))) || (~isempty(strfind(ibm_result{i}, target)))
                        correct(p, i) = correct(p, i)+1;
                    end
                end
            end
            total(p, i) = length(split_eng);  
            i = i+1;
        end
    end

    precision(:, :, align_model) = correct./total;

<<<<<<< HEAD
for i=1:length(eng_result)
    field = fieldnames(reference);
    for ref_index =1:numel(field)
        ref_len =  length(strsplit(' ', reference.(field{ref_index}){i}));
        disp(ref_len)
        if abs(min_brevity(i) - length(eng_result{i})) > abs(length(eng_result{i}) - ref_len)
            min_brevity(i) = ref_len;
=======
    for i=1:length(eng_result)

        field = fieldnames(reference);
        for ref_index =1:numel(field)
            % exclude SENTSTART SENTEND
            ref_len =  length(strsplit(' ', reference.(field{ref_index}){i})) - 2;
            eng_len = length(strsplit(' ', eng_result{i}));

            if abs(min_brevity(align_model, i) - eng_len) > abs(eng_len - ref_len)
                min_brevity(align_model, i) = ref_len;
            end
        end
        if min_brevity(align_model, i) >= eng_len
           min_brevity(align_model, i) =  exp(1-(min_brevity(align_model, i) / eng_len));
        else
           min_brevity(align_model, i) = 1;
>>>>>>> 0e295290640342b7d8b88f4cc67b80bf95f99874
        end
    end
    
end



bleu = zeros(3, 25, 4);

for align_model =1:4
    for index = 1:25
        for n=1:3
            if n==1
                bleu(n, index, align_model) = min_brevity(align_model, index) * precision(n, index, align_model);
            elseif n==2
                bleu(n, index, align_model) = min_brevity(align_model, index) * (precision(n-1, index, align_model) * precision(n, index, align_model)) ^ (1/n);
            else
                bleu(n, index, align_model) = min_brevity(align_model, index) * (precision(n-2, index, align_model) * precision(n-1, index, align_model) * precision(n, index, align_model)) ^ (1/n);
            end
            
        end
        
    end
end

disp(bleu)
