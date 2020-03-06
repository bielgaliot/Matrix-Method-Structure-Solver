function buckling = assessBuck(sig, sig_max, Tn)

buckling=zeros(size(Tn,1),1);

for e=1:size(Tn,1)
    
    if (abs(sig(e))>abs(sig_max(e))&&(sig(e)<0))
        fprintf('Risk of buckling in element %.0f \n', e);
        buckling(e)=1;
    end
    
end

if buckling(:) == 0
    
      fprintf('There is no risk of buckling \n');

 end
  
end