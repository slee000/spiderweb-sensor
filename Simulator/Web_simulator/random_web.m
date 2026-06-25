%% Random web generator
function [ lines , lines_index , fixedPoints ] = random_web( opt_par , isPlot , isRand )

% clear all
% close all
% clc
% pause(1e-1)

% read file and plot
addpath( 'igesToolBox_edited' , 'CAD source' ) ;


%% settings
% color the web
sec_colors.hub = [0.3 0 0.3];
sec_colors.capture = [0.7 0.7 0.7]; % grey
sec_colors.frame = "b";
sec_colors.radial = "k";
sec_colors.mooring = "r";

% inputs
if nargin < 2 || isempty( isPlot )
    isPlot = true ;
end

if nargin < 3 || isempty( isRand )
    isRand = true ; % randomize par.s
end

%% seed parameters: based on Fritz's image001
% frame xy normalized between -1,1
web_scale = 50 ; % web scale up from -1,1 (the span is 2)

r_frame = 0.85 ; % radius of the frame
% distort_frame = [[1.3; 0.9], [1; 1]] ; % scale for [[-x; x]: as a function of y, [-y; y]: as a function of x] sides of the frame
distort_frame = [[1; 1], [1; 1]] ;
if isRand
    distort_frame = ( 1 + rand([2,2]) ) * 0.5 ; % scale for [[-x; x]: as a function of y, [-y; y]: as a function of x] sides of the frame
end

% xy_center = [0.1; 0.2] ; % web center
xy_center = [0; 0] ; % web center
if isRand
    xy_center = ( -1 + rand([2,1]) ) * 0.5 ; % web center
end

n_rad = 27 ; % number of radii

n_hub = 5 ; % number of hub loops
r_hub = 0.1 ; % hub radius

n_cap = 23 ; % number of capture loops
r0_cap = 0.2 ; % capture inner radius
r_cap = 0.8 ; % capture outer radius, fixed value when capture is scaled for each radial to fill the offset

n_moor = 14 ; % number of mooring threads
r_moor = 0.4 ; % lenght of the mooring threads


%% optimisation parameters
if nargin >= 1 && ~isempty( opt_par )
    web_scale = opt_par.web_scale ;
    r_frame = opt_par.r_frame ;
    distort_frame = opt_par.distort_frame ;
    xy_center = opt_par.xy_center ;
    n_rad = opt_par.n_rad ;
    n_hub = opt_par.n_hub ;
    r_hub = opt_par.r_hub ;
    n_cap = opt_par.n_cap ;
    r0_cap = opt_par.r0_cap ;
    r_cap = opt_par.r_cap ;
    n_moor = opt_par.n_moor ;
    r_moor = opt_par.r_moor ;
end


%% noise addition
noise_rad = ( rand(1,n_rad) - 0.5 ) * 2 * pi / n_rad * 0.9 ; % randomizing radial thread director but prevent overlapping, scaled to not getting too close
if ~isRand
    noise_rad = 0 * noise_rad ;
end

n_rad_moor = floor( n_rad / n_moor ) + 1 ; % number of radial threads between each pair of mooring threads
noise_mooring = ( rand(1,n_moor) - 0.5 ) * n_rad_moor ; % randomizing radial thread director but prevent overlapping
if ~isRand
    noise_mooring = 0 * noise_mooring ;
end


%% optimisation parameters
if nargin >= 1 && ~isempty( opt_par )
    if isRand % scale the random values
        noise_rad = opt_par.noise_rad .* noise_rad ;
    else
        noise_rad = opt_par.noise_rad ;
    end
    if isRand
        noise_mooring = opt_par.noise_mooring .* noise_mooring ;
    else
        noise_mooring = opt_par.noise_mooring ;
    end
end


%% Initialization
% r_cap = 0.95 * ( r_frame - norm( xy_center ) ) ; % capture outer radius: if the capture distorts too
% r_cap = r_frame - min( min( distort_frame ) ) * r_fram - norm( xy_center ) ; % smallest circle that fit inside the distorted frame


%% generate the uniform web
% Line general recipe :
% lines{i_line}.name = 'LINE' ;
% lines{i_line}.type = 110 ;
% lines{i_line}.p1 = [x1 y1 z1] ;
% lines{i_line}.p2 = [x2 y2 z2] ;
% lines{i_line}.p = [ x1 x2; y1 y2; z1 z2 ] ; % points at both ends of a line

lines = {} ; % line data
lines_index = [ ] ; % HARD TO DISTINGUISH! line number for each region
i_line = 0 ; % number of lines
dir_rad = [] ; % radial thread director
l_rad = [] ; % radial thread length
mooring_line_idices = [] ; % indices for the mooring lines
fixedPoints = [] ; % indices of the mooring fixed ends

