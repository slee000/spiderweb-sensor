close all
clear all
clc

%% fritz_web_analysis.m results 2023
% excitation index is used
% web 1 with Shiv's points & excitation amp 7mm: 1830 lines, 50 damages with excite/read location
accuracy_img001 = [ ... % from 5 trials, index disturbation
    6.8421e-01   8.4211e-01   8.4211e-01;
    6.3158e-01   8.9474e-01   8.4211e-01;
    6.8421e-01   8.9474e-01   7.3684e-01;
    8.4211e-01   9.4737e-01   9.4737e-01;
    6.8421e-01   8.4211e-01   7.3684e-01] ; 
% accuracy_img001 = [ ... % from 5 trials, location disturbation
%     7.3684e-01   9.4737e-01   8.9474e-01;
%     4.2105e-01   8.4211e-01   7.8947e-01;
%     4.2105e-01   7.8947e-01   8.9474e-01;
%     6.3158e-01   9.4737e-01   8.4211e-01;
%     3.6842e-01   9.4737e-01   7.3684e-01];
mean_accuracy_img001 = mean( accuracy_img001 ) ;

% web 2 with Shiv's points & excitation amp 7mm: 2013 lines, 50 damages with excite/read location
accuracy_img002 = [ ... % from 5 trials, index disturbation
    6.3158e-01   8.4211e-01   8.4211e-01;
    6.8421e-01   8.9474e-01   8.9474e-01;
    7.8947e-01   8.9474e-01   1.0000e+00;
    7.3684e-01   1.0000e+00   7.3684e-01;
    6.8421e-01   1.0000e+00   8.4211e-01 ] ;
% accuracy_img002 = [ ... % from 5 trials, location disturbation
%     6.3158e-01   8.9474e-01   8.4211e-01;
%     4.7368e-01   9.4737e-01   8.9474e-01;
%     4.7368e-01   9.4737e-01   7.3684e-01;
%     5.2632e-01   7.8947e-01   9.4737e-01;
%     4.7368e-01   9.4737e-01   8.9474e-01];
mean_accuracy_img002 = mean( accuracy_img002 )

% plots
fig1_1 = figure ;
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;

subplot(2,4,3);
bar(1:3 , mean_accuracy_img001); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy_img001, mean_accuracy_img001 - min( accuracy_img001 ), max( accuracy_img001 ) - mean_accuracy_img001 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('bio web img001 - shiv points 2023 - amp 7mm')

subplot(2,4,4);
bar(1:3 , mean_accuracy_img002); hold on
set(gca,'xticklabel',x_names)
er2 = errorbar(1:3, mean_accuracy_img002, mean_accuracy_img002 - min( accuracy_img002 ), max( accuracy_img002 ) - mean_accuracy_img002 );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
ylim([0,1])
title('bio web img002 - shiv points 2023 - amp 7mm')


%% fritz_web_analysis.m results 2025
% excitation index is used
% web 1 with Shiv's points & excitation amp 7mm: 1830 lines, 50 damages with excite/read location
accuracy_img001 = [ ... % from 5 trials, index disturbation
    7.8947e-01   9.4737e-01   9.4737e-01;
    7.3684e-01   8.4211e-01   9.4737e-01;
    7.8947e-01   9.4737e-01   8.4211e-01;
    7.8947e-01   8.4211e-01   8.4211e-01;
    6.8421e-01   8.9474e-01   6.3158e-01] ; 
mean_accuracy_img001 = mean( accuracy_img001 )

% web 2 with Shiv's points & excitation amp 7mm: 2013 lines, 50 damages with excite/read location
accuracy_img002 = [ ... % from 5 trials, index disturbation
     7.3684e-01   8.9474e-01   8.4211e-01;
     7.8947e-01   1.0000e+00   7.3684e-01;
     5.7895e-01   6.8421e-01   1.0000e+00;
     7.3684e-01   8.9474e-01   7.3684e-01;
     5.7895e-01   1.0000e+00   8.9474e-01] ;
mean_accuracy_img002 = mean( accuracy_img002 )

% plots
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;

subplot(2,4,7);
bar(1:3 , mean_accuracy_img001); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy_img001, mean_accuracy_img001 - min( accuracy_img001 ), max( accuracy_img001 ) - mean_accuracy_img001 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('bio web img001 - shiv points 2025 - amp 7mm')

subplot(2,4,8);
bar(1:3 , mean_accuracy_img002); hold on
set(gca,'xticklabel',x_names)
er2 = errorbar(1:3, mean_accuracy_img002, mean_accuracy_img002 - min( accuracy_img002 ), max( accuracy_img002 ) - mean_accuracy_img002 );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
ylim([0,1])
title('bio web img002 - shiv points 2025 - amp 7mm')


%% web_optimization_sensitivity analysis results
%% Shiv's no-feature polarweb 2023 & excitation amp 7mm: 367 lines, 50*367/1830 damaged (same ratio as Fritz's img00 bio webs), with excite/read indices
accuracy_polarsym = [ ... % from 5 trials, purturbed index
    8.9474e-01   8.4211e-01   7.8947e-01;
    7.8947e-01   1.0000e+00   7.8947e-01;
    6.8421e-01   8.4211e-01   8.9474e-01;
    7.3684e-01   9.4737e-01   8.9474e-01;
    7.8947e-01   9.4737e-01   9.4737e-01] ;
