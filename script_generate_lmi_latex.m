%% Script - Create tex files with the LMIs

clear all;close all;clc;

%% Define Constants

% L is the number of vertices of the polytopic set for the system.  In the
% case of the example in the paper L is set to 2

L=2;

% To build the other LMI variables we need to know the dimensions of the system and
% control matrices.  This can be easily achieved by looking at the defintions
% of such matrices. 

nx=2;
nu=1;

%
% Set M is defined as the set of possible states (in Markov sense).   In
% the case of the example M={1,2,3,..M} (Note that the first M is the
% calligraphic M in the paper).   The second M is equal to 3 since the
% mode can take three different states = {1=normal,2=boom,3=slump}.
% 

% Three Diferent Situations

M=3;

% vertices of P

% T is the number of vertices of the polytopic set for the transition
% probability.   In the case of the example T is set to 2.

T=2;


% N is the number of the predicted control strategy. In the case of the
% example in the paper N is set to 3. 

N=3;

%% Define strings for caption and observation

capt=sprintf('$L_{l,h}=%g$, $M_i =%g$, $T_t=%g$ and $N_n=%g$',L,M,T,N);
observ='$L$ (indexes $l$ and $h$) - polytopic vertices, $M$ (index $i$) - modes, $T$ (index $t$) - Probability vertices and $N$ (index $n$) - steps ahead';

%% LMI 11

pre_build_lmi11_jianbo

write_check_lmi(auxm11,'lmicheck_jianbo_lmi11.tex',[capt ' - Jianbo - LMI 11'],observ);

%% LMI 15

pre_build_lmi15_jianbo

write_check_lmi(m15,'lmicheck_jianbo_lmi15.tex',[capt ' - Jianbo - LMI 15'],observ);

%% LMI 16

pre_build_lmi16_jianbo

write_check_lmi(auxm16,'lmicheck_jianbo_lmi16.tex',[capt ' - Jianbo - LMI 16'],observ);

%% LMI 20

pre_build_lmi20_jianbo

write_check_lmi(auxm20,'lmicheck_jianbo_lmi20.tex',[capt ' - Jianbo - LMI 20'],observ);

%% LMI 21

pre_build_lmi21_jianbo

write_check_lmi(auxm21,'lmicheck_jianbo_lmi21.tex',[capt ' - Jianbo - LMI 21'],observ);

%% LMI 23

pre_build_lmi23_jianbo

write_check_lmi(auxm23,'lmicheck_jianbo_lmi23.tex',[capt ' - Jianbo - LMI 23'],observ);

%% LMI 24

pre_build_lmi24_jianbo

write_check_lmi(auxm24,'lmicheck_jianbo_lmi24.tex',[capt ' - Jianbo - LMI 24'],observ);

%% LMI 25

pre_build_lmi25_jianbo

write_check_lmi(auxm25,'lmicheck_jianbo_lmi25.tex',[capt ' - Jianbo - LMI 25 (Part I)'],observ);

write_check_lmi(auxm25_1,'lmicheck_jianbo_lmi25_1.tex',[capt ' - Jianbo - LMI 25 (Part II)'],observ);

%% LMI 26

pre_build_lmi26_jianbo

write_check_lmi(auxm26,'lmicheck_jianbo_lmi26.tex',[capt ' - Jianbo - LMI 26 (Part I)'],observ);

write_check_lmi(auxm26_1,'lmicheck_jianbo_lmi26_1.tex',[capt ' - Jianbo - LMI 26 (Part II)'],observ);

