function [C_corr_out,X_dec_out]=new_preprocesar_standarized(G,L,N,filter_freq,resampling,show_flag)
%% DESCRIPTION
% This function applies filters for the complete EEG of a REKINE
% session (except the eyes elctrodes), and for the complete limb
% trajetories. 
%% INPUTS
% L: LAG
% G: GAP
% N: numeric vector. Represents the electrodes chosen.
% filter_frec: band-pass filter for the frequencies of the EEG signal. Choose one
% of these numeric values:
%                 1. 0.1 - 2 Hz
%                 2. 2 - 4 Hz
%                 3. 4 - 8 Hz
%                 4. 8 - 12 Hz
%                 5. 12 - 30 Hz
% resampling: 
% show_flag: plot the real trajectories against the decoded trajectories with the EEG. Numeric value 1 means yes and 0 no.

%% OUTPUTS
% C_corr_out: 
% X_dec_out: 


% check L, G y N,
% filer_freq
% resamling


%% FILES SELECTION
files=select_files(); %Select all the CSV files corresponding to 1 subject
fprintf('A total of %d files has been selected.\n',files.n_files)

% Loop for preprocessing and preparin the signal with the parameters filter_freq and
% resampling before creating the regression model

for f=1:files.n_files   
    %% SESSIONS LOAD
    fprintf('Processing the file %d of %d.\n',f,files.n_files)
    session = load_session([files.pathname files.filename{f}]); %Reads from CSV and creates the session struct with the necesary variables
    %% EEG FILTERING
    switch filter_freq
        case 1
            % Butterworth bandpass filter:
            EEG_l_f=0.1; % Low frequency
            EEG_u_f=2;   % High frequency
            fprintf('Filter Butterworth order 2 bandpass (%.1f-%.1f).\n',EEG_l_f,EEG_u_f);
            filtered_EEG = zeros(27, size(session.data_EEG(1, :), 2));  % Memory reserve.
            [b, a] = butter(2, [EEG_l_f, EEG_u_f]/(session.sample_frec_EEG/2), 'bandpass');   % Filter design.
            for num_chan=1:27
                filtered_EEG(num_chan, :) = filtfilt(b, a, session.data_EEG(num_chan, :));    % Filter application.
            end
        case 2
            % Butterworth bandpass filter:
            EEG_l_f=2; % Low frequency
            EEG_u_f=4;   % High frequency
            fprintf('Filter Butterworth order 2 bandpass (%.1f-%.1f).\n',EEG_l_f,EEG_u_f);
            filtered_EEG = zeros(27, size(session.data_EEG(1, :), 2));  % Memory reserve.
            [b, a] = butter(2, [EEG_l_f, EEG_u_f]/(session.sample_frec_EEG/2), 'bandpass');   % Filter design.
            for num_chan=1:27
                filtered_EEG(num_chan, :) = filtfilt(b, a, session.data_EEG(num_chan, :));    % Filter application.
            end
            
        case 3
            % Butterworth bandpass filter:
            EEG_l_f=4; % Low frequency
            EEG_u_f=8;   % High frequency
            fprintf('Filter Butterworth order 2 bandpass (%.1f-%.1f).\n',EEG_l_f,EEG_u_f);
            filtered_EEG = zeros(27, size(session.data_EEG(1, :), 2));  % Memory reserve.
            [b, a] = butter(2, [EEG_l_f, EEG_u_f]/(session.sample_frec_EEG/2), 'bandpass');   % Filter design.
            for num_chan=1:27
                filtered_EEG(num_chan, :) = filtfilt(b, a, session.data_EEG(num_chan, :));    % Filter application.
            end
        case 4
            % Butterworth bandpass filter:
            EEG_l_f=8; % Low frequency
            EEG_u_f=12;   % High frequency
            fprintf('Filter Butterworth order 2 bandpass (%.1f-%.1f).\n',EEG_l_f,EEG_u_f);
            filtered_EEG = zeros(27, size(session.data_EEG(1, :), 2));  % Memory reserve.
            [b, a] = butter(2, [EEG_l_f, EEG_u_f]/(session.sample_frec_EEG/2), 'bandpass');   % Filter design.
            for num_chan=1:27
                filtered_EEG(num_chan, :) = filtfilt(b, a, session.data_EEG(num_chan, :));    % Filter application.
            end
        case 5
            % Butterworth bandpass filter:
            EEG_l_f=12; % Low frequency
            EEG_u_f=30;   % High frequency
            fprintf('Filter Butterworth order 2 bandpass (%.1f-%.1f).\n',EEG_l_f,EEG_u_f);
            filtered_EEG = zeros(27, size(session.data_EEG(1, :), 2));  % Memory reserve.
            [b, a] = butter(2, [EEG_l_f, EEG_u_f]/(session.sample_frec_EEG/2), 'bandpass');   % Filter design.
            for num_chan=1:27
                filtered_EEG(num_chan, :) = filtfilt(b, a, session.data_EEG(num_chan, :));    % Filter application.
            end
        otherwise
            error('Filer not contemplated.\n');
    end
    
    %% KINEMATICS FILTERING
    % The angles of the IMUs are filtered with a butterworth lowpass filter of 2 Hz:
    IMUs_u_f=2;
    fprintf('Low pass filter to kinematics (%.1f).\n', IMUs_u_f);
    [b, a] = butter(4, IMUs_u_f/(session.sample_frec_angles/2));   % Filter design.
    %     Filter application:
    filtered_trajectories = zeros(6, size(session.IMUs_angles, 2));  % Memory reserve.
    filtered_trajectories(1, :) = filtfilt(b, a, session.IMUs_angles(1,:));    % Right ankle.
    filtered_trajectories(2, :) = filtfilt(b, a, session.IMUs_angles(2,:));    % Left ankle.
    filtered_trajectories(3, :) = filtfilt(b, a, session.IMUs_angles(3,:));    % Right knee.
    filtered_trajectories(4, :) = filtfilt(b, a, session.IMUs_angles(4,:)); % Left knee.
    filtered_trajectories(5, :) = filtfilt(b, a, session.IMUs_angles(5,:)); % Right hip.
    filtered_trajectories(6, :) = filtfilt(b, a, session.IMUs_angles(6,:));  % Left hip.
    
    %% RESAMPLING.  EEG AND IMU trajectories FREQUENCY MATCHING
    switch resampling
        case 1
            fprintf('Resample to match trajectories with EEG (30->500).\n');
            % Opci�n 1: original: Los �ngulos se remuestren a la misma frecuencia que el EEG
            fm_EEG=session.sample_frec_EEG;
            fm_IMUs=session.sample_frec_angles;
            task_indexes = session.index_EEG;        
            final_trajectories = zeros(6, size(session.data_EEG, 2));
            final_trajectories(1, :) = resample(filtered_trajectories(1, :), fm_EEG, fm_IMUs);
            final_trajectories(2, :) = resample(filtered_trajectories(2, :), fm_EEG, fm_IMUs);
            final_trajectories(3, :) = resample(filtered_trajectories(3, :), fm_EEG, fm_IMUs);
            final_trajectories(4, :) = resample(filtered_trajectories(4, :), fm_EEG, fm_IMUs);
            final_trajectories(5, :) = resample(filtered_trajectories(5, :), fm_EEG, fm_IMUs);
            final_trajectories(6, :) = resample(filtered_trajectories(6, :), fm_EEG, fm_IMUs);
            fm=fm_EEG;
            final_EEG=filtered_EEG;
        case 2
            fprintf('Resample to match EEG and trajectories to 60 Hz both (500->60 & 30->60).\n');
            fm_EEG = 60;
            fm_IMUs = 60;
            task_indexes = round(6*resample(session.index_EEG, fm_EEG, session.sample_frec_EEG));
            final_trajectories = zeros(6, size(session.data_EEG, 2)*fm_IMUs/session.sample_frec_EEG);
            final_trajectories(1, :) = resample(filtered_trajectories(1, :), fm_IMUs, session.sample_frec_angles);
            final_trajectories(2, :) = resample(filtered_trajectories(2, :), fm_IMUs, session.sample_frec_angles);
            final_trajectories(3, :) = resample(filtered_trajectories(3, :), fm_IMUs, session.sample_frec_angles);
            final_trajectories(4, :) = resample(filtered_trajectories(4, :), fm_IMUs, session.sample_frec_angles);
            final_trajectories(5, :) = resample(filtered_trajectories(5, :), fm_IMUs, session.sample_frec_angles);
            final_trajectories(6, :) = resample(filtered_trajectories(6, :), fm_IMUs, session.sample_frec_angles);
            
            final_EEG = zeros(27, size(session.data_EEG, 2)*fm_IMUs/session.sample_frec_EEG);
            for channel=1:27
                final_EEG(channel, :) = resample(filtered_EEG(channel, :), fm_EEG, session.sample_frec_EEG);
            end
            fm=fm_EEG;
        otherwise
            error('Resample not contemplated.\n');
    end
    
    %% CHOP SIGNALS
    fprintf('Chop signals.\n');
    % Find stretches limits:
    limits = find(task_indexes<0);
    limits = [limits size(task_indexes, 2)];
    % Stretch 1:
    eval(sprintf('filtered_signals.filtered_signals_%d.EEG.stretch_1 = final_EEG(:, limits(2):limits(3)-1);', f));
    eval(sprintf('filtered_signals.filtered_signals_%d.trajectories.stretch_1 = final_trajectories(:, limits(2):limits(3)-1);', f));
