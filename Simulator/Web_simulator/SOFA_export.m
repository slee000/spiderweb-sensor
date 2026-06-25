function SOFA_export(section_name, lines, lines_index, KDr, kdr_i, points, tol, frameType, excitation, monitorIndices, p_mean, fixedPoints)
%% parameters
m = 10e-3; % total mass
pre_tension = 1; % pretension range
diameter_scale = 1e6 ; % scale up the diameter for visualization

% excitation:
excite_index = excitation.excite_index ; % (153: near_spiral, 758: near_radial, 287:far_mid_radial) excitation point, starts from 0 so it corresponds to points (excite_index+1)
amp = excitation.amp ; % mm, excitation amplitude, from paper
omega = excitation.omega ; % Hz, excitation frequency, from paper

%% open file
errmsg = 0 ; % dummy value to check if the file opened
while ~isempty( errmsg ) % check if the file open worked
    [ fileID , errmsg ] = fopen('matlab_sofa.xml','w') ;
end

%% defaults
% simulation time step is default: 0.01s
fprintf(fileID,'<?xml version="1.0"?>\n') ;
fprintf(fileID,'<Node name="Root" gravity="0.0 -0.0 0.0" >\n') ;
fprintf(fileID,'    <VisualStyle displayFlags="showBehaviorModels showVisual showForceFields" />\n') ;
fprintf(fileID,'	<Node name="web"  >\n') ;
fprintf(fileID,'		<EulerImplicit name="cg_odesolver" printLog="false"  rayleighStiffness="0.1" rayleighMass="0.1" />\n') ;
fprintf(fileID,'		<CGLinearSolver name="cGLinearSolver1"  iterations="20"  tolerance="1e-05"  threshold="1e-08" />\n') ;

%% topology
% fprintf(fileID,'<EdgeSetTopologyContainer name="Container" points="" edges="" />') ;
fprintf(fileID,['		<EdgeSetTopologyContainer name="Container_points" points="']) ;
for i = 1 : numel( points(:,1) ) % write the points
    fprintf(fileID,'%f %f %f',points(i,1),points(i,2),points(i,3)) ;
    if i < numel( points(:,1) )
        fprintf(fileID,' ') ;
    end
end
% i % test
fprintf(fileID,'" />\n') ;
    
for i_f = 1 : numel( section_name )
    fprintf(fileID,['		<EdgeSetTopologyContainer name="Container_' section_name{i_f} '" points="@Container_points.points"']) ;
    
    file_lines = lines(lines_index(i_f,1):lines_index(i_f,2)) ;
%     % remove non-line elements
%     i = 0 ;
%     while ~isempty( file_lines ) % find 1st line
%         i = i + 1 ;
%         if i > numel( file_lines )
%             break
%         end
%         if ~strcmp( file_lines{i}.name , 'LINE' )
%             file_lines(i) = [] ;
%             i = i - 1 ;
%         else % adjust the center of area offset
%             file_lines{i}.p1 = file_lines{i}.p1 - p_mean' ;
%             file_lines{i}.p2 = file_lines{i}.p2 - p_mean' ;
%         end
%     end

    section_indices{i_f} = []; % points in this section
    fprintf(fileID,' edges="') ; % write the edges
    for i = 1 : numel( file_lines )
        % "index1 index2"
        fprintf(fileID,'%d %d',file_lines{i}.p_index(1)-1,file_lines{i}.p_index(2)-1) ;
        section_indices{i_f} = [ section_indices{i_f}, file_lines{i}.p_index(1)-1, file_lines{i}.p_index(2)-1 ] ;
        section_indices{i_f} = unique( section_indices{i_f} ) ;
        if i < numel( file_lines )
            fprintf(fileID,' ') ;
        end
    end
    % i % test
    fprintf(fileID,'" />\n') ;
end

%% general
fprintf(fileID,'		<PointSetGeometryAlgorithms name="pointAlgorithms" template="Vec3d" />\n') ;
fprintf(fileID,'		<EdgeSetGeometryAlgorithms name="edgeAlgorithms" template="Vec3d" />\n') ;
fprintf(fileID,['		<MechanicalObject name="dofs" template="Vec3d" restScale="' num2str( pre_tension ) '" />\n']) ;
fprintf(fileID,['		<UniformMass name="umass" totalMass="' num2str( m ) '" showGravityCenter = true />\n']) ;

%% fix nodes
% fprintf(fileID,'		<FixedConstraint name="FixedConstraint" indices="4 5 6 7" />\n') ;
% fprintf(fileID,'		<FixedConstraint name="FixedConstraint" indices="1668 1670 1671 1674" />\n') ;

