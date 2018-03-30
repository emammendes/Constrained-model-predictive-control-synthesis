% Build the second part of LMI 25 and inequality 23

%% Second part of LMI 25

auxlmi25_1=[];

for i=1:M
    for n=1:N
        auxlmi25_1=[auxlmi25_1;eval(auxm25_1)];
    end
end


biglmi25_1 = auxlmi25_1;
