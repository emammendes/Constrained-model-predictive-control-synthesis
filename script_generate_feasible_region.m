%% Script - An attempt (with failure) to use yalmip plot to get the feasible region

clear all;close all;clc;

%% Call yalmpi and solvers - This is an example - I am running Matlab on a mac.

addpath(genpath('~/Documents/MATLAB/yalmip'))
addpath(genpath('~/Documents/MATLAB/cvx/sedumi'))
addpath(genpath('~/Documents/MATLAB/cvx/sdpt3'))
addpath(genpath('~/mosek/8/toolbox/r2014a'));

%% Define Constants

flagc=0;

disp('***********************************************');

if flagc == 1
    disp('A Constrained problem will be solved');
    disp('');
    disp('LMIs 11, 15, 16, 20, 21, 23 and 25 will be used');
elseif flagc == 2
    disp('A Constrained problem will be solved');
    disp('');
    disp('LMIs 11, 15, 16, 20, 21, 23, 24, 25 and 26 will be used');
else
    disp('An unconstrained problem will be solved');
    disp('');
    disp('LMIs 11, 15 and 16 will be used');
end

opts = sdpsettings('verbose',0, 'warning',1,'solver','mosek');

model_parameters_jianbo

nq=nx;
nr=nu;

umax=1;
xmax=1;

rk=1;

N=1;

define_lmi_variables_jianbo

xk=sdpvar(2,1);

Obj=gamma_1+gamma_2;

%% LMI 11

pre_build_lmi11_jianbo
actual_build_lmi11_jianbo

%% LMI 15

pre_build_lmi15_jianbo
actual_build_lmi15_jianbo

%% LMI 16

pre_build_lmi16_jianbo
actual_build_lmi16_jianbo

%% Big LMI

if flagc == 1 % Constrained on the input
    pre_build_lmi20_jianbo
    actual_build_lmi20_jianbo
    pre_build_lmi21_jianbo
    actual_build_lmi21_jianbo
    pre_build_lmi23_jianbo
    actual_build_lmi23_jianbo
    pre_build_lmi25_jianbo
    actual_build_lmi25_jianbo
    LMIs_orig=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi25,biglmi25_1];
elseif flagc == 2 % Constrained on the input and states
    pre_build_lmi20_jianbo
    actual_build_lmi20_jianbo
    pre_build_lmi21_jianbo
    actual_build_lmi21_jianbo
    pre_build_lmi23_jianbo
    actual_build_lmi23_jianbo
    pre_build_lmi24_jianbo
    actual_build_lmi24_jianbo
    pre_build_lmi25_jianbo
    actual_build_lmi25_jianbo
    pre_build_lmi26_jianbo
    actual_build_lmi26_jianbo
    LMIs_orig=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi24;biglmi25,biglmi25_1;biglmi26,biglmi26_1];
else % unconstrained
    LMIs_orig=[biglmi11;biglmi15;biglmi16];
end


plot(LMIs_orig,xk,[],[],opts);
