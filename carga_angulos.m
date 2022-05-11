function carga_angulos(files)
%% DESCRIPTION
% This function executes all the stablished analysis to a REKINE
% register. It generates session_all.mat archives which contains data
% from EEG, HR, HRV, RR, GSR, IMUs, generated trajectories and decoded
% trajectories, for each one of the six lower limbs.
% EEG: Electroencephalografies.
% HR: Heart Rate.
% HRV: Heart Rate Variability.
% RR: Respiration Rate.
% GSR: Galvanic Skin Response.
% IMU: Inertial Measurement Unit.

if isempty(files)
    fprintf('Seleccionar los ficheros del usuario del 3 en adelante.\n')
    files=get_file_names();
end

%% SESSIONS LOAD
fprintf('Se han cargado un total de %d ficheros.\n',files.n_files)
for f=3:files.n_files
    load([files.pathname files.filename{f}],'session')
    fprintf('Cargando y obteniendo angulos del fichero %d de %d.\n',f,files.n_files)
    %% COMPUTE REAL LIMB TRAJECTORIES
    % Compute trajectories:
    real_angles = decode_IMUs_angles(session, 0, 1);
    
    %% SAVE REAL LIMB TRAJECTORIES
    session.limb_trajectories.real_right_ankle = real_angles(1, :);
    session.limb_trajectories.real_left_ankle = real_angles(2, :);
    session.limb_trajectories.real_right_knee = real_angles(3, :);
    session.limb_trajectories.real_left_knee = real_angles(4, :);
    session.limb_trajectories.real_right_hip = real_angles(5, :);
    session.limb_trajectories.real_left_hip = real_angles(6, :);
    
    %% SAVE COMPLETES SESSIONS
    if exist([files.pathname(1:end-1) '_angles\']) ~= 7
        mkdir([files.pathname(1:end-1) '_angles\'])
    end
    save([files.pathname(1:end-1) '_angles\' session.conf.acquisition.file_name '_angles.mat'], 'session');
end