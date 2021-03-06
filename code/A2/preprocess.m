function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  outSentence = regexprep( outSentence, '(\w+)([\,|\.|\;|\<|\>|\=|\?|!])', '$1 $2');
  outSentence = regexprep( outSentence, '\((\w*)\-(\w*)\)', '\($1 \- $2\)');
  outSentence = regexprep( outSentence, '([\<|\>|\+|\=|\(])(\w+)', '$1 $2');
  outSentence = regexprep( outSentence, '(\w+)([\<|\>|\+|\=|\)])', '$1 $2');

  outSentence = regexprep( outSentence, '(''|")(\w+)(''|")', '$1 $2 $3');
  switch language
  case 'e'
    % have dealt with above

  case 'f'
    outSentence = regexprep( outSentence, '([l|qu|j|t|d|s|q|w|r|y|p|g|h|k|z|x|v|b|n|m])''(\w+)', '$1'' $2');
    outSentence = regexprep( outSentence, '(\w+)''(on|il)', '$1'' $2');
    outSentence = regexprep( outSentence, 'd'' ([abord|accord|ailleurs|habitude])', 'd''$1');
  end
  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );
<<<<<<< HEAD
  disp(outSentence)
=======
>>>>>>> 0e295290640342b7d8b88f4cc67b80bf95f99874
