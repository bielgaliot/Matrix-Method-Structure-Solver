function [u,R] = solveSys(vL,vR,uR,KG,Fext)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

KLL=KG(vL,vL);
KLR=KG(vL,vR);
KRL=KG(vR,vL);
KRR=KG(vR,vR);
FextL=Fext(vL);
FextR=Fext(vR);


uL=KLL\(FextL-KLR*uR.');
Rr=KRR.'*uR.'+KRL*uL-FextR;

u(vL,1)=uL;
u(vR,1)=uR;

R(vL,1)=0;
R(vR,1)=Rr;
end