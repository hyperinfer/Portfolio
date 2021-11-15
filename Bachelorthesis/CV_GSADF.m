%**************************************************************************
%   "Testing for Multiple Bubbles" by Phillips, Shi and Yu (2011)
    
%   In this program, we calculate critical values for the generalized sup 
%   ADF statistic.
% *************************************************************************


clear all
close all
clc

format short

qe=[0.90;0.95;0.99];

tic;

m=2000;
T=573;            % change your sample size here
r0=0.01+1.8/sqrt(T);
swindow0=floor(r0*T);       % change your minimum window size here

 
dim=T-swindow0+1;



%% %%%% DATA GENERATING PROCESS %%%%%%
SI=1;
randn('seed',SI);   
e=randn(T,m); 
a=T^(-1);
y=cumsum(e+a);


%% THE GENERALIZED SUP ADF TEST %%%%%%

gsadf=ones(m,1);  
parfor j=1:m; 
    sadfs=zeros(dim,1); 
    for r2=swindow0:1:T;
        dim0=r2-swindow0+1;
        rwadft=zeros(dim0,1);
        for r1=1:1:dim0; 
            rwadft(r1)= ADF_FL(y(r1:r2,j),1,2);  % two tail 5% significant level
        end;  
        sadfs(r2-swindow0+1)=max(rwadft);
    end;
    gsadf(j)=max(sadfs);
end;

toc;


quantile_gsadf=quantile(gsadf,qe);

%%
writematrix(gsadf,'CV_Australien.xlsx');