% accuracy_polarsym = [ ... % from 5 trials, purturbed location
%     7.8947e-01   9.4737e-01   1.0000e+00;
%     8.4211e-01   7.8947e-01   8.9474e-01;
%     7.3684e-01   9.4737e-01   8.4211e-01;
%     7.3684e-01   8.9474e-01   8.4211e-01;
%     7.3684e-01   9.4737e-01   9.4737e-01];
mean_accuracy_polarsym = mean( accuracy_polarsym )

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(2,4,1);
bar(1:3 , mean_accuracy_polarsym); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy_polarsym, mean_accuracy_polarsym - min( accuracy_polarsym ), max( accuracy_polarsym ) - mean_accuracy_polarsym );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('Shiv no feature polar web 2023 - amp 7mm')


%% Fritz's img001 symmetric with Shiv's points 2023 & excitation amp 7mm: 1593 lines, 50 damaged, with excite/read location
% baseline
accuracy0 = [ ... % disturbed index
    7.0588e-01   7.0588e-01   6.4706e-01;
    8.8235e-01   7.6471e-01   9.4118e-01;
    7.6471e-01   9.4118e-01   7.0588e-01;
    7.6471e-01   8.8235e-01   6.4706e-01;
    7.0588e-01   8.8235e-01   7.0588e-01];
% accuracy0 = [ ... % disturbed location
%     5.8824e-01   8.2353e-01   5.8824e-01;
%     7.6471e-01   7.6471e-01   5.8824e-01;
%     9.4118e-01   9.4118e-01   7.6471e-01;
%     7.0588e-01   8.8235e-01   7.0588e-01;
%     6.4706e-01   7.0588e-01   6.4706e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(2,4,2);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('sym bio web with feature - shiv points 2023 - amp 7mm')


%% Fritz's img001 symmetric with Shiv's points 2025 & excitation amp 7mm: 1593 lines, 50 damaged, with excite/read location
% baseline
accuracy0 = [ ... % disturbed index
    7.6471e-01   8.2353e-01   6.4706e-01;
    7.6471e-01   8.8235e-01   5.2941e-01;
    9.4118e-01   9.4118e-01   6.4706e-01;
    7.0588e-01   1.0000e+00   8.8235e-01;
    5.8824e-01   1.0000e+00   7.0588e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(2,4,6);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('sym bio web with feature - shiv points 2025 - amp 7mm')


%% fritz_web_analysis.m results
% % excitation index is used
% % web 1 with Sudong's 24 points & excitation amp 1mm: 1830 lines, 50 damages with excite/read location
% accuracy_img001 = [ ... % from 5 trials, index disturbation
%     ] ; 
% mean_accuracy_img001 = mean( accuracy_img001 )
% 
% % web 2 with Sudong's 24 points & excitation amp 1mm: 2013 lines, 50 damages with excite/read location
% accuracy_img002 = [ ... % from 5 trials, index disturbation
%     5.0000e-01   4.1667e-01   4.5833e-01;
%     5.0000e-01   5.0000e-01   4.5833e-01;
%     2.9167e-01   4.5833e-01   4.1667e-01;
%     4.1667e-01   4.1667e-01   3.3333e-01;
%     3.3333e-01   3.7500e-01   3.3333e-01] ;
% mean_accuracy_img002 = mean( accuracy_img002 )
% 
% % web 1 with Sudong's 24 points & excitation amp 7mm: 1830 lines, 50 damages with excite/read location
% accuracy_img001 = [ ... % from 5 trials, index disturbation
%     6.2500e-01   5.4167e-01   3.7500e-01;
%     5.0000e-01   6.6667e-01   4.5833e-01;
%     3.3333e-01   7.9167e-01   6.6667e-01;
%     5.4167e-01   5.0000e-01   6.6667e-01;
%     5.0000e-01   5.8333e-01   4.5833e-01] ;
% mean_accuracy_img001 = mean( accuracy_img001 )
% 
% % web 2 with Sudong's 24 points & excitation amp 7mm: 2013 lines, 50 damages with excite/read location
% accuracy_img002 = [ ... % from 5 trials, index disturbation
%     3.7500e-01   7.5000e-01   7.0833e-01;
%     4.1667e-01   7.9167e-01   6.2500e-01;
%     5.4167e-01   7.0833e-01   7.5000e-01;
%     4.1667e-01   8.3333e-01   6.2500e-01;
%     4.1667e-01   6.6667e-01   6.6667e-01] ;
% mean_accuracy_img002 = mean( accuracy_img002 )

% excitation index is used
% web 1 with Sudong's 17 points (1st row with 24 points, 2nd & 3rd row with 17 points) & excitation amp 7mm: 1830 lines, 50 damages with excite/read location
accuracy_img001 = [ ... % from 5 trials, index disturbation
    6.4706e-01   8.8235e-01   5.8824e-01;
    6.4706e-01   7.0588e-01   5.2941e-01;
    7.0588e-01   7.0588e-01   7.6471e-01;
    7.6471e-01   7.6471e-01   1.0000e+00;
    5.8824e-01   6.4706e-01   7.0588e-01] ; 
mean_accuracy_img001 = mean( accuracy_img001 )

% web 2 with Sudong's 17 points & excitation amp 7mm: 2013 lines, 50 damages with excite/read location
accuracy_img002 = [ ... % from 5 trials, index disturbation
    5.8824e-01   7.0588e-01   7.6471e-01;
    6.4706e-01   7.6471e-01   7.0588e-01;
    7.6471e-01   7.6471e-01   5.2941e-01;
    6.4706e-01   6.4706e-01   5.8824e-01;
    6.4706e-01   6.4706e-01   4.1176e-01] ;
mean_accuracy_img002 = mean( accuracy_img002 )

% plots
fig1_2 = figure ;
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;

subplot(4,4,3);
bar(1:3 , mean_accuracy_img001); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy_img001, mean_accuracy_img001 - min( accuracy_img001 ), max( accuracy_img001 ) - mean_accuracy_img001 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
% title('bio web img001 - sudong points - amp 1mm')
title('bio web img001 - sudong points - amp 7mm')

subplot(4,4,4);
bar(1:3 , mean_accuracy_img002); hold on
set(gca,'xticklabel',x_names)
er2 = errorbar(1:3, mean_accuracy_img002, mean_accuracy_img002 - min( accuracy_img002 ), max( accuracy_img002 ) - mean_accuracy_img002 );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
ylim([0,1])
% title('bio web img002 - sudong points - amp 1mm')
title('bio web img002 - sudong points - amp 7mm')

% collect data for paper
accuracy_baseBioDist(:,4) = accuracy_img001(:,1) ;
accuracy_baseBioDamage(:,7:8) = accuracy_img001(:,2:3) ;
accuracy_baseBioDist(:,5) = accuracy_img002(:,1) ;
accuracy_baseBioDamage(:,9:10) = accuracy_img002(:,2:3) ;


%% Fritz's img001 symmetric with Sudong's 24 points & excitation amp 1mm: 1593 lines, 50 damaged, with excite/read location
% % baseline
% accuracy0 = [ ... % POSSIBLY WRONG READOUT POINTS
%     2.9167e-01   2.5000e-01   2.0833e-01;
%     2.5000e-01   2.5000e-01   1.6667e-01;
%     2.9167e-01   2.0833e-01   1.6667e-01;
%     1.6667e-01   2.0833e-01   2.5000e-01;
%     3.7500e-01   4.1667e-01   2.0833e-01];
% mean_accuracy0 = mean( accuracy0 )

% Fritz's img001 symmetric with Sudong's 17 points & excitation amp 7mm: 1593 lines, 50 damaged, with excite/read location
% % baseline
% accuracy0 = [ ... % POSSIBLY WRONG READOUT POINTS
%     5.8824e-01   8.8235e-01   4.7059e-01;
%     9.4118e-01   8.8235e-01   5.8824e-01;
%     5.8824e-01   8.8235e-01   5.2941e-01;
%     8.2353e-01   7.0588e-01   8.8235e-01;
%     3.5294e-01   6.4706e-01   6.4706e-01];
% mean_accuracy0 = mean( accuracy0 )

accuracy0 = [ ... % disturbed index
     7.058823529411765e-01     6.470588235294118e-01     6.470588235294118e-01;
     5.294117647058824e-01     5.294117647058824e-01     4.705882352941176e-01;
     4.705882352941176e-01     5.294117647058824e-01     4.117647058823529e-01;
     6.470588235294118e-01     7.058823529411765e-01     4.117647058823529e-01;
     7.058823529411765e-01     5.882352941176471e-01     5.882352941176471e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,2);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
% title('sym bio web - sudong points - amp 1mm')
title('sym bio web - sudong points - amp 7mm')

% collect data for paper
accuracy_baseBioDist(:,3) = accuracy0(:,1) ;
accuracy_baseBioDamage(:,5:6) = accuracy0(:,2:3) ;


%% Sudong's grid 24-point & excitation amp 1mm: 1624 lines, 51 damaged (same ratio as Fritz's symmetric img00 bio web)
% % baseline
% accuracy0 = [ ... % disturbed index
%     5.0000e-01   7.9167e-01   5.4167e-01;
%     6.2500e-01   5.4167e-01   4.1667e-01;
%     4.5833e-01   5.8333e-01   3.7500e-01;
%     5.8333e-01   6.6667e-01   4.1667e-01;
%     6.6667e-01   5.4167e-01   4.5833e-01];
% mean_accuracy0 = mean( accuracy0 )

% Sudong's grid 17-point & excitation amp 7mm: 1624 lines, 51 damaged (same ratio as Fritz's symmetric img00 bio web)
accuracy0 = [ ... % disturbed index
    4.7059e-01   8.8235e-01   7.6471e-01;
    5.8824e-01   7.0588e-01   7.6471e-01;
    4.7059e-01   6.4706e-01   4.7059e-01;
    4.7059e-01   7.0588e-01   7.6471e-01;
    4.7059e-01   8.2353e-01   5.8824e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,12);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
