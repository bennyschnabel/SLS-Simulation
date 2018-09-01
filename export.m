a=gridOUTPUT;
fig = figure();
[vol_handle] = VoxelPlotter(a,1);
set(gca,'xlim',[0 nx+1], 'ylim',[0 ny+1], 'zlim',[0 nz+1])
xlabel('Nodes in x')
ylabel('Nodes in y')
zlabel('Nodes in z')
alpha(0.8)
az = -217;
el = 30;
view(az, el);
orient(fig,'landscape')
print(fig,'-bestfit','Teil3','-dpdf','-r0')