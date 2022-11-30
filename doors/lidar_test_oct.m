

for k=1:1000
    scan = LidarScan(lidar);
    
    disp(['scan ', num2str(k), ' length: ', num2str(length(scan))]);

    plot(scan);
    
    pause(0.1);
end
