function [imad, nc, nl, nk, nt] = imz2mat(name, nlekp)


% imz2mat is used to read images in the Tivoli/Xima format.
%
%         Usage: ima = imz2mat('toto');
%
% (c) 1996 by B. Verdonck & L. Aurdal, ENST-IMA.
% (m) 1998 by M. Roux, ENST-TSI
% (m) 2001 by E. Roullot, ENST-TSIvisusar.m
% (m) 2015 by JM Nicolas, Télécom-ParisTech-TSI

% Version beta de Septembre 2017

% Open, read and close dimension file.

% 2011 : this m-procedure deals automatically with big-endian and small endian platforms

% Sept 2017 : on introduit un autre cas de rvb (double)

if nargin == 0
  error('You have to specify a filename (between quotes: ''name'') !');
end;

nlek=-1
if nargin==2
    nlek=nlekp;
end


% test sur le type de machine (JMN 2010)

[computerType, maxSize, endian] = computer;

% Open, read and close dimension file.

itagpile=0;
npile=1;
ncmplx=1;
kmplx=0;
type='uchar';
tag=11;
tagradar=0;

tagPC=0; % si le .dim a une info de bo, on met 0 ou 1  

nameLength = length(name) ;
    
    
if sum(name(nameLength-3:nameLength) == '.rvb') == 4
    dimname = [name(1:nameLength-4) '.dim'] ;
    dimfid = fopen(dimname, 'r') ;
    if ~(dimfid > 2)
        error('Error while opening the .dim file.') ;
    end
    
    [dim, nrRead] = fscanf(dimfid,'%d', 2) ;

    dimstat = fclose(dimfid) ;
    if dimstat
         error('Error while closing the .dim file.') ;
    end
    
    imafid = fopen(name, 'r') ;
    if ~(imafid > 2)
         error('Error while opening .dim file.') ;
    end
    [imad, nrRead] = fread(imafid,3*dim(1)*dim(2),'uchar') ;
   imad = reshape(imad,[3 dim(1) dim(2)]) ;
   imad = permute(imad,[3 2 1]) ;
   nrRead = nrRead/3 ;
    nl=dim(1);
    nc=dim(2);
    nk=1
    return
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

taglinima=1;  %% =1 si minuscule  =2 si majuscule


fileNameImage = name ;
tagdim=0;
if (nameLength > 4)
  if sum(name(nameLength-3:nameLength) == '.dim') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.ima') == 4| ...
     sum(name(nameLength-3:nameLength) == '.IMA') == 4| ...
     sum(name(nameLength-3:nameLength) == '.imw') == 4| ...
     sum(name(nameLength-3:nameLength) == '.IMW') == 4| ......
     sum(name(nameLength-3:nameLength) == '.ims') == 4| ...
     sum(name(nameLength-3:nameLength) == '.IMS') == 4| ...
     sum(name(nameLength-3:nameLength) == '.imf') == 4| ...
     sum(name(nameLength-3:nameLength) == '.IMF') == 4|  ...
     sum(name(nameLength-3:nameLength) == '.iml') == 4| ...
     sum(name(nameLength-3:nameLength) == '.IML') == 4| ......
     sum(name(nameLength-3:nameLength) == '.cxf') == 4| ...
     sum(name(nameLength-3:nameLength) == '.CXF') == 4| ...
     sum(name(nameLength-3:nameLength) == '.cxs') == 4| ...
     sum(name(nameLength-3:nameLength) == '.CXS') == 4| ...
     sum(name(nameLength-3:nameLength) == '.cxb') == 4
    fileNameDim = [name(1:nameLength-4) '.dim'] ;
     tagdim=1;
  end
end


