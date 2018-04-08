% Build LMI 16 on page 711

% Eduardo Mendes - 07/26/2017
% DELT - UFMG

% It uses the xk, uk and rk as in the previous lmi



%% Build LMI 16

biglmi16=[];

for l=1:L
    for t=1:T
        
        % Evaluation of matrix auxm16 which is symbolic
        
        for j1=1:size(auxm16,1) % (M+1) rows
            for j2=1:size(auxm16,2) % (M+1) columns
                m16{j1,j2}=eval(auxm16{j1,j2});
            end
        end
        
        
        % Transform cell matrix m16 to a LMI
        
        auxlmi16=[];
        
        for j1=1:size(auxm16,1) % (M+1)
            s='[';
            for j2=1:size(auxm16,2) % (M+1)
                s=sprintf('%s m16{%d,%d}',s,j1,j2);
            end
            s=sprintf('%s];',s);
            auxlmi16=[auxlmi16;eval(s)];
        end
        
        biglmi16=[biglmi16;auxlmi16>=0];
    end
end

