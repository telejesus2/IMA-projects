function [ newImage ] = slic( I, K, MaxIter, m )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% k doit etre un carre parfait
sqrk=sqrt(K);

s=size(I);
S=s(1)/sqrk;
S=floor(S);

d=zeros(s);   %& distance
d(1:s(1),1:s(2))=-1;
L=zeros(s);   % labels
L(1:s(1),1:s(2))=-1;

% initaliser les clusters

clusters=zeros(K,3);
x0=floor(S/2);
y0=floor(S/2);
for i=1:sqrk
    for j=0:sqrk-1
        clusters(i+j*sqrk,1)=x0+(i-1)*S;
        clusters(i+j*sqrk,2)=y0+j*S;
        clusters(i+j*sqrk,3)=I(clusters(i+j*sqrk,1),clusters(i+j*sqrk,2));
    end
end


p=0;
while(p<MaxIter)
    for k=1:K
        xk=clusters(k,1);
        yk=clusters(k,2);
        
        for i=xk-S:xk+S
            for j=yk-S:yk+S
                if (i>=1 && i<=s(1) && j>=1 && j<=s(2))
             
                    dc=sqrt((clusters(k,3)-I(i,j))^2);
                    ds=sqrt((i-xk)^2+(j-yk)^2);
                    D=sqrt(dc^2+((ds*m)/S)^2);
                    
                    if (D<d(i,j) || d(i,j)<0)
                        d(i,j)=D;
                        L(i,j)=k;
                    end
                end
            end
        end
    end
    
    %calcul de nouveaux clusters 
    for i=1:K, 
        
        x=0;
        y=0;
        color=0;
        n=0;
        
        for l=1:s(1)
            for t=1:s(2)
                if L(l,t)==i
                    x=x+l;
                    y=y+t;
                    color=color+I(l,t);
                    n=n+1;
                end
            end
        end
        clusters(i,1)=floor(x/n);
        clusters(i,2)=floor(y/n);
        clusters(i,3)=color/n;
    end   
    p=p+1;
end

% forcer connectivite

for k=1:K
end


newImage=zeros(s);
for i=1:s(1),
for j=1:s(2), 
  %newImage(i,j)=clusters(L(i,j),3);
  newImage(i,j)=L(i,j);
end
end




end