if (nameLength > 8 && tagdim==0)     
   if  sum(name(nameLength-7:nameLength) == '.cxstivo') == 8| ...
     sum(name(nameLength-7:nameLength) == '.CXSTIVO') == 8 | ...
     sum(name(nameLength-7:nameLength) == '.cxsadts') == 8| ...
     sum(name(nameLength-7:nameLength) == '.CXSADTS') == 8 | ...
     sum(name(nameLength-7:nameLength) == '.cxftivo') == 8| ...
     sum(name(nameLength-7:nameLength) == '.CXFTIVO') == 8| ...
     sum(name(nameLength-7:nameLength) == '.cxfadts') == 8| ...
     sum(name(nameLength-7:nameLength) == '.CXFADTS') == 8| ...
     sum(name(nameLength-7:nameLength) == '.cxbtivo') == 8| ...
     sum(name(nameLength-7:nameLength) == '.cxbadts') == 8
    fileNameDim = [name(1:nameLength-8) '.dim'] ;
    tagdim=2;
   end
end

if tagdim==0
   nameLength=nameLength+4;
   fileNameImage = [name '.ima'];
   fileNameDim = [name '.dim'];
   imafid = fopen(fileNameImage, 'r');
    if ~(imafid > 2)
           fileNameImage = [name '.IMA'];
           imafid = fopen(fileNameImage, 'r');
           if ~(imafid > 2)
               error(['Failed to open the file: ' name 'either with .ima or .IMA extension (and .imw or .IMW)']);
           end
            taglinima=2;
           fclose(imafid)
    else
        taglinima=1;
        fclose(imafid)
    end
    disp(['Image lue : ' fileNameImage]);

end




dimfid = fopen(fileNameDim, 'r');
if ~(dimfid > 2)
  error(['Failed to open the dimension file: ' fileNameDim]);
end;

disp(['Read from file (dim) : ' fileNameDim]);
[dim, nrRead] = fscanf(dimfid,'%d', 4);


itagrvb=0


