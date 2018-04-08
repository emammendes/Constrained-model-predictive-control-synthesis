%
% Paper ---  Constrained model predictive control synthesis for
% uncertain discrete-time Markovian jump linear systems, by Jianbo Lu,
% Dewei Li and Yugeng Xi. IET Control Theory and Applications v. 7, Iss. 5,
% pp. 707-719, 2014.
%
%
%
% Rosileide Lopes, Reinaldo Palhares and Eduardo Mendes - 03/24/2018
% DELT - UFMG

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

flagc=0;

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

% Obs.:  Flagc will be active in the file procedure_jianbo_esp.m 

%% Simulation parameters

ksteps=80;fprintf('Simulation size = %d steps\n',ksteps);

umax=1;
xmax=1.5;
if flagc ==1
    fprintf('Maximum allowed control input = %g\n',umax);
elseif flagc == 2
    fprintf('Maximum allowed control input = %g\n',umax);
    fprintf('Maximum vale for the state    = %g\n',xmax);
end

nrep=100;fprintf('Number of replications = %d\n',nrep);


%% Predicted Control Strategy

% N is the number of the predicted control strategy. In the case of the
% example in the paper N is set to 1 or 3. 

N=1;

fprintf('%d-steps ahead will be considered \n',N);

disp('*******************************************************************');

%% Initial Conditions and modes

% Initial state

x=zeros(nx,ksteps);

x(:,1) = ones(nx,1);
xk=x(:,1);

flagx = 0;   % If flagx = 0  the CIs above will be used.  If it is equal to 1, the CIs are randomly chosen.

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
    
    ccontrol_orig = zeros(nrep,1); % Total Control Cost of the original method
    
    x_orig=[];
    
    u_orig=[];
    
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
        
        infoSolver_orig{1,mc}='Initial';
        
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
            % Plot results
            plot_figure_sim(1,1,x,u,r,cc_orig)
            drawnow;
            ccontrol_orig(mc)=cc_orig;
            x_orig=[x_orig x'];
            u_orig=[u_orig u'];
            mc=mc+1;
        else
            mc_failure=[mc_failure mcseed];
            x_failure=[x_failure xk];
            r_failure=[r_failure rk];
        end
        
        mcseed=mcseed+1;
        
    end
    
    %% Mean and Standard deviation for the states
    
    x_orig_mean=[];
    
    x_orig_std=[];
    
    for i=1:nx
        x_orig_mean=[x_orig_mean mean(x_orig(:,i:nx:size(x_orig,2)),2)];
        x_orig_std=[x_orig_std 2*std(x_orig(:,i:nx:size(x_orig,2))')'];
    end
    
    %% Mean and Standard deviation for the input
    
    u_orig_mean=mean(u_orig,2);
    u_orig_std=2*std(u_orig')';
    
    %% Save the results of the simulation
    
    fcost_orig{iparb}=mean(ccontrol_orig);
    
    finfoSolver_orig{iparb}=infoSolver_orig;
    
    fx_orig_mean{iparb}=x_orig_mean;
    
    fx_orig_std{iparb}=x_orig_std;
    
    fu_orig_mean{iparb}=u_orig_mean;
    
    fu_orig_std{iparb}=u_orig_std;
    
end

%% Failures

fprintf('\nNumber of failures = %d of %d attempts, %d successful replications\n',mcseed-mc,mcseed-1,nrep)


%% Plot some important variables

% State

tfig=2;

figure(tfig);plot(1:nrep,ccontrol_orig,'*',1:nrep,mean(ccontrol_orig)*ones(1,nrep),'r-');
if flagc == 1
    title(sprintf('Average control cost = %g for N=%d - Input Constraint',mean(ccontrol_orig),N));
elseif flagc == 2
    title(sprintf('Average control cost = %g for N=%d - Input and State Constraints',mean(ccontrol_orig),N));
else
    title(sprintf('Average control cost = %g for N=%d',mean(ccontrol_orig),N));
end
xlabel('Number of replications');

linS = {'--','-','--'};
linC = {'r','k','r'};

for i=1:nx
    tfig=tfig+1;
    figure(tfig);
    %subplot(3,1,1);
    %vec=[(x_orig_mean(:,i)-x_orig_std(:,i)) x_orig_mean(:,i) (x_orig_mean(:,i)+x_orig_std(:,i))];
    vec=[min(x_orig(:,i:nx:end),[],2) x_orig_mean(:,i) max(x_orig(:,i:nx:end),[],2)];
    for j=1:3
        plot(vec(:,j),'LineStyle',linS{j},'Color',linC{j});hold on;
    end
    ylabel(sprintf('x_%d(t)',i));title('Original');
    title(sprintf('State Path for N=%d bounded by the maximum and minimum paths',N));
    xlabel('Number of steps');
    hold off;
end

% Input

tfig=tfig+1;

figure(tfig);
vec1=[min(u_orig,[],2) u_orig_mean max(u_orig,[],2)];
for i=1:size(vec1,2)
    plot(vec1(:,i),'LineStyle',linS{i},'Color',linC{i});hold on;
end
ylabel('u(t)');title(sprintf('Average Control effort over %g replications bounded by the maximum and minimum paths',nrep));
%ylim([min([min(min(vec1)) min(min(vec2)) min(min(vec3))]) max([max(max(vec1)) max(max(vec2)) max(max(vec3))])]);
xlabel('Number of steps');
hold off;

%% Initial conditions for the state if randomly chosen

if flagx > 0
    tfig=tfig+1;
    figure(tfig);
    plot(x_orig(1,1:2:end),x_orig(1,2:2:end),'*');
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
            s=sprintf('images/image_%d_u_constraint_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/image_%d_u_constraint_N_%d_nrep_%d.png',i,N,nrep);
        end
    elseif flagc == 2
        if flagx 
            s=sprintf('images/image_%d_u_and_x_constraints_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/image_%d_u_and_x_constraints_N_%d_nrep_%d.png',i,N,nrep);
        end
    else
        if flagx 
            s=sprintf('images/image_%d_no_constraints_N_%d_nrep_%d_random.png',i,N,nrep);
        else
            s=sprintf('images/image_%d_no_constraints_N_%d_nrep_%d.png',i,N,nrep);
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
    s=sprintf('data/data_jianbo_u_constraint_N_%d_nrep_%d_umax_%g.mat',N,nrep,umax);
elseif flagc == 2
    s=sprintf('data/data_jianbo_u_and_x_constraints_N_%d_nrep_%d_umax_%g_xmax_%g.mat',N,nrep,umax,xmax);
else
    s=sprintf('data/data_jianbo_no_constraints_N_%d_nrep_%d.mat',N,nrep);
end

save_results_simulation
