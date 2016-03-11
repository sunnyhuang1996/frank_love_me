function text = upload(file, language)
text = {};

fid = fopen(file);
disp(fid);
line = fgets(fid);
i = 1;

while ischar(line)
    line = preprocess(line, language);
    text{i} = line;
    line = fgets(fid);
    i = i+1;
end    

fclose(fid);
end



