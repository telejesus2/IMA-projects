function out=moyenne_L2(A)
x=size(A);
out=zeros(x(1),x(2));
for k=1:x(1),
   for l=1:x(2),
       for n=1:x(3),
           out(k,l)=out(k,l)+abs(A(k,l,n))*abs(A(k,l,n));
       end
       out(k,l)=out(k,l)/x(3);
       out(k,l)=sqrt(out(k,l));
   end
end