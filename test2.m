stlName = 'Teil2.STL';

thermalParameter = getThermalParameter();

nx = thermalParameter.numberOfNodesInX;
ny = thermalParameter.numberOfNodesInY;
nz = thermalParameter.numberOfNodesInZ;

fa  = stlread(stlName);
[val,idx] = max([fa.vertices]);
maxVal = 50;% max(val);

[gridOUTPUT] = VOXELISE(nx,ny,nz,stlName,'xyz');
figure();
[vol_handle]=VoxelPlotter(gridOUTPUT,1); 
%view(3);
%daspect([1,1,1]);
% set all patches transparency
alpha(0.8)
set(gca,'xlim',[0 nx+1], 'ylim',[0 ny+1], 'zlim',[0 nz+1]);
xlabel('Nodes in x')
ylabel('Nodes in y')
zlabel('Nodes in z')