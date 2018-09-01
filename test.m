a=gridOUTPUT;
i = 1;
fig = figure();
hold on;

writerObj = VideoWriter('out.avi'); % Name it.
writerObj.FrameRate = 100; % How many frames per second.
open(writerObj); 

while i <= nx
    hold on;
    B = circshift(a,[0 0 -1]);
    [vol_handle] = VoxelPlotter(B,1);
    set(gca,'xlim',[0 nx+1], 'ylim',[0 ny+1], 'zlim',[0 nz+1])
    xlabel('Nodes in x')
    ylabel('Nodes in y')
    zlabel('Nodes in z')
    alpha(0.8)
    az = -37;
    el = 30;
    view(az, el);
    a = B;
    pause(0.01);
    frame = getframe(gcf);
    writeVideo(writerObj, frame);
    i = i + 1;
end

hold off
close(writerObj); % Saves the movie.


%{
fig = figure();
[vol_handle] = VoxelPlotter(firstLayerShift,1);
alpha(0.8)
az = -37;
el = 30;
view(az, el);
set(gca,'xlim',[0 nx+1], 'ylim',[0 ny+1], 'zlim',[0 nz+1])
xlabel('Nodes in x')
ylabel('Nodes in y')
zlabel('Nodes in z')
%}

%fig = figure();

