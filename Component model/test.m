%a = Temp(160:200,40:60);
ma = a;
[m,n] = size(ma);
v = VideoWriter('peaks.avi');
open(v);
for i = 1 : m-1
    figure(2)
    %plot(ma(i,:))
    [x,y] = meshgrid(1:1:n,1:1:i+1);
    surf(x,y,ma(1:i+1,:))
    set(gca,'nextplot','replacechildren'); 
    view(0,90)
    cb = colorbar;
    axis tight manual 
    ylabel(cb, 'Temperatur °C');
    drawnow
    M(i) = getframe;
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);