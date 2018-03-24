% This is script is my attempt to build LMIs 11, 15 and 16 in a way that I
% can understand what is going on.

% Eduardo Mendes - 07/26/17
% DELT - UFMG


% Use pre_build_m11_multi to build the string version of the LMI

%% Build LMI 11

biglmi11=[];

for i=1:M
    for n=1:N
        for l=1:L
            for t=1:T
                
                % Evaluation of matrix auxm11 which is symbolic
                
                for j1=1:(M+3)
                    for j2=1:(M+3)
                        m11{j1,j2}=eval(auxm11{j1,j2});
                    end
                end
                
                
                % Transform cell matrix m to a LMI
                
                auxlmi=[];
                
                for j1=1:(M+3)
                    s='[';
                    for j2=1:(M+3)
                        s=sprintf('%s m11{%d,%d}',s,j1,j2);
                    end
                    s=sprintf('%s];',s);
                    auxlmi=[auxlmi;eval(s)];
                end
                biglmi11=[biglmi11;auxlmi>=0];
            end
        end
    end
end