% title('Sudong grid - amp 1mm')
title('Sudong grid - amp 7mm')

% collect data for paper
accuracy_baseBioDist(:,1) = accuracy0(:,1) ;
accuracy_baseBioDamage(:,1:2) = accuracy0(:,2:3) ;


%% Sudong's polar 24-point & excitation amp 1mm: 1464 lines, 46 damaged (same ratio as Fritz's symmetric img00 bio web)
% % baseline
% accuracy0 = [ ... % disturbed index
%     4.1667e-01   2.5000e-01   1.6667e-01;
%     4.5833e-01   3.3333e-01   1.6667e-01;
%     3.3333e-01   3.3333e-01   2.0833e-01;
%     1.6667e-01   1.2500e-01   8.3333e-02;
%     2.9167e-01   2.5000e-01   2.5000e-01];
%     % 1.6667e-01   3.7500e-01   2.0833e-01;
%     % 4.1667e-01   3.3333e-01   1.6667e-01];
% mean_accuracy0 = mean( accuracy0 )

% Sudong's polar 17-point & excitation amp 7mm: 1464 lines, 46 damaged (same ratio as Fritz's symmetric img00 bio web)
accuracy0 = [ ... % disturbed index
    7.6471e-01   4.1176e-01   3.5294e-01;
    4.7059e-01   4.1176e-01   3.5294e-01
    4.1176e-01   5.8824e-01   2.9412e-01;
    6.4706e-01   4.7059e-01   4.7059e-01;
    5.2941e-01   4.1176e-01   4.1176e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,9);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
