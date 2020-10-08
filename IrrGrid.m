clc;
clear;
close all;
tic;

%% Inputs 

batiOrg=dlmread('noktalar.txt');                                            % Enter bathymetry x,y,z file
cornerPoints=dlmread('blankArea.bln',',',1,0);                              % Enter corner points for irregular shape
incX=1;                                                                     % Enter x direction increment (m)
incY=1;                                                                     % Enter y direction increment (m)
saveData=1;                                                                 % (1): Save, (0):Not Save
saveFig=1;                                                                  % (1): Save, (0):Not Save
%% Code

gridX=min(cornerPoints(:,1)):incX:max(cornerPoints(:,1));
gridY=min(cornerPoints(:,2)):incY:max(cornerPoints(:,2));
batiGrid=griddata(batiOrg(:,1),batiOrg(:,2),batiOrg(:,3),gridX,gridY','nearest');
[row,col]=size(batiGrid);

indX=knnsearch(gridX',cornerPoints(:,1));
indY=knnsearch(gridY',cornerPoints(:,2));
solPoints=poly2mask(indX,indY,row,col);
solPoints=~solPoints;
batiGrid(solPoints)=NaN;

figure('windowstate','maximized');
contourf(gridX,gridY,batiGrid);
colormap('jet');
axis equal;
if saveFig==1
    savefig('figure.fig');
end

if saveData==1
    save('results.mat','batiGrid','gridX','gridY');
end

toc;