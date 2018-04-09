%% Script - An attempt (with failure) to use yalmip plot to get the feasible region

clear all;close all;clc;

%% Call yalmpi and solvers - This is an example - I am running Matlab on a mac.

addpath(genpath('~/Documents/MATLAB/yalmip'))
addpath(genpath('~/Documents/MATLAB/cvx/sedumi'))
addpath(genpath('~/Documents/MATLAB/cvx/sdpt3'))
addpath(genpath('~/mosek/8/toolbox/r2014a'));

%% Define Constants

flagc=1;

disp('*******************************************************************');
disp('*                                                                 *');
disp('*                   Dr. Lu''s procedure                             *');
disp('*                                                                 *');
disp('*******************************************************************');
disp('');

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

disp('');
disp('Feasible Region using plot - lmilab is recommended but mosek works');
disp('');
disp('*******************************************************************');
disp('');


opts = sdpsettings('verbose',1, 'warning',1,'solver','mosek');

model_parameters_jianbo

nq=nx;
nr=nu;

umax=1;
xmax=0.7;

rk=1;

N=1;

define_lmi_variables_jianbo

xk=sdpvar(2,1);

B{2,1}=[0.9;1];

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
    %LMIs_jianbo=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi25,biglmi25_1];
    LMIs_jianbo=[biglmi20;biglmi21;biglmi23;biglmi25;biglmi25_1];
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
    LMIs_jianbo=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi24;biglmi25,biglmi25_1;biglmi26,biglmi26_1];
else % unconstrained
    LMIs_jianbo=[biglmi11;biglmi15;biglmi16];
end

%% Plot

tfig=0;
tfig=tfig+1;
figure(tfig);
plot(LMIs_jianbo,xk,'b',[],opts);
if flagc == 1
    title(sprintf('Feasible Region - Input constraint with u_{max} = %g',umax));
else
    title(sprintf('Feasible Region - Input and State constraints with u_{max} = %g and x_{max} = %g',umax,xmax));
end
xlabel('x_1(0)');ylabel('x_2(0)');


%% Images

% if exist('images','dir') ~= 7 % Please see help for exist
%     mkdir('images')
% end
% 
% for i=1:tfig
%     if flagc == 1
%         s=sprintf('images/feasregp_jianbo_%d_u_constraint_N_%d_umax_%g.png',i,N,umax);
%     elseif flagc == 2
%         s=sprintf('images/feasregp_jianbo_%d_u_and_x_constraints_N_%d_umax_%g_xmax_%g.png',i,N,umax,xmax);
%     else
%         s=sprintf('images/feasregp_jianbo_%d_no_constraints_N_%d.png',i,N);
%     end
%     figure(i);
%     print(s,'-dpng');
% end

