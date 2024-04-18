%% GRAPH COMPARE stats Functional connectivity

%% set directory
clearvars
cd("C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\BIDSpipeline_results_FCthermo\ALL_w7s5")
fold='alpha'; cond="resp";
fold= strcat(fold,'\',cond');
cd(fold)
myfiles = dir('*.mat');

%% upload matrix with ROI labels
%[num, txt, raw] = xlsread('Y:\users\Simula\Thermo\PatientsThermo_SARA.xlsx', 'ElectrodesMatrixFC');
chan_info = readtable('Y:\users\Simula\Thermo\PatientsThermo_SARA.xlsx', 'Sheet', 'ElectrodesMatrixFC');


%% upload data
%OPTION 1: each subject separately
% subj = "3560ee60e7c2";
% algo = "r2_hp-1_lp-4";
% 
% cond = "post";  %post or pre
% post = strcat("sub-", subj, "_ses-postimp_task-", cond, "TC_run-01_ieeg__algo-", algo);
% all_dataPOST = load(post);
% 
% cond = "pre";  
% pre = strcat("sub-", subj, "_ses-postimp_task-", cond, "TC_run-01_ieeg__algo-", algo);
% all_dataPRE = load(pre);


%% extract the important variables from all_data:
%each channel has its own strenght measure (average for all windows), and
%we must compare the before TC vs the after TC.

% channels = string(all_dataPOST.electrode_names); %single row cell with channels names trasformed into a string array

% strengths_post= all_dataPOST.aw_h2; %if i understood well, it's a 3d matrix containing 1 2D matrix for each window. In each 2d matrix, each electrode has its strenght h2 against each other electrode
% lags_post = all_dataPOST.aw_lag; %same structure as aw_h2, gives directionality info based on lag
% times_post = all_dataPOST.time;
% 
% strengths_pre = all_dataPRE.aw_h2;
% lags_pre = all_dataPRE.aw_lag;
% times_pre = all_dataPRE.time;

% strengths_post= mean(all_dataPOST.aw_h2,3); %if i understood well, it's a 3d matrix containing 1 2D matrix for each window. In each 2d matrix, each electrode has its strenght h2 against each other electrode
% lags_post = mean(all_dataPOST.aw_lag,3); %same structure as aw_h2, gives directionality info based on lag
% 
% strengths_pre = mean(all_dataPRE.aw_h2,3);
% lags_pre = mean(all_dataPRE.aw_lag,3);

%% OPTION 2: load mat files of all subjects in a certain directory

%initialize matrix where all data will be stored (pooled for all patients)
INstre = [];
OUTstre = [];
TOTstre = [];
roi=[];
for index=1:2:length(myfiles)
    alldata_post = load(myfiles(index).name);
    alldata_pre = load(myfiles(index+1).name);
    subj = string(extractBetween(myfiles(index).name, 'sub-', '_ses'));
    channels = string(alldata_pre.electrode_names);

%% division in EZ, PZ, NI
%upload the file containing the divisions between ROIs. In my case, it is a
%different file form the montage one so I have to do a bit more of work

subchan = chan_info(chan_info.SubjBIDS == subj, :); %extract subtable of subject's data
% thermocontacts = chan_info(chan_info.Thermo == 'yes', :);
%add info on ROI for each channel in 'channels'
for i=1:length(channels)
%     if i>length(channels)
%         break
%     end
    check=string(channels(i));
   if ~isempty(string(subchan.ROI(subchan.Channel == check)))
    roi= [roi; subj,  check, string(subchan.ROI(subchan.Channel == check)), string(subchan.Thermo(subchan.Channel == check))];
   else   roi= [roi; subj, check, "empty", ""];
   end
   
%    else   roi= [roi; "?"];
%         display(channels(i)+ ' deleted in sub-' + subj)
%         channels(i) = [];
%         alldata_pre.aw_h2(i,:,:) = []; alldata_pre.aw_h2(:,i,:) = []; 
%         alldata_pre.aw_lag(i,:,:) = []; alldata_pre.aw_lag(:,i,:) = [];
%         alldata_post.aw_h2(i,:,:) = []; alldata_post.aw_h2(:,i,:) = [];
%         alldata_post.aw_lag(i,:,:) = []; alldata_post.aw_lag(:,i,:) = []; 
%         i=i-1;
    
    
end
%% calculate the in, out, tot strengths (thr_h2=0 for strength, >0 for degrees) using the funcyion countlinks in graphcompare
thr_h2 = 0; %strength if 0, degrees if >0
thr_lag = 1; %default in graphcompare
[links_pre,tit_pre,times_pre]=ins_countlinks(alldata_pre,thr_h2,thr_lag);
[links_post,tit_post,times_post]=ins_countlinks(alldata_post,thr_h2,thr_lag);

INstre_pre = mean(links_pre{1}, 2);
OUTstre_pre = mean(links_pre{2}, 2);
TOTstre_pre = mean(links_pre{3}, 2);

INstre_post = mean(links_post{1}, 2);
OUTstre_post = mean(links_post{2}, 2);
TOTstre_post = mean(links_post{3}, 2);

