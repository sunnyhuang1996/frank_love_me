function pp = GTperplexity( LM, testDir, language)

global CSC401_A2_DEFNS

DD        = dir( [ testDir, filesep, '*', language] );
pp        = 0;
N         = 0;

for iFile=1:length(DD)

  lines = textread([testDir, filesep, DD(iFile).name], '%s','delimiter','\n');

  for l=1:length(lines)

    processedLine = preprocess(lines{l}, language);
    tpp = GTprob(processedLine, LM);
    if (tpp > -Inf)   % only consider sentences that have some probability 
      pp = pp + tpp;
      words = strsplit(' ', processedLine);
      N = N + length(words);
    end
  end
end

pp = 2^(-pp/N);
return