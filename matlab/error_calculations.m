function error_calculations()
    close all;
    
    % subroutines are located in this folder
    addpath([pwd,'/mfunctions']);
    
    %error_calculations_noise();
    %error_calculations_order();
    
    display_error_vs_order();
    display_error_vs_noise();
    display_error_vs_noise_avg();
    display_error_vs_noise_long();
    display_failure_rate();
    display_sani_lookup_vs_interpolation();
end

function display_error_vs_order()
    load('errors_order.mat', 'errors_order');

    % Error vs Order
    for k = 2:8
        tmp(k-1, 1) = sqrt(mean(errors_order(k-1).hudzovic_tu_tg(isfinite(errors_order(k-1).hudzovic_tu_tg))));
        tmp(k-1, 2) = sqrt(mean(errors_order(k-1).hudzovic_t10_t50_t90(isfinite(errors_order(k-1).hudzovic_t10_t50_t90))));
        tmp(k-1, 3) = sqrt(mean(errors_order(k-1).sani_tu_tg(isfinite(errors_order(k-1).sani_tu_tg))));
        tmp(k-1, 4) = sqrt(mean(errors_order(k-1).sani_t10_t50_t90(isfinite(errors_order(k-1).sani_t10_t50_t90))));
        tmp(k-1, 5) = sqrt(mean(errors_order(k-1).hudzovic_fit(isfinite(errors_order(k-1).hudzovic_fit))));
        tmp(k-1, 6) = sqrt(mean(errors_order(k-1).sani_fit(isfinite(errors_order(k-1).sani_fit))));
    end

    figure;
    semilogy(2:8, tmp, 'LineWidth', 2);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit');
    %axis([2 8 10e-7 20e-3]);
    axis square
    xlabel('\fontsize{14}Order of filter');
    ylabel('\fontsize{14}Root Mean Square Error');
    title('\fontsize{16}Error vs Order');
end

function display_sani_lookup_vs_interpolation()
    tmp = load('errors_order_sani_lookup.mat', 'errors_order');
    lookup = tmp.errors_order;
    tmp = load('errors_order_sani_interpolation.mat', 'errors_order');
    interpolation = tmp.errors_order;
    
    % Error vs Order
    tmp = zeros(7, 6);
    for k = 2:8
        tmp(k-1, 1) = sqrt(mean(interpolation(k-1).hudzovic_tu_tg(isfinite(interpolation(k-1).hudzovic_tu_tg))));
        tmp(k-1, 2) = sqrt(mean(interpolation(k-1).hudzovic_t10_t50_t90(isfinite(interpolation(k-1).hudzovic_t10_t50_t90))));
        tmp(k-1, 3) = sqrt(mean(interpolation(k-1).sani_tu_tg(isfinite(interpolation(k-1).sani_tu_tg))));
        tmp(k-1, 4) = sqrt(mean(interpolation(k-1).sani_t10_t50_t90(isfinite(interpolation(k-1).sani_t10_t50_t90))));
        tmp(k-1, 5) = sqrt(mean(interpolation(k-1).hudzovic_fit(isfinite(interpolation(k-1).hudzovic_fit))));
        tmp(k-1, 6) = sqrt(mean(interpolation(k-1).sani_fit(isfinite(interpolation(k-1).sani_fit))));
    end

    figure;
    for i = 1:6
        if i == 4
            semilogy(2:8, tmp(:,i), 'LineWidth', 2);
        else
            semilogy(2:8, tmp(:,i));  hold on, grid on
        end
    end
    tmp2 = zeros(1, 7);
    for k = 2:8
        tmp2(k-1) = sqrt(mean(lookup(k-1).sani_t10_t50_t90(isfinite(lookup(k-1).sani_t10_t50_t90))));
    end
    semilogy(2:8, tmp2, '--', 'LineWidth', 2);
    
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90, Interpolation Formulae',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit',...
        '\fontsize{14}Sani t10/t50/t90, Lookup');
    %axis([2 8 10e-7 20e-3]);
    axis square
    xlabel('\fontsize{14}Order of filter');
    ylabel('\fontsize{14}Root Mean Square Error');
    title('\fontsize{16}Sani Interpolation Formulae vs Lookup');
