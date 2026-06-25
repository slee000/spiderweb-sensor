%% biological relevance of 3D printed web
%% 1-t_bio vs 1-t_sim vs V_exp
clear all
close all
clc


%% read  point
read_point = [ 41, 40 ] ; % [ 60.54, 58.66 ] where the vibration are read from, NO NEED TO MIRROR

%% simulation
%% based on the front of the wave, i.e, when displacement starts at the hub centre
sim_front_time = [ ... % excitaion 1mm: time that wave arrives at hub centre
    0.04 0.08 0.16 0.22;
    0.05 0.06 0.11 0.19;
    0.05 0.08 0.17 0.23;
    0.1 0.15 0.23 0.26;
    0.09 0.15 0.22 0.24;
    0.06 0.13 0.18 0.24] ;


%% based on mean maximum absolute displacement at readout points
% sim_mean_max_abs = [ ... % excitaion 1mm: mean maximum absolute displacement at readout points   
%    6.0356e-03   1.6283e-03   2.0881e-02   1.5568e-01;
%    2.1417e-02   2.2390e-03   2.1136e-02   1.0536e-01;
%    1.1156e-03   6.1319e-03   3.6607e-02   1.5516e-01;
%    2.3685e-02   7.0328e-02   4.5696e-02   1.0205e-01;
%    3.9272e-03   2.2978e-06   5.0199e-03   2.2823e-02;
%    5.3391e-04   4.0188e-03   2.2116e-02   2.0789e-02] ;

sim_mean_max_abs = [ ... % excitaion 7mm: mean maximum absolute displacement at readout points   
   4.4000e-01   1.5130e+00   1.0980e+00   1.9386e+00;
   6.7014e-01   1.7084e+00   1.3558e+00   2.3216e+00;
   4.3353e-01   1.5241e+00   2.3603e+00   3.4932e+00;
   1.2070e+00   1.8223e+00   1.9613e+00   3.1219e+00;
   7.1682e-01   2.7047e+00   2.6788e+00   3.1197e+00;
   2.9626e-01   6.5477e-01   1.1798e+00   1.1738e+00] ;


%% 3D printed web tests
%% Sudong's stiffness [N/mm] data
print_peak_V = [ ... % dataset 1 - peack signal voltage from 3D-printed web: [ rad x cap ] according to Beth's Msc student report
    400, 590, 553, 581 ;
    478, 474, 475, 478 ;
    375, 465, 384, 385 ;
    400, 350, 254, 411; % 400, 350, 254, 411;
    394, 391, 390, 394 ;
    518, 476, 482, 518 ;
    408, 410, 407, 408 ;
    413, 505, 424, 439 ] ;

