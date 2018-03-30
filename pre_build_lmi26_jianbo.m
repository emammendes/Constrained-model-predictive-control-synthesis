% Build LMI 26 on page 712

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix m25.

% xk, uk and rk are the state, the input and the mode at time k,
% respectively.

% Don't worry about Q and R.  They are all the same.

% First Part

auxm26{1,1}='mathX(:,:,n,i);';
auxm26{2,1}='(mathPhi*mathW(:,:,n,i))'';';
auxm26{1,2}='mathPhi*mathW(:,:,n,i);';
auxm26{2,2}='mathW(:,:,n,i);';

% Second Part

for jbar=1:nphi
    auxm26_1=sprintf('mathX(%g,%g,n,i) <= xmax^2;',jbar,jbar);
end


