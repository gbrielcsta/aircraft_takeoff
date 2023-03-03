% Plot results
figure()
    plot(t, V)
    hold on
    xlabel('Time (s)')
    ylabel('Velocity (m/s)')
    title('Velocity vs Time')    
    grid minor
    
figure()
    plot(D, V)
    hold on
    xlabel('Distance (m)')
    ylabel('Velocity (m/s)')
    title('Distance vs Velocity')
    xlim([0 70])
    grid minor
 
figure()
    plot(t, D)
    hold on
    xlabel('Time (s)')
    ylabel('Distance (m)')
    title('Distance vs Time')
    grid minor
    
figure()
    plot(U, T)
    hold on
    plot(U, Treq)
    xlabel('Velocity (m/s)')
    ylabel('Thrust (N)')
    title('Thrust vs Velocity')
    grid minor