% title('Sudong no feature polar - amp 1mm')
title('Sudong no feature polar - amp 7mm')

% collect data for paper
accuracy_baseBioDist(:,2) = accuracy0(:,1) ;
accuracy_baseBioDamage(:,3:4) = accuracy0(:,2:3) ;


%% Opt symmetric without feature (from Fritz's img001) & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % disturbed index
     6.250000000000000e-01     8.750000000000000e-01     5.000000000000000e-01
     7.500000000000000e-01     6.250000000000000e-01     7.500000000000000e-01
     7.500000000000000e-01     6.250000000000000e-01     8.750000000000000e-01
     7.500000000000000e-01     6.250000000000000e-01     6.250000000000000e-01
     5.000000000000000e-01     8.750000000000000e-01     7.500000000000000e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,13);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('sym bio no-feature opt web - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,1) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,1:2) = accuracy0(:,2:3) ;


%% Opt without feature 5 DoF & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % disturbed index
     8.750000000000000e-01     6.250000000000000e-01     6.250000000000000e-01
     1.000000000000000e+00     7.500000000000000e-01     6.250000000000000e-01
     7.500000000000000e-01     6.250000000000000e-01     5.000000000000000e-01
     1.000000000000000e+00     7.500000000000000e-01     5.000000000000000e-01
     1.000000000000000e+00     8.750000000000000e-01     6.250000000000000e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,15);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('opt no-feature 5 DoF web - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,2) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,3:4) = accuracy0(:,2:3) ;


%% Opt without feature 9 DoF & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % disturbed index, 1st run
     7.500000000000000e-01     7.500000000000000e-01     7.500000000000000e-01
     8.750000000000000e-01     8.750000000000000e-01     8.750000000000000e-01
     8.750000000000000e-01     6.250000000000000e-01     3.750000000000000e-01
     7.500000000000000e-01     1.000000000000000e+00     7.500000000000000e-01
     1.000000000000000e+00     5.000000000000000e-01     3.750000000000000e-01];
% accuracy0 = [ ... % disturbed index, 2nd run
%      7.500000000000000e-01     7.500000000000000e-01     2.500000000000000e-01
%      8.750000000000000e-01     6.250000000000000e-01     5.000000000000000e-01
%      7.500000000000000e-01     7.500000000000000e-01     7.500000000000000e-01
%      8.750000000000000e-01     5.000000000000000e-01     6.250000000000000e-01
%      8.750000000000000e-01     8.750000000000000e-01     8.750000000000000e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,16);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('opt no-feature 9 DoF web - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,3) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,5:6) = accuracy0(:,2:3) ;


%% Opt symmetric with feature (from Fritz's img001) & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % opt. nodes
     8.750000000000000e-01     8.750000000000000e-01     6.250000000000000e-01;
     7.500000000000000e-01     7.500000000000000e-01     3.750000000000000e-01;
     5.000000000000000e-01     8.750000000000000e-01     3.750000000000000e-01;
     6.250000000000000e-01     7.500000000000000e-01     3.750000000000000e-01;
     6.250000000000000e-01     7.500000000000000e-01     1.000000000000000e+00];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,6);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('sym opt web with feature - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,4) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,7:8) = accuracy0(:,2:3) ;


%% Opt with feature 5 DoF & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % disturbed index
     8.750000000000000e-01     8.750000000000000e-01     7.500000000000000e-01
     7.500000000000000e-01     8.750000000000000e-01     5.000000000000000e-01
     7.500000000000000e-01     6.250000000000000e-01     5.000000000000000e-01
     7.500000000000000e-01     8.750000000000000e-01     6.250000000000000e-01
     6.250000000000000e-01     5.000000000000000e-01     7.500000000000000e-01];
