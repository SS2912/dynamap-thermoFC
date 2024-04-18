%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                SPIKE RATE DIFFERENCE THERMO                %%%%%%%
%%%%%%%               S. Simula - Dec/ Jan 2022/2023               %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1a. prepare to read the excel files in the folders (pre, post folders)
% to change with your directory if different than this one. For the sake of
% reviewers' comments, we only analysed preTC vs postB, so we only need 2
% folders
clear

% if at lab: 
folder_pre  = "C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate\pre";
folder_post = "C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate\post";

% if in teletravail:
% folder_pre  = "C:\Users\saras\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate\pre";
% folder_post = "C:\Users\saras\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate\post";

subdirs_pre  = strcat(folder_pre, '\**\*.xlsx');
subdirs_post = strcat(folder_post, '\**\*.xlsx');
myfiles_pre  = dir(subdirs_pre);
myfiles_post = dir(subdirs_post);

%% 1b. read the montages of each patient, in which you will insert the calculated SR 
% (step which is necessary here cause delphos only keeps the non-zero detections channels in its results tables)

SR_diff_table = table();
mtgs = dir('C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate\montages_used\simula\**\*preTC_run-01_ieeg.vhdr.mtg');

for i = 1:size(mtgs,1) % for each subject
    SR_subtab = table();
    sub = string(extractBetween(mtgs(i).name, '-', '_'));
    montage_struct = dyn_read_mtg(strcat(mtgs(i).folder, '\', mtgs(i).name));
    % create table with bipolar channels and sub code where you'll insert
    % SR info
    for j = 1:length(montage_struct)
        SR_subtab.subj(j)= sub(1);
        SR_subtab.chan(j) = strcat(string(montage_struct(j).name), '-', string(montage_struct(j).reference));
    end
    

    %% 2. find the same subject's folder of pre SR and read + write the results onto SR_diff_table
    match = contains(string({myfiles_pre.name}), sub(1), 'IgnoreCase', true);
    if sum(match)
        cd(myfiles_pre(match).folder);
        opts = detectImportOptions(myfiles_pre(match).name);
        opts.SelectedVariableNames = ["Channels","Spk_Rate"]; % only reads the excel variables that we input
        subtab_pre = readtable(myfiles_pre(match).name, opts);
        
        for chan=1:size(subtab_pre,1)
            SR_subtab.SRpre(strcmp(string(subtab_pre.Channels(chan)), SR_subtab.chan)) = subtab_pre.Spk_Rate(chan);
        end
    else 
        SR_subtab.SRpre(:) = 0;
    end
    
    clearvars opts subtab_pre

    %% 3. do the same with post SR
    match = contains(string({myfiles_post.name}), sub(1), 'IgnoreCase', true);
    if sum(match) % we have one patient in pre which is not in post cause didnt have any detection so delphos did not create result excel
        cd(myfiles_post(match).folder);
        opts = detectImportOptions(myfiles_post(match).name);
        opts.SelectedVariableNames = ["Channels","Spk_Rate"]; % only reads the excel variables that we input
        subtab_post = readtable(myfiles_post(match).name, opts);
        
        for chan=1:size(subtab_post,1)
            SR_subtab.SRpost(strcmp(string(subtab_post.Channels(chan)), SR_subtab.chan)) = subtab_post.Spk_Rate(chan);
        end
    else 
        SR_subtab.SRpost(:) = 0;
    end
    
    clearvars opts subtab_post

    %% 4. concatenate the temp table in the whole table so to keep all subjects in one big table

    SR_diff_table = [SR_diff_table; SR_subtab];
    clearvars SR_subtab sub montage_struct
    
end

SR_diff_table.SRdiff = SR_diff_table.SRpost - SR_diff_table.SRpre;

name = strcat('C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\spikerate','\','SRtable.csv');
writetable(SR_diff_table,name)  

% if nsub_post < nsub_pre
%     allsubj = unique(tab_pre.sub);
%     idx = ismember(allsubj, unique(tab_post.sub), 'rows');
%     missing_sub = tab_pre(strcmp(tab_pre.sub, allsubj(~idx)),:);   
% else if nsub_post > nsub_pre
%         idx = ismember(unique(tab_post.sub), unique(tab_pre.sub), 'rows');
%         missing_sub = tab_pre(strcmp(tab_pre.sub, allsubj(~idx)),:);   
%     end
% end
% 
% %% merge the two tabs and calculate the SR difference for each channel
