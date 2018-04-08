%% Feasible Region - Brute Force
%
% Paper ---  Constrained model predictive control synthesis for
% uncertain discrete-time Markovian jump linear systems, by Jianbo Lu,
% Dewei Li and Yugeng Xi. IET Control Theory and Applications v. 7, Iss. 5,
% pp. 707-719, 2014.
%
%
% Rosileide Lopes, Reinaldo Palhares and Eduardo Mendes - 03/24/2018
% DELT - UFMG
%
% Obs.: Unfortunately I could not figure out how to use plot to get the
% feasible region.

%% Cleaning the variables

clear;
close all;
clc;

%% Call yalmpi and solvers - This is an example - I am running Matlab on a mac.

addpath(genpath('~/Documents/MATLAB/yalmip'))
addpath(genpath('~/Documents/MATLAB/cvx/sedumi'))
addpath(genpath('~/Documents/MATLAB/cvx/sdpt3'))
addpath(genpath('~/mosek/8/toolbox/r2014a'));


%% To monitor the results

gammav(:,1)=[NaN;NaN];   % No solver as yet.


%% Call the example.  In this case, the example is the one given in Jianbo's paper

% Many parameters can be found there

model_parameters_jianbo

%% Options Solver

opts = sdpsettings('verbose',0, 'warning',1,'solver','mosek');

%% Set flag for constrained or unconstrained simulations

% if flagc = 0 an unconstrained problem will be solved
% if flagc = 1 a constrained problem adding LMIs 20, 21, 23 e 25 will be solved.
% if flagc = 2 a constrained problem adding LMIs 20, 21, 23, 24, 25 e 25 will be solved

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


% Obs.:  Flagc will be active in the file procedure_jianbo_esp.m 

%% Simulation parameters

ksteps=1;fprintf('For the feasible region just %d step is needed\n',ksteps);

umax=1;
xmax=3;  % xmax=1.5;
if flagc ==1
    fprintf('Maximum allowed control input = %g\n',umax);
elseif flagc == 2
    fprintf('Maximum allowed control input = %g\n',umax);
    fprintf('Maximum vale for the state    = %g\n',xmax);
end

nrep=2000;fprintf('Number of replications = %d\n',nrep);


%% Predicted Control Strategy

% N is the number of the predicted control strategy. In the case of the
% example in the paper N is set to 1 or 3. 

N=1;

fprintf('%d-steps ahead will be considered \n',N);

disp('***********************************************');

%% Initial Conditions and modes

% Initial state

x=zeros(nx,ksteps);

x(:,1) = ones(nx,1);
xk=x(:,1);

flagx = 1;   % If flagx = 0  the CIs above will be used.  If it is equal to 1, the CIs are randomly chosen.

% Initial Mode

r{1}=1;
rk=r{1};  % I did not need to do that but it makes debug somehow easier

flagr = 0;   % Meaning that I will be using the CIs above.  If it is equal to 1, the CIs are randomly chosen.

%  I have just added the following in case I need to change the matrix B in
%  the example. parb=[0.0] which is the value in the paper.

parb=[0.0];% 0.4 0.45 0.46 0.47 0.475 0.476 0.477 0.478 0.478 0.479 0.48 0.49 0.5 0.6 0.7 0.8 0.9 1.0]; % values of the parameter b

%% Main Loop

