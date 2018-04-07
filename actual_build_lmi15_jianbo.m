% Build LMI 15 on page 710

% Eduardo Mendes - 07/26/2017
% DELT - UFMG


% Build LMI 15

auxlmi15=[];

auxm15=m15;

for j1=1:3 % linhas 
    s=[];
    for j2=1:3 % colunas
        s=[s eval(m15{j1,j2})];
    end
    auxlmi15=[auxlmi15;s];
end

biglmi15= (auxlmi15>= 0);