function text = upload(file, language)
text = {};

fid = fopen(file);
line = fgets(fid);
i = 1;

while ischar(line)
    line = preprocess(line, language);
    text{i} = line;
    line = fgets(fid);
    
fclose(fid);
end



