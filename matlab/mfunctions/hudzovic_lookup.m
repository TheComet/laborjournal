function [T, r, order] = hudzovic_lookup(Tu, Tg)
    % Check if we can load the curves
    if exist('hudzovic_curves.mat', 'file') == 2
        load('hudzovic_curves.mat', 'curves');
    else
        fprintf('Hudzovic curves need to be generated (only needs to be done once).\n');
        fprintf('This may take a while. Go get a coffee or something.\n');
        curves = hudzovic_gen_curves();
        save('hudzovic_curves.mat', 'curves');
    end
    
    % First, determine required order. We check Tu/Tg against the tu_tg
    % hudzovic curve for this
    tu_tg = Tu/Tg;
    for order = 2:8
        if tu_tg <= curves(order-1).tu_tg(1)
            break
        end
    end
    fprintf('order is %d\n', order);
    
    % Next, look up r in tu_tg table. Use cubic interpolation for higher
    % accuracy.
    r = spline(curves(order-1).tu_tg, curves(order-1).r, tu_tg);
    
    % With r, look up T in T/Tg table. Use cubic interpolation for higher
    % accuracy.
    T = spline(curves(order-1).r, curves(order-1).t_tg, r) * Tg;
    
    figure(1); hold on, grid on, grid minor
    for k = 2:8
        plot(curves(k-1).r, curves(k-1).tu_tg);
    end
    title('Tu/Tg with r=parameter');
    xlabel('parameter r');
    ylabel('Tu/Tg of step function');

    
    print -depsc epsFig
end
