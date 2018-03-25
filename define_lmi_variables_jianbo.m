% In this script I define the LMI variables

% Eduardo Mendes - 07/26/17
% DELT - UFMG

% The LMI variables to be created are: Q, G, Y, gamma_1, gamma_2 and uk. These
% last three variables are scalars.

gamma_1 = sdpvar(1);
gamma_2 = sdpvar(1);
uk      = sdpvar(1);assign(uk,0);   % Old - assign(uk,CIu);

% To build the other LMI variables we need to know the dimensions of the system and
% control matrices.  This can be easily achieved by looking at the defintions
% of such matrices. 

%nx=2;
%nu=1;

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

% Define the other LMI variables

Q=sdpvar(nx,nx,N,M,'symmetric');
G=sdpvar(nx,nx,N,M,'full');
Y=sdpvar(nu,nx,N,M,'full');


mathW=sdpvar(nx,nx,N,M,'symmetric');
mathU=sdpvar(nu,nu,N,M,'symmetric');
mathX=sdpvar(nx,nx,N,M,'symmetric');


