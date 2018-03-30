% Build LMI 25 on page 712

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix m25.

% xk, uk and rk are the state, the input and the mode at time k,
% respectively.

% Don't worry about Q and R.  They are all the same.

%% First Part

auxm25{1,1}='mathU(:,:,n,i);';
auxm25{2,1}='(Y(:,:,n,i))'';';
auxm25{1,2}='Y(:,:,n,i);';
auxm25{2,2}='G(:,:,n,i)''+G(:,:,n,i)-mathW(:,:,n,i);';

%% Second Part

for jbar=1:nu
    auxm25_1=sprintf('mathU(%g,%g,n,i) <= umax^2;',jbar,jbar);
end


