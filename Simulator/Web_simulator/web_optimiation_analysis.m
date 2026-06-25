clear all
close all
clc
format shorte

%% selection
seed_web = 'full_feature' ; % {'full_feature','no_free_zone'}; 'full_feature': web with free zone feature, 'no_free_zone' web without free zone feature
DOF = '5DoF' ; %{'5DoF', '9DoF'}; Optimization DoF
opt_type = 'ga' ; % {'ga', 'fmincon', 'ga_fmincon', 'none'}; select optimization type or their combination. 'none': try sample results
sample_results = 3 ; % [1:5]; sample results from optimization studies. 1: seed web, 2: 5DoF with features, 3: 9DoF with features, 4: 5DoF without free zone features, 5: 9DoF without free zone features
postproc_damage = 'predefined'; % {'predefined', 'random'}; 'predefined': post process final optimization results based on predefined damaged lines and 8-point classification task, 'random': postprocess final optimization results based on random selection of damaged lines and 17-point classification task

%% optimization parameters
n_trials = 1 ; % number of damage trials to take a mean from,
               % 3 for random damage, 1 for predefined points/lines

%% simulation default par.s
file_type = 'opt'; % optimization and sensitivity analysis

pars.animate_path = false ;
pars.isPlot = false ;
pars.isTerminalPrint = false ;
pars.isGCode = false ;
pars.fixedPoints = [] ;
pars.frameType = 'pointVector' ;
pars.isTrain = true ;
pars.i_web = 1 ;
pars.excite_indices_variation_max = 0 ;
pars.excite_loc_variation_max = 0 ;
pars.n_damageItteration = 3 ; % set to 3 to have 1 damage case only
pars.n_damageBatch = 50 ; % OVERRIDEN BELOW!
pars.SUDONG_EXCITE_READOUT = 'no' ; % classification task with 24 excitation points
pars.EXCITE_LOCATION = false ;
pars.damageCase = 'lines' ; % randomly introducing damage results in non-converging & non-consistent optimization results
pars.latDispReadPoint = [] ;

%% optimization seed
% Symmetric biological web from Fritz's imag001 WITH free zone features
% USE EXCITATION INDICES to stay valid for large dimensional variations
pars.n_damageBatch = 50 ;

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


%% Symmetric biological web from Fritz's imag001 WITHOUT free zone features
if strcmp(seed_web,'no_free_zone')
    opt_par.r0_cap = opt_par.r_frame / ( opt_par.n_cap + opt_par.n_hub ) * opt_par.n_hub ;
    opt_par.r_hub = opt_par.r0_cap ;
    opt_par.r_cap = opt_par.r_frame ;
    % opt_par.r_hub /opt_par.n_hub % check
    % (opt_par.r_cap - opt_par.r0_cap) / opt_par.n_cap % check
end


%% sim parameters
fit_val = nan ; % dummy value to prevent error


