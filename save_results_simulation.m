% Script to save the results in a mat-file

allv=who;  % Get all variables in the workspace

for i=1:length(allv)
    flag=strcmp(class(eval(allv{i})),'sdpvar') || strcmp(class(eval(allv{i})),'ndsdpvar') || strcmp(class(eval(allv{i})),'lmi') || strcmp(class(eval(allv{i})),'constraint');
    flag=flag || strcmp(allv{i},'m11') || strcmp(allv{i},'m15') || strcmp(allv{i},'m16') || strcmp(allv{i},'m20') || strcmp(allv{i},'m21');
    flag=flag || strcmp(allv{i},'m23') || strcmp(allv{i},'m25') || strcmp(allv{i},'m25_1') || strcmp(allv{i},'m26') || strcmp(allv{i},'m26_1');
    flag=flag || strcmp(allv{i},'flag') || strcmp(allv{i},'allv') || strcmp(allv{i},'s');
    flag=flag || strcmp(allv{i},'cmd') || strcmp(allv{i},'i') || strcmp(allv{i},'j') || strcmp(allv{i},'j1') || strcmp(allv{i},'j2')  || strcmp(allv{i},'t');
    flag=flag || strcmp(allv{i},'k') || strcmp(allv{i},'h') || strcmp(allv{i},'kk') || strcmp(allv{i},'mc') || strcmp(allv{i},'l') || strcmp(allv{i},'n');
    flag=flag || strcmp(allv{i},'tfig') || strcmp(allv{i},'linS') || strcmp(allv{i},'linC') || strcmp(allv{i},'vec') || strcmp(allv{i},'vec1') || strcmp(allv{i},'vec2');
    if not(flag)
        if i == 1
            cmd=sprintf('save(''%s'',''%s'')',s,allv{i});
        else
            cmd=sprintf('save(''%s'',''%s'',''-append'')',s,allv{i});
        end
    end
    eval(cmd);
end