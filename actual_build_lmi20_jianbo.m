% Build LMI 20

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% LMI (20) 

% Build LMI 21

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% LMI (21) 


biglmi20=[];


for i=1:M
    for l=1:L             % Evaluation of matrix auxm20 which is symbolic
        for j1=1:M-1
            for j2=1:M-1
                m20{j1,j2}=eval(auxm20{j1,j2});
            end;
        end;
        
        
        % Transform cell matrix m16 to a LMI
        
        auxlmi20=[];
        
        for j1=1:M-1
            s='[';
            for j2=1:M-1
                s=sprintf('%s m20{%d,%d}',s,j1,j2);
            end;
            s=sprintf('%s];',s);
            auxlmi20=[auxlmi20;eval(s)];
        end;
        
        biglmi20=[biglmi20;auxlmi20>=0];
    end
end

