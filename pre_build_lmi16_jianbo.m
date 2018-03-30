% Build LMI 16 on page 711

% Eduardo Mendes - 07/26/2017
% DELT - UFMG

% It uses the xk, uk and rk as in the previous lmi

%% Ready to build the matrix - LMI 16

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix auxm16.

% First - Create the matrix with the necessary dimension

for j2=1:(M+1) % M plus 1 element - the first element of the matrix
    for j1=j2:(M+1)
        auxm16{j1,j2}='zeros(nx,nx);';
        auxm16{j2,j1}='zeros(nx,nx)'';';
    end
end

% Second - Build the diagonal

for j=1:(M+1) % M plus 1 element
    if j == 1
        auxm16{j,j}='gamma_2;';
    else
        auxm16{j,j}=sprintf('inv(P{t}(rk,%d))*Q(:,:,1,%d);',j-1,j-1);
    end
end

% Third - First column and first row

for j=2:(M+1)
    auxm16{j,1}='A{l,rk}*xk+B{l,rk}*uk;';
    auxm16{1,j}='(A{l,rk}*xk+B{l,rk}*uk)'';';
end


