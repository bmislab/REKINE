function session = load_session(path_file)

% This function take the files of the REKINE project chosen previously in
% the function select_files
% and creates the session struct with the necessary data that will be
% used for the study. An example of the files with the corresponding format have to be in the same folder
% to work properly: 
% subject_02_cond_03_run_03_EEG.csv
% subject_02_cond_03_run_03_EEG.json 
% subject_02_cond_03_run_03_jointAngles.csv

%% EEG data extraction
t = readtable(path_file); % Reads CSV and convert it to table 
session.time = t.time'; % Time vector for EEG
temporal_index = t.task'; % Task performed in each moment
session.electrodes = t(:, 2:32).Properties.VariableNames;
session.data_EEG = table2array(t(:, 2:32))'; %EEG raw data of the trial

% Index vector creation
real_index=zeros(1,size(temporal_index,2));
derivada=diff(temporal_index);
indices = find(derivada~=0);

for j=1:1:length(indices)
    real_index(indices(j)+251)=j;
    if j~=1
    real_index(indices(j)+1)=-j;         
    end
end
session.index_EEG=real_index;

% Extracts the variable SamplingFrequency from the json file
fid_EEG = fopen([path_file(1:end-3) 'json']); % Opening the file
raw_EEG = fread(fid_EEG,inf); % Reading the contents
str_EEG = char(raw_EEG'); % Transformation
fclose(fid_EEG); % Closing the file
data_EEG = jsondecode(str_EEG); % Using the jsondecode function to parse JSON from str_EEG
session.sample_frec_EEG=data_EEG.SamplingFrequency;

%% Joint real angles data extraction

t2 = readtable([path_file(1:end-7) 'jointAngles.csv']); % Reads CSV and convert it to table 
session.IMUs_angles = table2array(t2(:, 3:3:18))';
session.sample_frec_angles=round(1/(double(table2array(t2(2,1)))-double(table2array(t2(1,1))))); % IMUs sample frequency 

% fid_angles = fopen([path_file(1:end-7) 'angles.json']); % Opening the file
% raw_angles = fread(fid_angles,inf); % Reading the contents
% str_angles = char(raw_angles'); % Transformation
% fclose(fid_angles); % Closing the file
% data_angles = jsondecode(str_angles); % Using the jsondecode function to parse JSON from str_anglesing

end
