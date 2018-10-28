% fonctions que j'ai code:
% slic.m
% k_means.m
% moyenne_L1.m
% moyenne_L2.m
% moyenne.m

% les autres fonctions sont de Peter Kosevi et je les ai juste adaptes au
% niveau de gris



% charger les images et afficher un exemple

A=imz2mat('Pilechenguang1_512x512RECALZ4.IMA');
im=A(:,:,10);
visusar(im);
figure();
im=double(abs(im));
hist(im(:),100);
figure();

% afficher la moyenne et le rapport ecarttype sur moyenne

iml2=moyenne_L2(A);
visusar(iml2);
figure();
imstats=stats_time(A);
visusar(imstats,6);
figure();

% flouter l'image et afficher la segmentation kmeans, slic, et slic2

N=5; % taille de la fenetre de moyennage (ex: fenetre 5x5, N=5)
imfiltre=moyenne(A,floor(N/2));
visusar(imfiltre);
figure();
K=10; % nombre de classes pour le K-means
imkmeans=k_means(imfiltre,K,10);
visusar(imkmeans);
figure();
K=400; % nombre de superpixels pour slic (pour slic.m, K doit etre un carre parfait)
m=20; % parametre m de slic
imslic=slic(imfiltre,K,10,m);
visusar(drawregionboundaries(imslic,imfiltre,255));
figure();
imslic2=slic2(imfiltre,K,m,1.5,'median');
visusar(drawregionboundaries(imslic2,imfiltre,255));
