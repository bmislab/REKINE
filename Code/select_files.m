function files=select_files()

% This function restricts the files taken to the CSV files for EEG. Even if
% that data is not the unique that is going to be used, only the files of the 
% folder that meet the requirements are allowed to be selected.

[files.filename, files.pathname, files.n_files] = uigetfile( ...
    {'*.csv','CSV-files (*.csv)'}, ...
    'Choose the EEG data files', '*cond_03*EEG.csv','MultiSelect', 'on');

if iscell(files.filename)
    files.filename=sort(files.filename);
end

if and(files.n_files~=0,~iscell(files.filename))
    files.filename=cellstr(files.filename);
end

if files.n_files~=0
    files.n_files=length(files.filename);
end

return