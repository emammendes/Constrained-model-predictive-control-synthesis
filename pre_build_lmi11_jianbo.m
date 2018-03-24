% This is script is my attempt to build LMIs 11, 15 and 16 in a way that I
% can understand what is going on.

% Eduardo Mendes - 07/26/17
% DELT - UFMG


% To build the other LMI variables we need to know the dimensions of the system and
% control matrices.  This can be easily achieved by looking at the defintions
% of such matrices. 

%nx=2;
%nu=1;

% in order to build a general matrix I need to know the dimensions of
% matrices Q and R

%nq=nx;
%nr=nu;

% Set M is defined as the set of possible states (in Markov sense).   In
% the case of the example M={1,2,3,..M} (Note that the first M is the
% calligraphic M in the paper).   The second M is equal to 3 since the
% mode can take two different states = {1=normal,2=boom,3=slump}.

%M=3;

% N is the number of the predicted control strategy. In the case of the
% example in the paper N is set to 3.   

%N=3;

% L is the number of vertices of the polytopic set for the system.  In the
% case of the example in the paper L is set to 2

%L=2;

% T is the number of vertices of the polytopic set for the transition
% probability.   In the case of the example T is set to 2.

%T=2;

%% Ready to build the matrix - LMI 11

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix auxm11.

% First - Create the matrix with the necessary dimension

for j2=1:(M+3) % M plus 3 elements - the first and last and the before the last elements
    for j1=j2:(M+3)
        if ( (j1 == (M+3)) || (j2 == (M+3)) )
            ax='zeros(nr,nx);';
            ay='zeros(nr,nx)'';';
        else
            ax='zeros(nq,nx);';
            ay='zeros(nq,nx)'';';
        end
        auxm11{j2,j1}=ay;
        auxm11{j1,j2}=ax;
    end
end

% Second - Let us build the diagonal

for j=1:(M+3) % M plus 3 elements - the first and last and the before the last elements
    if j == 1
        auxm11{j,j}='G(:,:,n,i)''+G(:,:,n,i)-Q(:,:,n,i);';
    elseif (j > 1 && j <= M+1)
        auxm11{j,j}=sprintf('inv(P{t}(i,%d))*Q(:,:,min(N,n+1),%d);',j-1,j-1);
    elseif j == M+2
        auxm11{j,j}='eye(nq,nx);';
    else
        auxm11{j,j}='eye(nr);';
    end
end

% Third - First column and first row

for j=2:(M+3)
    if (j > 1 && j <= M+1)
        auxm11{j,1}='A{l,i}*G(:,:,n,i)+B{l,i}*Y(:,:,n,i);';
        auxm11{1,j}='(A{l,i}*G(:,:,n,i)+B{l,i}*Y(:,:,n,i))'';';
    elseif j == M+2
        auxm11{j,1}='sqrtm(mathQ{i})*G(:,:,n,i);';
        auxm11{1,j}='(sqrtm(mathQ{i})*G(:,:,n,i))'';';
    else
        auxm11{j,1}='sqrtm(mathR{i})*Y(:,:,n,i);';
        auxm11{1,j}='(sqrtm(mathR{i})*Y(:,:,n,i))'';';
    end
end





