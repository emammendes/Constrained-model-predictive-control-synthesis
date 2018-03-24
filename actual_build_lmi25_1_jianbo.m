% Build the second part of LMI 25 and inequality 23

%% Second part of LMI 25

auxlmi25_1=[];

for i=1:M
    for n=1:N
        auxlmi25_1=[auxlmi25_1;eval(auxm25_1)];
    end
end

%% Inequality 23

% auxlmi25_1=[auxlmi25_1;eval(m23)];

%% LMI

biglmi25_1 = auxlmi25_1;
