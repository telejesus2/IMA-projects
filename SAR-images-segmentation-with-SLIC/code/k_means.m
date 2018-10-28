function [ newImage ] = k_means( I, K, MaxIter )
%K_MEANS Summary of this function goes here
%   Detailed explanation goes here

I=abs(I);
I=double(I);
im=I(:);
m=floor(max(im))+1;

[hh,bins]=hist(im,m);
ind=find(hh);  % niveaux de gris non nuls qui aparaissent dans l'image

% initialisation de la valeur de chaque classe 
classes=zeros(1,K);
a=0;
total=length(im);
j=1;
for i=1:length(ind)
    a=a+hh(ind(i));
    if (a/total>j/(K+1))
        classes(j)=ind(i);
        j=j+1;
    end
    if (j==K+1)
        break
    end
end

l=length(hh);
hc=zeros(1,l);

j=0;
while(j<MaxIter)
  for i=1:length(ind)              
      c=abs(ind(i)-classes);
      cc=find(c==min(c));
      hc(ind(i))=cc(1);         % hc contient la classe la plus proche de chaque niveau de gris
  end
  %calcul de nouvelles classes  
  for i=1:K, 
      a=find(hc==i);   % a contient les niveaux de gris qui feront partie de la classe i
      d=classes(i);
      classes(i)=sum(a.*hh(a))/sum(hh(a)); % calcul de la nouvelle moyenne 
      if (isnan(classes(i)))
        classes(i)=d;
      end   
  end
  j=j+1; 
end

% calcul de la nouvelle image
s=size(I);
newImage=zeros(s);
for i=1:s(1),
for j=1:s(2),
  c=abs(I(i,j)-classes);
  cc=find(c==min(c));  
  newImage(i,j)=classes(cc(1));
end
end

end