print_all_dV = [ ... % dataset 2 - average of top 5% of data from 24 poking locations for 21 pairs of electrode locations
    0.452103	0.157182	0.158945	0.388822	0.385878	0.278381	0.691527	0.506009	0.798375	1	0.782537	0.572901	0.367383	0.29182	0.254078	0.459985	0.157391	0.292473	0.420365	0.379503	0.347488;
    0.445277	0.167374	0.245015	0.546535	0.368372	0.289567	0.686354	0.505629	0.831175	1	0.785758	0.567985	0.629091	0.313759	0.266035	0.713837	0.24529	0.295899	0.507459	0.495277	0.387022;
    0.440368	0.163398	0.31847     0.552461	0.359185	0.284295	0.684261	0.504969	0.827577	1	0.790268	0.601125	0.654881	0.307531	0.260161	0.74313	0.338823	0.330101	0.492178	0.477805	0.385303;
    0.436949	0.182322	0.430181	0.789157	0.355427	0.282961	0.683132	0.504364	0.823737	1	0.795043	0.588438	0.864628	0.425913	0.341531	0.889764	0.450538	0.386177	0.552042	0.492886	0.383808;
    0.434241	0.188433	0.424319	0.789433	0.36879	    0.292571	0.685745	0.503245	0.825995	1	0.798899	0.557652	0.856543	0.584604	0.528276	0.886931	0.445472	0.380829	0.57976	0.553156	0.390512;
    0.432625	0.206268	0.419158	0.802644	0.37157	    0.348583	0.685765	0.501116	0.88483	1	0.801425	0.531819	0.877286	0.580106	0.523887	0.880324	0.44103	0.376576	0.713109	0.703067	0.390546;
    0.430219	0.204334	0.415646	0.806794	0.369927	0.344475	0.686064	0.49855	0.892175	1	0.802984	0.521207	0.877857	0.57583	0.520417	0.889917	0.443011	0.386205	0.721568	0.762177	0.390611;
    0.428135	0.202677	0.412301	0.798654	0.36831	    0.340611	0.686467	0.495751	0.888547	1	0.803631	0.518601	0.870469	0.571489	0.51772	0.883823	0.484188	0.389129	0.711934	0.773704	0.390565;
    0.425786	0.201063	0.408568	0.794832	0.368112	0.337458	0.686213	0.493143	0.895974	1	0.803446	0.499479	0.876599	0.567849	0.515309	0.878819	0.482787	0.38589	0.729315	0.785943	0.437067;
    0.424457	0.200363	0.405368	0.79223	    0.36767	    0.335325	0.686084	0.491205	0.894975	1	0.803491	0.488569	0.87204	0.564522	0.513108	0.874806	0.48198	0.383228	0.744414	0.793726	0.474049;
    0.423485	0.199216	0.402224	0.788444	0.36909	    0.333654	0.68599	0.488926	0.892613	1	0.803836	0.474233	0.867605	0.561564	0.510801	0.87104	0.481517	0.381003	0.745438	0.797837	0.474679;
    0.421853	0.198152	0.39921	    0.802058	0.370051	0.331913	0.685635	0.485852	0.899128	1	0.804231	0.462389	0.871824	0.558969	0.508607	0.868886	0.481321	0.378815	0.80751	0.825191	0.47512;
    0.420362	0.197201	0.396788	0.797218	0.43139	    0.330369	0.685222	0.482023	0.897508	1	0.804927	0.463108	0.867851	0.563375	0.506673	0.866359	0.48145	0.376942	0.814766	0.821063	0.553013;
    0.419075	0.196649	0.394729	0.792822	0.521314	0.336769	0.684621	0.478179	0.896417	1	0.805658	0.46682	0.864272	0.580242	0.50494	0.8646	0.491729	0.375847	0.874272	0.821902	0.68056;
    0.406281	0.190406	0.381738	0.766947	0.743651	0.348399	0.665027	0.460815	0.870902	1	0.784179	0.450877	0.837165	0.711017	0.48925	0.839141	0.625156	0.364572	0.936792	0.797821	0.893724;
    0.349443	0.163491	0.327538	0.658368	0.928911	0.330058	0.57286	0.393918	0.750558	1	0.676659	0.386652	0.719395	0.874872	0.421689	0.722326	0.803744	0.325462	0.812005	0.686596	0.993164;
    0.348249	0.163098	0.326168	0.655077	0.924562	0.332395	0.57215	0.390349	0.749848	1	0.67651	0.384272	0.716749	0.870217	0.424093	0.720702	0.799244	0.328857	0.810004	0.685516	0.990451;
    0.347048	0.162424	0.32472	    0.652051	0.920086	0.332734	0.571638	0.387046	0.749276	1	0.67619	0.381626	0.714392	0.865638	0.424568	0.719172	0.794668	0.328662	0.808349	0.684284	0.987811;
    0.345865	0.161742	0.323432	0.649077	0.915238	0.335541	0.571227	0.384005	0.748783	1	0.675942	0.381937	0.712143	0.861113	0.425133	0.717627	0.789945	0.329402	0.806892	0.683243	0.985265;
    0.344585	0.161575	0.322272	0.647254	0.910147	0.33599	0.570802	0.381055	0.748284	1	0.675657	0.381282	0.709977	0.856149	0.424883	0.715902	0.784885	0.329326	0.805297	0.68228	0.982594;
    0.343314	0.160918	0.321296	0.653916	0.904907	0.336309	0.570282	0.379151	0.74782	1	0.675995	0.377973	0.707872	0.851338	0.427521	0.714073	0.779786	0.335029	0.803652	0.681398	0.979743;
    0.342024	0.16029	    0.324109	0.677922	0.899516	0.336659	0.569646	0.376736	0.747432	1	0.675732	0.373597	0.705737	0.846673	0.427669	0.71215	0.774853	0.33497	0.802097	0.680602	0.976914;
    0.340786	0.160482	0.334906	0.807847	0.894198	0.336977	0.578203	0.391941	0.747279	1	0.675346	0.371128	0.713005	0.841998	0.427695	0.729655	0.769837	0.334896	0.802235	0.684032	0.974216;
    0.341886	0.160361	0.335267	0.863907	0.888421	0.337074	0.624542	0.503461	0.746601	1	0.691294	0.370363	0.723322	0.836935	0.427548	0.745603	0.764344	0.334664	0.800781	0.687999	0.971151;
    ];
