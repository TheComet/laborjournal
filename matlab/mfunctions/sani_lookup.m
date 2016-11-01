function [T, r, order] = sani_lookup(t10, t50, t90)
    % Check if we can load the curves
    if exist('sani_curves.mat', 'file') == 2
        load('sani_curves.mat', 'curves');
    else
        fprintf('Sani curves need to be generated (only needs to be done once).\n');
        fprintf('This may take a while. Go get a coffee or something.\n');
        curves = sani_gen_curves();
        save('sani_curves.mat', 'curves');
    end
    
    % First, determine required order. We check Tu/Tg against the tu_tg
    % sani curve for this
    tu_tg = t50 / (t90 - t10);
    for order = 2:8
        if tu_tg <= curves(order-1).tu_tg(end)
            break;
        end
    end
    fprintf('order is %d\n', order);
    
    % Next, look up r in tu_tg table. Use cubic interpolation for higher
    % accuracy.
    r = spline(curves(order-1).tu_tg, curves(order-1).r, tu_tg);
    
    % With r, look up T in T/Tg table. Use cubic interpolation for higher
    % accuracy.
    T = spline(curves(order-1).r, curves(order-1).t_tg, r);
end
