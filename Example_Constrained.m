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

% Many parameters can be found there, specially N that defines the
% prediction horizon and of course the system itself

model_parameters_jianbo

%% Options Solver

opts = sdpsettings('verbose',0, 'warning',1,'solver','mosek');

%% Set flag for constrained or unconstrained simulations

% if flagc = 1 constrained else unconstrained

flagc=1; % constrained

disp('***********************************************');

if flagc 
    disp('A Constrained problem will be solved');
    disp('');
    disp('LMIs 11, 15, 16, 20, 21, 23 and 25 will be used');
else
    disp('An unconstrained problem will be solved');
    disp('');
    disp('LMIs 11, 15 and 16 will be used');
end

% Obs.:  Flagc will be active in the file procedure_jianbo_esp.m 

%% Simulation parameters

ksteps=80;fprintf('Simulation size = %d steps\n',ksteps);

umax=1;
if flagc 
    fprintf('Maximum allowed control input = %g\n',umax)
end

nrep=100;fprintf('Number of replications = %d\n',nrep);

fprintf('%d-steps ahead will be considered \n',N);

disp('***********************************************');

%% Initial Conditions and modes

% Initial state

x=zeros(nx,ksteps);

x(:,1) = ones(nx,1);
xk=x(:,1);

flagx = 0;   % Meaning that I will be using the CIs above.  If it is equal to 1, the CIs are randomly chosen.

% Initial input

u=zeros(nu,ksteps);

CIu=0.22;

u(:,1)=CIu;

flagu = 0;   % Meaning that I will be using the CIs above.  If it is equal to 1, the CIs are randomly chosen.

flagu = 0;

% Initial Mode

r{1}=1;
rk=r{1};  % I did not need to do that but it makes debug somehow easier

flagr = 0;   % Meaning that I will be using the CIs above.  If it is equal to 1, the CIs are randomly chosen.

%  The prediction horizon is set in the file model_parameteres_jianbo.m

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
    
    while mc <= nrep
        
        disp(' ');
        fprintf('Replication #%g\n',mc);
        disp(' ');
        
        % Save solver info
        
        infoSolver_orig{1,mc}='Initial';
        
        % Just to be sure that uk is not NaN and it is the replication is
        % not taken into account
        
        flaguk=0;
        
        % Set the seed
        
        rng(mcseed,'twister');  % I know what the seed is
        
        % Initial state
        
        if ~flagx 
            x(:,1) = ones(nx,1);
        else
            x(:,1)=unifrnd(-1,1,nx,1);
        end
        
        xk=x(:,1);
        
        % Initial input
        
        u=zeros(nu,ksteps);
        
        if ~flagu
            u(:,1)=CIu;
        else
            u(:,1)=unifrnd(-umax,umax,nu,1);
        end
        
        % Initial Mode
        
        if ~flagr
            r{1}=1;
        else
            r{1}=unidrnd(3);
            rk=r{1};  % I did not need to do that but it makes debug somehow easier
        end
        
        
        % Jianbo's ideas are implemented in the following script
        
        procedure_jianbo_esp
        
        % If there is no problem with the solution do
        
        if ~flaguk
            % Plot results
            plot_figure_sim(1,1,x,u,r,cc_orig)
            drawnow;
            ccontrol_orig(mc)=cc_orig;
            x_orig=[x_orig x'];
            u_orig=[u_orig u'];
            mc=mc+1;
        else
            mc_failure=[mc_failure mcseed];
        end
        
        mcseed=mcseed+1;
        
        %disp('Here');pause;
        
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

tfig=2;

figure(tfig);plot(1:nrep,ccontrol_orig,'*',1:nrep,mean(ccontrol_orig)*ones(1,nrep),'r-');title(sprintf('Average control cost = %g for N=%d',mean(ccontrol_orig),N));
xlabel('Number of replications');

linS = {'--','-','--'};
linC = {'r','k','r'};

for i=1:nx
    tfig=tfig+1;
    figure(tfig);
    %subplot(3,1,1);
    vec=[(x_orig_mean(:,i)-x_orig_std(:,i)) x_orig_mean(:,i) (x_orig_mean(:,i)+x_orig_std(:,i))];
    for j=1:3
        plot(vec(:,j),'LineStyle',linS{j},'Color',linC{j});hold on;
    end
    ylabel(sprintf('x_%d(t)',i));title('Original');
    hold off;
end

% Average trajectories for the original and modified algorithm

for i=1:nx
    tfig=tfig+1;
    figure(tfig);
    plot(x_orig_mean(:,i));ylabel(sprintf('x_%d(t)',i));legend('Original');
    title(sprintf('Average trajectory over %g replications',nrep));xlabel('Number of steps');
end

% Control

% tfig=tfig+1;
% 
% figure(tfig);
% %subplot(3,1,1);
% vec1=[(u_orig_mean-u_orig_std) u_orig_mean (u_orig_mean+u_orig_std)];
% for i=1:size(vec1,2)
%     plot(vec1(:,i),'LineStyle',linS{i},'Color',linC{i});hold on;
% end
% ylabel('u(t)');title(sprintf('Agerage Control effort over %g replications - Original - one std',nrep));
% %ylim([min([min(min(vec1)) min(min(vec2)) min(min(vec3))]) max([max(max(vec1)) max(max(vec2)) max(max(vec3))])]);
% xlabel('Number of steps');
% hold off;


tfig=tfig+1;

figure(tfig);
vec1=[min(u_orig,[],2) u_orig_mean max(u_orig,[],2)];
for i=1:size(vec1,2)
    plot(vec1(:,i),'LineStyle',linS{i},'Color',linC{i});hold on;
end
ylabel('u(t)');title(sprintf('Agerage Control effort over %g replications - Original - max and min',nrep));
%ylim([min([min(min(vec1)) min(min(vec2)) min(min(vec3))]) max([max(max(vec1)) max(max(vec2)) max(max(vec3))])]);
xlabel('Number of steps');
hold off;


