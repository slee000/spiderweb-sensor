%% Code to import web mesh or data file and generate the G-code for printing and SOFA scene for simulation
% This code uses DXFtool toolbox

function [ sim_data , sampTime , latDispReadPoint , p_mean , points , lines , section_lines , net , accuracy ] = ...
    mesh_import( testCase, file_type, file_name, KDr , tol , pars )

%% preparation
% close all
% clear all
% clc
format shorte
% pause(1e-1)

% link source files
addpath( 'igesToolBox_edited' , 'CAD source' ) ;


%% input parameters
if nargin < 1 || isempty( testCase )
    %% preparation
    close all
    clear all
    clc
    format shorte
    pause(1e-1)
    testCase = 'Fritz_image' ; % setting for different studies conducted on spider web simulation
                         % 'Beth', 'Fritz_code', 'Fritz_image', 'Shiv_image', 'shiv_polar', 'sudong_grid', 'sudong_polar', 'sensitivity', 'optimization'
end
if nargin < 6 || isempty( pars ) % some parameters below will get overridden in the rest of the code, make sure double checking that
    animate_path = false ; % animate the 3D printing path
    isPlot = true ; % plot the results
    isTerminalPrint = true ; % print in terminal
    isGCode = true ; % generate G-code or not
    i_web = 1 ; % Fritz's web instance only
    fixedPoints = [] ; % fixed mooring points for SOFA simulation
    frameType = 'square' ; % frame type to fix in SOFA: 'pointVector' to use predefined points, 'square' to fix the nodes on the square edges, '1stSectionName' to fix all the nodes in the 1st web section (usually "frame")
    isTrain = true ;
    excite_indices_variation_max = 1 ; % maximum variation in the excitation index, set to 0 for no variation
    excite_loc_variation_max = 0 ; % OVERRIDES INDEX VARIATION! maximum variation in the excitation location, set to 0 for no variation
    n_damageItteration = 4 ; % number of damaged web tests, 1: intact web, 2: excitation point variation, >2: damaged cases = ( n_damageItteration - 2 )
    n_damageBatch = 50 ; % number of damaged lines per iteration
    SUDONG_EXCITE_READOUT = 'damage' ; % {'no', 'damage', 'classification'}, type of excitation and readout points to match the experiments
    EXCITE_LOCATION = false ; % false- use excitation index (extracted from SOFA, for when only dimensions change)
                             % true- use excitation location (extracted from web Cartesian geometry, for when the number of lines changes due to damage or web morphological parameters change)
    damageCase = 'random' ; % 'random': randomly remove lines, 'lines': remove predefined lines, 'line_points': remove lines between predefined point pairs, 'points': remove all lines attached to predefined points
    latDispReadPoint = [] ; % to keep record of latest calculations and do not repeat them again
else
    animate_path = pars.animate_path ;
    isPlot = pars.isPlot ;
    isTerminalPrint = pars.isTerminalPrint ;
    isGCode = pars.isGCode ;
    i_web = pars.i_web ;
    fixedPoints = pars.fixedPoints ;
    frameType = pars.frameType ;
    isTrain = pars.isTrain ;
    excite_indices_variation_max = pars.excite_indices_variation_max ;
    excite_loc_variation_max = pars.excite_loc_variation_max ;
    n_damageItteration = pars.n_damageItteration ;
    n_damageBatch = pars.n_damageBatch ;
    SUDONG_EXCITE_READOUT = pars.SUDONG_EXCITE_READOUT;
    EXCITE_LOCATION = pars.EXCITE_LOCATION ;
    damageCase = pars.damageCase ;
    latDispReadPoint = pars.latDispReadPoint ;
end
if nargin < 3 || isempty( file_type ) || isempty( file_name )

    %<Beth's web>%
    if strcmp( testCase , 'Beth' )
        file_type = 'iges'; % my files
        file_name = {'frame3fixed_CAD'} ; % continuous radii
        file_name = {'frame3fixed_FEM'} ; % segmented radii
        file_name = {'mooring_frame','radial','capture','hub'}; % different stiffnesses
    end
        
    %<Fritz code data>%
    if strcmp( testCase , 'Fritz_code' )
        file_type = 'txt'; % fritz code data
        file_name = 'S347_1104';
    end

    %<Fritz's image extraction, Shiv's tests>%
    if strcmp( testCase , 'Fritz_image' ) || strcmp( testCase , 'Shiv_image' ) || strcmp( testCase , 'Shiv_polar' ) || strcmp( testCase , 'sensitivity' ) || strcmp( testCase , 'optimization' )
        file_type = 'mat'; % fritz image extraction
        file_name = [ 'img00' , num2str( i_web ) ] ; % amended in based on the web case as {img001, img002}
    end

    %<sensitivity analysis, & optimization>%
    if strcmp( testCase , 'sensitivity' ) || strcmp( testCase , 'optimization' )
        file_type = 'opt'; % fritz image extraction
        frameType = 'pointVector' ;
        load('sym_bio_img001_w_features.mat') % will load variable 'file_name' and 'fixedPoints' that contains lines structure variable and fixed points for a symmetric web based on Fritz's bio web img001
    end
    
    %<sudong code data>%
    if strcmp( testCase , 'sudong_grid' ) || strcmp( testCase , 'sudong_polar' )
        file_type = 'line_structure'; % fritz code data
        file_name = [ testCase '_lines' ] ;
    end
    
end
if nargin < 4 || isempty( KDr )
    mu = 8e-8 ; % from my paper
    K = [ 4 0.06 ] * 1e12 ;
    r = 1.2e-6; % single thread radius

    %<Beth's web & Fritz code data>%
    if strcmp( testCase , 'Beth' ) || strcmp( testCase , 'Fritz_code' )
        KDr = [ % K: stiffness, D: damping, r: radius coefficient. order should match the order of section_name
            4*K(1) , 4*mu , 4*r ; % mooring & frame
            3*K(1) , 3*mu , 3*r ; % radial
            2*K(2) , 2*mu , 2*r ; % capture (spiral)
            4*K(1) , 4*mu , 4*r ; % hub
            ] ;% K: stiffness, D: damping, r: radius
    end

    %<Fritz's image extraction, Shiv's & Sudong's tests, sensitivity analysis, & optimization>%
    if strcmp( testCase , 'Fritz_image' ) || strcmp( testCase , 'Shiv_image' ) || strcmp( testCase , 'Shiv_polar' ) || strcmp( testCase , 'sensitivity' ) || strcmp( testCase , 'optimization' ) || strcmp( testCase , 'sudong_grid' ) || strcmp( testCase , 'sudong_polar' )
        KDr = [ 3*K(1) , 3*mu , 3*r ] .* ones( numel(file_name) , 3 ) ;
    end
