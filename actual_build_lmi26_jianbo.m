% Build LMI 26 on page 712

% Eduardo Mendes - 07/26/2017
% DELT - UFMG


%% Build LMI 26 - First Part

biglmi26=[];

for i=1:M
    for n=2:N
        
        % Evaluation of matrix auxm26 which is symbolic
        
        for j1=1:size(auxm26,1) % 2 rows
            for j2=1:size(auxm26,2) % 2 columns
                m26{j1,j2}=eval(auxm26{j1,j2});
            end
        end
        
        % Transform cell matrix m26 to a LMI
        
        auxlmi26=[];
        
        for j1=1:size(auxm26,1) % 2
            s='[';
            for j2=1:size(auxm26,2) % 2
                s=sprintf('%s m26{%d,%d}',s,j1,j2);
            end
            s=sprintf('%s];',s);
            auxlmi26=[auxlmi26;eval(s)];
        end
        
        biglmi26=[biglmi26;auxlmi26>=0];
    end
end

%% Second part of LMI 26

auxlmi26_1=[];

for i=1:M
    for n=1:N
        auxlmi26_1=[auxlmi26_1;eval(auxm26_1)];
    end
end

biglmi26_1 = auxlmi26_1;


