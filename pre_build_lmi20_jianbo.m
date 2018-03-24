% Build LMI 20 on page 711

% Rosileide Lopes - 03/13/2018
% DELT - UFMG

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix m15.

% xk, uk and rk are the state, the input and the mode at time k,
% respectively.

% Don't worry about Q and R.  They are all the same.

auxm20{1,1}='1;';
auxm20{1,2}='(A{l,rk}*xk+B{l,rk}*uk)'';';
auxm20{2,1}='(A{l,rk}*xk+B{l,rk}*uk);';
auxm20{2,2}='mathW(:,:,1,i);';