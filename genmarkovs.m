function next_mode = genmarkovs(P,init_mode)
% genmarkovs is used to generate the next mode in the path of a Markov chain
%
% On entry
%
% P         : transition probability matrix
% init_mode : initial mode
%
% On return
%
% next_mode : the next generated mode
%
% Example:
%
% Suppose the following transition matrix
%
% P1=[0.55 0.23 0.22;0.36 0.35 0.29;0.32 0.16 0.52];


% Modified based on the original genmarkov function
% Eduardo Mendes - 07/23/2017 
% DELT - UFMG

sample = [init_mode ];
i=1;
[ ~,sample(i+1) ]=histc( rand,[0 cumsum(P(sample(i),:))] );
next_mode=sample(end);


% P1=[0.55 0.23 0.22;0.36 0.35 0.29;0.32 0.16 0.52];
% P2=[0.79 0.11 0.10;0.27 0.53 0.20;0.23 0.07 0.70];