INstre = [INstre; INstre_post INstre_pre];
OUTstre = [OUTstre; OUTstre_post OUTstre_pre];
TOTstre = [TOTstre; TOTstre_post TOTstre_pre];

clearvars -except INstre OUTstre TOTstre myfiles chan_info index roi fold cond
end

preS = @(x) strcat('pre',x);
postS = @(x) strcat('post',x);
roi_tot = [cellfun(postS,roi(:, 3),'UniformOutput',false); cellfun(preS,roi(:, 3),'UniformOutput',false)];
tot= [TOTstre(:,1); TOTstre(:,2)];
thermoyesno = [cellfun(postS,roi(:, 4),'UniformOutput',false); cellfun(preS,roi(:, 4),'UniformOutput',false)];
diffstreTOT = diff(TOTstre,1,2);
bigtable = table(roi(:,1), roi(:,2), roi(:,3), roi(:,4), diffstreTOT);
bigtable.Properties.VariableNames = {'subj','channel','ROI', 'thermo', 'TOTpostpre'};

% %% display the stats via a violin plot
figure
data_thermo=[tot string(thermoyesno)];
postyes=data_thermo(data_thermo(:,2)=="postyes", :);
preyes= data_thermo(data_thermo(:,2)=="preyes", :);
% grouporder={'preEZ', 'postEZ', 'prePZ', 'postPZ', 'preNI', 'postNI'};
% cats=categorical(grouporder);
grouporder={'preyes', 'postyes'};
cats=categorical(grouporder);
vs = violinplot(str2double([preyes(:,1); postyes(:,1)]), [preyes(:,2); postyes(:,2)],'GroupOrder',grouporder); %can put roi_tot au lieu de thermoyesno
title(strcat(fold,'- postvspre'));
hold all
plot(str2double([preyes(:,1) postyes(:,1)])','o-')
xlabel('condition+ROI'); ylabel('TOT strength');


%% violin with LINES pre-post
% data_tot=[tot string(roi_tot)];
% graphit(data_tot, 1, "tot strength", cond, fold)
% out= [OUTstre(:,1); OUTstre(:,2)];
% data_out=[out string(roi_tot)];
% graphit(data_out, 1, "out strength", cond, fold)
% in= [INstre(:,1); INstre(:,2)];
% data_in=[in string(roi_tot)];
% graphit(data_in, 1, "in strength", cond, fold)


%% comparison
%   
function  graphit(data, norm, ylab, cond, fold) 
   
    ez=str2double([data(data(:,2)=="preEZ",1) data(data(:,2)=="postEZ",1)]);
    pz=str2double([data(data(:,2)=="prePZ",1) data(data(:,2)=="postPZ",1)]);
    ni=str2double([data(data(:,2)=="preNI",1) data(data(:,2)=="postNI",1)]);

    roiez=cellstr([data(data(:,2)=="preEZ",2); data(data(:,2)=="postEZ",2)]);
    roipz=cellstr([data(data(:,2)=="prePZ",2); data(data(:,2)=="postPZ",2)]);
    roini=cellstr([data(data(:,2)=="preNI",2); data(data(:,2)=="postNI",2)]);

   if strcmp(norm, 'true') || norm ==1
       EZ=normalize(ez); PZ=normalize(pz); NI=normalize(ni);
   end
    
    if strcmp(cond, "resp")

        subplot(2,3,1)
        grouporder={'preEZ', 'postEZ'};
        vs = violinplot([EZ(:,1); EZ(:,2)] , roiez, 'GroupOrder',grouporder);
        hold all
        plot(EZ','o-')
        ylabel(ylab);

        subplot(2,3,2)
        grouporder={'prePZ', 'postPZ'};
        vs = violinplot([PZ(:,1); PZ(:,2)] , roipz, 'GroupOrder',grouporder);
        hold all
        plot(PZ','o-')
        title(strcat(fold,'- postvspre'));
        xlabel('condition+ROI');

        subplot(2,3,3)
        grouporder={'preNI', 'postNI'};
        vs = violinplot([NI(:,1); NI(:,2)] , roini, 'GroupOrder',grouporder);
        hold all
        plot(NI','o-')

    else if strcmp(cond,"nonresp")
        subplot(2,3,4)
        grouporder={'preEZ', 'postEZ'};
        vs = violinplot([EZ(:,1); EZ(:,2)] , roiez, 'GroupOrder',grouporder);
        hold all
        plot(EZ','o-')
        ylabel(ylab);

        subplot(2,3,5)
        grouporder={'prePZ', 'postPZ'};
        vs = violinplot([PZ(:,1); PZ(:,2)] , roipz, 'GroupOrder',grouporder);
        hold all
        plot(PZ','o-')
        title(strcat(fold,'- postvspre'));
        xlabel('condition+ROI'); 

        subplot(2,3,6)
        grouporder={'preNI', 'postNI'};
        vs = violinplot([NI(:,1); NI(:,2)] , roini, 'GroupOrder',grouporder);
        hold all
        plot(NI','o-')   
        end
    end
end
    

    







