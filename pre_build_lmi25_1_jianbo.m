% Build LMI 25 on page 712

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the second part of LMI 25 and inequality 23.

% xk, uk and rk are the state, the input and the mode at time k,
% respectively.

% Don't worry about Q and R.  They are all the same.

% 

for jbar=1:nu
    auxm25_1=sprintf('mathU(%g,%g,n,i) <= umax^2;',jbar,jbar);
end

% Inequality 25