%% optimization parameters
if strcmp(DOF,'5DoF')
    % base parameters: symmetric biological web Fritz's image001
    dof = 5 ; % number of opt dof.s
    X = [  opt_par.r_frame , opt_par.xy_center' , opt_par.r_hub , opt_par.r_cap ]
    A = [ -1 0 0 0 1 ] ; % A*x <= b, r_cap < r_frame
    b = [ 0 ] ;
    % lb = [ 0.7 -0.5 -0.5 0.05 0.7 ] ; % lb <= x <= ub
    % ub = [   1  0.5  0.5  0.2   1 ] ;
    lb = [ 0.7 -0.7 -0.7 0.05 0.7 ] ; % lb <= x <= ub
    ub = [   1  0.7  0.7  0.2   1 ] ;
end

% extended parameters
if strcmp(DOF,'9DoF')
    dof = 9 ; % number of opt dof.s
    X = [  opt_par.r_frame , opt_par.xy_center' , opt_par.r_hub , opt_par.r_cap , ...
        opt_par.distort_frame(1,1) , opt_par.distort_frame(2,1) , opt_par.distort_frame(1,2) , opt_par.distort_frame(2,2) ]
    A = [ -1 0 0 0 1 0 0 0 0 ] ; % r_frame > r_cap
    b = [ 0 ] ;
    lb = [ 0.7 -0.7 -0.7 0.05 0.7 0.7 0.7 0.7 0.7 ] ;
    ub = [   1  0.7  0.7  0.2   1   1   1   1   1 ] ;
    % lb = [ 0.7 -0.7 -0.7 0.05 0.7 0.5 0.5 0.5 0.5 ] ;
    % ub = [   1  0.7  0.7  0.2   1   1   1   1   1 ] ;
end


%% optimization
% global optimization
if strcmp(opt_type,'ga')
    options = optimoptions( 'ga', 'InitialPopulationMatrix', X, 'UseParallel', false, 'PlotFcn', { @gaplotbestf , @gaplotbestindiv }, 'MaxGenerations', 100, 'PopulationSize', 100 );
    [ X , fit_val ] = ga( @(X)fit_func( X , pars , opt_par , file_type , n_trials , dof ), dof, ...
        A, b, [], [], lb, ub, [], options )
    % [ X , fit_val ] = ga( @(X)fit_func( X , pars , opt_par , file_type , n_trials , dof ), dof, ...
    %     A, b, [], [], lb, ub, @(X)nonlcon( X , pars , opt_par , dof ), options ) % takes ages
end

% local optimization
if strcmp(opt_type,'fmincon') || strcmp(opt_type,'ga_fmincon')
    options = optimoptions( 'fmincon', 'PlotFcn', { @optimplotx , @optimplotfval } );
    [ X , fit_val ] = fmincon( @(X)fit_func( X , pars , opt_par , file_type , n_trials , dof ), X, ...
        A, b, [], [], lb, ub, [], options)
    % [ X , fit_val ] = fmincon( @(X)fit_func( X , pars , opt_par , file_type , n_trials , dof ), X, ...
    %     A, b, [], [], lb, ub, @(X)nonlcon( X , pars , opt_par , dof ), options)
end


%% results
% result records:
X_results = [ opt_par.r_frame , opt_par.xy_center' , opt_par.r_hub , opt_par.r_cap, 0, 0, 0, 0 ; % seed web
      9.0440e-01   1.5325e-02   2.0496e-02   1.2971e-01   8.1117e-01, 0, 0, 0, 0 ; % 5 DoF with features
      0.869801 -0.0749579 -0.0134072 0.0859151 0.804076 0.838754 0.977723 0.964301 0.869657 ; % 9 DoF with features
      8.7696e-01   4.5919e-02   7.4480e-03   1.3183e-01   7.9399e-01, 0, 0, 0, 0 ; % 5 DoF WITHOUT fee zone feature
      8.652942181432565e-01    -2.242351161789710e-03     7.082468491100561e-03     9.522967348188613e-02     8.376531344286868e-01     9.000969824554618e-01     9.648393118454173e-01     9.442415349950113e-01     9.257114675316284e-01 ] ; % 9 DoF WITHOUT fee zone feature
fit_val_results = [ 2.5e-01; % seed web
            8.7500e-01; % 5 DoF with features
            1.25e-01; % 9 DoF with features
            1.2500e-01; % 5 DoF WITHOUT fee zone feature
            1.250000000000000e-01] ; % 9 DoF WITHOUT fee zone feature
mean_accuracy_results = [ 7.5e-01; % seed web
                  1.2500e-01; % 5 DoF with features
                  nan; % 9 DoF with features
                  8.7500e-01; % 5 DoF WITHOUT fee zone feature
                  8.7500e-01] ; % 9 DoF WITHOUT fee zone feature
if strcmp(opt_type,'none') % run sample result for optimization based on predefined 50 damaged links
    X = X_results(sample_results,:) ;
    fit_val = fit_val_results(sample_results) ;
    mean_accuracy = mean_accuracy_results(sample_results) ;
end

%% post-processing
% clc

% opt step analysis (with fixed damage points)
pars.isPlot = true;
pars.isTerminalPrint = false ;
n_trials = 1 ; % number of trials for final evaluation
pars.n_damageItteration = 3 ; % set to 3 to have 1 damage case only

% final analysis (with random damage points)
if  strcmp( postproc_damage, 'random')
    n_trials = 5 ; % number of trials for final evaluation
    pars.n_damageItteration = 4 ; % set to 3 to have 1 damage case only
    pars.damageCase = 'random' ;
    pars.excite_indices_variation_max = 1 ;
    pars.SUDONG_EXCITE_READOUT = 'damage' ;
end

% final evaluation
[ c , ceq ] = nonlcon( X , pars , opt_par , dof ) ;
accuracy = accuracy_func( X , pars , opt_par , file_type , n_trials , dof , true ) ;
view([0,-1,1])

% report:
format longe
c
ceq
X
fit_val
accuracy
mean_accuracy = mean(accuracy)
inv_mean_accuracy = 1 - mean_accuracy 
save( 'opt_result.mat' )


%% functions
function inv_mean_accuracy = fit_func( X , pars , opt_par , file_type , n_trials , dof )
accuracy = accuracy_func( X , pars , opt_par , file_type , n_trials , dof , false ) ;
inv_mean_accuracy = 1 - mean( accuracy ) ;
if true || inv_mean_accuracy < 1e-1 % report
    X
    accuracy
    inv_mean_accuracy
end
end

function accuracy = accuracy_func( X , pars , opt_par , file_type , n_trials , dof , SAVE_RESULTS )
% X
% parameters: to work with different number of optimization parameters
if dof >= 5
    opt_par.r_frame = X(1) ;
    opt_par.xy_center = X(2:3)' ;
    opt_par.r_hub = X(4) ;
    opt_par.r_cap = X(5) ;
end
if dof >= 9
    opt_par.distort_frame(1,1) = X(6) ;
    opt_par.distort_frame(2,1) = X(7) ;
    opt_par.distort_frame(1,2) = X(8) ;
    opt_par.distort_frame(2,2) = X(9) ;
end

% constraint check
constraint = nonlcon( X , pars , opt_par , dof ) ;
if true && max( constraint ) <= 0 % nonlinear constraint is satisfied
    % simulation trials
    while true
        i_opt = 0 ; % optimization iterator
        accuracy = [] ; % collect accuracy across trials
        while i_opt < n_trials
            i_opt = i_opt + 1 ;
            [ lines , lines_index , fixedPoints ] = random_web( opt_par , false , true ) ; % isRank is True to set the noise to zero
            results.file_name = lines ;
            pars.fixedPoints = fixedPoints ;
            
            [ results.sim_data , results.sampTime ,  results.latDispReadPoint , results.p_mean , results.points , results.lines , results.section_lines , results.net , results.accuracy ] = ...
                mesh_import( 'optimization', file_type, results.file_name, [] , [] , pars ) ;
            pars.latDispReadPoint = results.latDispReadPoint ;
            % clf % clear web fig if being monitored
            
            accuracy = [ accuracy ; results.accuracy ] ;
        end
        
        accuracy ;
        inv_mean_accuracy = 1 - mean( accuracy ) ;
        if inv_mean_accuracy == 0 % repeat the evaluation if 0
            % X
            accuracy
            inv_mean_accuracy
        else % report the fitness
            break
        end
    end

    if SAVE_RESULTS % save results
        save( 'sim_pars_results' , 'X' , 'pars' , 'opt_par' , 'file_type' , 'n_trials' , 'dof' , 'results' )
    end

else % nonlinear constraint is not satisfied!
    accuracy = 0 ;
    inv_mean_accuracy = 1 - accuracy ;

end 

end


function [ c , ceq ] = nonlcon( X , pars , opt_par , dof ) 
% parameters: to work with different number of optimization parameters
if dof >= 5
    opt_par.r_frame = X(1) ;
    opt_par.xy_center = X(2:3)' ;
    opt_par.r_hub = X(4) ;
    opt_par.r_cap = X(5) ;
end

% r_cap - r_frame <= 0: is already satisfied above as Ax-b<=0
c = [ ... % c <= 0, to keep the hub radius less than the min cap inner radius
    ... ( ( opt_par.r_hub + opt_par.r_hub / opt_par.n_hub ) - ... % ( r_hub + dr_hub ) - ( min_r_cap0 ) <= 0
    ( opt_par.r_hub - ... % r_hub - ( min_r_cap0 ) <= 0
    ( ( opt_par.r_frame - norm( opt_par.xy_center ) ) / opt_par.r_frame * opt_par.r0_cap ) ) , ...
    ];
ceq = 0 ; % ceq = 0

end


