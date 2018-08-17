function [model, modelHeight] = buildModel()
thermalParameter = getThermalParameter();

Lx = thermalParameter.lengthOfDomainInX;
Ly = thermalParameter.lengthOfDomainInY;
Lz = thermalParameter.lengthOfDomainInZ;
nx = thermalParameter.numberOfNodesInX;
ny = thermalParameter.numberOfNodesInY;
nz = thermalParameter.numberOfNodesInZ;
dx = Lx/(nx-1);
dy = Ly/(ny-1);
dz = Lz/(nz-1);

model = zeros(nx,ny,nz);

for i = nx/2 - 5 : nx/2 + 5
    for j = ny/2 - 1 : ny/2 + 1 
        for k = nz/2 : nz 
            model(i,j,k) = 1;
        end
    end
end

[maxNumCol, maxIndexCol] = max(model);
[maxNum, col] = max(maxNumCol);

modelHeight = max(col) * dz;

mymap = [0 1 1
    0 0 0];

%figure('Name','3D Punktwolke');
[x,y,z] = meshgrid(0:dx:Lx,0:dy:Ly,0:dz:Lz);
%h=slice(x,y,z,model,Lx/2,Ly/2,Lz/2);
h=scatter3(x(:),y(:),z(:),10,model(:),'filled');
region = [0,Lx,0,Ly,0,Lz];
axis(region);
%h(1).EdgeColor = 'none';
%h(2).EdgeColor = 'none';
%h(3).EdgeColor = 'none';
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
colormap(mymap);
%colorbar;