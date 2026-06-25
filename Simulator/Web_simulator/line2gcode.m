%Typo created by Adrien Rosselet

%put your mill just touching the surface manually
%set the gcode sender to X0 Y0 Z0
%run the code

function line2gcode( name , lines , r_t , tol , frtype , animate_path , p_mean , bed_size )

%parameters (in mm)
feedrate = 500 ; % printing speed um/s
travel = 10 ; % travel speed scale up
f_scale = 0.1e10 ; % PLA: 0.2e10 all & 0.1e10 capSpiral % filament feedrate scale

retract = 0 ; % retract in free movement
preflow = 0 ; % preflow for each run
tap_flow = 0; % 0.5 ; % init flow after long free run

tap = 0 ; % 0.5 ; % z tap (change in height in mm so nozzle would be at up-tap) to fix string start
up = 0.7 ; % height when the tool is moving

fileID = fopen([ name '_gcode.gcode' ],'w');%enter the name of the created file
fprintf(fileID,'%s\n','G21 G90 G17 F90');%Check this header line. Is it ok for your machine?

%program
rapid='G0';
lent='G1';

% initialize
% G92 z0; set new reference for z0
% G28; home
% G29; auto level
fprintf(fileID,'M107\n') ;
fprintf(fileID,'M104 S210 ; set temperature\n') ;
fprintf(fileID,'G28 ; home all axes\n') ;
fprintf(fileID,'G1 Z5 F5000 ; lift nozzle\n') ;

fprintf(fileID,'; Filament gcode\n') ;

fprintf(fileID,'M140 S100 ; set bed temperature and wait for it to be reached\n') ;
fprintf(fileID,'M109 S230 ; set nozzle temperature and wait for it to be reached\n') ;
fprintf(fileID,'G21 ; set units to millimeters\n') ;
fprintf(fileID,'G90 ; use absolute coordinates\n') ;
% fprintf(fileID,'M82 ; use absolute distances for extrusion\n') ;
fprintf(fileID,'M83 ; use relative distances for extrusion\n') ;
fprintf(fileID,'G92 E0\n') ;
fprintf(fileID,'G92 E0\n') ;
fprintf(fileID,'G1 F1500\n') ;
% fprintf(fileID,'G1 Z0.000 E10.000 F1500.000\n') ;
fprintf(fileID,'G1 Z0.000 F1500.000\n') ;
fprintf(fileID,'G1 Z1.500 E1.000 F1500.000\n') ;
fprintf(fileID,'G1 Z0.700 F1500.000\n') ;
% fprintf(fileID,'G1 X10 Y80 E0.500 F1500.000\n') ; % manual tweak for the 1st printed web only at U Bristol
fprintf(fileID,'G92 X0 Y0 E0 ; set new reference \n') ;
fprintf(fileID,'G1 F1500\n') ;

% compare print center of area and the printer bed size
offset = p_mean - ( bed_size(:,2) + bed_size(:,1) )' / 2;

% remove not-line elements & add the offset
i = 0 ;
while ~isempty( lines ) % find 1st line
    i = i + 1 ;
    if i > numel( lines )
        break
    end
    lines_left = numel( lines )
    if ~strcmp( lines{i}.name , 'LINE' )
        lines(i) = [] ;
        i = i - 1 ;
    else % adjust the offset for printing
        lines{i}.p1 = lines{i}.p1 - offset' ;
        lines{i}.p2 = lines{i}.p2 - offset' ;
    end
end
lines_left = numel( lines )

% first line
i = 0 ;
end_points = zeros(1,6) ; % xyz
while ~isempty( lines ) % find 1st line
    i = i + 1 ;
    lines_left = numel( lines )
    if i <= numel( lines )
        p1 = lines{i}.p1 ; p2 = lines{i}.p2 ;
        if abs( p1(1) ) < tol
            if abs( p1(2) ) < tol
                lines(i) = [] ;
                break
            end
        end
    else
        p1 = lines{1}.p1 ; p2 = lines{1}.p2 ;
        lines(1) = [] ;
        break
    end