mean_accuracy0 = mean( accuracy0 )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,7);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('opt 5 DoF web - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,5) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,9:10) = accuracy0(:,2:3) ;


%% Opt with feature 9 DoF & excitation amp 1mm: 1593 lines, 50 damaged
% baseline
accuracy0 = [ ... % opt. nodes
     1.000000000000000e+00     6.250000000000000e-01     3.750000000000000e-01
     7.500000000000000e-01     1.000000000000000e+00     6.250000000000000e-01
     8.750000000000000e-01     8.750000000000000e-01     1.000000000000000e+00
     1.000000000000000e+00     1.000000000000000e+00     6.250000000000000e-01
     7.500000000000000e-01     8.750000000000000e-01     7.500000000000000e-01];
mean_accuracy0 = mean( accuracy0 )

accuracy_sudong_damage = [ ... % sudong 17-point damage nodes and 7mm amp
     7.647058823529411e-01     7.058823529411765e-01     5.294117647058824e-01;
     7.058823529411765e-01     7.058823529411765e-01     8.235294117647058e-01;
     6.470588235294118e-01     7.058823529411765e-01     7.647058823529411e-01;
     6.470588235294118e-01     7.058823529411765e-01     6.470588235294118e-01;
     8.823529411764706e-01     8.235294117647058e-01     5.294117647058824e-01];
mean_accuracy_sudong_damage = mean( accuracy_sudong_damage )

acc_all = [] ;
acc_all = [ acc_all ; 0 , mean_accuracy0(2) , min( accuracy0(:,2) ) , max( accuracy0(:,2) ) , 0 ] ; % [ variation, mean, min, max, mean_difference ]

% plotting
x_names = {'disturbed exitation', 'L1 damage', 'L2 damage'} ;
subplot(4,4,8);
bar(1:3 , mean_accuracy0); hold on
set(gca,'xticklabel',x_names)
er1 = errorbar(1:3, mean_accuracy0, mean_accuracy0 - min( accuracy0 ), max( accuracy0 ) - mean_accuracy0 );
er1.Color = [0 0 0];
er1.LineStyle = 'none';
ylim([0,1])
title('opt 9 DoF web - opt points - amp 1mm')

% collect data for paper
accuracy_baseOptDist(:,6) = accuracy0(:,1) ;
accuracy_baseOptDamage(:,11:12) = accuracy0(:,2:3) ;
accuracy_baseBioDist(:,6) = accuracy_sudong_damage(:,1) ;
accuracy_baseBioDamage(:,11:12) = accuracy_sudong_damage(:,2:3) ;


%% collect web analysis
% base-bio web damage plot with Sudong's points
fig1_3 = figure();
subplot(2,2,1);
x_names = {'Grid Web','','Polar Web','','Sym. Spider Web 1','','Spider Web 1','','Spider Web 2','','Opt 9DoF full-feature',''} ;
mean_accuracy_baseBioDamage = mean( accuracy_baseBioDamage );
bar1 = bar(1:12 , mean_accuracy_baseBioDamage); hold on
bar1.FaceColor = 'flat';
bar1.CData(1,:) = [0.7 0.7 1]; bar1.CData(2,:) = [0.5 0.5 0.7];
bar1.CData(3,:) = [0 1 0]; bar1.CData(4,:) = [0 0.7 0];
bar1.CData(5,:) = [0 1 1]; bar1.CData(6,:) = [0 0.7 0.7];
bar1.CData(7,:) = [1 0.5 0]; bar1.CData(8,:) = [0.7 0.3 0];
bar1.CData(9,:) = [1 1 0]; bar1.CData(10,:) = [0.7 0.7 0];
bar1.CData(11,:) = [1 0 0]; bar1.CData(12,:) = [0.7 0 0];
% mean_organized = [];
% for i = 1:5
%     mean_organized = [ mean_organized; mean_accuracy_baseBioDamage(2*i-1:2*i) ];
% end
% bar1 = bar(1:5 , mean_organized); hold on
set(gca,'xticklabel',x_names)
ylabel('% Accuracy')
er2 = errorbar(1:12, mean_accuracy_baseBioDamage, mean_accuracy_baseBioDamage - min( accuracy_baseBioDamage ), max( accuracy_baseBioDamage ) - mean_accuracy_baseBioDamage );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
% min_err_organized = [];
% max_err_organized = [];
% for i = 1:5
%     min_err_organized = [ min_err_organized; mean_accuracy_baseBioDamage(2*i-1:2*i) - min( accuracy_baseBioDamage(2*i-1:2*i) ) ];
%     max_err_organized = [ max_err_organized; max( accuracy_baseBioDamage(2*i-1:2*i) ) - mean_accuracy_baseBioDamage(2*i-1:2*i) ];
% end
% er2 = errorbar(1:5, mean_organized, min_err_organized, max_err_organized );
% er2(1).Color = [0 0 0]; er2(2).Color = [0 0 0];
% er2(1).LineStyle = 'none'; er2(2).LineStyle = 'none';
ylim([0,1.1])
% title('Damage resiliance (without noise) - 24-point task - amp 1mm')
title('Damage resiliance (without noise) - 17-point task - amp 7mm')
fontsize(gca, 12, "points")
clear bar1

% base-bio web disturbance plot with Sudong's points
subplot(2,2,2);
mean_accuracy_baseBioDist = mean( accuracy_baseBioDist ) ;
x_names = {'Grid Web','Polar Web','Sym. Spider Web 1','Spider Web 1','Spider Web 2','Opt 9DoF full-feature'} ;
bar1 = bar(1:6 , mean_accuracy_baseBioDist); hold on
bar1.FaceColor = 'flat';
bar1.CData(1,:) = [0.7 0.7 1];
bar1.CData(2,:) = [0 1 0];
bar1.CData(3,:) = [0 1 1];
bar1.CData(4,:) = [1 0.5 0];
bar1.CData(5,:) = [1 1 0];
bar1.CData(6,:) = [1 0 0];
set(gca,'xticklabel',x_names)
ylabel('% Accuracy')
er2 = errorbar(1:6, mean_accuracy_baseBioDist, mean_accuracy_baseBioDist - min( accuracy_baseBioDist ), max( accuracy_baseBioDist ) - mean_accuracy_baseBioDist );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
ylim([0,1.1])
% title('Disturbance (noise) resiliance - 24-point task - amp 1mm')
title('Disturbance (noise) resiliance - 17-point task - amp 1mm')
fontsize(gca, 12, "points")
clear bar1

% base-opt web damage plot with opt points
subplot(2,2,3);
mean_accuracy_baseOptDamage = mean( accuracy_baseOptDamage ) ;
x_names = {'Sym. Feature-less Web','','Feature-less Opt. (5DoF)','','Feature-less Opt. (9DoF)','','Sym. Spider Web 1','','Sym. Spider Opt. (5DoF)','','Sym. Spider Opt. (9DoF)',''} ;
bar1 = bar(1:12 , mean_accuracy_baseOptDamage); hold on
bar1.FaceColor = 'flat';
bar1.CData(1,:) = [0 1 0]; bar1.CData(2,:) = [0 0.7 0];
bar1.CData(3,:) = [1 0.5 0]; bar1.CData(4,:) = [0.7 0.3 0];
bar1.CData(5,:) = [1 1 0]; bar1.CData(6,:) = [0.7 0.7 0];
bar1.CData(7,:) = [0 1 1]; bar1.CData(8,:) = [0 0.7 0.7];
bar1.CData(9,:) = [0.7 0.7 1]; bar1.CData(10,:) = [0.5 0.5 0.7];
bar1.CData(11,:) = [0.7 0.7 0.7]; bar1.CData(12,:) = [0.5 0.5 0.5];
% mean_organized = [];
% for i = 1:6
%     mean_organized = [ mean_organized; mean_accuracy_baseOptDamage(2*i-1:2*i) ];
% end
% bar1 = bar(1:6 , mean_organized); hold on
set(gca,'xticklabel',x_names)
ylabel('% Accuracy')
er2 = errorbar(1:12, mean_accuracy_baseOptDamage, mean_accuracy_baseOptDamage - min( accuracy_baseOptDamage ), max( accuracy_baseOptDamage ) - mean_accuracy_baseOptDamage );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
% min_err_organized = [];
% max_err_organized = [];
% for i = 1:6
%     min_err_organized = [ min_err_organized; mean_accuracy_baseOptDamage(2*i-1:2*i) - min( accuracy_baseBioDamage ) ];
%     max_err_organized = [ max_err_organized; max( accuracy_baseBioDamage ) - mean_accuracy_baseOptDamage(2*i-1:2*i) ];
% end
% er2 = errorbar(1:6, mean_accuracy_baseOptDamage, min_err_organized, max_err_organized );
ylim([0,1.1])
title('Damage resiliance (without noise) - 8-point opt. task - amp 1mm')
fontsize(gca, 12, "points")
clear bar1

% base-opt web disturbance plot with opt points
subplot(2,2,4);
mean_accuracy_baseOptDist = mean( accuracy_baseOptDist ) ;
x_names = {'Sym. Feature-less Web','Feature-less Opt. (5DoF)','Feature-less Opt. (9DoF)','Sym. Spider Web 1','Sym. Spider Opt. (5DoF)','Sym. Spider Opt. (9DoF)'} ;
bar1 = bar(1:6 , mean_accuracy_baseOptDist); hold on
bar1.FaceColor = 'flat';
bar1.CData(1,:) = [0 1 0];
bar1.CData(2,:) = [1 0.5 0];
bar1.CData(3,:) = [1 1 0];
bar1.CData(4,:) = [0 1 1];
bar1.CData(5,:) = [0.7 0.7 1];
bar1.CData(6,:) = [0.7 0.7 0.7];
set(gca,'xticklabel',x_names)
ylabel('% Accuracy')
er2 = errorbar(1:6, mean_accuracy_baseOptDist, mean_accuracy_baseOptDist - min( accuracy_baseOptDist ), max( accuracy_baseOptDist ) - mean_accuracy_baseOptDist );
er2.Color = [0 0 0];
er2.LineStyle = 'none';
ylim([0,1.1])
title('Disturbance (noise) resiliance - 8-point opt. task - amp 1mm')
fontsize(gca, 12, "points")
clear bar1


%% sensitivity analysis with Shiv's excitation points and excitation amp 7mm
%% opt_par.r_frame = 0.85 + 0.05
accuracy = [...
    7.6471e-01;
    7.0588e-01;
    8.2353e-01;
    8.2353e-01;
    8.2353e-01]
mean_accuracy = 7.8824e-01
   
variation = 0.05/0.85*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.r_frame = 0.85 - 0.05
accuracy = [ ...
   7.0588e-01;
   7.0588e-01;
   9.4118e-01;
   8.2353e-01;
   7.6471e-01]
mean_accuracy = 7.8824e-01
acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
r_plot = [] ;
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;
polar_color = [] ;
polar_red = [1 0 0]; % ascending /
polar_magenta = [1 0 1]; % local min \/
polar_blue = [0 0 1]; % local max /\
polar_green = [0 1 0]; % descending \
polar_gray = [0.7 0.7 0.7]; % undetermined -

fig2 = figure ;
subplot(3,6,1)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta r_f') ; ylabel('%\Delta Accuracy') ; fontsize(gca, 12, "points")

% polar plot & record
fig3 = figure ;
polarplot( [ linspace(0,2*pi,100) ] , zeros(1,100) , ':', 'Color', [0,0,0] , 'linewidth' , 0.1 )
hold on
dtheta = 2 * pi / 17 ;
theta = 0 ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.noise_rad = 0.1 * ones(1,opt_par.n_rad) ;
accuracy = [ ...
   8.2353e-01;
   7.0588e-01;
   5.2941e-01;
   5.2941e-01;
   6.4706e-01]
mean_accuracy = 6.4706e-01
    

variation = 0.1/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,16)
x_plot = [ acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , [ acc_all(1,3) , acc_all(end,3) ] - y_plot , y_plot - [ acc_all(1,4) , acc_all(end,4) ] );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta\theta_r') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , ( acc_all(end,5) ) ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-(acc_all(end,2)-acc_all(end,3)) , r_plot(end)+(acc_all(end,4)-acc_all(end,2)) ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
% polar_color = [ polar_color ; polar_gray ] ;
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.noise_mooring = 0.1 * ones(1,opt_par.n_moor) ;
accuracy = [ ... 
   8.8235e-01;
   7.6471e-01;
   8.2353e-01;
   6.4706e-01;
   7.6471e-01]