end

function display_error_vs_noise()
    load('errors_noise_fit.mat', 'errors_noise');

    % Error vs Input noise
    tmp = zeros(length(errors_noise.hudzovic_tu_tg), 6);
    tmp(:,1) = errors_noise.hudzovic_tu_tg;
    tmp(:,2) = errors_noise.hudzovic_t10_t50_t90;
    tmp(:,3) = errors_noise.sani_tu_tg;
    tmp(:,4) = errors_noise.sani_t10_t50_t90;
    tmp(:,5) = errors_noise.hudzovic_fit;
    tmp(:,6) = errors_noise.sani_fit;
    for i = 1:6
        tmp(:,i) = sliding_average(tmp(:,i), 10);
    end
    figure;
    semilogy(errors_noise.noise_amplitude * 100, tmp);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit',...
        'Location', 'southeast');
    %axis([0 200 10e-8 20e-2]);
    axis square
    xlabel('\fontsize{14}Normalised noise amplitude (%)');
    ylabel('\fontsize{14}Root Mean Square Error');
    title({'\fontsize{16}Error vs Input noise', '\fontsize{14}(Single 4th Order Step Response)'});
end

function display_error_vs_noise_avg()
    load('errors_noise_avg.mat', 'errors_noise');

    % Error vs Input noise
    tmp = zeros(length(errors_noise.hudzovic_tu_tg), 6);
    tmp(:,1) = sqrt(errors_noise.hudzovic_tu_tg);
    tmp(:,2) = sqrt(errors_noise.hudzovic_t10_t50_t90);
    tmp(:,3) = sqrt(errors_noise.sani_tu_tg);
    tmp(:,4) = sqrt(errors_noise.sani_t10_t50_t90);
    for i = 1:4
        tmp(:,i) = sliding_average(tmp(:,i), 20);
    end
    figure;
    semilogy(errors_noise.noise_amplitude * 100, tmp);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        'Location', 'southeast');
    axis([0 35 1e-3 3e-2]);
    axis square
    xlabel('\fontsize{14}Normalised noise amplitude (%)');
    ylabel('\fontsize{14}Root Mean Square Error');
    title({'\fontsize{16}Error vs Input noise', '\fontsize{14}(Random Step Responses)'});
end

function display_error_vs_noise_long()
    load('errors_noise_10000iter_200percent.mat', 'errors_noise');

    % Error vs Input noise
    tmp = zeros(length(errors_noise.hudzovic_tu_tg), 6);
    tmp(:,1) = sqrt(errors_noise.hudzovic_tu_tg);
    tmp(:,2) = sqrt(errors_noise.hudzovic_t10_t50_t90);
    tmp(:,3) = sqrt(errors_noise.sani_tu_tg);
    tmp(:,4) = sqrt(errors_noise.sani_t10_t50_t90);
    tmp(:,5) = sqrt(errors_noise.hudzovic_fit);
    tmp(:,6) = sqrt(errors_noise.sani_fit);
    for i = 1:6
        for k = 1:length(tmp(:,i))
            if tmp(k,i) > 1; tmp(k,i) = Inf; end
        end
        tmp(:,i) = sliding_average(tmp(:,i), 30);
    end
    figure;
    semilogy(errors_noise.noise_amplitude * 100, tmp);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit',...
        'Location', 'southeast');
    axis([0 200 1e-4 1e0]);
    axis square
    xlabel('\fontsize{14}Normalised noise amplitude (%)');
    ylabel('\fontsize{14}Root Mean Square Error');
    title({'\fontsize{16}Error vs Input noise', '\fontsize{14}(Single 4th Order Step Response)'});
end