end
lines_left = numel( lines )
                        
l = - retract ; % retract
fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',rapid,'X',p1(1),'Y',p1(2),'Z',up,'E',l,'F',travel*feedrate);
if tap ~= 0
    fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p1(1),'Y',p1(2),'Z',up-tap,'E',tap_flow,'F',feedrate);
    fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p1(1),'Y',p1(2),'Z',up,'E',tap_flow,'F',feedrate);
end
end_points = [ end_points ; p1' p1' ] ;
tmp = p1 - p2 ;
l = retract + preflow + f_scale * pi * r_t ^ 2 * sqrt( tmp' * tmp ) ; 
fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p2(1),'Y',p2(2),'Z',up,'E',l,'F',feedrate);
% fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p2(1),'Y',p2(2),'Z',up,'E',l/2,'F',feedrate);
% fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',rapid,'X',p2(1),'Y',p2(2),'Z',up,'E',0,'F',feedrate);
end_points = [ end_points ; p1' p2' ] ;

% rest of lines: searches for connection to the 2nd end of a line: p2
i_restart = 0 ; % number of restarts that causes threads in the print
while( ~isempty( lines ) )
    lines_left = numel( lines )
            
    found = 0 ; % connecting lines found alert    
    min_dist = inf ; % to find the line with the closest start point
    i = 1 ; % tested line index
    while( ~isempty( lines ) && i <= numel( lines ) ) % search all lines to find all the connecting lines
        dist = [ norm( lines{i}.p1 - p2 ) , norm( lines{i}.p2 - p2 ) ] ; % line ends' distance to the last printed line end
        if min( dist ) < min_dist % record the closest line to the last printed line
            i_dist = i ;
            min_dist = min( dist ) ;
            if dist(1) < dist(2) % closer end is the 1st end
                p1_dist = lines{i}.p1 ;
                p2_dist = lines{i}.p2 ;
            else % closer end is the 2nd end
                p1_dist = lines{i}.p2 ;
                p2_dist = lines{i}.p1 ;                
            end
            % if numel( p1_dist ) > 3 || numel( p2_dist ) > 3
            %   1 
            % end
        end
        if dist(1) < tol % new line's 1st end distance to the last printed line
            if strcmp( frtype{1} , 'tangent' ) % smooth tangent between the lines to follow a more spider-like path
                if found == 1 && ... % already found a line
                        align_index( p2-p1 , lines{i}.p2-lines{i}.p1 ) > align_index( p2-p1 , p2_temp-p1_temp ) % larger align-index so not smoother than the previous found line
                    i = i + 1 ; % to iterate over all the remaining lines
                    continue % disregard this and check the next line
                end
                p1_temp = lines{i}.p1 ;
                p2_temp = lines{i}.p2 ;
                i_temp = i ;
                found = 1 ;
            elseif strcmp( frtype{1} , 'first_encountered_in_array' ) % proceed with the 1st found line, no smooth connection selection!
                break
            end
        elseif dist(2) < tol % new line's 2nd end distance to the last printed line
            if strcmp( frtype{1} , 'smooth' )  % smooth tangent between the lines to follow a more spider-like path
                if found == 1 && ... % already found a line
                        align_index( p2-p1 , lines{i}.p1-lines{i}.p2 ) > align_index( p2-p1 , p2_temp-p1_temp ) % larger align-index so not smoother than the previous found line
                    i = i + 1 ; % to iterate over all the remaining lines
                    continue % disregard this and check the next line
                end
                p1_temp = lines{i}.p2 ;
                p2_temp = lines{i}.p1 ;
                i_temp = i ;
                found = 1 ;
            elseif strcmp( frtype{1} , 'first_encountered_in_array' ) % proceed with the 1st found line, no smooth connection selection!
                break
            end
        end
        i = i + 1 ; % to iterate over all the remaining lines
    end

    if found == 1 % connected line found
        p1 = p1_temp; p2 = p2_temp ;
        % i_temp
        lines(i_temp) = [] ;
    else % not found so continue with the closest line
        if strcmp( frtype{2} , 'closest_line' )
            i_restart = i_restart + 1 ; % count restarts
            found = 1 ;
            p1 = p1_dist; p2 = p2_dist ;
            % i_dist
            lines(i_dist) = [] ;
        else strcmp( frtype{2} , 'array_first' ) % continue with the 1st found line in the list
        end
    end
                
    if found == 1 % found
        tmp = p1 - p2 ;
        l = f_scale * pi * r_t ^ 2 *sqrt( tmp' * tmp ) ;
        fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p2(1),'Y',p2(2),'Z',up,'E',l,'F',feedrate); 
        end_points = [ end_points ; p1' p2' ] ;
    else if ~isempty( lines ) % not found so choose 1st line of not handled lines in the list and start form there
            i = 1 ; % return to the 1st line in the list of the remaining lines
            i_restart = i_restart + 1 ; % count restarts
            p1 = lines{i}.p1 ;
            p2 = lines{i}.p2 ;
            lines(i) = [] ;
            l = - retract ; % retract
            fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',rapid,'X',p1(1),'Y',p1(2),'Z',up,'E',l,'F',travel*feedrate);
            if tap ~= 0
                fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p1(1),'Y',p1(2),'Z',up-tap,'E',tap_flow,'F',feedrate);
                fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p1(1),'Y',p1(2),'Z',up,'E',tap_flow,'F',feedrate);
            end
            end_points = [ end_points ; p1' p1' ] ; 
            tmp = p1 - p2 ;
            l = retract + preflow + f_scale * pi * r_t ^ 2 *sqrt( tmp' * tmp ) ;
            fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p2(1),'Y',p2(2),'Z',up,'E',l,'F',feedrate);