for i_rad = 1 : n_rad % radial thread director
    theta_rad = 2 * pi / n_rad * ( i_rad - 1 ) + noise_rad(i_rad) ;
    p_frame(:,i_rad) = r_frame * [ cos( theta_rad ); sin( theta_rad ) ] ; % points on the frame
    dir = p_frame(:,i_rad) - xy_center(1:2) ; % radial thread director (non-normalized)
    dir_rad = [ dir_rad, dir/norm(dir) ] ;
    l_rad = [ l_rad, norm(dir) ] ;
end
   
% web generation
i_moor = 1 ; % counter for generated mooring threads
for i_rad = 1 : n_rad % radial thread director    
    % hub region
    for i_hub = 1 : n_hub % iterate over hub loops
        
        % radial segments
        i_line = i_line + 1 ;
        lines{i_line}.name = 'LINE' ;
        lines{i_line}.type = 110 ;
        if i_hub == 1 % only for first hub loop
            lines{i_line}.p1(1:2,1) = xy_center(1:2) ; % first hub thread starts at the web center
        else
            lines{i_line}.p1(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( i_hub - 2 ) ) * r_hub / n_hub ) * dir_rad(:,i_rad) ; % first hub thread starts at the web center
        end
        lines{i_line}.p1(3,1) = 0 ;
        lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( i_hub - 1 ) ) * r_hub / n_hub ) * dir_rad(:,i_rad) ;
        lines{i_line}.p2(3,1) = 0 ;
        lines{i_line}.color = sec_colors.hub;
        
        % hub segments
        if ~ ( i_rad == 1 && i_hub == 1 ) % except for the hub start point
            i_line = i_line + 1 ;
            lines{i_line}.name = 'LINE' ;
            lines{i_line}.type = 110 ;
            lines{i_line}.p1 = lines{i_line-1}.p2 ; % same as the end of above radial line segment
            if i_rad == 1 % should connect to previous hub loop
                lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( n_rad / n_rad + ( i_hub - 2 ) ) * r_hub / n_hub ) * dir_rad(:,end) ; % last point of previous hub loop
            else % connect to the same hub loop
                lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( ( i_rad - 1 ) / n_rad + ( i_hub - 1 ) ) * r_hub / n_hub ) * dir_rad(:,i_rad-1) ; % recent point of the same hub loop
            end
            lines{i_line}.p2(3,1) = 0 ;
            lines{i_line}.color = sec_colors.hub;
            
        end
    end
    
    % cap region
    for i_cap = 1 : n_cap % iterate over hub loops
        
        % radial segments
        i_line = i_line + 1 ;
        lines{i_line}.name = 'LINE' ;
        lines{i_line}.type = 110 ;
        if i_cap == 1 % only for first hub loop
            lines{i_line}.p1(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( n_hub - 1 ) ) * r_hub / n_hub ) * dir_rad(:,i_rad) ; % first cap thread connects to hub
        else
            lines{i_line}.p1(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( i_cap - 2 ) ) * ( r_cap - r0_cap ) / n_cap + r0_cap ) * dir_rad(:,i_rad) * l_rad(i_rad) / r_frame ;
        end
        lines{i_line}.p1(3,1) = 0 ;
        lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( i_cap - 1 ) ) * ( r_cap - r0_cap ) / n_cap + r0_cap ) * dir_rad(:,i_rad) * l_rad(i_rad) / r_frame ;
        lines{i_line}.p2(3,1) = 0 ;
        lines{i_line}.color = sec_colors.radial;
        
        % cap segments
        if ~ ( i_rad == 1 && i_hub == 1 ) % except for the cap start point
            i_line = i_line + 1 ;
            lines{i_line}.name = 'LINE' ;
            lines{i_line}.type = 110 ;
            lines{i_line}.p1 = lines{i_line-1}.p2 ; % same as the end of above radial line segment
            if i_rad == 1 % should connect to previous cap loop
                lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( n_rad / n_rad + ( i_cap - 2 ) ) * ( r_cap - r0_cap ) / n_cap + r0_cap ) * dir_rad(:,end) * l_rad(end) / r_frame ; % last point of previous cap loop
            else % connect to the same cap loop
                lines{i_line}.p2(1:2,1) = xy_center(1:2) + ( ( ( i_rad - 1 ) / n_rad + ( i_cap - 1 ) ) * ( r_cap - r0_cap ) / n_cap + r0_cap ) * dir_rad(:,i_rad-1) * l_rad(i_rad-1) / r_frame ; % recent point of the same cap loop
            end
            lines{i_line}.p2(3,1) = 0 ;
            lines{i_line}.color = sec_colors.capture;
            
        end
    end
    
    % frame region
    % radial segments
    i_line = i_line + 1 ;
    lines{i_line}.name = 'LINE' ;
    lines{i_line}.type = 110 ;
    lines{i_line}.p1(1:2,1) = xy_center(1:2) + ( ( i_rad / n_rad + ( n_cap - 1 ) ) * ( r_cap - r0_cap ) / n_cap + r0_cap ) * dir_rad(:,i_rad) * l_rad(i_rad) / r_frame ; % frame thread connects to capture
    lines{i_line}.p1(3,1) = 0 ;
    lines{i_line}.p2(1:2,1) = p_frame(:,i_rad) ;
    lines{i_line}.p2(3,1) = 0 ;
    lines{i_line}.color = sec_colors.radial;
    
    % frame segments
    i_line = i_line + 1 ;
    lines{i_line}.name = 'LINE' ;
    lines{i_line}.type = 110 ;
    lines{i_line}.p1 = lines{i_line-1}.p2 ; % same as the end of above radial line segment
    if i_rad == 1 % frame point on 1st radial should connect to the frame point on last radial
        lines{i_line}.p2(1:2,1) = p_frame(:,n_rad) ; % last point of previous cap loop
        lines{i_line}.color = sec_colors.frame;
    elseif ( i_moor <= n_moor && ... % until all the mooring threads are created
            ( i_moor - 1 ) * n_rad_moor <= i_rad && ... % noise around the symmetric location of the mooring thread
            mod( floor( i_rad + noise_mooring(i_moor) ) , n_rad_moor ) == 0 ) || ... % every n_rad/n_moor radial thread, we have a mooring thread, with an offset from the x and y axes
            (i_rad == n_rad && i_moor == n_moor ) % if the last mooring thread is not created
        i_moor = i_moor + 1 ;
        % 1st part of frame around the mooring thread
        lines{i_line}.p2(1:2,1) = ( p_frame(:,i_rad) + p_frame(:,i_rad-1) ) / 2 ; % last point of previous cap loop
        lines{i_line}.p2(3,1) = 0 ;
        lines{i_line}.color = sec_colors.frame;
        % mooring line
        i_line = i_line + 1 ;
        lines{i_line}.name = 'LINE' ;
        lines{i_line}.type = 110 ;
        lines{i_line}.p1 = lines{i_line-1}.p2 ; % same as the end of 1st part of the frame around mooring thread
        lines{i_line}.p2(1:2,1) = lines{i_line}.p1(1:2,1) + r_moor * ( dir_rad(:,i_rad) + dir_rad(:,i_rad-1) ) / 2 ; % along the average of the directors of the adjutant radial threads
        lines{i_line}.p2(3,1) = 0 ; 
        lines{i_line}.color = sec_colors.mooring;
        mooring_line_idices = [ mooring_line_idices , i_line ] ;
        % 2nd part of the frame around the mooring thread
        i_line = i_line + 1 ;
        lines{i_line}.name = 'LINE' ;
        lines{i_line}.type = 110 ;
        lines{i_line}.p1 = lines{i_line-2}.p2 ; % same as the end of 1st part of the frame around mooring thread
        lines{i_line}.p2(1:2,1) = p_frame(:,i_rad-1) ; % recent point of the same cap loop
        lines{i_line}.p2(3,1) = 0 ;
        lines{i_line}.color = sec_colors.frame;
    else
        lines{i_line}.p2(1:2,1) = p_frame(:,i_rad-1) ; % recent point of the same cap loop
        lines{i_line}.color = sec_colors.frame;
    end
    lines{i_line}.p2(3,1) = 0 ;
    lines{i_line}.color = sec_colors.frame;
    
    
