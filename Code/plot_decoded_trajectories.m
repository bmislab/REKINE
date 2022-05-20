function plot_decoded_trajectories(C_corr,trajectories_temp, file_test, fm, L, G, user)
%% DESCRIPTION
% This function constructs three six-plots with the decoded and the
% real trajectorie of each one of the six lower limbs, one per stretch.
% It also proporcionates de Perason correlation coefficient between the
% real and the decoded trajectorie for each one of the subplots. It
% requires an structure with the real trajectories (test_trajectories
% format, see prepare_regression_data.m), another similar structure
% with the decoded trajectories (like X_dec in
% multi_linear_regression.m), the sample frequency, and the lag and gap
% parameters employed in the decodification of the trajectories.


% for h=1:6
%     eval(sprintf('X_dec_out.file_%d.stretch_1(h).s=X_dec.file_%d.stretch_1(h,:);',files.n_files,files.n_files))
%     eval(sprintf('X_dec_out.real_file_%d.stretch_1(h).s=X_dec.real_file_%d.stretch_1(h,:);',files.n_files,files.n_files))
%     eval(sprintf('X_dec_out.file_%d.stretch_2(h).s=X_dec.file_%d.stretch_2(h,:);',files.n_files,files.n_files))
%     eval(sprintf('X_dec_out.real_file_%d.stretch_2(h).s=X_dec.real_file_%d.stretch_2(h,:);',files.n_files,files.n_files))
%     eval(sprintf('X_dec_out.file_%d.stretch_3(h).s=X_dec.file_%d.stretch_3(h,:);',files.n_files,files.n_files))
%     eval(sprintf('X_dec_out.real_file_%d.stretch_3(h).s=X_dec.real_file_%d.stretch_3(h,:);',files.n_files,files.n_files))
% end

%% MEMORY RESERVE
if length(G)==1
    G=repmat(G,1,6);
end
%% PLOTTING
eval(sprintf('trajectories.stretch_1=trajectories_temp.file_%d.stretch_1;;',file_test))
eval(sprintf('trajectories.stretch_2=trajectories_temp.file_%d.stretch_2;',file_test))
eval(sprintf('trajectories.stretch_3=trajectories_temp.file_%d.stretch_3;',file_test))
eval(sprintf('trajectories.real_stretch_1=trajectories_temp.real_file_%d.stretch_1;',file_test))
eval(sprintf('trajectories.real_stretch_2=trajectories_temp.real_file_%d.stretch_2;',file_test))
eval(sprintf('trajectories.real_stretch_3=trajectories_temp.real_file_%d.stretch_3;',file_test))

for stretch = 1:3
    % Time vector:
    % Left hip:
    eval(sprintf('t = linspace((L*G(6)-G(6)+1)/fm, (length(trajectories.stretch_%d(6,:))-L*G(6)+G(6)-1)/fm, length(trajectories.stretch_1(6,:)));', stretch));
    figure(stretch)
    graph = subplot(3, 2, 1);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(6,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(6,:));', stretch));    % Decoded trajectories.
    title(['Left hip - Pearson correlation coefficient: ' num2str(C_corr(6))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label.
    legend(graph, {'Real', 'Decoded'}); % Legend.
    
    % Right hip:
    eval(sprintf('t = linspace((L*G(5)-G(5)+1)/fm, (length(trajectories.stretch_%d(5,:))-L*G(5)+G(5)-1)/fm, length(trajectories.stretch_1(5,:)));', stretch));
    subplot(3, 2, 2);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(5,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(5,:));', stretch));    % Decoded trajectories.
    title(['Right hip - Pearson correlation coefficient: ' num2str(C_corr(5))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label
    
    % Left knee:
    eval(sprintf('t = linspace((L*G(4)-G(4)+1)/fm, (length(trajectories.stretch_%d(4,:))-L*G(4)+G(4)-1)/fm, length(trajectories.stretch_1(4,:)));', stretch));
    subplot(3, 2, 3);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(4,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(4,:));', stretch));    % Decoded trajectories.
    title(['Left knee - Pearson correlation coefficient: ' num2str(C_corr(4))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label.
    
    % Right knee:
    eval(sprintf('t = linspace((L*G(3)-G(3)+1)/fm, (length(trajectories.stretch_%d(3,:))-L*G(3)+G(3)-1)/fm, length(trajectories.stretch_1(3,:)));', stretch));
    subplot(3, 2, 4);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(3,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(3,:));', stretch));    % Decoded trajectories.
    title(['Right knee - Pearson correlation coefficient: ' num2str(C_corr(3))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label.
    
    % Left ankle:
    eval(sprintf('t = linspace((L*G(2)-G(2)+1)/fm, (length(trajectories.stretch_%d(2,:))-L*G(2)+G(2)-1)/fm, length(trajectories.stretch_1(2,:)));', stretch));
    subplot(3, 2, 5);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(2,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(2,:));', stretch));    % Decoded trajectories.
    title(['Left ankle - Pearson correlation coefficient: ' num2str(C_corr(2))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label.
    
    % Right ankle:
    eval(sprintf('t = linspace((L*G(1)-G(1)+1)/fm, (length(trajectories.stretch_%d(1,:))-L*G(1)+G(1)-1)/fm, length(trajectories.stretch_1(1,:)));', stretch));
    subplot(3, 2, 6);
    eval(sprintf('plot(t, trajectories.real_stretch_%d(1,:));', stretch)); % Real trajectories.
    hold on
    eval(sprintf('plot(t, trajectories.stretch_%d(1,:));', stretch));    % Decoded trajectories.
    title(['Right ankle - Pearson correlation coefficient: ' num2str(C_corr(1))]);  % Title.
    xlabel('Time [s]'); % x axis label.
    ylabel('Standarized angles');   % y axis label.
    
    % Global title:
    text = ['Decoded lower limbs trajectories from ' user ' - L=' num2str(L) ', G=' num2str(G) ' - Stretch ' num2str(stretch)];
    try
        sgtitle(text);
    catch
        fprintf('%s\n',text)
    end
    hold off;
    
end

end