print_mean_max_dV_vec = mean( print_all_dV' )


%% web geometry
%% based on "Web locations.fig"
poke_xy(:,:,1) = [ ... % location of poking on the web radii #1
    41.143, 47.037;
    41.143, 54.537;
    41.143, 62.037;
    41.143, 69.537] ;
poke_xy(:,:,2) = [ ... % location of poking on the web radii #2
    34.64780947, 43.287;
    28.15261894, 47.037;
    21.65742841, 50.787;
    15.16223789, 54.537] ;
poke_xy(:,:,3) = [ ... % location of poking on the web radii #3
    34.64780947, 35.787;
    28.15261894, 32.037;
    21.65742841, 28.287;
    15.16223789, 24.537] ;
poke_xy(:,:,4) = [ ... % location of poking on the web radii #4
    41.143, 32.037;
    41.143, 24.537;
    41.143, 17.037;
    41.143, 9.537;] ;
poke_xy(:,:,5) = [ ... % location of poking on the web radii #5
    47.63819053, 35.787;
    54.13338106, 32.037;
    60.62857159, 28.287;
    67.12376211, 24.537;] ;
poke_xy(:,:,6) = [ ... % location of poking on the web radii #6
    47.63819053, 43.287;
    54.13338106, 47.037;
    60.62857159, 50.787;
    67.12376211, 54.537] ;

% for i_r = 1:6 % mirror the points to match 3D printed and simulation versions: mirored w.r.t. line y=-x
%     poke_xy(:,:,i_r) = 100 - [ poke_xy(:,2,i_r), poke_xy(:,1,i_r) ] ;
% end
  

%% distance normalized data
for i_r = 1:6 % radial threads
    for i_c = 1:4 % capture threds
        sim_front_time_norm(i_r,i_c) = sim_front_time(i_r,i_c) / norm( poke_xy(i_c,:,i_r) - read_point ) ;
        sim_vel_norm(i_r,i_c) = norm( poke_xy(i_c,:,i_r) - read_point ) / sim_front_time(i_r,i_c) ;
    end
end


%% vectorize data
print_peak_V_vec = [] ;
poke_xy_vec = [] ;
sim_front_time_vec = [] ;
sim_front_time_norm_vec = [] ;
sim_vel_norm_vec = [] ;
sim_mean_max_abs_vec = [] ;
for i = 1:6 % radii
    print_peak_V_vec = [ print_peak_V_vec print_peak_V(i,:) ] ;
    poke_xy_vec = [ poke_xy_vec ; [ poke_xy(:,:,i), zeros(4,1) ] ] ;
    sim_front_time_vec = [ sim_front_time_vec sim_front_time(i,:) ] ;
    sim_front_time_norm_vec = [ sim_front_time_norm_vec sim_front_time_norm(i,:) ] ;
    sim_vel_norm_vec = [ sim_vel_norm_vec sim_vel_norm(i,:) ] ;
    sim_mean_max_abs_vec = [ sim_mean_max_abs_vec sim_mean_max_abs(i,:) ] ;
end

% normalize data
% print_normalized = print_peak_V_vec / max( print_peak_V_vec(:) ) ;
% print_normalized = print_mean_max_dV_vec / max( print_mean_max_dV_vec ) ;
sim_front_time_vec = sim_front_time_vec / max( sim_front_time_vec(:) ) ;
sim_front_time_norm_vec = sim_front_time_norm_vec / max( sim_front_time_norm_vec(:) ) ;
sim_vel_norm_vec = sim_vel_norm_vec / max( sim_vel_norm_vec(:) ) ;
sim_mean_max_abs_vec = sim_mean_max_abs_vec / max( sim_mean_max_abs_vec(:) ) ;

print_normalized = ( print_peak_V_vec - min( print_peak_V_vec(:) ) ) / ( max( print_peak_V_vec(:) ) - min( print_peak_V_vec(:) ) ) ;
% print_normalized = ( print_mean_max_dV_vec - min( print_mean_max_dV_vec(:) ) ) / ( max( print_mean_max_dV_vec(:) ) - min( print_mean_max_dV_vec(:) ) ) ;
% sim_front_time_vec = ( sim_front_time_vec - min( sim_front_time_vec(:) ) ) / ( max( sim_front_time_vec(:) ) - min( sim_front_time_vec(:) ) ) ;
% sim_front_time_norm_vec = ( sim_front_time_norm_vec - min( sim_front_time_norm_vec(:) ) ) / ( max( sim_front_time_norm_vec(:) ) - min( sim_front_time_norm_vec(:) ) ) ;
% sim_mean_max_abs_vec = ( sim_mean_max_abs_vec - min( sim_mean_max_abs_vec(:) ) ) / ( max( sim_mean_max_abs_vec(:) ) - min( sim_mean_max_abs_vec(:) ) ) ;


%% plots arrival time data
open('bioWeb001.fig')
view([0,0,1])
hold on
psz = 300 ;
%% fast wave (high tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 1.5*psz, 1-sim_front_time_vec(:)+min(sim_front_time_vec(:)), 'filled', 's', 'MarkerEdgeColor', [0,0,0]) 
hold on
%% highest voltage change (higher stress due to higher tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 0.2*psz, print_normalized(:), 'filled', 'o', 'MarkerEdgeColor', [0,0,0])
hold on
plot(read_point(1),read_point(2),'rx') % web senter

title('arrival time - Normalized by min value')
ylabel('Experiments - Mean max abs voltage drop')
set( gca , 'fontsize' , 15 )
colorbar
axis equal
pause(1)

figure
plot( 1-sim_front_time_vec(:)+min(sim_front_time_vec(:)) , print_normalized(:) , '*' )
axis([0,1,0,1])
xlabel('Simulations - arrival time - Normalized by min value'); ylabel('Experiments - Mean max abs voltage drop')
lsline
axis equal
R1 = corrcoef(1-sim_front_time_vec(:)+min(sim_front_time_vec(:)) , print_normalized(:)) % Pearson correlation coefficient (PCC)


%% plots velocity time data
open('bioWeb001.fig')
view([0,0,1])
hold on
psz = 300 ;
%% fast wave (high tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 1.5*psz, sim_front_time_norm_vec(:)+min(sim_front_time_norm_vec(:)), 'filled', 's', 'MarkerEdgeColor', [0,0,0]) 
hold on
%% highest voltage change (higher stress due to higher tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 0.2*psz, print_normalized(:), 'filled', 'o', 'MarkerEdgeColor', [0,0,0])
hold on
plot(read_point(1),read_point(2),'rx') % web senter

title('velocity - Normalized by min value and distance to centre')
ylabel('Experiments - Mean max abs voltage drop')
set( gca , 'fontsize' , 15 )
colorbar
axis equal
pause(1)

figure
plot( sim_front_time_norm_vec(:)+min(sim_front_time_norm_vec(:)) , print_normalized(:) , '*' )
axis([0,1,0,1])
xlabel('Simulations - velocity - Normalized by min value and distance to centre'); ylabel('Experiments - Mean max abs voltage drop')
lsline
axis equal
R2 = corrcoef(sim_front_time_norm_vec(:)+min(sim_front_time_norm_vec(:)) , print_normalized(:)) % Pearson correlation coefficient (PCC)


%% plots velocity time data
open('bioWeb001.fig')
view([0,0,1])
hold on
psz = 300 ;
%% fast wave (high tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 1.5*psz, sim_front_time_norm_vec(:), 'filled', 's', 'MarkerEdgeColor', [0,0,0]) 
hold on
%% highest voltage change (higher stress due to higher tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 0.2*psz, 1-print_normalized(:)+min(print_normalized(:)), 'filled', 'o', 'MarkerEdgeColor', [0,0,0])
hold on
plot(read_point(1),read_point(2),'rx') % web senter

title('inv velocity - Normalized by min value and distance to centre')
ylabel('Experiments - normalize and scaled increased resistance')
set( gca , 'fontsize' , 15 )
colorbar
axis equal
pause(1)

figure
plot( sim_front_time_norm_vec(:) , 1-print_normalized(:)+min(print_normalized(:)) , '*' )
axis([0,1,0,1])
xlabel('Simulations - inv velocity - Normalized by min value and distance to centre');
ylabel('Experiments - normalize and scaled increased resistance')
lsline
axis equal
R3 = corrcoef(sim_front_time_norm_vec(:) , 1-print_normalized(:)+min(print_normalized(:))) % Pearson correlation coefficient (PCC)


%% plots mean_max_abs displacements time data
open('bioWeb001.fig')
view([0,0,1])
hold on
psz = 300 ;
%% fast wave (high tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 1.5*psz, sim_mean_max_abs_vec(:), 'filled', 's', 'MarkerEdgeColor', [0,0,0]) 
hold on
%% highest voltage change (higher stress due to higher tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 0.2*psz, print_normalized(:), 'filled', 'o', 'MarkerEdgeColor', [0,0,0])
hold on
plot(read_point(1),read_point(2),'rx') % web senter

title('Mean-max-abs displacement - Normalized by min value')
ylabel('Experiments - Mean max abs voltage drop')
set( gca , 'fontsize' , 15 )
colorbar
axis equal
pause(1)

figure
plot( sim_mean_max_abs_vec(:) , print_normalized(:) , '*' )
axis([0,1,0,1])
xlabel('Simulations - Mean max abs displacement'); ylabel('Experiments - Mean max abs voltage drop')
lsline
axis equal
R4 = corrcoef(sim_mean_max_abs_vec(:) , print_normalized(:)) % Pearson correlation coefficient (PCC)


%% plots velocity time data
open('bioWeb001.fig')
view([0,0,1])
hold on
psz = 300 ;
%% fast wave (high tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 1.5*psz, sim_vel_norm_vec(:), 'filled', 's', 'MarkerEdgeColor', [0,0,0]) 
hold on
%% highest voltage change (higher stress due to higher tension or stiffer path): 1
scatter(poke_xy_vec(:,1), poke_xy_vec(:,2), 0.2*psz, print_normalized(:), 'filled', 'o', 'MarkerEdgeColor', [0,0,0])
hold on
plot(read_point(1),read_point(2),'rx') % web senter

title('velocity - Normalized by min value and distance to centre')
ylabel('Experiments - normalize and scaled increased voltage (reduced resistance)')
set( gca , 'fontsize' , 15 )
colorbar
axis equal
pause(1)

figure
plot( sim_vel_norm_vec(:) , print_normalized(:) , '*' )
axis([0,1,0,1])
xlabel('Simulations - velocity - Normalized by min value and distance to centre');
ylabel('Experiments - normalize and scaled increased voltage (reduced resistance)')
lsline
axis equal
R3 = corrcoef(sim_vel_norm_vec(:) , print_normalized(:)) % Pearson correlation coefficient (PCC)
% R3 = corrcoef(sim_vel_norm_vec([1:14 16:end]) , print_normalized([1:14 16:end])) % Pearson correlation coefficient (PCC)