mean_accuracy = 7.7647e-01

variation = 0.1/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,17)
x_plot = [ acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , [ acc_all(1,3) , acc_all(end,3) ] - y_plot , y_plot - [ acc_all(1,4) , acc_all(end,4) ] );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta\theta_m') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , ( acc_all(end,5) ) ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-(acc_all(end,2)-acc_all(end,3)) , r_plot(end)+(acc_all(end,4)-acc_all(end,2)) ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
% polar_color = [ polar_color ; polar_gray ] ;
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.distort_frame = [ [1+0.2; 1] ,[1; 1] ] ;
accuracy = [ ...
   8.2353e-01;
   9.4118e-01;
   8.2353e-01;
   7.6471e-01;
   9.4118e-01]
mean_accuracy = 8.5882e-01

variation = 0.2/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.distort_frame = [ [1-0.2; 1] ,[1; 1] ] ;
accuracy = [ ...
   7.0588e-01;
   9.4118e-01;
   8.2353e-01;
   9.4118e-01;
   8.8235e-01]
mean_accuracy = 8.5882e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,2)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta x^-') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.distort_frame = [ [1; 1+0.2] ,[1; 1] ] ;
accuracy = [ ...
   8.8235e-01;
   8.2353e-01;
   8.8235e-01;
   9.4118e-01;
   7.6471e-01]
