%% Build LMI 24

% please note that I had to include flagfeas here.  flagfeas was defined in
% procedure_jianbo_exp

auxlmi24=[];
flaglmi24=0;  % Constraints are ok.

for j=1:nphi
    for l=1:L
        aux=eval(auxm24);
        if ~islogical(aux)
            auxlmi24=[auxlmi24;eval(auxm24)];
        else
            if not(eval(auxm24(1:45)) && eval(auxm24(10:end)))
                flaglmi24=1; % Infeasible
                break;
            end
        end
    end
end

if flaglmi24
    fprintf('Infeasible LMI at iteration %d (LMI 24) \n',k);
    biglmi24=[];
else
    biglmi24 = auxlmi24;
end