% Build LMI 15 on page 710

% Eduardo Mendes - 07/26/2017
% DELT - UFMG

% In order to check if the LMIs are as they suppose to be I have coded them
% as a string.  If I want to check if the code is right, I just need to
% look at the elements of the matrix m15.

% xk, uk and rk are the state, the input and the mode at time k,
% respectively.

% Don't worry about Q and R.  They are all the same.

m15{1,1}='gamma_1;';
m15{1,2}='xk'';';
m15{1,3}='uk'';';
m15{2,1}='xk;';
m15{2,2}='inv(mathQ{rk});';
m15{2,3}='zeros(nu,nq)'';';
m15{3,1}='uk;';
m15{3,2}='zeros(nu,nq);';
m15{3,3}='inv(mathR{rk});';

