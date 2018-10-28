function [] = visusar( Ap, valspep )
%procedure visusar : 
%   Pour visualiser une image RSO dans la figure courante
% visusar( Ap, valspep ) : valspe est un nombre positif. Prendre 3 (normal)
% ou 7 (pour cibles)
% si l'on prend la valeur 0, il n'y aura aucun seuillage
%
% Version V2.2016


% Version beta du 17 aout 2015

% Ete 2016 : on élargit l'utilisation de cette procédure à des tableaux
% quelconques
% Tous les calculs sont plus ou moins en double



if nargin == 0
  error('You have to specify a image/matrix !');
end;
if nargin > 2
  error('You have to specify only a image/matrix and a threshold !');
end;

if size(Ap,1)<2
    error('Your image/matrix is too small!');
end

valspe=3.;
if nargin == 2
  valspe=valspep;
end;

if isreal(Ap) == 1
    A=Ap;
else
    A = abs(double(Ap));
end


xmin=min(A(:));
xmax=max(A(:));
xmean=mean2(A);
xstd=std2(A);
xseuil=xmean+valspe*xstd;
if valspe==0
    xseuil=xmax;
end
if xseuil<xmax
    titre=sprintf('Image seuillee : valmoy + %.3f sigma (%.1f)',valspe,xseuil);
else
    titre=sprintf('Image non seuillee  (entre 0 et xmax=%.3f)',xmax);
end

delx=double(xseuil-xmin);
if delx == 0
    error('Your image is null !!');
end;

step=255./double(delx);


if xseuil<xmax
    B=A<delx;

    dxmin=double(xmin)
    C=((double(A)-dxmin).*double(B))*step + (1.-double(B))*255;
else
    delx=double(xmax)
    C=(double(A))*step ;
    
end


image(C);
colormap(gray(255));
axis image;

legx=sprintf('Min %.3f  Max %.3f Moy %.3f Ect %.3f', xmin, xmax, xmean, xstd);
xlabel(legx)
title(titre);


end
