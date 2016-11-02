function [T, r, order] = sani_lookup(t10, t50, t90)
    % see if we're doing Tu/Tg or 
    % First, determine required order. We check Tu/Tg against the tu_tg
    % sani curve for this
    lambda = (t90 - t10) / t50;
    for order = 2:8
        if lambda >= sani_lambda(1-1e-6, order);
            break;
        end
    end
    fprintf('order is %d\n', order);

    % Next, look up r in tu_tg table. Use cubic interpolation for higher
    % accuracy.
    %r = spline(curves(order-1).tu_tg, curves(order-1).r, tu_tg);
    fun = @(r)sani_lambda(r, order);
    r = binary_search(fun, lambda, 0, 1);

    % With r, look up T in T/Tg table. Use cubic interpolation for higher
    % accuracy.
    T = t50 / (log(2) - 1 + (1-r^(order+1))/(1-r));
end

function lambda = sani_lambda(r, order)
    lambda = (1.315*sqrt(3.8 * (1-r^(2*(order+1)))/(1-r^2) - 1)) / (log(2) - 1 + (1-r^(order+1))/(1-r));
end

function result = binary_search(fun, target, lower, upper)
    mid = (upper - lower) / 2;
    x = mid / 2;
    max_iter = 20;
    while max_iter > 0
        max_iter = max_iter - 1;
        y = fun(x);
        mid = mid / 2;
        if y > target
            x = x + mid;
        else
            x = x - mid;
        end
    end
    
    result = x;
end