end
if nargin < 5 || isempty( tol )
    %<Beth's web>%
    if strcmp( testCase , 'Beth' )
        tol = [ 1e-3 1e-1 1e-1 1 ] ; % [m], [ merge_points, find_next_line_to_print, find_sides , unit_conversion ]
    end

    %<Fritz code data>%
    if strcmp( testCase , 'Fritz_code' )
        tol = [ 1e-3 1e-1 1e-1 0.07 ] ; % [um], [ merge_points, find_next_line_to_print, find_sides , unit_conversion ]
    end

    %<Fritz's image extraction>%
    if strcmp( testCase , 'Fritz_image' )
        tol = [ 5e-1 1e-1 1e-1 10 ] ; % [um], [ merge_points, find_next_line_to_print, find_sides , unit_conversion ]
    end
    
    %<Shiv's & Sudong's tests, sensitivity analysis & optimization>%
    if strcmp( testCase , 'Shiv_image' ) || strcmp( testCase , 'Shiv_polar' ) || strcmp( testCase , 'sensitivity' ) || strcmp( testCase , 'optimization' ) || strcmp( testCase , 'sudong_grid' ) || strcmp( testCase , 'sudong_polar' )
        tol = [ 0 1e-1 1e-1 10 ] ; % [um], [ merge_points, find_next_line_to_print, find_sides , unit_conversion ]
    end
end

if isTerminalPrint
    disp( 'mesh_import... \n' )
end


%% Compile the c-files: do it only once on each system!
% cd 'igesToolBox_edited'
% makeIGESmex ;
% cd ..