%     % Stretch 2:
    eval(sprintf('filtered_signals.filtered_signals_%d.EEG.stretch_2 = final_EEG(:, limits(5):limits(6)-1);', f));
    eval(sprintf('filtered_signals.filtered_signals_%d.trajectories.stretch_2 = final_trajectories(:, limits(2):limits(3)-1);', f));
%     % Stretch 3:
    eval(sprintf('filtered_signals.filtered_signals_%d.EEG.stretch_3 = final_EEG(:, limits(8):limits(9));', f));
    eval(sprintf('filtered_signals.filtered_signals_%d.trajectories.stretch_3 = final_trajectories(:, limits(8):limits(9));', f));   
    
    %% STANDARIZE SIGNALS
    fprintf('Standarize signals.\n');
    for num_stretch = 1:3
        % EEG:
        eval(sprintf('EEG = filtered_signals.filtered_signals_%d.EEG.stretch_%d;', f,num_stretch)); % EEG load.
        %     eval(sprintf('standarized_signals.EEG.stretch_%d = zeros(27, size(filtered_signals.EEG.stretch_%d, 2));', num_stretch, num_stretch));   % Memory reserve.
        for num_chan = 1:size(EEG, 1)
            aver = mean(EEG(num_chan, :));  % Mean of the stretch.
            stand = std(EEG(num_chan, :));  % Standard devition of the stretch.
            eval(sprintf('filtered_signals.filtered_signals_%d.EEG.stretch_%d = (EEG(num_chan, :)-aver)./stand;', f,num_stretch));
        end
    end
    eval(sprintf('filtered_signals.filtered_signals_%d.fm = fm;', f));
end

% Regression:
[C_corr_out,X_dec_out, fm] = multi_linear_regression(filtered_signals, L, G, N);

% fprintf('Right ankle\t%f\t%d\t%f\t%s\nLeft ankle\t%f\t%d\t%f\nRight knee\t%f\t%d\t%f\nLeft knee\t%f\t%d\t%f\nRight hip\t%f\t%d\t%f\nLeft hip\t%f\t%d\t%f\nMean\t%f\nSTD\t%f\n',...
%     C_corr_out(1), G, (L*G-G+1)/fm, files.filename{1}(9:10),...
%     C_corr_out(2), G, (L*G-G+1)/fm,...
%     C_corr_out(3), G, (L*G-G+1)/fm,...
%     C_corr_out(4), G, (L*G-G+1)/fm,...
%     C_corr_out(5), G, (L*G-G+1)/fm,...
%     C_corr_out(6), G, (L*G-G+1)/fm,...
%     mean(C_corr_out),...
%     std(C_corr_out))

%% PLOT KINEMATICS
if show_flag
    plot_decoded_trajectories(C_corr_out,X_dec_out,files.n_files, fm, L, G,  files.filename{1}(9:10));
end

end