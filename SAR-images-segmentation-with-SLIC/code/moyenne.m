function [ out ] = moyenne(A , N )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
I=moyenne_L2(A);
x=size(I);
out=zeros(x(1),x(2));

im=zeros(x(1)+2*N,x(2)+2*N);
im(2+N-1:x(1)+N,2+N-1:x(2)+N)=abs(I);

for k=1:x(1),
   for l=1:x(2),
       mean=0;
       denominateur=0;
            for p=-N:N
                for t=-N:N
                    a=im(k+N+p,l+N+t);
                    if (a~=0)
                        denominateur=denominateur+1;
                        mean=mean+a^2;
                    end
                end
            end
       mean=mean/denominateur;
       out(k,l)=sqrt(mean);
   end
end

end

