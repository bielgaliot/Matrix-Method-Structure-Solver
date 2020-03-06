function Td = connectDOFs(n_el,n_nod,n_i,Tn)


Td = zeros(n_el,n_nod*n_i);


for e=1:n_el
    for a=1:n_nod
        for j=1:n_i
        i=n_i*(a-1)+j;    
        Td(e,i) = n_i*(Tn(e,a)-1)+j;
        end
    end
end
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el     Total number of elements
%                  n_nod    Number of nodes per element
%                  n_i      Number of DOFs per node
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering.



end