function plot_figure_sim(flag,tfig,x,u,r,ccost)
% fucntion plot_figure_sim plots the results of a simulation
%
% On entry
%
% flag - flag that determines whether the figure will be plotted or
% not.
% tfig - number of the figure where the results will be plotted
% x - line vector with the states
% u - vector with control signal
% r - model (cell)
% ccost - total control cost
% 
% Example
% plot_figure_sim(1,1,x,u,r,cc_orig)

% Eduardo Mendes - 09/30/2017
% DELT - UFMG

y=x';  % Not needed but ...

[a,nx]=size(y);

if flag
    figure(tfig);
    subplot(3,1,1);
    plot(x');title(sprintf('State path - Total Control Cost = %g',ccost));xlabel('Number of steps');ylabel('Amplitude');
    hold on;
    plot(x','r*');
    s=sprintf('legend(''x_{1}(k)''');
    for i=2:nx
        s=sprintf('%s,''x_{%d}(k)''',s,i);
    end
    s=sprintf('%s);',s);
    eval(s);
    hold off;
    subplot(3,1,2);
    plot(u);title('Input path');xlabel('Number of steps');ylabel('Amplitude');
    hold on;
    plot(u,'*r');
    hold off;
    subplot(3,1,3);
    stem(cell2mat(r));title('Mode path');xlabel('Number of steps');ylabel('State');
end