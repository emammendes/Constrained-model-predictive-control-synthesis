%% Original Method
%
% Constrained model predictive control synthesis for
% uncertain discrete-time Markovian jump linear systems, by Jianbo Lu,
% Dewei Li and Yugeng Xi. IET Control Theory and Applications v. 7, Iss. 5,
% pp. 707-719, 2014.


%% Yalmip

yalmip('clear');

%% To monitor the results

gammav(:,1)=[NaN;NaN];   % No solver as yet.

%% Define LMI variables

define_lmi_variables_jianbo

%% Build LMI 11

% in order to build a general matrix I need to know the dimensions of
% matrices Q and R

% I need to do this just once since there is no uk and yk in the LMI.

nq=nx;
nr=nu;

pre_build_lmi11_jianbo
actual_build_lmi11_jianbo


%% Pre-Build LMI 15 and 16

% Since LMI 15 and 16 are updated at every step only the string version of them is
% built here

pre_build_lmi15_jianbo
pre_build_lmi16_jianbo


%% Ready for simulation

% State initial conditions

% x(:,1) = [1; 1];
% xk=x(:,1);

% Initial input

% u(1)=0;

% Initial Mode -------------------------------------------

% r{1}=1;
% rk=r{1};  % I did not need to do that but it makes debug somehow easier

% Cost function and options

Obj=gamma_1+gamma_2;

% Horizon

% ksteps=30;

% Control cost

control_cost=zeros(ksteps,1);
control_cost(1)=x(:,1)'*mathQ{1}*x(:,1)+u(1)*mathR{1}*u(1);

% Other variables

elapsed_time=zeros(ksteps,1);
problems=zeros(ksteps,1);

% More LMIS

if flagc == 1 % Constrained on the input
    pre_build_lmi20_jianbo
    pre_build_lmi21_jianbo
    pre_build_lmi23_jianbo
    pre_build_lmi25_jianbo
    
    actual_build_lmi21_jianbo
    actual_build_lmi25_jianbo
else
    if flag == 2
        pre_build_lmi20_jianbo
        pre_build_lmi21_jianbo
        pre_build_lmi23_jianbo
        pre_build_lmi24_jianbo
        pre_build_lmi25_jianbo
        pre_build_lmi26_jianbo
        
        actual_build_lmi21_jianbo
        actual_build_lmi25_jianbo
        actual_build_lmi26_jianbo
    end
end

% Main Loop

for k=1:ksteps
    
    if k > 1 % For k =1 xk and rk are already chosen
        
        % Call script to choose matrices and model
        
        % script_choose_matrices_mode
        
        alphaS = rand(1,L); alphaS = alphaS/sum(alphaS); % L is the number of vertices of the system matrices
        alphaP = rand(1,T); alphaP = alphaP/sum(alphaP); % T is the number of vertices of the Probability matrix
        
        A_alpha{k-1}=alphaS(1)*A{1,r{k-1}};
        B_alpha{k-1}=alphaS(1)*B{1,r{k-1}};
        
        for kk=2:length(alphaS)
            A_alpha{k-1}=A_alpha{k-1}+alphaS(kk)*A{kk,r{k-1}};
            B_alpha{k-1}=B_alpha{k-1}+alphaS(kk)*B{kk,r{k-1}};
        end
        
        P_alpha{k-1}= alphaP(1)*P{1};
        
        for kk=2:length(alphaP)
            P_alpha{k-1}=P_alpha{k-1}+alphaP(kk)*P{kk};
        end
        
        % Second Step - Run the system considering that mode is already given.
        
        x(:,k) = A_alpha{k-1}*x(:,k-1) + B_alpha{k-1}*u(k-1);
        xk=x(:,k); % I did not need to do that but it makes debug somehow easier
        
        % Third step - Choose the next mode
        r{k}=genmarkovs(P_alpha{k-1},r{k-1});
        
        rk=r{k}; % I did not need to do that but it makes debug somehow easier
        
        %fprintf('Value of uk = %g at step %d \n',double(uk),k);
        
    end
    
    
    % Update LMIs 15, 16 and 20 using the string version of the LMIs
    
    actual_build_lmi15_jianbo
    actual_build_lmi16_jianbo
    
    if flagc == 1 % Constrained on the input
        actual_build_lmi20_jianbo
        actual_build_lmi23_jianbo
        actual_build_lmi25_jianbo
        LMIs_orig=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi25,biglmi25_1];
    elseif flagc == 2 % Constrained on the input and states
        actual_build_lmi20_jianbo
        actual_build_lmi23_jianbo
        actual_build_lmi24_jianbo
        actual_build_lmi25_jianbo
        actual_build_lmi26_jianbo
        LMIs_orig=[biglmi11;biglmi15;biglmi16;biglmi20;biglmi21;biglmi23;biglmi24;biglmi25,biglmi25_1;biglmi26,biglmi26_1];
    else % unconstrained
        LMIs_orig=[biglmi11;biglmi15;biglmi16];
    end
    
    sol = optimize(LMIs_orig,Obj,opts);
    
    %[primal, ~] = checkset(LMIs_orig);
    
    elapsed_time(k) = sol.solvertime;
    
    problems(k)=sol.problem;
    
    infoSolver_orig{k,mc}=sol.info;
    
    % The following test is temporary.  I need to find what is wrong if the
    % implementation before testing the LMIs
    
    %     if sol.problem == 0
    %         fprintf('#%d - Successfully solved\n',k);
    %     elseif sol.problem == 3
    %         fprintf('#%d - Maximum #iterations or time-limit exceeded\n',k);
    %     elseif sol.problem == 4
    %         fprintf('#%d - Numerical problems\n',k);
    %     elseif sol.problem == 5
    %         fprintf('#%d - Lack of progress\n',k);
    %     else
    %         disp('LMI unfeasible');
    %         fprintf('#%d - Aborting process at interation \n',k);
    %         break;
    %     end
    
    % Use the result of the LMI as the new input
    
    u(:,k)=double(uk);
    
    % Control Cost
    
    control_cost(k)=x(:,k)'*mathQ{r{k}}*x(:,k)+u(:,k)*mathR{r{k}}*u(:,k);
    
    %  Gamma
    
    gammav(:,k)=[double(gamma_1);double(gamma_2)];
    
    % Some interesting variables
    
    %      uk
    %      double(mathU)
    
    
    if sol.problem == 1 || flaglmi24 % either a problem with a LMI or with an state inequality
        s='[';
        for ii=1:nx
            s=sprintf('%s %g',s,xk(ii));
        end
        s=[s ']'];
        fprintf('Infeasible LMI at iteration %d for xk=%s\n',k,s);
        flagfeas=0; % Infeasible
        break;
    end
end

%% Overall Control Cost

if flagfeas
    
    cc_orig=sum(control_cost);
    
    fprintf('Jianbo - Total control cost is %g\n',cc_orig);
    
end


