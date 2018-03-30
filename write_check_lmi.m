function [s,status,result] = write_check_lmi(aux,filename,caption,obs)
% function [s,status,result] = write_check_lmi(aux) is a function that writes a string with
% the information necessary to compile a latex.
%
% On entry
% aux - cell with the lmi
% filename - filename to be created 
% caption -  table caption
% obs - observation 
%
% On return
% s - string with the latex code
% status - status of invoking the system command
% result - result of invoking the system command
%
% Example
%
%  s='$L=2$, $M=3$, $T=2$ and $N=3$';
%  s1='L - polytopic vertices, M - modes, T - Prob vertices and N - steps ahead';
%  write_check_lmi(auxm11,'lmicheck.tex',s,s1)

% Eduardo Mendes - 10/05/2017
% DELT - UFMG

if ((nargin < 1) || (nargin > 4))
    error('write_check_lmi requires 1 to 4 input arguments.');
elseif nargin == 1
    filename='lmicheck.tex';
    caption='LMI';
    obs=' ';
elseif nargin == 2
    filename='lmicheck.tex';
    obs=' ';
elseif nargin == 3
    obs=' ';
end
    
    

[a,b]=size(aux);

% or use the larger caption package

s=char('\documentclass{article}',...
'\usepackage{pdflscape}',...
'\usepackage{afterpage}',...
'\usepackage{capt-of}',...
'\usepackage{longtable,tabu}',...
'\usepackage[pass]{geometry} ',...
'\begin{document}',...
'\afterpage{%',...
'    \clearpage% Flush earlier floats (otherwise order might not be correct)',...
'    \thispagestyle{empty}% empty page style (?)',...
'    \newgeometry{left=4cm,right=0.1cm,bottom=0.1cm,top=0.1cm}',...
'    \normalsize',...
'    \begin{landscape}% Landscape page',...
'        \centering % Center table');
%         \begin{tabular}{llll}
%             A & B & C & D \\
%         \end{tabular}

x='\begin{longtabu} to 1.25\textwidth {';
for i=1:size(aux,2)
    x=sprintf('%s|X[3,l]',x);
end
x=sprintf('%s|}\\hline',x);

%x=sprintf('\\begin{tabularx}{\\linewidth}{X*{%d}{c}}',b);
% x='\begin{tabular}{';
% for j=1:b
%     x=sprintf('%sl',x);
% end
% x=sprintf('%s}',x);
s=char(s,x);

for i=1:size(aux,1)
    x='';
    for j=1:size(aux,2)
        if j < size(aux,2)
            x=sprintf('%s $%s',x,strrep(char(aux{i,j}),';','$ &'));
        else
           x=sprintf('%s $%s',x,strrep(char(aux{i,j}),';','$ \\ \hline'));
        end
    end
    x=sprintf('%s ',x);
    x=strrep(x,'{','_{');
    x=strrep(x,'mathQ','\mathcal{Q}');
    x=strrep(x,'mathR','\mathcal{R}');
    x=strrep(x,'mathW','\mathcal{W}');
    x=strrep(x,'mathU','\mathcal{U}');
    %x=strrep(x,'}','\}');
    s=char(s,x);
end

x=sprintf('\\\\ \\caption{%s}',caption);
s=char(s,x);

s=char(s,...
    '\end{longtabu} ');
%    '\end{tabularx}');
%x=sprintf('\\captionof{table}{%s}',caption);
%s=char(s,x);
s=char(s,obs);
s=char(s,...
    '\end{landscape}',...
    '\clearpage% Flush page',...
'}');
s=char(s, ...
'\end{document}');

% File

fid = fopen(filename,'w');
for i=1:size(s,1)
    fprintf(fid,'%s\n',deblank(s(i,:)));
end
fclose(fid);

% Compile

aux=sprintf('/Library/TeX/texbin/pdflatex %s',filename);
[status,result]=system(aux);



        