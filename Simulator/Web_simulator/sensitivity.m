clear all
close all
clc


%% optimization parameters
n_trials = 5 ; % number of trials to take a mean from


%% simulation default par.s
file_type = 'opt'; % sensitivity analysis and optimization

pars.animate_path = false ;
pars.isPlot = false ;
pars.isTerminalPrint = false ;
pars.isGCode = false ;
pars.fixedPoints = [] ;
pars.frameType = 'pointVector' ;
pars.isTrain = true ;
pars.i_web = 1 ;
pars.excite_indices_variation_max = 1 ; % OVERRIDEN BELOW!
pars.excite_loc_variation_max = 5 ; % OVERRIDEN BELOW!
pars.n_damageItteration = 4 ; % OVERRIDEN BELOW!
pars.n_damageBatch = 50 ; % OVERRIDEN BELOW!
pars.SUDONG_EXCITE_READOUT = 'no' ; % classification task with 24 excitation points
pars.EXCITE_LOCATION = true ; % use only when the number of lines changes
pars.damageCase = 'random' ;
pars.latDispReadPoint = [] ;

%% sensitivity analysis seed
% Symmetric biological web from Fritz's imag001 WITH free zone features
% USE EXCITATION INDICES to stay valid for large dimensional variations
pars.excite_indices_variation_max = 0 ; % 0 for sensitivity analysis, 1 for index disturbing, 0 for location disturbing
pars.excite_loc_variation_max = 0 ; % 0 for sensitivity analysis, 0 for index disturbing, 1.5 for location disturbing
pars.n_damageItteration = 3 ; % 3 for sensitivity analysis, 4 for general analysis
pars.n_damageBatch = 50 ; % floor( 50 * 1593 / 1830 ) ;

opt_par.web_scale = 50 ;
opt_par.r_frame = 0.85 ;
opt_par.distort_frame = [ [1; 1] ,[1; 1] ] ;
opt_par.xy_center = [0; 0] ;
opt_par.n_rad = 27 ;
opt_par.n_hub = 5 ;
opt_par.r_hub = 0.1 ;
opt_par.n_cap = 23 ;
opt_par.r0_cap = 0.2 ;
opt_par.r_cap = 0.8 ;
opt_par.n_moor = 14 ;
opt_par.r_moor = 0.4 ;
opt_par.noise_rad = 0 * ones(1,opt_par.n_rad) ;
opt_par.noise_mooring = 0 * ones(1,opt_par.n_moor) ;

% % Shiv's polar web: USE EXCITATION INDICES
% pars.excite_indices_variation_max = 0 ; % 0 for perturbed location, 1 for perturbed index
% pars.excite_loc_variation_max = 5 ; % 5 for perturbed location, 0 for perturbed index
% pars.n_damageItteration = 4 ;
% pars.n_damageBatch = floor( 50 * 367 / 1830 ) ; % 10 to preserve the #lines to #damaged lines ratio, 20 for favorable results similar to Shiv's RoboSoft paper
% 
% opt_par.web_scale = 50 ;
% opt_par.r_frame = 1 ;
% opt_par.distort_frame = [ [1; 1] ,[1; 1] ] ;
% opt_par.xy_center = [0; 0] ;
% opt_par.n_rad = 16 ;
% opt_par.n_hub = 2 ;
% opt_par.r_hub = 0.1 ;
% opt_par.n_cap = 8 ;
% opt_par.r0_cap = 0.1 ;
% opt_par.r_cap = 0.9 ;
% opt_par.n_moor = 10 ;
% opt_par.r_moor = 0.2 ;
% opt_par.noise_rad = 0 * ones(1,opt_par.n_rad) ;
% opt_par.noise_mooring = 0 * ones(1,opt_par.n_moor) ;


%% simulation trials
i_opt = 0 ; % optimization iterator
accuracy = [] ; % collect accuracy across trials
while i_opt < n_trials
    i_opt = i_opt + 1 ;
    [ lines , lines_index , fixedPoints ] = random_web( opt_par , false , true ) ;
    file_name = lines ;
    pars.fixedPoints = fixedPoints ;
    % save('sym_bio_img001_w_features','file_name','fixedPoints')

    [ results.sim_data , results.sampTime ,  results.latDispReadPoint , results.p_mean , results.points , results.lines , results.section_lines , results.net , results.accuracy ] = ...
        mesh_import( 'sensitivity', file_type, file_name, [] , [] , pars ) ;
    pars.latDispReadPoint = results.latDispReadPoint ;
    
    % save( [ 'opt_results_' num2str(i_opt) ] , 'results' )
    accuracy = [ accuracy ; results.accuracy ] ;
end

accuracy
mean_accuracy = mean( accuracy )


