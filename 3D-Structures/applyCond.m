function [vL,vR,uR] = applyCond(n_i,n_dof,fixNod)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i      Number of DOFs per node
%                  n_dof    Total number of DOFs
%   - fixNod  Prescribed displacements data [Npresc x 3]
%              fixNod(k,1) - Node at which the some DOF is prescribed
%              fixNod(k,2) - DOF (direction) at which the prescription is applied
%              fixNod(k,3) - Prescribed displacement magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each displacement is prescribed.

vR = zeros(1,size(fixNod,1));

for a=1:size(fixNod,1)
 
    vR(1,a) = n_i*fixNod(a,1)-(n_i-fixNod(a,2));

end

vL=setdiff(1:n_dof,vR);


uR=fixNod(:,3).';

end



% i=1;
% for b=1:n_dof
%     
%     k=find(vR==b, 1);
%     p=isempty(k); %p=1 si n_dof no aparece en vR | p=0 si n_dof sí aparece en vR
%     
%     if (p==1)
%         vL(i,1)=b;
%         i=i+1;  
%     end
%      
% end