%% segmenting the web regions
lines = {} ; lines_index = [] ; n_lines = 0;
switch file_type
    
    % Beth's web
    case 'iges' % Load parameter data from IGES-file.
        if isTerminalPrint
            disp('Load IGES file...');
        end
        section_name = file_name; % each file contains the CAD for a section of the web
        kdr_i = [ 1 2 3 4 ] ;

        for i = 1 : numel( file_name )
            temp_lines = iges2matlab( [file_name{i} '.' file_type] ) ;
            for j = 1 : numel( temp_lines ) % add stiffness data
                temp_lines{i}.KDr = KDr(i,:) ;
            end
            lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
            n_lines = n_lines + numel(temp_lines) ;
            lines = [ lines temp_lines ] ; % all lines
        end
        
        % curve to line
        n_li = numel( lines ) ;
        n_lo = n_li ;
        for i = 1 : n_li % find fixed points and masses
            if strcmp( lines{i}.name , 'B-NURBS CRV' )
                for i_p = 1 : numel( lines{i}.p(1,:) ) - 1
                    n_lo = n_lo + 1 ;
                    lines{n_lo}.name = 'LINE' ;
                    lines{n_lo}.type = 110 ;
                    lines{n_lo}.p1 = lines{i}.p(:,i_p) ;
                    lines{n_lo}.p2 = lines{i}.p(:,i_p+1) ;
                end
            end
        end
        
    % Fritz code data
    case 'txt' % load Thiemo & Fritz's txt file
        if isTerminalPrint
            disp('Load Thiemo''s file...');
        end
        section_name = { 'Frame' , 'Radius' , 'CapSpiral' , 'Hub' }; % web section names: order should match the order of KDr rows       
        s = fileread( [ file_name '.' file_type ] ) ; % your text file's name
        kdr_i = [ 1 2 3 4 ] ;

        temp_lines = pext( s , 'Frame:' , +2 , 'Hub:' , -5 , KDr(1,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
                
        temp_lines = pext( s , 'Radius:' , +2 , 'AuxSpiral:' , -5 , KDr(2,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
%         temp_lines = pext( s , 'AuxSpiral:' , +2 , 'CapSpiral:' , -5 , KDr(2,:) , tol(4) ) ; % these are temporary and will be eaten
        temp_lines = pext( s , 'CapSpiral:' , +2 , 'End' , -7 , KDr(3,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
        temp_lines = pext( s , 'Hub:' , +2 , 'NumRadii:' , -5 , KDr(4,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
    % Fritz's image extraction
    case 'mat' % load manually extracted points
        if isTerminalPrint
            disp('Load manual segmentation file...');
        end
        load (['CAD source/' file_name '.mat'] ) ; % basics_motor: t, outlin, outrot, inlin, inrot
        section_name = { 'Frame' , 'Mooring' , 'Radii' , 'CapSpiral' , 'Hub' }; % web section names: order should match the order of KDr rows     
        kdr_i = [ 1 1 2 3 4 ] ;
               
        temp_lines = pmat( Frame , KDr(1,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
        temp_lines = pmat( Mooring , KDr(1,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
               
        temp_lines = pmat( Radii , KDr(2,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
        temp_lines = pmat( CapSpiral , KDr(3,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
        temp_lines = pmat( Hub , KDr(4,:) , tol(4) ) ;
        lines_index = [ lines_index ; n_lines+[1 numel(temp_lines)] ] ;
        n_lines = n_lines + numel(temp_lines) ;
        lines = [ lines temp_lines ] ; % all lines
        
    % external function call by sensitivity analysis & web optimization
    case 'opt' % load randomly generated web
        if isTerminalPrint
            disp('Load randomly generated web...');
        end
        section_name = { 'full_web' }; % web section names: order should match the order of KDr rows
        kdr_i = 2 ;
        lines = file_name ;
        n_lines = numel( file_name ) ;
        file_name = 'random_web' ;
        lines_index = [ 1 n_lines ] ;

    % Sudong's webs & general line struct inport
    case 'line_structure' % load randomly generated web
        if isTerminalPrint
            disp('Load line structure variable web...');
        end
        section_name = { 'full_web' }; % web section names: order should match the order of KDr rows
        kdr_i = 2 ;
        load(file_name) % will load lines structure variable and probably fixedPoints vector
        n_lines = numel( lines ) ;
        lines_index = [ 1 n_lines ] ;
        
end


%% Plot the IGES object
if isPlot
    subplot(1,2,1)
    plotIGES( lines ) ; hold on
    view( [ -1 -1 2 ] ) ;
    pause( 1 ) ;
end
        
% list the imported entities
if isTerminalPrint
    disp('Fix imported file...');
end
points = zeros(1,6) ; % [ x_p y_p z_p i_body i_link link_end_no ]
points_mass = zeros(1,4) ; % [ x_p y_p z_p i_b ]


%% find overlapping and too close points and assign masses to the points
i_b = 0 ;
i_jd = 0 ;
i_p = 0 ;
i_jl = 0 ;
for i = 1 : numel( lines ) % find fixed points and masses
    if strcmp( lines{i}.name , 'LINE' ) % only line elements

        % defaults
        i_jl = i_jl + 1 ;

        % first mass (line start point)
        i_px = [] ; i_py = [] ; i_pz = [] ; 
        i_px = find( abs( lines{i}.p1(1) - points(:,1) ) <= tol(1) ) ; % compare x values
        if isempty( i_px ) % new point: not close to previous x values
            i_p = i_p + 1 ;
            points(i_p,:)= [ lines{i}.p1(1:3)' 0 i_jl 1 ] ; % update point list
            lines{i}.p_index(1) = i_p ; % update line point index
        else % close x values detected
            i_py = find( abs( lines{i}.p1(2) - points(i_px,2) ) <= tol(1) ) ; % compare y values
            if isempty( i_py ) % new point: not close to previous y values
                i_p = i_p + 1 ;
                points(i_p,:)= [ lines{i}.p1(1:3)' 0 i_jl 1 ] ; % update point list
                lines{i}.p_index(1) = i_p ; % update line point index
            else % close xy values detected
                i_pz = find( abs( lines{i}.p1(3) - points(i_px(i_py),3) ) <= tol(1) ) ; % compare z values
                if isempty( i_pz ) % new point: not close to previous z values
                    i_p = i_p + 1 ;
                    points(i_p,:)= [ lines{i}.p1(1:3)' 0 i_jl 1 ] ; % update point list
                    lines{i}.p_index(1) = i_p ; % update line point index
                else % close xyz values detected
                    if points(i_px(i_py(i_pz)),4) == 0 % new mass; No mass is already assigned to this point
                        i_b = i_b + 1 ;
                        points(i_px(i_py(i_pz)),4) = i_b ; % update mass list
                        i_jd = i_jd + 1 ; % new dof joint                        
                    end
                    i_px_tmp = i_px(i_py(i_pz)) ; % to handle when multiple coinciding points are found
                    lines{i}.p1 = points(i_px_tmp(1),1:3)' ; % Update point coordinates if it was too close to a previous point
                    lines{i}.p_index(1) = i_px_tmp(1) ; % update line point index
                end
            end
        end

        % second mass (line end point)
        % same procedure as above, see above comments
        i_px = [] ; i_py = [] ; i_pz = [] ; 
        i_px = find( abs( lines{i}.p2(1) - points(:,1) ) <= tol(1) ) ;
        if isempty( i_px ) % new point
            i_p = i_p + 1 ;
            points(i_p,:)= [ lines{i}.p2(1:3)' 0 i_jl 2 ] ;
            lines{i}.p_index(2) = i_p ; % update line point index
        else
            i_py = find( abs( lines{i}.p2(2) - points(i_px,2) ) <= tol(1) ) ;
            if isempty( i_py ) % new point
                i_p = i_p + 1 ;
                points(i_p,:)= [ lines{i}.p2(1:3)' 0 i_jl 2 ] ;
                lines{i}.p_index(2) = i_p ; % update line point index
            else
                i_pz = find( abs( lines{i}.p2(3) - points(i_px(i_py),3) ) <= tol(1) ) ;
                if isempty( i_pz ) % new point
                    i_p = i_p + 1 ;
                    points(i_p,:)= [ lines{i}.p2(1:3)' 0 i_jl 2 ] ;
                    lines{i}.p_index(2) = i_p ; % update line point index
                else
                    if points(i_px(i_py(i_pz)),4) == 0 % new mass
                        i_b = i_b + 1 ;
                        points(i_px(i_py(i_pz)),4) = i_b ;
                        i_jd = i_jd + 1 ; % new dof joint
                    end
                    i_px_tmp = i_px(i_py(i_pz)) ; % to handle when multiple coinciding points are found
                    lines{i}.p2 = points(i_px_tmp(1),1:3)' ; % merge points
                    lines{i}.p_index(2) = i_px_tmp(1) ; % update line point index
                end
            end
        end

    end
end
        
% mean point
p_mean = [mean(points(:,1)), mean(points(:,2)), mean(points(:,3))] ;


%% generate G-code by following the most continuous and straight path
if isTerminalPrint
    disp('Generate GCode...');
end

%<Beth's web>%
if strcmp( testCase , 'Beth' )
    frtype = { 'tangent' , 'closest_line' } ; % {follow, restart} type. follow type: first, smooth. restart type: first, closest
end

%<Fritz's image extraction, Shiv's & Sudong's tests, sensitivity analysis, & optimization>%
if strcmp( testCase , 'Fritz_code' ) || strcmp( testCase , 'Fritz_image' ) || strcmp( testCase , 'Shiv_image' ) || strcmp( testCase , 'Shiv_polar' ) || strcmp( testCase , 'sensitivity' ) || strcmp( testCase , 'optimization' ) || strcmp( testCase , 'sudong_grid' ) || strcmp( testCase , 'sudong_polar' )
    frtype = { 'first_encountered_in_array' , 'array_first' } ; % {follow, restart} type. follow type: first, smooth. restart type: first, closest
end

% bed_size = [ 0 180 ; 0 180 ; 0 0 ] ; % in mm, bed width (xmin xmax) and length (ymin ymax) and height (zmin zmax)
bed_size = [ -90 90 ; -90 90 ; 0 0 ] ; % in mm, bed width (xmin xmax) and length (ymin ymax) and height (zmin zmax)
for i = 1 : numel( section_name )
    section_lines = lines(lines_index(i,1):lines_index(i,2)) ;
    if isGCode
        line2gcode( section_name{i} , section_lines , KDr(kdr_i(i),3) , tol(2) , frtype , animate_path , p_mean , bed_size ) ;
    end
end


%% export to SOFA
if isTerminalPrint
    disp('Generate SOFA Scene...');
end
for i_di = 1 : n_damageItteration % test damaged webs
    
    if isTerminalPrint
        disp('Generate SOFA Scene for new damaged case...');
        i_di % 1: no damage, 2: excitation point variation, >2: damaged cases
    end
    
    if i_di == 1 && ~isempty( latDispReadPoint ) % skip intact web simulation if it is already run in the previous mesh_import function call
        continue
    end
    
    
    %% experiment parameters
    excite_location = [] ; % excite/monitor based on cartesian location
    monitor_location = [] ;
    
    %<Beth's web>%
    if strcmp( testCase , 'Beth' )
        frameType = 'square'; % frame type to fix in SOFA: 'square' or '1stSection'
        excite_indices = [ 1361 1368 1379 1117 1126 1133 1142 680 674 606 656 338 341 347 360 834 841 849 858 1515 1525 1530 1540 730 739 746 756 ] ;
        excitation.amp = [ 0 0 7 ] ; % mm, excitation amplitude, from Beth's paper
        excitation.omega = 100 ; % Hz, excitation frequency, from Beth's paper
        monitor_indices = [ 1109 ] ;
        % monitor_indices = [ 1401 576 1404 572 1398 579 147 148 1392 586 1381 597 1388 590 1383 595 ] ;
    end
    
    %<Fritz code data>%
    if strcmp( testCase , 'Fritz_code' ) 
        frameType = '1stSection'; % frame type to fix in SOFA: 'square' or '1stSection'
        excitation.excite_index = 75 % (153: near_spiral, 758: near_radial, 287:far_mid_radial) excitation point, starts from 0 so it corresponds to points (excite_index+1)
        excitation.amp = [ 0 0 0.17 ] % mm, excitation amplitude, from paper
        excitation.omega = 1/4/3e-3 % Hz, excitation frequency, from paper
        monitor_indices = [ 43 45 ] ;
    end
    
    %<Fritz's image extraction: Shiv's RoboSoft Fig. 8b >%
    if strcmp( testCase , 'Fritz_image' ) || strcmp( testCase , 'Shiv_image' )
        frameType = '1stSectionName'; % frame type to fix in SOFA: 'pointVector' to use predefined points, 'square' to fix the nodes on the square edges, '1stSectionName' to fix all the nodes in the 1st web section, usually "frame"
        
        % Shive's recording/excitation points:
        excite_indices = [ 160 217 273 375 429 481 570 630 685 743 790 107 172 289 412 594 700 782 76 ; % web01, starts from 0 so it corresponds to points (excite_index+1)
            199 246 339 434 867 592 660 756 804 845 111 155 211 324 470 674 792 123 87 ] ; % web02, starts from 0 so it corresponds to points (excite_index+1)
        % excitation.amp = [ 0 0 10 ] ; % mm, [NOT WORKING] excitation amplitude, from Shiv's paper
        excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
        % excitation.omega = 1/5 ; % Hz, [NOT WORKING] excitation frequency, from Shiv's paper
        excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper
        monitor_indices = [ 76 21 29 36 42 49 52 57 68 72 ; % web01
            88 83 80 76 71 62 55 42 38 31 ] ; % web02 

        if EXCITE_LOCATION && strcmp( SUDONG_EXCITE_READOUT, 'no' ) % RETURNS BAD RESULTS!!!! Only when number of lines varies!!!
            excite_location(:,:,1) = [ ... % points(excite_indices(i_web,:)+1,1:2) ; % from original sym web
                4.4681e+01   8.8373e+01;
                6.0176e+01   9.2022e+01;
                7.3648e+01   8.7990e+01;
                8.6951e+01   7.6309e+01;
                9.0572e+01   6.1834e+01;
                8.9259e+01   4.4550e+01;
                7.9411e+01   3.3100e+01;
                5.8506e+01   2.5499e+01;
                4.3677e+01   2.9273e+01;
                3.0060e+01   4.3062e+01;
                2.6638e+01   5.4108e+01;
                3.2477e+01   7.7033e+01;
                5.2462e+01   7.3324e+01;
                6.6027e+01   7.1376e+01;
                7.5328e+01   6.0092e+01;
                6.5993e+01   4.3891e+01;
                5.3108e+01   4.7060e+01;
                4.3080e+01   5.5903e+01;
                6.0410e+01   5.8912e+01];
            monitor_location(:,:,1) = [ ... % points(monitor_indices(i_web,:)+1,1:2) ; % from original sym web
                6.0410e+01   5.8912e+01;
                5.9900e+00   9.5268e+01;
                4.4501e+01   9.6040e+01;
                8.7662e+01   9.9322e+01;
                9.8580e+01   7.8849e+01;
                9.6262e+01   3.0409e+01;
                8.2365e+01   1.9514e+01;
                3.8218e+01   3.9280e+00;
                2.0051e+01   1.7816e+01;
                1.0440e+01   5.6359e+01];
            excite_location(:,:,2) = [ ...
                2.1417e+01   8.5698e+01;
                3.6133e+01   9.2836e+01;
                5.3768e+01   8.9599e+01;
                6.7806e+01   7.6679e+01;
                7.1731e+01   5.9213e+01;
                6.6346e+01   4.3608e+01;
                5.4312e+01   3.2381e+01;
                3.5606e+01   2.7794e+01;
                2.4343e+01   3.1762e+01;
                1.2400e+01   4.3388e+01;
                7.8484e+00   5.7910e+01;
                1.0262e+01   7.3520e+01;
                2.9247e+01   7.2711e+01;
                4.5728e+01   7.4338e+01;
                5.3338e+01   6.0364e+01;
                4.5683e+01   4.5844e+01;
                3.0975e+01   4.6398e+01;
                2.4825e+01   5.9499e+01;
                3.6543e+01   6.0235e+01];
            monitor_location(:,:,2) = [ ...
                3.5323e+01   6.0021e+01;
                1.4670e+01   9.3361e+01;
                3.1693e+01   9.8647e+01;
                5.8211e+01   9.9141e+01;
                8.2290e+01   7.8387e+01;
                7.7088e+01   2.3329e+01;
                4.8181e+01   7.4353e+00;
                2.0966e+00   3.0128e+01;
                3.5928e+00   5.0007e+01;
                4.6101e+00   6.9586e+01];
        end

        % Sudong's recording/excitation points:
        if strcmp( SUDONG_EXCITE_READOUT , 'damage' ) || strcmp( SUDONG_EXCITE_READOUT , 'classification' )
            EXCITE_LOCATION = true ;
            monitor_indices = [];
            monitor_location(:,:,1) = [ 38.22, 93.95; 72.75, 89.4; 93.95, 61.77; 61.77, 6.05; 27.25, 10.6; 27.25, 10.6; 6.05, 38.22; 17.83, 82.17 ] ;
            monitor_location(:,:,2) = monitor_location(:,:,1) ;
            excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
            excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper

            if strcmp( SUDONG_EXCITE_READOUT , 'classification' )
                excite_location(:,:,1) = [  41.143, 47.037; % similar to Sudong's grid 24-point excitation: used for classification and noise impact studies
                                            41.143, 54.537;
                                            41.143, 62.037;
                                            41.143, 69.537;
                                            34.64780947, 43.287;
                                            28.15261894, 47.037;
                                            21.65742841, 50.787;
                                            15.16223789, 54.537;
                                            34.64780947, 35.787;
                                            28.15261894, 32.037;
                                            21.65742841, 28.287;
                                            15.16223789, 24.537;
                                            41.143, 32.037;
                                            41.143, 24.537;
                                            41.143, 17.037;
                                            41.143, 9.537;
                                            47.63819053, 35.787;
                                            54.13338106, 32.037;
                                            60.62857159, 28.287;
                                            67.12376211, 24.537;
                                            47.63819053, 43.287;
                                            54.13338106, 47.037;
                                            60.62857159, 50.787;
                                            67.12376211, 54.537 ] ;
                excite_location(:,:,2) = excite_location(:,:,1) ;
            end    

            if strcmp( SUDONG_EXCITE_READOUT , 'damage' )
                excite_location(:,:,1) = [  ... % similar to Sudong's grid 17-point excitation: used for damage resilience studies
                                            41.332900000000002 39.458799999999997;
                                            41.332900000000002 54.458799999999997;
                                            41.332900000000002 64.458799999999997;
                                            30.726298282201789 50.065401717798210;
                                            23.655230470336317 57.136469529663685;
                                            26.332900000000002 39.458799999999997;
                                            16.332900000000002 39.458799999999997;
                                            30.726298282201789 28.852198282201783;
                                            23.655230470336313 21.781130470336311;
                                            41.332900000000002 24.458799999999997;
                                            41.332900000000002 14.458799999999997;
                                            51.939501717798215 28.852198282201783;
                                            59.010569529663684 21.781130470336304;
                                            56.332900000000002 39.458799999999997;
                                            66.332899999999995 39.458799999999989;
                                            51.939501717798215 50.065401717798210;
                                            59.010569529663698 57.136469529663685 ] ;
                excite_location(:,:,2) = excite_location(:,:,1) ; 
            end
        end

        monitor_location(:,:,1) = 100 - [ monitor_location(:,2,1), monitor_location(:,1,1) ] ; % web 1 is mirrored w.r.t. line y=-x in Sudong's plots
        excite_location(:,:,1) = 100 - [ excite_location(:,2,1), excite_location(:,1,1) ] ;
        monitor_location(:,:,2) = [ monitor_location(:,1,2)-3 100-monitor_location(:,2,2) ] ; % web 2 is mirrored wrt x-axis in Sudong's plots + some corrections in x-direction to get the points in the right position
        excite_location(:,:,2) = [ excite_location(:,1,2)-3 100-excite_location(:,2,2) ] ;
    end
   
    %<Shiv's polar web >%
    if strcmp( testCase , 'Shiv_polar' )
        % frameType = '1stSectionName'; % frame type to fix in SOFA: 'pointVector' to use predefined points, 'square' to fix the nodes on the square edges, '1stSectionName' to fix all the nodes in the 1st web section, usually "frame"
        excite_indices = [ 21 111 146 170 9 51 75 115 126 150 163 174 18 17 31 55 68 70 103 ] ;
        %     excitation.amp = [ 0 0 10 ] ; % mm, [NOT WORKING] excitation amplitude, from Shiv's paper
        excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
        %     excitation.omega = 1/5 ; % Hz, [NOT WORKING] excitation frequency, from Shiv's paper
        excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper
        monitor_indices = [ 21 128 152 175 20 32 56 80 104 ] ;
    end
                   
    %<sensitivity analysis>%
    if strcmp( testCase , 'sensitivity' )
        % frameType = '1stSectionName'; % frame type to fix in SOFA: 'pointVector' to use predefined points, 'square' to fix the nodes on the square edges, '1stSectionName' to fix all the nodes in the 1st web section, usually "frame"
        
        % for sensitivity analysis: Shive's recording/excitation points:
        excite_indices = [ 422 430 547 639 729 19 131 250 340 440 558 650 740 47 141 260 352 ] ;
        %     excitation.amp = [ 0 0 10 ] ; % mm, [NOT WORKING] excitation amplitude, from Shiv's paper
        excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
        %     excitation.omega = 1/5 ; % Hz, [NOT WORKING] excitation frequency, from Shiv's paper
        excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper
        monitor_indices = [ 422 446 566 657 746 55 146 266 357 ] ;

        if EXCITE_LOCATION && strcmp( SUDONG_EXCITE_READOUT, 'no' ) % Only when number of lines varies, not when only dimensions change!!!
            excite_location(:,:,1) = [ ... % points(excite_indices+1,1:2) from original sym web
                -4.4880e+00   5.2457e-01;
                -1.9673e+01   2.2994e+00;
                -1.1040e+01  -1.1701e+01;
                -1.0196e+00  -1.7507e+01;
                1.1337e+01  -1.5229e+01;
                1.6570e+01            0;
                1.5802e+01   1.3259e+01;
                -1.1348e+00   1.9484e+01;
                -1.2598e+01   1.3353e+01;
                -3.2628e+01   3.8137e+00;
                -2.0886e+01  -2.2137e+01;
                -1.8539e+00  -3.1830e+01;
                1.9905e+01  -2.6737e+01;
                3.4831e+01            0;
                2.5794e+01   2.1644e+01;
                -1.8932e+00   3.2505e+01;
                -2.3339e+01   2.4738e+01];
            monitor_location(:,:,1) = [ ... % points(monitor_indices+1,1:2) from original sym web
                -4.4880e+00   5.2457e-01;
                -4.2213e+01   4.9339e+00;
                -2.9165e+01  -3.0913e+01;
                -2.4712e+00  -4.2428e+01;
                2.5379e+01  -3.4090e+01;
                4.2500e+01            0;
                3.2557e+01   2.7318e+01;
                -2.4712e+00   4.2428e+01;
                -2.9165e+01   3.0913e+01];
        end

        % % for sym web test: Sudong's recording/excitation 24-points:
        if strcmp( SUDONG_EXCITE_READOUT , 'damage' ) || strcmp( SUDONG_EXCITE_READOUT , 'classification' )
            EXCITE_LOCATION = true ;
            monitor_indices = [];
            monitor_location(:,:,1) = [ 38.22, 93.95; 72.75, 89.4; 93.95, 61.77; 61.77, 6.05; 27.25, 10.6; 27.25, 10.6; 6.05, 38.22; 17.83, 82.17 ] ;
            monitor_location(:,:,1) = monitor_location(:,:,1) - 50 ;
            excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
            excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper 

            if strcmp( SUDONG_EXCITE_READOUT , 'classification' )
                excite_location(:,:,1) = [  50, 57.5; % similar to Sudong's polar web 24-points
                                            50, 65;
                                            50, 72.5;
                                            50, 80;
                                            43.50480947, 53.75;
                                            37.00961894, 57.5;
                                            30.51442841, 61.25;
                                            24.01923789, 65;
                                            43.50480947, 46.25;
                                            37.00961894, 42.5;
                                            30.51442841, 38.75;
                                            24.01923789, 35;
                                            50, 42.5;
                                            50, 35;
                                            50, 27.5;
                                            50, 20;
                                            56.49519053, 46.25;
                                            62.99038106, 42.5;
                                            69.48557159, 38.75;
                                            75.98076211, 35;
                                            56.49519053, 53.75;
                                            62.99038106, 57.5;
                                            69.48557159, 61.25;
                                            75.98076211, 65 ] ;
            end    

            if strcmp( SUDONG_EXCITE_READOUT , 'damage' )
                excite_location(:,:,1) = [  ... % 17 pokes for damage resilience analysis
                                            50.000000000000000 50.000000000000000;
                                            50.000000000000000 65.000000000000000;
                                            50.000000000000000 75.000000000000000;
                                            39.393398282201787 60.606601717798213;
                                            32.322330470336311 67.677669529663689;
                                            35.000000000000000 50.000000000000000;
                                            25.000000000000000 50.000000000000000;
                                            39.393398282201787 39.393398282201787;
                                            32.322330470336311 32.322330470336311;
                                            50.000000000000000 35.000000000000000;
                                            50.000000000000000 25.000000000000000;
                                            60.606601717798213 39.393398282201787;
                                            67.677669529663689 32.322330470336311;
                                            65.000000000000000 50.000000000000000;
                                            75.000000000000000 49.999999999999993;
                                            60.606601717798213 60.606601717798213;
                                            67.677669529663689 67.677669529663689 ] ;
            end
            excite_location(:,:,1) = excite_location(:,:,1) - 50 ;
        end
    end
    
    %<Optimisation of random webs>%
    if strcmp( testCase , 'optimization' )
        % frameType = '1stSectionName'; % frame type to fix in SOFA: 'pointVector' to use predefined points, 'square' to fix the nodes on the square edges, '1stSectionName' to fix all the nodes in the 1st web section, usually "frame"
        excite_indices = [ 440 558 650 740 47 141 260 352 ] ;
        %     excitation.amp = [ 0 0 7 ] ; % mm, [NOT WORKING] excitation amplitude, from Shiv's paper
        excitation.amp = [ 0 0 1 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
        %     excitation.omega = 1/5 ; % Hz, [NOT WORKING] excitation frequency, from Shiv's paper
        excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper
        % monitor_indices = [ 422 446 566 657 746 55 146 266 357 ] ;
        monitor_indices = [ 422 446 566 657 746 55 146 266 357 ] ;
        damaged_line_points = [ 276 , 245 ;
                                104 , 73 ;
                                555 , 586 ] ; % point index for the damaged lines
        damaged_points = [ 278 104 555 ] ; % damaged points to remove
        % damaged_points = [ 278 104 555 468 347 233 171 429 648 761 38 ] ; % damaged points to remove
        damage_lines = [ 760 207 364 289 1071 519 1260 870 368 1095 79 913 1584 579 891 1478 414 1327 279 1402 446 1354 1286 302 1559 405 1241 1292 794 1459 161 217 1368 30 1161 1301 186 779 554 1233 455 1314 276 1376 1476 305 81 874 16 1320 ] ;
    
        % for sym web test: Sudong's recording/excitation points:
        if strcmp( SUDONG_EXCITE_READOUT , 'damage' ) || strcmp( SUDONG_EXCITE_READOUT , 'classification' )
            EXCITE_LOCATION = true ;
            monitor_indices = [];
            monitor_location(:,:,1) = [ 38.22, 93.95; 72.75, 89.4; 93.95, 61.77; 61.77, 6.05; 27.25, 10.6; 27.25, 10.6; 6.05, 38.22; 17.83, 82.17 ] ;
            monitor_location(:,:,1) = monitor_location(:,:,1) - 50 ;
            excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
            excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper
    
            if strcmp( SUDONG_EXCITE_READOUT , 'classification' )
                excite_location(:,:,1) = [  50, 57.5; % similar to Sudong's polar web 24-points
                                            50, 65;
                                            50, 72.5;
                                            50, 80;
                                            43.50480947, 53.75;
                                            37.00961894, 57.5;
                                            30.51442841, 61.25;
                                            24.01923789, 65;
                                            43.50480947, 46.25;
                                            37.00961894, 42.5;
                                            30.51442841, 38.75;
                                            24.01923789, 35;
                                            50, 42.5;
                                            50, 35;
                                            50, 27.5;
                                            50, 20;
                                            56.49519053, 46.25;
                                            62.99038106, 42.5;
                                            69.48557159, 38.75;
                                            75.98076211, 35;
                                            56.49519053, 53.75;
                                            62.99038106, 57.5;
                                            69.48557159, 61.25;
                                            75.98076211, 65 ] ;
            end
    
            if strcmp( SUDONG_EXCITE_READOUT , 'damage' )
                excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
                excite_location(:,:,1) = [  ... % 17 pokes for damage resilience analysis
                                            50.000000000000000 50.000000000000000;
                                            50.000000000000000 65.000000000000000;
                                            50.000000000000000 75.000000000000000;
                                            39.393398282201787 60.606601717798213;
                                            32.322330470336311 67.677669529663689;
                                            35.000000000000000 50.000000000000000;
                                            25.000000000000000 50.000000000000000;
                                            39.393398282201787 39.393398282201787;
                                            32.322330470336311 32.322330470336311;
                                            50.000000000000000 35.000000000000000;
                                            50.000000000000000 25.000000000000000;
                                            60.606601717798213 39.393398282201787;
                                            67.677669529663689 32.322330470336311;
                                            65.000000000000000 50.000000000000000;
                                            75.000000000000000 49.999999999999993;
                                            60.606601717798213 60.606601717798213;
                                            67.677669529663689 67.677669529663689 ] ;
            end
            excite_location(:,:,1) = excite_location(:,:,1) - 50 ;
        end
    end

    %<Sudong's webs>%
    if strcmp( testCase , 'sudong_grid' ) || strcmp( testCase , 'sudong_polar' )
        frameType = 'square' ;
        i_web = 1;
        EXCITE_LOCATION = true ;
        monitor_indices = [];
        % monitor_location(:,:,1) = [ 85.8, 100; 100, 63.5; 41.4, 100; 0, 100; 0, 39; 21.4, 0; 69.5, 0 ] ;
        monitor_location(:,:,1) = [ 38.22, 93.95; 72.75, 89.4; 93.95, 61.77; 61.77, 6.05; 27.25, 10.6; 27.25, 10.6; 6.05, 38.22; 17.83, 82.17 ] ;
        excitation.amp = [ 0 0 7 ] ; % mm, [WORKING] excitation amplitude, from Beth's paper
        excitation.omega = 100 ; % Hz, [WORKIN] excitation frequency, from Beth's paper

        if strcmp( testCase , 'sudong_grid' )
            if strcmp( SUDONG_EXCITE_READOUT , 'classification' )
                excite_location(:,:,1) = [  41.143, 47.037; % 24 pokes for sensitivity analysis
                                            41.143, 54.537;
                                            41.143, 62.037;
                                            41.143, 69.537;
                                            34.64780947, 43.287;
                                            28.15261894, 47.037;
                                            21.65742841, 50.787;
                                            15.16223789, 54.537;
                                            34.64780947, 35.787;
                                            28.15261894, 32.037;
                                            21.65742841, 28.287;
                                            15.16223789, 24.537;
                                            41.143, 32.037;
                                            41.143, 24.537;
                                            41.143, 17.037;
                                            41.143, 9.537;
                                            47.63819053, 35.787;
                                            54.13338106, 32.037;
                                            60.62857159, 28.287;
                                            67.12376211, 24.537;
                                            47.63819053, 43.287;
                                            54.13338106, 47.037;
                                            60.62857159, 50.787;
                                            67.12376211, 54.537 ] ;
            end

            if strcmp( SUDONG_EXCITE_READOUT , 'damage' )
                excite_location(:,:,1) = [  ... % 17 pokes for damage resilience analysis
                                            41.332900000000002 39.458799999999997;
                                            41.332900000000002 54.458799999999997;
                                            41.332900000000002 64.458799999999997;
                                            30.726298282201789 50.065401717798210;
                                            23.655230470336317 57.136469529663685;
                                            26.332900000000002 39.458799999999997;
                                            16.332900000000002 39.458799999999997;
                                            30.726298282201789 28.852198282201783;
                                            23.655230470336313 21.781130470336311;
                                            41.332900000000002 24.458799999999997;
                                            41.332900000000002 14.458799999999997;
                                            51.939501717798215 28.852198282201783;
                                            59.010569529663684 21.781130470336304;
                                            56.332900000000002 39.458799999999997;
                                            66.332899999999995 39.458799999999989;
                                            51.939501717798215 50.065401717798210;
                                            59.010569529663698 57.136469529663685 ] ;
            end
        end

        if strcmp( testCase , 'sudong_polar' )
            if strcmp( SUDONG_EXCITE_READOUT , 'classification' )
                excite_location(:,:,1) = [  50, 57.5; % 24 pokes for sensitivity analysis
                                            50, 65;
                                            50, 72.5;
                                            50, 80;
                                            43.50480947, 53.75;
                                            37.00961894, 57.5;
                                            30.51442841, 61.25;
                                            24.01923789, 65;
                                            43.50480947, 46.25;
                                            37.00961894, 42.5;
                                            30.51442841, 38.75;
                                            24.01923789, 35;
                                            50, 42.5;
                                            50, 35;
                                            50, 27.5;
                                            50, 20;
                                            56.49519053, 46.25;
                                            62.99038106, 42.5;
                                            69.48557159, 38.75;
                                            75.98076211, 35;
                                            56.49519053, 53.75;
                                            62.99038106, 57.5;
                                            69.48557159, 61.25;
                                            75.98076211, 65 ] ;
            end
            
            if strcmp( SUDONG_EXCITE_READOUT , 'damage' )
                excite_location(:,:,1) = [  ... % 17 pokes for damage resilience analysis
                                            50.000000000000000 50.000000000000000;
                                            50.000000000000000 65.000000000000000;
                                            50.000000000000000 75.000000000000000;
                                            39.393398282201787 60.606601717798213;
                                            32.322330470336311 67.677669529663689;
                                            35.000000000000000 50.000000000000000;
                                            25.000000000000000 50.000000000000000;
                                            39.393398282201787 39.393398282201787;
                                            32.322330470336311 32.322330470336311;
                                            50.000000000000000 35.000000000000000;
                                            50.000000000000000 25.000000000000000;
                                            60.606601717798213 39.393398282201787;
                                            67.677669529663689 32.322330470336311;
                                            65.000000000000000 50.000000000000000;
                                            75.000000000000000 49.999999999999993;
                                            60.606601717798213 60.606601717798213;
                                            67.677669529663689 67.677669529663689 ] ;
            end
        end  
    end


    %% introduce excitation point variation & damage in the web
    lines_damaged = lines ; 
    ind_damaged_lines = [] ;
    if i_di > 2 % introduce damage (see i_di=2 below)
        if strcmp( damageCase , 'random' ) % random damage points
            ind_damaged_lines = randi( n_lines , 1 , ( i_di - 2 ) * n_damageBatch ) ;
        end
        if strcmp( damageCase , 'line_points' ) % pre-defined damage line points
            for i_dl = 1 : numel( damaged_line_points(:,1) )
                for i_l = 1: n_lines
                    if min( ismember( damaged_line_points(i_dl,:) , lines{i_l}.p_index ) )
                        ind_damaged_lines = [ ind_damaged_lines , i_l ] ;
                    end
                end
            end
        end
        if strcmp( damageCase , 'lines' ) % pre-defined damage lines
            ind_damaged_lines = damage_lines ;
        end
        if strcmp( damageCase , 'points' ) % pre-defined damage points
            for i_dp = 1 : numel( damaged_points )
                for i_l = 1: n_lines
                    if ismember( damaged_points(i_dp) , lines{i_l}.p_index )
                        ind_damaged_lines = [ ind_damaged_lines , i_l ] ;
                    end
                end
            end
        end
        for i_dl = ind_damaged_lines % remove damaged lines
            lines_damaged{i_dl}.p1 = lines_damaged{i_dl}.p2 ; % both ends of damaged lines become the same so the web mass remains preserved
            lines_damaged{i_dl}.p_index(1) = lines_damaged{i_dl}.p_index(2) ;
        end
    end


    %% find excitation and monitor indices
    % find indices based on locations
    if ~isempty( excite_location )
%         excite_indices = [] ; % find closest indices for excitation points
        for i_point = 1 : numel( excite_location(:,1,i_web) )
            [ temp_dist , temp_index ] = min( normV( points(:,1:2) - excite_location(i_point,1:2,i_web) ) ) ;
            excite_indices(i_web,i_point) = temp_index-1 ;
        end
    end
    % find closest indices for monitor points 
    if ~isempty( monitor_location )
%         monitor_indices = [] ; % find closest indices for monitor points
        for i_point = 1 : numel( monitor_location(:,1,i_web) )
            [ temp_dist , temp_index ] = min( normV( points(:,1:2) - monitor_location(i_point,1:2,i_web) ) ) ;
            monitor_indices(i_web,i_point) = temp_index-1 ;
        end
    end


    %% plot experiment
    n_exp = numel( excite_indices(i_web,:) ) ; % number of poking places
%     n_exp = 3 % test
    if isPlot
        fig_web = figure();
        figure(fig_web)
        % points
        plot3( points(:,1) , points(:,2) , points(:,3) , 'x' ) ; hold on
        % plot3( points_mass(:,1) , points_mass(:,2) , points_mass(:,3) , 'ro' ) ; hold on

        % mean point plot
        plot3(p_mean(1),p_mean(2),p_mean(3),'yo','linewidth',2)

        % show mass number for reference
        strValues = strtrim( cellstr( num2str( points_mass(:,4) , '%d' ) ) ) ;
        text( points_mass(:,1) , points_mass(:,2) , points_mass(:,3) , strValues , 'VerticalAlignment' , 'bottom' ) ;

        % excitation points
        plot3( points(excite_indices(i_web,:)+1,1) , points(excite_indices(i_web,:)+1,2) , points(excite_indices(i_web,:)+1,3) , 'rx' , 'linewidth' , 2 )

        % monitor points
        plot3( points(monitor_indices(i_web,:)+1,1) , points(monitor_indices(i_web,:)+1,2) , points(monitor_indices(i_web,:)+1,3) , 'gs' , 'linewidth' , 2 )
        
        % plot conditioning
        xlabel( 'x[mm]' ) ; ylabel( 'y[mm]' ) ; zlabel( 'z[mm]' ) ;
        title( [ 'Damage case: ' num2str( i_di ) ] )
        view( [ -1 -1 2 ] ) ; axis equal ;
%         pause
    
        fig_data = figure; % one figure per damage case

    % else % test for web shape monitoring during optimization
    %     % excitation points
    %     plot3( points(excite_indices(i_web,:)+1,1) , points(excite_indices(i_web,:)+1,2) , points(excite_indices(i_web,:)+1,3) , 'rx' , 'linewidth' , 2 )
    % 
    %     % monitor points
    %     plot3( points(monitor_indices(i_web,:)+1,1) , points(monitor_indices(i_web,:)+1,2) , points(monitor_indices(i_web,:)+1,3) , 'ms' , 'linewidth' , 2 )

    end
    
    
    %% run experiment
    for i_exp = 1 : n_exp
        if isTerminalPrint
            disp('Generate SOFA Scene for new exp instant (excitation index)...');
            i_exp
        end

        
        %% disturb excitation point
        % excitation index variation
        excite_indices_disturbed(1,i_exp) = excite_indices(i_web,i_exp) ;
        if i_di == 2 % introduce variation in the excitation point
            if excite_indices_variation_max == 0 && excite_loc_variation_max == 0 ; continue ; end % no need to introduce excitation node disturbance
            if excite_indices_variation_max ~= 0 % no need to introduce excitation node disturbance
                excite_indices_variation = randi( [ -excite_indices_variation_max, excite_indices_variation_max ] ) ;
                excite_indices_disturbed(1,i_exp)= excite_indices(i_web,i_exp) + excite_indices_variation ;
            end
            % excitation location variation, OVERRIDES ABOVE!
            if excite_loc_variation_max ~= 0 % no need to introduce excitation node disturbance
                excite_loc_variation(1,1) = rand() * 2 * excite_loc_variation_max - excite_loc_variation_max ;
                excite_loc_variation(1,2) = rand() * 2 * excite_loc_variation_max - excite_loc_variation_max ;
                % temp1 = find( abs( points(:,1) - points(excite_indices(i_web,i_exp),1:2) - excite_loc_variation(1,1) ) < tol(3) ) ; % find excite points' indices x
                % temp2 = find( abs( points(temp1,2) - points(excite_indices(i_web,i_exp),1:2) - excite_loc_variation(1,2) ) < tol(3) ) ; % find excite points' indices y
                % excite_indices_disturbed(1,i_exp)= temp1(temp2) ;
                [ temp_dist , temp_index ] = min( normV( points(:,1:2) - ( points(excite_indices(i_web,i_exp)+1,1:2) + excite_loc_variation ) ) ) ;
                excite_indices_disturbed(1,i_exp)= temp_index - 1 ;
            end
        end
        excitation.excite_index = excite_indices_disturbed(1,i_exp) ;
        
        % generate SOFA scene
        SOFA_export(section_name, lines_damaged, lines_index, KDr, kdr_i, points, tol(3), frameType, excitation, monitor_indices(i_web,:), p_mean, fixedPoints) ;
        
        % % to record good videos from Sudong's webs
        % % if excitation.excite_index == 350  % Sudong's grid
        % if excitation.excite_index == 474  % Sudong's polar
        %     pause();
        % end


        %% Run SOFA
        % results are stored in: C:\Users\hadis\OneDrive - Queen Mary, University of London\Hadi\Postdoc\1_Bristol\2. Research\12. Model\1. CAD and Printing\Matlab GCode\export_x.txt
        if isTerminalPrint
            disp('Run SOFA Simulation...');
        end
        simulationTime = 0.5 ; % 0.3 shiv, 0.5 Beth, [s] simulation duration
        simulationFrames = simulationTime / 0.01 ; % number of simulation steps, 0.01 is the default simulation timestep
        pathToSofaScene = '"C:\Users\hadis\OneDrive - Queen Mary, University of London\Hadi\Postdoc\1_Bristol\2. Research\12. Model\1. main_CAD_MatlabGCode_SOFA_Opt\Matlab GCode"';
        SofaSceneFile = 'matlab_sofa.xml';
        [status, result] = system(['cd ' pathToSofaScene]); % navigate to the scene folder
        [status, result] = system(['C:\SOFA\bin\runSofa -g batch -n ' num2str( simulationFrames ) ' ' SofaSceneFile]); % run Sofa scene
        [status, result] = system('cd C:\Users\hadis'); % return to root folder


        %% read sim data for 8 pair [ xyz_leg xyz_gap_end] of nodes to get both lateral and longitudinal vibrations
        if isTerminalPrint
            disp('Load Simulation Results...');
        end
        pathToSimData = 'C:\Users\hadis\OneDrive - Queen Mary, University of London\Hadi\Postdoc\1_Bristol\2. Research\12. Model\1. main_CAD_MatlabGCode_SOFA_Opt\Matlab GCode\export_x.txt';
        fid = -1 ; % initialize fid to keep opening the result file
        while fid == -1 % t+keep trying to open the result file
            fid = fopen(pathToSimData,'rt');
        end
        sim_cell = textscan( fid, '%f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t%f %f %f\t', 'HeaderLines',2);
        fclose(fid);
        sim_data{i_exp} = cell2mat(sim_cell); % always 49 columns (each representing a reading point) were recorded with extra ones filled with NAN
        sampTime = sim_data{i_exp}(:,1) ; % sampling time for simulation data points
        latDispReadPoint{i_di}{i_exp} = sim_data{i_exp}(:,4:3:(numel(monitor_indices(i_web,:))*3+1))' ; % lateral displacement of read points: [z1, z2, ..., z_N]
        latDispExcitePoint{i_di}{i_exp} = sim_data{i_exp}(:,(numel(monitor_indices(i_web,:))*3+4))' ; % lateral displacement of excitation point
        meanMaxAbs_latDispReadPoint(i_exp,i_di) = mean(max(abs(latDispReadPoint{i_di}{i_exp}'))) ; % mean value of maximum absolute displacement of the readout points for comparing with real and printed web data


        %% plot sim data
        % t: sim_data(:,1), xyz_1: sim_data(:,4:6), ...
        if isPlot
            figure( fig_data )
            plot( sampTime, latDispReadPoint{i_di}{i_exp}' ) % z axis of sensing nodes
            xlabel('t [s]'); ylabel('z [mm]'); legend()
            hold on
            title( [ 'Damage case: ' num2str( i_di ) ] )
            % pause
        end
        
    end
    
    if isTerminalPrint
        % report final webs
        [ 'Damaged case: ' num2str( i_di ) ]

        i_b
        i_p
        i_jd
        i_jl
        p_mean
        meanMaxAbs_latDispReadPoint
    end
    if isPlot
        figure(fig_web)
        % perturbed excitation points
        plot3( points(excite_indices_disturbed+1,1) , points(excite_indices_disturbed+1,2) , points(excite_indices_disturbed+1,3) , 'go' , 'linewidth' , 1 )
    end

end


%% run LSTM
if isTrain && n_damageItteration > 1
    if isTerminalPrint
        disp('LSTM training & Evaluation...');
    end
    % stack data in coloumn vector for network training
    xtrain = latDispReadPoint{1} ; ytrain = categorical(ordinal(( 1 : n_exp )')) ; % train based on intact web
    damageRecordSkip = 1 ; % adjust for train and test data sets: no need to test the intact web anymore
    if excite_indices_variation_max == 0 && excite_loc_variation_max == 0 % no excitation index distribution so no test for excitation variation
        damageRecordSkip = 2 ; % start network test from 1st damaged case: ( n_damageItteration - 2 )
    end
    for i_di = 1 : n_damageItteration - damageRecordSkip
        xtest{i_di} = latDispReadPoint{i_di+damageRecordSkip} ; ytest{i_di} = categorical(ordinal(( 1 : n_exp )')) ;
    end
    [ net , accuracy , info ] = LSTM_fun( xtrain , ytrain , xtest , ytest , isPlot ) ;
    if isTerminalPrint
        accuracy
    end
else
    net = nan; accuracy = nan ;
end

% report main result
accuracy