end
n_line = i_line ; % number of lines in the web
lines_index = [ 1 n_line ] ;

% distort all points
for i_line = 1  : n_line
    lines{i_line}.p1 = scale_distort( lines{i_line}.p1 , distort_frame, web_scale ) ;
    lines{i_line}.p2 = scale_distort( lines{i_line}.p2 , distort_frame, web_scale ) ;
    lines{i_line}.p = [ lines{i_line}.p1, lines{i_line}.p2 ] ;
end

% collect mooring line fixed points
for i_line = mooring_line_idices
    fixedPoints = [ fixedPoints ; lines{i_line}.p2' ] ;
end

% plot the web
if isPlot
    plotIGES( lines ) ; hold on
    % view( [ -1 -1 2 ] ) ;
    pause( 1 ) ;
    
    save( 'random_webs' , 'lines' , 'lines_index' )
end


%% functions
function p_out = scale_distort( p_in, distort, scale )
% distort: scale for [[-x; x], [-y; y]] sides of the frame
% p_in: [x; y]
% scale: scalar

p_out = scale * ... % general scale up
    [ ( ( p_in(2,1) + 1 ) * ( distort(2,1) - distort(1,1) ) / 2 + distort(1,1) ) ; % distort along x axis
      ( ( p_in(1,1) + 1 ) * ( distort(2,2) - distort(1,2) ) / 2 + distort(1,2) ) ] .* ...
      p_in(1:2,1) ; % distort along y axis
p_out(3,1) = 0 ;


