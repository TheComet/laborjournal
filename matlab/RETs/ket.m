function K = ket(z,varargin)

%  For z defined as a square root of non-square positive integer.
%  Return partial quotient array for continued fraction of z.

%  Initially, set floor of z as Q(1):
if isempty(varargin), Q=floor(z);
else Q=varargin; end

%  If Q defined from varargin, it must be converted from cell type
if iscell(Q), Q = Q{1}; end

%  tolerance options for fsolve
options = optimset('Display','off','tolfun', 1e-8);

K = [Q];
for i = 1:10
q = fsolve(@(x) z-HnKnv([K x]),2*K(1),options);
q = floor(q);

K = [K q];
if q == 2*K(1), break, end;
end
end

function [qd,Qn] = HnKnv(A)

%   Receives a row vector of partial quotients, A=[a1;a2,a3,...,an]
%   Returns approximate value of the simple continued fraction (from A)

iL=length(A);
HK = [1 0 ; 0 1];  Qn=[];

%   Matrix Multiplication method; as in "bdac" form
for i=1:iL
    an = A(i);
    if iscell(an), an = an{1}; end
    HK=HK*[an(1) 1 ; 1 0];
    Qn=[Qn,[HK(1);HK(2)]];
end

qd=double(HK(1,1)/HK(2,1));
end