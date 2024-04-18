%% STATS and stationary analysis of strength

% analysis of internal variance in the strength measure. Example test

cd("C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\BIDSpipeline_results_FCthermo\ALL_w7s5")
fold='beta'; cond="resp";
fold= strcat(fold,'\',cond');
cd(fold)

%test
pre= load('sub-e2924ad7529a_ses-postimp_task-preTC_run-01_ieeg__algo-r2_hp-15_lp-30.mat');
post = load('sub-e2924ad7529a_ses-postimp_task-postTC_run-01_ieeg__algo-r2_hp-15_lp-30.mat');

h_pre= pre.aw_h2; lag_pre= pre.aw_lag;
h_post=post.aw_h2; lag_post=post.aw_lag;
[stre_pre, dir_pre]=strength(h_pre, lag_pre);
[stre_post, dir_post]=strength(h_post, lag_post);

hA_pre=pre.aw_h2(:,:,1:end/2); hB_pre=pre.aw_h2(:,:,(end/2)+1:end);
lagA_pre=pre.aw_lag(:,:,1:end/2); lagB_pre=pre.aw_lag(:,:,(end/2)+1:end);

hA_post=post.aw_h2(:,:,1:end/2); hB_post=post.aw_h2(:,:,(end/2)+1:end);
lagA_post=post.aw_lag(:,:,1:end/2); lagB_post=post.aw_lag(:,:,(end/2)+1:end);

[streA_pre, dirA_pre]= strength(hA_pre,lagA_pre);
[streB_pre, dirB_pre] = strength(hB_pre, lagB_pre);

[streA_post, dirA_post]= strength(hA_post,lagA_post);
[streB_post, dirB_post] = strength(hB_post, lagB_post);
%

