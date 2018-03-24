# Constrained-model-predictive-control-synthesis

Constrained-model-predictive-control-synthesis is an attempt to implement the ideas liad out in the paper Lu, J., D. Li and Y. Xi (2013). "Constrained model predictive control synthesis for uncertain discrete-time Markovian jump linear systems." IET Control Theory & Applications 7(5): 707-719.

A matlab code is provided that uses Yalmip with sedumi or mosek. It is assumed that all the necessary packages are already installed in the MATLAB environment. If not you can uncomment a few lines in the main script and change them accordingly.


## The MATLAB mfiles

### The main script

The main script is the file "Example_Constrained".

Just type the name after the prompt and the script will take care of running the example given in the paper.

Please remember to set the path for yalmip, sedumi or mosek before calling it. On the script you will find the following lines:

addpath(genpath('~/Documents/MATLAB/yalmip'))

addpath(genpath('~/Documents/MATLAB/cvx/sedumi'))

addpath(genpath('~/Documents/MATLAB/cvx/sdpt3'))

addpath(genpath('~/mosek/8/toolbox/r2014a'));

Please change them accordingly.

## Some useful information

All the LMIs are coded using a string variable and then convert to LMIs.  For instance if the content of LMI 21 needs to be checked, just issue the following command after the matlab prompt

>> auxm21

and you will see

auxm21 =

  2×2 cell array

    'G(:,:,n,i)'+G(:,:,n,i)-mathW(:,: ...'    '(A{l,i}*G(:,:,n,i)+B{l,i}*Y(:,:, ...'
    '(A{l,i}*G(:,:,n,i)+B{l,i}*Y(:,:, ...'    'mathW(:,:,min(N,n+1),j);'          

The sdpvar version of the same LMI can be found in the variable m21 which is a cell array. LMI 21 is pilled up in the variable called biglmi21.

The same rationale is used for all other LMIs, that is, LMI 11, LMI 15, LM 16, LMI 20, LMI 21, LMI 23, LMI 25 (two parts)

The m code is commented as much as possible.

If you find any mistake please let me know.  Thanks.
