% Build LMI 25 on page 712

% Eduardo Mendes - 07/26/2017
% DELT - UFMG

% It uses the xk, uk and rk as in the previous lmi


%% Build LMI 25 - First Part

biglmi25=[];

for i=1:M
    for n=1:N
        
        % Evaluation of matrix auxm16 which is symbolic
        
        for j1=1:2 % linhas
            for j2=1:2 % colunas
                m25{j1,j2}=eval(auxm25{j1,j2});
            end
        end
        
        % Transform cell matrix m16 to a LMI
        
        auxlmi25=[];
        
        for j1=1:2
            s='[';
            for j2=1:2
                s=sprintf('%s m25{%d,%d}',s,j1,j2);
            end
            s=sprintf('%s];',s);
            auxlmi25=[auxlmi25;eval(s)];
        end
        
        biglmi25=[biglmi25;auxlmi25>=0];
    end
end

%% Build LMI 25 - Second Part

auxlmi25_1=[];

for i=1:M
    for n=1:N
        auxlmi25_1=[auxlmi25_1;eval(auxm25_1)];
    end
end

biglmi25_1 = auxlmi25_1;