mean_accuracy = 8.5882e-01

variation = 0.2/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.distort_frame = [ [1; 1-0.2] ,[1; 1] ] ;
accuracy = [ ...    
   7.6471e-01;
   8.2353e-01;
   8.8235e-01;
   9.4118e-01;
   7.0588e-01]
mean_accuracy = 8.2353e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,3)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta x^+') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.distort_frame = [ [1; 1] ,[1+0.2; 1] ] ;
accuracy = [ ...
   7.6471e-01;
   7.0588e-01;
   8.8235e-01;
   7.6471e-01;
   7.6471e-01]
mean_accuracy = 7.7647e-01

variation = 0.2/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.distort_frame = [ [1; 1] ,[1-0.2; 1] ] ;
accuracy = [ ...
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   9.4118e-01;
   9.4118e-01]
mean_accuracy = 9.0588e-01
acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,4)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta y^-') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.distort_frame = [ [1; 1] ,[1; 1+0.2] ] ;
accuracy = [ ...
   7.6471e-01;
   7.0588e-01;
   8.8235e-01;
   9.4118e-01;
   8.2353e-01]
mean_accuracy = 8.2353e-01

variation = 0.2/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.distort_frame = [ [1; 1] ,[1; 1-0.2] ] ;
accuracy = [ ...
   9.4118e-01;
   8.2353e-01;
   8.2353e-01;
   7.6471e-01;
   8.2353e-01]
mean_accuracy = 8.3529e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,5)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta \delta y^+') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.xy_center = [0+0.05; 0] ;
accuracy = [ ...
   7.0588e-01;
   8.2353e-01;
   8.8235e-01;
   9.4118e-01;
   8.2353e-01]
mean_accuracy = 8.3529e-01

variation = 0.05/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.xy_center = [0-0.05; 0] ;
accuracy = [ ...
   8.8235e-01;
   7.6471e-01;
   8.2353e-01;
   7.0588e-01;
   7.0588e-01]
mean_accuracy = 7.7647e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,6)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta x_o') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.xy_center = [0; 0+0.05] ;
accuracy =[ ...
   7.0588e-01;
   8.2353e-01;
   9.4118e-01;
   9.4118e-01;
   8.2353e-01]
mean_accuracy = 8.4706e-01
    
variation = 0.05/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.xy_center = [0; 0-0.05] ;
accuracy = [ ...
   9.4118e-01;
   1.0000e+00;
   8.2353e-01;
   1.0000e+00;
   8.2353e-01]
mean_accuracy = 9.1765e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,7)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta y_o') ; ylabel('%\Delta Accuracy') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.n_rad = 27+1 ;
accuracy = [ ...
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   7.0588e-01;
   8.8235e-01]
mean_accuracy = 8.4706e-01

variation = 1/27*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.n_rad = 27-1 ;
accuracy = [ ...
   7.6471e-01;
   8.2353e-01;
   8.8235e-01;
   8.2353e-01;
   8.8235e-01]
mean_accuracy = 8.3529e-01
    
acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,8)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta n_r') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.n_hub = 5+1 ;
accuracy = [ ...
   8.2353e-01;
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   1.0000e+00]
mean_accuracy = 8.9412e-01

variation = 1/5*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.n_hub = 5-1 ;
accuracy = [ ...
   8.8235e-01;
   1.0000e+00;
   7.6471e-01;
   8.2353e-01;
   8.2353e-01]
mean_accuracy = 8.5882e-01
    
acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,9)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta n_h') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_red ] ;


%% opt_par.r_hub = 0.1+0.02 ;
accuracy = [ ...
   7.6471e-01;
   8.2353e-01;
   9.4118e-01;
   8.8235e-01;
   7.0588e-01]
mean_accuracy = 8.2353e-01

variation = 0.02/1*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.r_hub = 0.1-0.02 ;
accuracy = [ ...
   7.0588e-01;
   9.4118e-01;
   1.0000e+00;
   9.4118e-01;
   8.2353e-01]
mean_accuracy = 8.8235e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,10)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta r_h') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.n_cap = 23+1 ;
accuracy = [ ...
   7.6471e-01;
   7.6471e-01;
   8.2353e-01;
   8.8235e-01;
   8.2353e-01]
mean_accuracy = 8.1176e-01

variation = 1/23*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.n_cap = 23-1 ;
accuracy = [ ...
   6.4706e-01;
   8.2353e-01;
   9.4118e-01;
   8.2353e-01;
   8.8235e-01]