if dim(1)>0 & dim(2)>0
  % old IMA type
  dim = dim';
  npile=1;
  
 if tagdim==1
  if sum(name(nameLength-3:nameLength) == '.imw') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.IMW') == 4
    if sum(name(nameLength-3:nameLength) == '.imw') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.IMW') == 4
        taglinima=2;
    end
        
    tag=12;
    ncmplx=1;
    type='uint16';
    disp(['     ima file type ; values in [0:65535] ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
   
  if sum(name(nameLength-3:nameLength) == '.ims') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.IMS') == 4
    if sum(name(nameLength-3:nameLength) == '.ims') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.IMS') == 4
        taglinima=2;
    end
        
    tag=12;
    ncmplx=1;
    type='int16';
    disp(['     ima file type ; values in [-32768:32767] ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
  
  
  if sum(name(nameLength-3:nameLength) == '.iml') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.IML') == 4
    if sum(name(nameLength-3:nameLength) == '.iml') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.IML') == 4
        taglinima=2;
    end
        
    tag=14;
    ncmplx=1;
    type='int32';
    disp(['     iml file type ; values in Z ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end 
  
  if sum(name(nameLength-3:nameLength) == '.cxs') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.CXS') == 4
    if sum(name(nameLength-3:nameLength) == '.cxs') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.CXS') == 4
        taglinima=2;
    end
    kmplx=1;
    tag=12;
    ncmplx=2;
    type='int16';
    disp(['     ima file type ; complex values in [-32768:32767] ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
    
  if sum(name(nameLength-3:nameLength) == '.cxf') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.CXF') == 4
    if sum(name(nameLength-3:nameLength) == '.cxf') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.CXF') == 4
        taglinima=2;
    end
    kmplx=1;
    tag=14;
    ncmplx=2;
    type='float';
    disp(['     ima file type ; complex values in RR ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
  
  
  if sum(name(nameLength-3:nameLength) == '.imf') == 4 | ...
     sum(name(nameLength-3:nameLength) == '.IMF') == 4
    if sum(name(nameLength-3:nameLength) == '.imf') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.IMF') == 4
        taglinima=2;
    end
    tag=14;
    ncmplx=1;
    type='float';
    disp(['     ima file type ;  values in R ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
  
  
  if sum(name(nameLength-3:nameLength) == '.ima') == 4
    tag=11;
    ncmplx=1;
    type='uchar';
    disp(['     ima file type ; values in [0:255] ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
  
  if sum(name(nameLength-3:nameLength) == '.cxb') == 4
    kmplx=1;
    tag=21;
    ncmplx=2;
    type='char';
    disp(['     ima file type ; complex values in [-128:127] ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
 end
 
 if tagdim==2
    
  if sum(name(nameLength-7:nameLength) == '.cxstivo') == 8 | ...
     sum(name(nameLength-7:nameLength) == '.CXSTIVO') == 8
    if sum(name(nameLength-7:nameLength) == '.cxstivo') == 8
        taglinima=1;
    end
    if sum(name(nameLength-7:nameLength) == '.CXSTIVO') == 8
        taglinima=2;
    end
    kmplx=2;
    tag=12;
    ncmplx=2;
    type='int16';
    disp(['     ima file type ; complex values in RR ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
       
           
  if sum(name(nameLength-7:nameLength) == '.cxftivo') == 8 | ...
     sum(name(nameLength-7:nameLength) == '.CXFTIVO') == 8
    if sum(name(nameLength-7:nameLength) == '.cxftivo') == 8
        taglinima=1;
    end
    if sum(name(nameLength-7:nameLength) == '.CXFTIVO') == 8
        taglinima=2;
    end
    kmplx=2;
    tag=14;
    ncmplx=2;
    type='float';
    disp(['     ima file type ; complex values in RR ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
          
  if sum(name(nameLength-7:nameLength) == '.cxfadts') == 8 | ...
     sum(name(nameLength-7:nameLength) == '.CXFADTS') == 8
    if sum(name(nameLength-7:nameLength) == '.cxfadts') == 8
        taglinima=1;
    end
    if sum(name(nameLength-7:nameLength) == '.CXFADTS') == 8
        taglinima=2;
    end
    kmplx=3;
    tag=14;
    ncmplx=2;
    type='float';
    disp(['     ima file type ; complex values in RR ; size (' ...
	  int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  end
       
 end
end

if nrRead >2 
    if sum(name(nameLength-3:nameLength) == '.ima') == 4
        taglinima=1;
    end
    if sum(name(nameLength-3:nameLength) == '.IMA') == 4
        taglinima=2;
    end
    if nrRead == 4 & dim(1)>0 & dim(2)>0 & dim(3)~0 & dim(4)==1
        itagpile=1;
        npile=dim(3);
        nt=dim(4);
        dim = dim';
        while nrRead > 0
            [comcle, nrRead] = fscanf(dimfid,'%s',1);
            [comval, nrRead] = fscanf(dimfid,'%s',1);
            if nrRead>0
                disp([int2str(nrRead) '   ,   ' comcle '   ,   ' comval ] );
                if strcmp(comcle,'-bo')==1
                    if strcmp(comval,'DEC')==1
                        tagPC=2;
                    end
                    if strcmp(comval,'DCBA')==1
                        tagPC=2;
                    end
                    if strcmp(comval,'SUN')==1
                        tagPC=1;
                    end
                    if strcmp(comval,'ABCD')==1
                        tagPC=1;
                    end
                    disp(['information byte order sur le .dim : tagPC = ' int2str(tagPC)]);
                    
                end
                             
                if strcmp(comcle,'-radar')==1
                    if strcmp(comval,'ERS')==1
                        tagradar=1;
                        disp('On a affaire a un radar ERS');
                    end
                end
                
                
                if strcmp(comcle,'-type')==1
                    if strcmp(comval,'FLOAT')==1
                        tag=14;
                        ncmplx=1;
                        type = 'float';
                    end
                    if strcmp(comval,'DOUBLE')==1
                        tag=18;
                        ncmplx=1;
                        type = 'double';
                    end
                    if strcmp(comval,'U8')==1
                        tag=11;
                        ncmplx=1;
                        type = 'uint8';
                    end
                    if strcmp(comval,'U16')==1
                        tag=12;
                        ncmplx=1;
                        type = 'uint16';
                    end
                    if strcmp(comval,'S16')==1
                        tag=12;
                        ncmplx=1;
                        type = 'int16';
                    end
                    if strcmp(comval,'U32')==1
                        tag=14;
                        ncmplx=1;
                        type = 'uint32';
                    end
                    if strcmp(comval,'S32')==1
                        tag=14;
                        ncmplx=1;
                        type = 'int32';
                    end
%% les cmplx
                    if strcmp(comval,'CS8')==1
                        tag=21;
                        ncmplx=2;
                        kmplx=1;
                        type = 'schar';
                    end
                    if strcmp(comval,'CS16')==1
                        tag=12;
                        ncmplx=2;
                        kmplx=1;
                        type = 'short';
                    end
                    if strcmp(comval,'CFLOAT')==1
                        tag=14;
                        ncmplx=2;
                        kmplx=1;
                        type = 'float';
                    end
                    if strcmp(comval,'CDOUBLE')==1
                        tag=18;
                        ncmplx=2;
                        kmplx=1;
                        type = 'double';
                    end
                    if strcmp(comval,'CS16TIVO')==1
                        tag=12;
                        ncmplx=2;
                        kmplx=2;
                        type = 'short';
                    end
                    if strcmp(comval,'C32TIVO')==1
                        tag=14;
                        ncmplx=2;
                        kmplx=2;
                        type = 'float';
                    end
                    if strcmp(comval,'C32ADTS')==1
                        tag=14;
                        ncmplx=2;
                        kmplx=2;
                        type = 'float';
                    end
                end
                
                        
            end
        end
        
 
        if(dim(3) <0)
            itagrvb=1
        end
    
    else
            error(['Failed to interpret the dimension file: ' fileNameDim]);
    end
end;

    
    
dimstat = fclose(dimfid);
if ~(dimstat == 0)
  error('Failed to close the dimension file')
end;

% Open, read and close image file.


imafid = fopen( fileNameImage, 'r');
if ~(imafid > 2)
  error(['Failed to open the file: ' fileNameImage]);
end;

if tagPC>0
    taglinima=tagPC;
    disp(['choix machine a partir du .dim :' int2str(taglinima)]);
end

disp(['Read from file: ' fileNameImage '   type ' type '    tag ' int2str(tag) ' linux ' int2str(taglinima) '  pile ' int2str(npile)]);
 
ncmplxspe=1;
if kmplx==2
    ncmplx=1;
    ncmplxspe=2;
end
if kmplx==3
    ncmplx=1;
    ncmplxspe=2;
end



if taglinima==1
    machine='b';
end
if taglinima==2
    machine='l';
end

if nlek==-1
    ncanaldebut=1;
    ncanalfin=npile;
else
    if(nlek<npile+1)
        ncanaldebut=nlek;
        ncanalfin=nlek;
    else
        ncanaldebut=npile;
        ncanalfin=npile;
    end
end

nimage=ncanalfin-ncanaldebut+1;

  

fakspe=1
disp(['ICI le type   ',type])
if strcmp(type,'short') == 1
    fakspe=2
end
if strcmp(type,'float') == 1
    fakspe=4
end
if strcmp(type,'double') == 1
    fakspe=8
end
if strcmp(type,'uint8') == 1
    fakspe=1
end
if strcmp(type,'uint16') == 1
    fakspe=2
end
if strcmp(type,'int16') == 1
    fakspe=2
end
if strcmp(type,'uint32') == 1
    fakspe=4
end
if strcmp(type,'int32') == 1
    fakspe=4
end
if strcmp(type,'schar') == 1
    fakspe=1
end

zsize=fakspe*(ncanaldebut-1);
if(zsize>0)
    fseek( imafid,  ncmplx*dim(1)*ncmplxspe*dim(2)*zsize,-1) ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%  on traite un cas nouveau en embetant
%
% 

if itagrvb==1     
    disp('Cas RVB généralisés (RNSat) pour certains cas seulement  ');
 
    if(kmplx==0)   
        nkan=-dim(3)
        [imad, nrRead] = fread(imafid,nkan*dim(1)*dim(2), type, machine) ;
        imad = reshape(imad,[nkan dim(1) dim(2)]) ;
        imad = permute(imad,[3 2 1]) ;
        nrRead = nrRead/3 ;
        return
    end
    error('Erreur : cas non envisagé (cas des complexwes, etc....)')
end


for iutbase=ncanaldebut:ncanalfin
    iut=iutbase-ncanaldebut+1
    if itagpile==1
        disp(['  stack : ' int2str(iut) ' : ' int2str(npile)  ]);
    end
 

    [cxs, nrRead] = fread(imafid, [ncmplx*dim(1), ncmplxspe*dim(2)], type, machine);
if nrRead~=ncmplx*ncmplxspe*dim(1)*dim(2)
    disp(['Probleme : ' int2str(ncmplx) '  ' int2str(dim(1)) '  ' int2str(dim(2)) ' >> ' int2str(nrRead)]);
  error(['Image data file size does not match dimension '...
	  'specifications.']);
end;

% disp(['Read OK from file: ' fileNameImage '   type ' type '    tag ' int2str(tag) '  pile ' int2str(npile)]);

if tag==11 
    imaspe=double(cxs) ;
end

if tag==21 
    imaspe=double(cxs) ;
    zz = mean(mean(imaspe(:)));
    imaspe=imaspe-zz;
end

if tag==12
   imaspe = double(cxs) ;
end
 
if tag==14
   imaspe = double(cxs) ;
end
 
if tag==18
   imaspe = cxs ;
end
 

if kmplx>0
    if(kmplx==1)
        ima = imaspe(1:2:2*dim(1),:)-j*imaspe(2:2:2*dim(1),:); % la transposition conjuguera !
        disp('complex conversion');
        if tagradar==1
            disp('Radar ERS : on modifie la valeur en soustrayant la moyenne ');
            ima = ima-mean(ima(:));
        end
    end
    
    if(kmplx==2)
        %disp(['Verif ', int2str(dim(1)), ' x ', int2str(dim(2)), '   ',int2str(size(imaspe,1)), '   ',int2str(size(imaspe,2))]);
        ima = imaspe(:,1:1:dim(2))-j*imaspe(:,dim(2)+1:1:2*dim(2)); % la transposition conjuguera !
        disp(['complex conversion (format tivoli) ',int2str(size(ima,1)),' x ',int2str(size(ima,2))]);
    end    
    
    if(kmplx==3)
        %disp(['Verif ', int2str(dim(1)), ' x ', int2str(dim(2)), '   ',int2str(size(imaspe,1)), '   ',int2str(size(imaspe,2))]);
        ima = imaspe(:,1:1:dim(2)) .* ( cos(imaspe(:,dim(2)+1:1:2*dim(2) )) - j*sin(imaspe(:,dim(2)+1:1:2*dim(2))) ); % la transposition conjuguera !
        disp(['complex conversion (format adts) ',int2str(size(ima,1)),' x ',int2str(size(ima,2))]);
    end
 
    if npile==1
        imad = double(ima');
    else
        imad(:,:,iut) = double(ima');
    end
    
end

if kmplx==0
    if npile==1
        imad= double(imaspe');
    else
        imad(:,:,iut)= double(imaspe');
    end
end


end   %fin de la pile

disp('Image read !');
disp(['  size (' int2str(dim(1)) ', ' int2str(dim(2)) ')']); 
if itagpile==1
    disp(['  stack : ' int2str(dim(3)) ]);
end

imastat = fclose(imafid);
if ~(imastat == 0)
  error(['Failed to close the file:' fileNameImage]);
end

nc=dim(1);
nl=dim(2);
nk=npile;


disp(['dimension du tableau Matlab obtenu a partir de l''image :  ',int2str(size(imad))]);

% end. 		%Modif mroux 20-08-1998 (mise en commentaire de la ligne).