switch frameType
    case 'pointVector' % fix the points lying on the square frame
        fix_ind = [] ;
        for i_point = 1 : numel( fixedPoints(:,1) )
            temp1 = find( abs( points(:,1) - fixedPoints(i_point,1) ) < tol ) ; % find fixed points' indices x
            temp2 = find( abs( points(temp1,2) - fixedPoints(i_point,2) ) < tol ) ; % find fixed points' indices y
            fix_ind = [ fix_ind; temp1(temp2) ] ;
        end
        fprintf(fileID,['		<FixedConstraint name="FixedConstraint" indices="' num2str( fix_ind'-1 ) '" />\n']) ;

    case 'square' % fix the points lying on the square frame
        fix_ind = find( abs( points(:,1) - min( points(:,1) ) ) < tol ) ; % min x
        temp  = find( abs( points(:,1) - max( points(:,1) ) ) < tol ) ; fix_ind = [ fix_ind; temp ] ; % max x
        temp  = find( abs( points(:,2) - min( points(:,2) ) ) < tol ) ; fix_ind = [ fix_ind; temp ] ; % min y
        temp  = find( abs( points(:,2) - max( points(:,2) ) ) < tol ) ; fix_ind = [ fix_ind; temp ] ; % max y
        
        fprintf(fileID,['		<FixedConstraint name="FixedConstraint" indices="' num2str( fix_ind'-1 ) '" />\n']) ;
        
    case '1stSectionName' % fixe all points in the 1st web section, usually "frame"
        fprintf(fileID,['		<FixedConstraint name="FixedConstraint" indices="' num2str( section_indices{1} ) '" />\n']) ;        
end

%% MeshSpingForceField:
for i_f = 1 : numel( section_name )
    fprintf(fileID,['		<MeshSpringForceField name="Springs_' section_name{i_f} '" topology="@Container_' section_name{i_f} '" template="Vec3d" noCompression=true stiffness="' num2str( KDr(kdr_i(i_f),1) ) '"  damping="' num2str( KDr(kdr_i(i_f),2) ) '" drawSpringSize="' num2str( KDr(kdr_i(i_f),3) * diameter_scale ) '"']) ;
    fprintf(fileID,' drawMinElongationRange="-1e-20" drawMaxElongationRange="1e-20"') ;
    fprintf(fileID,' />\n') ;
end

%% SpingForceField:
% fprintf(fileID,'		<SpringForceField name="Springs" template="Vec3d"') ;
% fprintf(fileID,' spring="') ; % write the springs
% for i = 1 : numel( lines )
%     ind1 = lines{i}.p_index(1)-1;
%     ind2 = lines{i}.p_index(2)-1;
%     p1 = lines{i}.p1;
%     p2 = lines{i}.p2;
%     L = norm(p1-p2);
%     % "index1 index2 K D L"
%     fprintf(fileID,'%d %d %d %d %d',ind1,ind2,K_m*L,D_m*L,pre_tens*L) ;
%     if i < numel( lines )        
%         fprintf(fileID,' ') ;
%     end
% end
% i
% fprintf(fileID,'" />\n') ;

%% lateral vibration visualization
fprintf(fileID,'		<RestShapeSpringsForceField name="Springs_lateral" points="@Container_points.points" template="Vec3d" stiffness="0" drawSpring="1" springColor="255 255 0 255" />\n') ;

%% other general
fprintf(fileID,'		<OglModel name="renderer" color="red" />\n') ;
% fprintf(fileID,'		<IdentityMapping name="identityMap1"  input="@."  output="@renderer" />\n') ;
fprintf(fileID,['		<OscillatorConstraint name="excitation" template="Vec3d" oscillators="' ...
    num2str(excite_index) '  '  num2str(points(excite_index+1,1:3)) '  '  num2str(amp) '  '  num2str(omega) ' 0" />\n']) ; % "index mean_position amplitude frequency"

monitorIndices = [ monitorIndices , excite_index ] ; % to monitor both the read and the excitation point dosplacement
% fprintf(fileID,'		<Monitor template="Vec3d" name="export" indices=@Container.points ExportPositions=true fileName="C:\\Users\\hadis\\OneDrive - Queen Mary, University of London\\Hadi\\Postdoc\\1_Bristol\\2. Research\\12. Model\\1. main_CAD_MatlabGCode_SOFA_Opt\\Matlab GCode\\export" />\n') ;
fprintf(fileID,['		<Monitor template="Vec3d" name="export" indices="' num2str( monitorIndices ) '" ExportPositions=true fileName="C:\\Users\\hadis\\OneDrive - Queen Mary, University of London\\Hadi\\Postdoc\\1_Bristol\\2. Research\\12. Model\\1. main_CAD_MatlabGCode_SOFA_Opt\\Matlab GCode\\export" />\n']) ;
fprintf(fileID,'	</Node>\n') ;
fprintf(fileID,'</Node>\n') ;

%% end
pause( 5e-1 ) ;
fclose( fileID );
pause( 5e-1 ) ;