mean_accuracy = 8.2353e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,11)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta n_c') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_blue ] ;


%% opt_par.r0_cap = 0.2+0.05 ;
accuracy = [ ...
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   9.4118e-01]
mean_accuracy = 9.9412e-01

variation = 0.05/0.2*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.r0_cap = 0.2-0.05 ;
accuracy = [ ...
   7.0588e-01;
   8.8235e-01;
   9.4118e-01;
   9.4118e-01;
   7.0588e-01]
mean_accuracy = 8.3529e-01 

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,12)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta r_{c1}') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_red ] ;


%% opt_par.r_cap = 0.8+0.05 ;
accuracy = [ ...
   9.4118e-01;
   8.8235e-01;
   8.8235e-01;
   1.0000e+00;
   1.0000e+00]
mean_accuracy = 9.4118e-01

variation = 0.05/0.8*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.r_cap = 0.8-0.05 ;
accuracy = [ ...
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   8.8235e-01;
   8.8235e-01]
mean_accuracy = 8.8235e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,13)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta r_{c2}') ; ylabel('%\Delta Accuracy') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_magenta ] ;


%% opt_par.n_moor = 14+1 ;
accuracy = [ ...
   8.2353e-01;
   9.4118e-01;
   9.4118e-01;
   7.0588e-01;
   8.2353e-01]
mean_accuracy = 8.4706e-01

variation = 1/14*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.n_moor = 14-1 ;
accuracy = [ ...
   8.2353e-01;
   9.4118e-01;
   8.8235e-01;
   9.4118e-01;
   9.4118e-01]
mean_accuracy = 9.0588e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,14)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta n_m') ; ylabel('%\Delta Accuracy') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', [0.7 0.7 0.7], 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_green ] ;


%% opt_par.r_moor = 0.4+0.05 ;
accuracy = [ ...
   8.2353e-01;
   6.4706e-01;
   8.8235e-01;
   7.0588e-01;
   9.4118e-01]
mean_accuracy = 8.0000e-01

variation = 0.05/0.4*100 ;
acc_all = [ acc_all ; variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% opt_par.r_moor = 0.4-0.05 ;
accuracy = [ ...
   8.8235e-01;
   8.2353e-01;
   8.8235e-01;
   9.4118e-01;
   8.8235e-01]
mean_accuracy = 8.8235e-01

acc_all = [ acc_all ; -variation , mean_accuracy , min( accuracy ) , max( accuracy ) , mean_accuracy-acc_all(1,2) ] ;

% plot & record
figure(fig2) ; subplot(3,6,15)
x_plot = [ acc_all(end-1,1) , acc_all(1,1) , acc_all(end,1) ] ;
y_plot = [ acc_all(end-1,2) , acc_all(1,2) , acc_all(end,2) ] ;
dy_plot = [ acc_all(end-1,5) , acc_all(1,5) , acc_all(end,5) ] ;
plot( x_plot , dy_plot , '-ok' , 'linewidth' , 3 ) ; hold on
er1 = errorbar( x_plot , dy_plot , y_plot - [ acc_all(end-1,3) , acc_all(1,3) , acc_all(end,3) ] , [ acc_all(end-1,4) , acc_all(1,4) , acc_all(end,4) ] - y_plot );
er1.Color = polar_gray;
er1.LineStyle = '-';
xlim([min(x_plot),max(x_plot)]+0.3*max(x_plot)*[-1,1]) ;
xlabel('%\Delta r_m') ; fontsize(gca, 12, "points")

% polar plot & record
r_plot = [ r_plot , max( ( acc_all(end-1:end,5) ) )/variation*100 ] ;

figure(fig3) ;
theta = [ theta , theta(end)+dtheta ] ;
polarplot( [ theta(end) , theta(end) ] , ...
    [ r_plot(end)-max( acc_all(end-1:end,2)-acc_all(end-1:end,3) )/variation*100 , r_plot(end)+max( acc_all(end-1:end,4)-acc_all(end-1:end,2) )/variation*100 ] , 'Color', polar_gray, 'linewidth' , 3 )
hold on
polar_color = [ polar_color ; polar_green ] ;


%% polar plot
theta_thick = linspace( 0 , 360 , 18 ) ;
% theta_names = {'r_{frame}','radial angle noise','mooring angle noise','distort x-neg','distort x-pos','distort y-neg','distort y-pos','x_{center}','y_{center}','n_{radial}','n_{hub spiral}','r_{hub}','n_{capture spiral}','r_{capture_{inner}}','r_{capture_{outer}}','n_{mooring}','r_{mooring}'} ;
theta_names = {'r_f','\delta\theta_r','\delta\theta_m','\delta x^-','\delta x^+','\delta y^-','\delta y^+','x_o','y_o','n_r','n_h','r_h','n_c','r_{c1}','r_{c2}','n_m','r_m'} ;
% polarscatter( theta , r_plot , 'r' ,'filled')
polarplot( [ theta , theta(1) ] , [ r_plot , r_plot(1) ] , '-ko' , 'linewidth' , 0.5 )
hold on
polarscatter( theta , r_plot , 90 , polar_color , 'filled' )
set(gca,'thetatick',theta_thick,'thetaticklabel',theta_names)
rlim([-6,3])
fontsize(gca, 14, "points")

fig4 = figure;
polarplot( [ theta , theta(1) ] , abs( [ r_plot , r_plot(1) ] ) , ':ro' , 'linewidth' , 2 )
set(gca,'thetatick',theta_thick,'thetaticklabel',theta_names)
% rlim([-6,10])
fontsize(gca, 14, "points")