for iparb=1:length(parb)
    
    B{2,1}=[parb(iparb);1];
    
    disp(' ');
    fprintf('Simulation for B{2,1}=[%g;1]\n',parb(iparb));
    disp(' ');
    
    ccontrol_jianbo = zeros(nrep,1); % Total Control Cost of the original method
    
    x_jianbo=[];
    
    u_jianbo=[];
    
    mc=1;
    
    mcseed=1;
    
    mc_failure=[];
    
    x_failure=[];
    
    r_failure=[];
    
    while mc <= nrep
        
        disp(' ');
        fprintf('Replication #%g\n',mc);
        disp(' ');
        
        % Save solver info
        
        infoSolver_jianbo{1,mc}='Initial';
        
        % Just to be sure that uk is not feasible and it is the replication is
        % not taken into account
        
        flagfeas=1;   % Assuming Feasible solution
        
        % Set the seed
        
        rng(mcseed,'twister');  % I know what the seed is
        
        % Initial state
        
        if ~flagx 
            x(:,1) = ones(nx,1);
        else
            x(:,1)=unifrnd(-xmax,xmax,nx,1);
        end
        
        xk=x(:,1);
        
        % Initial input
        
        u=zeros(nu,ksteps);
        
        % Initial Mode
        
        if ~flagr
            r{1}=1;
        else
            r{1}=unidrnd(3);
        end
        
        rk=r{1};  % I did not need to do that but it makes debug somehow easier
        
        % Jianbo's ideas are implemented in the following script
        
        procedure_jianbo_esp
        
        % If there is no problem with the solution do
        
        if flagfeas
            ccontrol_jianbo(mc)=cc_jianbo;
            x_jianbo=[x_jianbo x'];
            u_jianbo=[u_jianbo u'];
            mc=mc+1;
        else
            mc_failure=[mc_failure mcseed];
            x_failure=[x_failure xk];
            r_failure=[r_failure rk];
        end
        
        mcseed=mcseed+1;
        
    end
    
    %% Mean and Standard deviation for the states
    
    x_jianbo_mean=[];
    
    x_jianbo_std=[];
    
    for i=1:nx
        x_jianbo_mean=[x_jianbo_mean mean(x_jianbo(:,i:nx:size(x_jianbo,2)),2)];
        x_jianbo_std=[x_jianbo_std 2*std(x_jianbo(:,i:nx:size(x_jianbo,2))')'];
    end
    
    %% Mean and Standard deviation for the input
    
    u_jianbo_mean=mean(u_jianbo,2);
    u_jianbo_std=2*std(u_jianbo')';
    
    %% Save the results of the simulation
    
    fcost_jianbo{iparb}=mean(ccontrol_jianbo);
    
    finfoSolver_jianbo{iparb}=infoSolver_jianbo;
    
    fx_jianbo_mean{iparb}=x_jianbo_mean;
    
    fx_jianbo_std{iparb}=x_jianbo_std;
    
    fu_jianbo_mean{iparb}=u_jianbo_mean;
    
    fu_jianbo_std{iparb}=u_jianbo_std;
    
end

%% Failures

fprintf('\nNumber of failures = %d of %d attempts, %d successful replications\n',mcseed-mc,mcseed-1,nrep)


%% Initial conditions for the state if randomly chosen

tfig=0;

if flagx > 0
    tfig=tfig+1;
    figure(tfig);
    plot(x_jianbo(1,1:nx:end),x_jianbo(1,2:nx:end),'*');
    if flagc == 1
        title(sprintf('Valid initial conditions over %g replications for N = %d - Input constraint',nrep,N));
    else
        title(sprintf('Valid initial conditions over %g replications for N = %d - Input and State constraints',nrep,N));
    end
    xlabel('x_1(0)');ylabel('x_2(0)');
end


%% Images

if exist('images','dir') ~= 7 % Please see help for exist
    mkdir('images')
end

for i=1:tfig
    if flagc == 1
        if flagx 
            s=sprintf('images/feasreg_jianbo_%d_u_constraint_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/feasreg_jianbo_%d_u_constraint_N_%d_nrep_%d.png',i,N,nrep);
        end
    elseif flagc == 2
        if flagx 
            s=sprintf('images/feasreg_jianbo_%d_u_and_x_constraints_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/feasreg_jianbo_%d_u_and_x_constraints_N_%d_nrep_%d.png',i,N,nrep);
        end
    else
        if flagx 
            s=sprintf('images/feasreg_jianbo_%d_no_constraints_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/feasreg_jianbo_%d_no_constraints_N_%d_nrep_%d.png',i,N,nrep);
        end
    end
    figure(i);
    print(s,'-dpng');
end

%% Save results

if exist('data','dir') ~= 7 % Please see help for exist
    mkdir('data')
end

if flagc == 1
    if flagx
        s=sprintf('data/feasreg_jianbo_%d_u_constraint_N_%d_nrep_%d_random.mat',i,N,nrep);
    else
        s=sprintf('data/feasreg_jianbo_%d_u_constraint_N_%d_nrep_%d.mat',i,N,nrep);
    end
elseif flagc == 2
    if flagx
        s=sprintf('data/feasreg_jianbo_%d_u_and_x_constraints_N_%d_nrep_%d_random.mat',i,N,nrep);
    else
        s=sprintf('data/feasreg_jianbo_%d_u_and_x_constraints_N_%d_nrep_%d.mat',i,N,nrep);
    end
else
    if flagx
        s=sprintf('data/feasreg_jianbo_%d_no_constraints_N_%d_nrep_%d_random.mat',i,N,nrep);
    else
        s=sprintf('data/feasreg_jianbo_%d_no_constraints_N_%d_nrep_%d.mat',i,N,nrep);
    end
end

save_results_simulation


