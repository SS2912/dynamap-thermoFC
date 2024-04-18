clear all

dir_data        = 'C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo\AAA_LAST RESULTS';
dir_info        = 'C:\Users\simula\OneDrive - Aix-Marseille Université\PhD\MyProjects\Thermo';

name_info_table = 'PatientsThermo_SARA.xlsx';
dir_res         = strcat(dir_data, '\', 'Clinical_info_tables');

sheets = ["ElectrodesMatrixFC" "Allsubj_matlab"];
% selROI = "ez+pz";
pars = ["Etiology_epi","Age_at_thermocoag","LocationMRILesion","Duration_of_improvement", "OutcomeOfSurgery1"]; % test, to change , "Outcome of surgery1"
norm = 1; %norm 2 is zscore on the normalised strength, 1 is median on norm strength, 0 is median on non norm strength

%% broad
fold = "broadband";
roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
broadband_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "all", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(broadband_all, output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
broadband_ezpz = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "ez+pz", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(broadband_ezpz,output);

%% delta
fold = "delta";
roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
deltaT_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "all", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(deltaT_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
delta_ezpz = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "ez+pz", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(delta_ezpz,output);


%% beta
fold = "beta";
roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
betaT_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "all", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(betaT_all, output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
betaT_ezpz = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "ez+pz", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(betaT_ezpz, output);

%% alpha
fold = "alpha";

roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
alpha_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(alpha_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
alphaEZPZ = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(alphaEZPZ,output);

%% theta
fold = "theta";
roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
theta_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "all", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(theta_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
theta_ezpz = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', "ez+pz", 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(theta_ezpz,output);

%% low gamma
fold = "lowgamma";

roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
lowgamma_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(lowgamma_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
lowgammaEZPZ = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(lowgammaEZPZ,output);
%% high gamma
fold = "highgamma";

roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
highgamma_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(highgamma_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
highgammaEZPZ = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(highgammaEZPZ,output);
%% ripple
fold = "ripple";

roi_sel = "all";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
ripples_all = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(ripples_all,output);

roi_sel = "ez+pz";
output = strcat(dir_res,'\',fold,'_',roi_sel,'_norm',string(norm), '_', 'withzval','.csv');
ripplesEZPZ = MMTable(dir_data, fold, dir_info, name_info_table, 'roi', roi_sel, 'sheets', sheets, 'subj_param', pars, 'norm', norm);
writetable(ripplesEZPZ,output);