function display_failure_rate()
    load('errors_order.mat', 'errors_order');

    % Plot the "failure rate" in function of order. Whenever the error is
    % too large, the error is set to Inf. For every order, we created 100
    % random step responses which means the number of Inf items is directly
    % the failure rate in percent.
    tmp = zeros(7, 6);
    for k = 2:8
        tmp(k-1, 1) = 100 - sum(isfinite(errors_order(k-1).hudzovic_tu_tg));
        tmp(k-1, 2) = 100 - sum(isfinite(errors_order(k-1).hudzovic_t10_t50_t90));
        tmp(k-1, 3) = 100 - sum(isfinite(errors_order(k-1).sani_tu_tg));
        tmp(k-1, 4) = 100 - sum(isfinite(errors_order(k-1).sani_t10_t50_t90));
        tmp(k-1, 5) = 100 - sum(isfinite(errors_order(k-1).hudzovic_fit));
        tmp(k-1, 6) = 100 - sum(isfinite(errors_order(k-1).sani_fit));
    end
    figure;
    plot(2:8, tmp, 'LineWidth', 2);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit');
    axis square
    xlabel('\fontsize{14}Order of filter');
    ylabel('\fontsize{14}Failure Rate (%)');
    title('\fontsize{16}Failure vs Order');
end

