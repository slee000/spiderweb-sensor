% ################################################################################
% Sudong Lee ( sudong.lee (at) epfl.ch )
%   CREATE Lab
%		: https://www.epfl.ch/labs/create/
%   Institute of Mechanical Engineering (IGM)
%   School of Engineering (STI)
%   EPFL
% ################################################################################
clc; clear; close all;

%%
data_ = readmatrix('/*** File Name ***/');
setCount_ = 102;
VideoMAKE = false;
plot_CHK = false;

%%
data = data_;
hz_ = 16;

abs_temp = abs(data(:,3:23));
for i = 1:size(abs_temp,1)
    X = abs_temp(i,:);
    [temp,X_ranked] = ismember(X,unique(X));
    ranking_(i,:) = X_ranked;
end

%%
oneTouch_ = 57;
colorList_turbo = turbo(21);
f = figure('Position',[50 50 550 550]);
f.Theme = 'light';
for i = 1:21
    plot( (1:1:size(ranking_,1))./hz_, ranking_(:,i), 'Color', colorList_turbo(i,:), 'LineWidth', 2.0 ); hold on;
end
i=49; j=i+1;
xlim([oneTouch_*(i-1)+1, oneTouch_*j]./hz_);
ylim([0.5 21.5]); yticks(1:5:21); yticklabels(21:-5:1);
xlabel('Time (s)'); ylabel('Ranking');
set(gca, 'FontName','Arial', 'Fontsize',20);

ranking_a = -ranking_+22;
for i = 1:setCount_
    start_ = oneTouch_*(i-1)+1;
    end_ = oneTouch_*i;
    rankingDiffSum_temp = 0;
    for j = (start_+1):(end_-1)
        rankingDiffSum_temp = rankingDiffSum_temp + sum(abs( ranking_a(j+1,:) - ranking_a(j,:) ));
    end
    rankingDiffSum_(i,1) = rankingDiffSum_temp;
end

for i = 1:setCount_
    start_ = oneTouch_*(i-1)+1;
    end_ = oneTouch_*i;
    rankingDiffSum_temp = 0;
    for j = (start_+1):(end_-1)
        for k = 1:5
            inx_temp = ranking_a(j,:)==k;
            rankingDiffSum_temp = rankingDiffSum_temp + sum(abs( ranking_a(j+1,inx_temp) - ranking_a(j,inx_temp) ));
        end
    end
    rankingDiffSum_(i,2) = rankingDiffSum_temp;
end
sum(rankingDiffSum_,1)

%%
Fs = hz_;
N_ = size(ranking_a,1);
f_time_t = (0:floor(N_/2)) * (Fs/N_);

Y_t = fft(ranking_a,[],1);

magX_t = abs(Y_t(1:floor(N_/2)+1, :));
phaseX_t = angle(Y_t(1:floor(N_/2)+1, :));

magX_t(2:end-1, :) = 2 * magX_t(2:end-1,:);

f = figure('Position', [50, 50, 600, 550]);
f.Theme = 'light';
imagesc(1:21, f_time_t, magX_t);
colorbar;
caxis([0 1500]);
yticks(0:2:8);
xticks(0:3:21);
ylabel('Frequency (Hz)');
set(gca, 'FontName','Arial', 'Fontsize',20);

%%
Fs = hz_;
f_time = (0:floor(oneTouch_/2)) * (Fs/oneTouch_);

for i = 1:setCount_
    start_ = oneTouch_*(i-1)+1;
    end_ = oneTouch_*i;

    Y_ = fft(ranking_a(start_:end_,:),[],1);
    
    Y_all(:,:,i) = Y_(1:floor(oneTouch_/2)+1,:);
    phaseX_all(:,:,i) = angle(Y_(1:floor(oneTouch_/2)+1,:));
end
magX_mean = mean(abs(Y_all), 3);
magX_std = std(abs(Y_all), 0, 3);
phaseX_mean = mean(phaseX_all, 3);
