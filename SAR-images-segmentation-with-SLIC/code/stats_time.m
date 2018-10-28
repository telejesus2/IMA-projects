function [out] = stats_time(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x=size(A);
out=zeros(x(1),x(2));

im=zeros(x(1)+2,x(2)+2,x(3));
for n=1:x(3)
    im(2:x(1)+1,2:x(2)+1,n)=abs(A(:,:,n));
end
    
for k=1:x(1),
   for l=1:x(2),
       mean1=0;  
       mean2=0;
       denominateur=0;
       for n=1:x(3),
            for p=-1:1
                for t=-1:1
                   a=im(k+1+p,l+1+t,n);
                   if(a~=0)
                        denominateur=denominateur+1;
                        mean2=mean2+a^4;
                        mean1=mean1+a^2;
                   end
                end
            end
       end
       mean2=mean2/denominateur;
       mean2=sqrt(mean2);
       mean1=mean1/denominateur;
       ecarttype=sqrt(mean2^2 - mean1^2);
       out(k,l)=ecarttype./mean1;
   end
end

end