function error_calculations_noise()
    rand('state', 0);
    %errors_noise = struct
    load('errors_noise.mat', 'errors_noise');
    
    num_simulations = 1000;
    num_avg = 500;
    for i = 851:num_simulations
        fprintf('Current iteration: %d\n', i);
        for k = 1:num_avg
            % generate transfer function
            [xdata_orig, ydata_orig] = gen_random_ptn(randi([2 8], 1, 1));

            % apply noise
            amp_rand = 0.35 * (i-1) / (num_simulations-1);
            xdata_raw = xdata_orig;
            ydata_raw = ydata_orig + amp_rand * (rand(length(ydata_orig),1)-0.5);

            err_acc = zeros(1, 6);

            try
                [xdata, ydata] = preprocess_curve(xdata_raw, ydata_raw);
                [Tu, Tg] = characterise_curve(xdata, ydata);
                [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

                % Hudzovic, Tu/Tg
                [T, r, order] = hudzovic_lookup(Tu, Tg);
                G = hudzovic_transfer_function(T, r, order);
                g_hudzovic_tu_tg = step(G, xdata);

                % Hudzovic, t10/t50/t90
                [T, r, order] = hudzovic_lookup(t10, t50, t90);
                G = hudzovic_transfer_function(T, r, order);
                g_hudzovic_t3 = step(G, xdata);

                % Sani, Tu/Tg
                [T, r, order] = sani_lookup(Tu, Tg);
                G = sani_transfer_function(T, r, order);
                g_sani_tu_tg = step(G, xdata);

                % Sani, t10/t50/t90
                [T, r, order] = sani_lookup(t10, t50, t90);
                G = sani_transfer_function(T, r, order);
                g_sani_t3 = step(G, xdata);

                % Hudzovic fit of raw data
%                 [T, r, order] = hudzovic_lookup(t10, t50, t90);
%                 [T, r] = hudzovic_fit(T, r, order, xdata_raw, ydata_raw);
%                 G = hudzovic_transfer_function(T, r, order);
%                 g_hudzovic_fit = step(G, xdata);
% 
%                 % Sani fit of raw data
%                 [T, r, order] = sani_lookup(t10, t50, t90);
%                 [T, r] = sani_fit(T, r, order, xdata_raw, ydata_raw);
%                 G = sani_transfer_function(T, r, order);
%                 g_sani_fit = step(G, xdata);
            catch
            end
            
            % accumulate errors so we can compute the average later
            err_acc(1) = err_acc(1) + sqrt(immse(g_hudzovic_tu_tg, ydata_orig));
            err_acc(2) = err_acc(2) + sqrt(immse(g_hudzovic_t3, ydata_orig));
            err_acc(3) = err_acc(3) + sqrt(immse(g_sani_tu_tg, ydata_orig));
            err_acc(4) = err_acc(4) + sqrt(immse(g_sani_t3, ydata_orig));
%             err_acc(5) = err_acc(5) + sqrt(immse(g_hudzovic_fit, ydata_orig));
%             err_acc(6) = err_acc(6) + sqrt(immse(g_sani_fit, ydata_orig));
        end
        
        % average
        err_acc = err_acc ./ num_avg;
        
        errors_noise.noise_amplitude(i) = amp_rand;
        errors_noise.hudzovic_tu_tg(i) = err_acc(1);
        errors_noise.hudzovic_t10_t50_t90(i) = err_acc(2);
        errors_noise.sani_tu_tg(i) = err_acc(3);
        errors_noise.sani_t10_t50_t90(i) = err_acc(4);
%         errors_noise.hudzovic_fit(i) = err_acc(5);
%         errors_noise.sani_fit(i) = err_acc(6);
    end

    save('errors_noise.mat', 'errors_noise');
end

function error_calculations_order()
    rand('state', 0);

    for k = 2:8
        num_simulations = 100;
        errors_order(k-1) = struct(...
            'hudzovic_tu_tg', 0,...
            'hudzovic_t10_t50_t90', 0,...
            'sani_tu_tg', 0,...
            'sani_t10_t50_t90', 0,...
            'hudzovic_fit', 0,...
            'sani_fit', 0);
        
        for i = 1:num_simulations
            [xdata, ydata] = gen_random_ptn(k);

            [Tu, Tg] = characterise_curve(xdata, ydata);
            [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

            try
            % Hudzovic, Tu/Tg
            [T, r, order] = hudzovic_lookup(Tu, Tg);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_tu_tg = step(G, xdata);

            % Hudzovic, t10/t50/t90
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_t3 = step(G, xdata);

            % Sani, Tu/Tg
            [T, r, order] = sani_lookup(Tu, Tg);
            G = sani_transfer_function(T, r, order);
            g_sani_tu_tg = step(G, xdata);

            % Sani, t10/t50/t90
            [T, r, order] = sani_lookup(t10, t50, t90);
            G = sani_transfer_function(T, r, order);
            g_sani_t3 = step(G, xdata);

            % Hudzovic fit of raw data
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            [T, r] = hudzovic_fit(T, r, order, xdata, ydata);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_fit = step(G, xdata);

            % Sani fit of raw data
            [T, r, order] = sani_lookup(t10, t50, t90);
            [T, r] = sani_fit(T, r, order, xdata, ydata);
            G = sani_transfer_function(T, r, order);
            g_sani_fit = step(G, xdata);
            catch
            end

            errors_order(k-1).hudzovic_tu_tg(i) = sqrt(immse(g_hudzovic_tu_tg, ydata));
            errors_order(k-1).hudzovic_t10_t50_t90(i) = sqrt(immse(g_hudzovic_t3, ydata));
            errors_order(k-1).sani_tu_tg(i) = sqrt(immse(g_sani_tu_tg, ydata));
            errors_order(k-1).sani_t10_t50_t90(i) = sqrt(immse(g_sani_t3, ydata));
            errors_order(k-1).hudzovic_fit(i) = sqrt(immse(g_hudzovic_fit, ydata));
            errors_order(k-1).sani_fit(i) = sqrt(immse(g_sani_fit, ydata));
        end
    end

    save('errors_order.mat', 'errors_order');
end

function error_calculations_order_sani_lookup()
    rand('state', 0);

    for k = 2:8
        num_simulations = 100;
        
        for i = 1:num_simulations
            [xdata, ydata] = gen_random_ptn(k);

            [Tu, Tg] = characterise_curve(xdata, ydata);
            [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

            try
            % Sani, t10/t50/t90
            [T, r, order] = sani_lookup(t10, t50, t90);
            G = sani_transfer_function(T, r, order);
            g_sani_t3 = step(G, xdata);
            catch
            end

            errors_order(k-1) = rmse(g_sani_t3, ydata);
        end
    end

    save('errors_order_sani_lambda_lookup.mat', 'errors_order');
end

function [xdata, ydata] = gen_random_ptn(order)
    s = tf('s');
    G = 1;
    for k = 1:order
        Tk = (rand(1,1)*0.8+0.1) * 10;
        G = G / (1+s*Tk);
    end
    [ydata, xdata] = step(G);
    ydata = ydata - ydata(1);
    ydata = ydata / ydata(end);
end