%             fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',lent,'X',p1(1),'Y',p1(2),'Z',up,'E',l/2,'F',feedrate);
%             fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',rapid,'X',p2(1),'Y',p2(2),'Z',up,'E',0,'F',feedrate);
            end_points = [ end_points ; p1' p2' ] ;
        else % not found and no line left so exit
            break
        end        
    end
    
end
lines_left = numel( lines )
i_restart

% finalize
fprintf(fileID,'%s %c%.3f %c%.3f %c%.3f %c%.3f %c%.3f\n',rapid,'X',0,'Y',0,'Z',up,'E',0,'F',2*feedrate);

fprintf(fileID,'M107\n') ;
fprintf(fileID,'; Filament-specific end gcode \n') ;
fprintf(fileID,'; END gcode for filament\n') ;
fprintf(fileID,'M104 S0 ; turn off temperature\n') ;

% fprintf(fileID,'G28 X0  ; home X axis\n') ;
fprintf(fileID,'G28 X0 Y0; home all axis\n') ;
fprintf(fileID,'M84      ; disable motors\n') ;

fprintf(fileID,'M140 S0 ; set bed temperature\n') ;

pause( 5e-1 ) ;
fclose( fileID );
pause( 5e-1 ) ;

% plot the print path
subplot(1,2,2)
grayColor = [.7 .7 .7];
for i = 1 : numel( end_points(:,1) )
    plot3( end_points(i,[1,4])' , end_points(i,[2,5])' , end_points(i,[3,6])' , 'color', 'b' , 'LineWidth' , 2 ) ; hold on
    if animate_path
        pause(1e-3)
    end
end

% save the end points for the lines
eval( [ name ' = end_points ; save( ''' name '.mat'' , ''' name ''' ) ;' ] ) ;

end


function index = align_index( ref , v )
index = abs( 1 - ref' * v / norm( ref ) / norm( v ) ) ; % the small the more aligned with the same direction
end


function theta = rel_angle( u , v )
% theta = ( acos( abs( dot( u , v ) ) / ( norm(u) * norm(v) ) ) ) ;
theta = atan2( cross( v , u ) , dot( u , v ) ) ;
end


