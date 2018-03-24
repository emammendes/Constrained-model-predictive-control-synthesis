% model parameters
%
% Example from the paper entitled Constrained model predictive control synthesis for
% uncertain discrete-time Markovian jump linear systems, by Jianbo Lu,
% Dewei Li and Yugeng Xi. IET Control Theory and Applications v. 7, Iss. 5,
% pp. 707-719, 2013.
% 
%
% L is the number of vertices of the polytopic set for the system.  In the
% case of the example in the paper L is set to 2

L=2;

% To build the other LMI variables we need to know the dimensions of the system and
% control matrices.  This can be easily achieved by looking at the defintions
% of such matrices. 

nx=2;
nu=1;

% Factor that multiplies Q and R

dq=0.01;
dr=0.01;

%
% Set M is defined as the set of possible states (in Markov sense).   In
% the case of the example M={1,2,3,..M} (Note that the first M is the
% calligraphic M in the paper).   The second M is equal to 3 since the
% mode can take three different states = {1=normal,2=boom,3=slump}.
% 

% Three Diferent Situations

M=3;

% r_k=1, normal situation
% example: A{3,2}(1,1)=A{i,l}(i,j) modo i=2, l=3, is the element (1,1) of the matriz A^3(2).

A{1,1} = [0 1;-2.6 3.3];
A{2,1} = [0 1;-2.4 3.1];

B{1,1} = [0; 1];
%B{2,1} = [0.478; 1];  % Just vale works for Z and W
B{2,1} = [0.46; 1];
%B{2,1}=[0;0.5];

mathQ{1}=dq*eye(2);

mathR{1}=dr*eye(1);

% r_k=2 "boom" ------------------------------------------------------

A{1,2} = [0 1;-4.4 4.6];
A{2,2} = [0 1;-4.2 4.4];

B{1,2} = [0; 1];
B{2,2} = [0; 1];
%B{2,2} = [0.02; 1];

mathQ{2}=dq*eye(2);

mathR{2}=dr*eye(1);

% r_k=3 ---------- "slump" ----------------------------------------------------

A{1,3} = [0 1;5.4 -5.3];
A{2,3} = [0 1;5.2 -5.1];

B{1,3} = [0; 1];
B{2,3} = [0; 1];
%B{2,3} = [0.01; 1];

mathQ{3}=dq*eye(2);

mathR{3}=dr*eye(1);

% vertices of P

% T is the number of vertices of the polytopic set for the transition
% probability.   In the case of the example T is set to 2.

T=2;

P{1}=[0.55 0.23 0.22;0.36 0.35 0.29;0.32 0.16 0.52]; % t=1
P{2}=[0.79 0.11 0.10;0.27 0.53 0.20;0.23 0.07 0.70]; % t=2

% N is the number of the predicted control strategy. In the case of the
% example in the paper N is set to 3. 

N=1;

