% Build LMI 21

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% LMI (21) 


biglmi21=[];

for i=1:M
    for j=1:M
        for n=1:N
            for l=1:L             % Evaluation of matrix auxm21 which is symbolic          
                for j1=1:2
                    for j2=1:2
                        m21{j1,j2}=eval(auxm21{j1,j2});
                    end
                end
                
                
                % Transform cell matrix m16 to a LMI
                
                auxlmi21=[];
                
                for j1=1:2
                    s='[';
                    for j2=1:2
                        s=sprintf('%s m21{%d,%d}',s,j1,j2);
                    end
                    s=sprintf('%s];',s);
                    auxlmi21=[auxlmi21;eval(s)];
                end
                biglmi21=[biglmi21;auxlmi21>=0];
            end
        end
    end
end
