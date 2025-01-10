cd /vast/iaslab/FSMAP
addpath /vast/iaslab/FSMAP/scripts/revision_scripts/kmeans_clustering

%% SECTION A: CORTICAL MAPS OF CORTICAL SEEDS
eta2_lhrh = load('scripts/revision_scripts/kmeans_clustering/eta2_lhrh_corticalSeed.mat');

cort_ind=[1:7]; % step leftover from skipping dAmy previously
eta2_lhrh.cort = eta2_lhrh.eta(cort_ind, cort_ind);
mean(eta2_lhrh.cort(:)) % 0.6669
std(eta2_lhrh.cort(:)) % 0.1742

% test k range
idx2 = kmeans(eta2_lhrh.eta,2,'Distance','cityblock','Display','final','Replicates',100, 'MaxIter', 1000);
[silh2,h] = silhouette(eta2_lhrh.eta,idx2, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh2) % 0.4057

idx3 = kmeans(eta2_lhrh.eta,3,'Distance','cityblock','Display','final',''Replicates',10, 'MaxIter', 1000);
[silh3,h] = silhouette(eta2_lhrh.eta,idx3, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh3) % 0.4230

idx4 = kmeans(eta2_lhrh.eta,4,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh4,h] = silhouette(eta2_lhrh.eta,idx4, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh4) % 0.5772

[idx2,cent2,sumdist] = kmeans(eta2_lhrh.eta,2,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
sum(sumdist) % 3.86512
idx2' %      1     2     2     1     2     2     1
% order: dpIns_Gianaros pgACC_Gianaros dACC_Wager dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager

%evaluation by Calinski-Harabasz Criterion
eva=evalclusters(eta2_lhrh.eta,'kmeans','CalinskiHarabasz','KList',2:6);
plot(eva.CriterionValues);

%%  SECTION B: CORTICAL MAPS OF SUBCORTICAL SEEDS
% load data
eta2_lhrh = load('scripts/revision_scripts/kmeans_clustering/eta2_lhrh_subcorticalSeed.mat');
mean(eta2_lhrh.eta(:)) % 0.6063
std(eta2_lhrh.eta(:)) %  0.1746

% test k range
idx2 = kmeans(eta2_lhrh.eta,2,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh2,h] = silhouette(eta2_lhrh.eta,idx2, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh2) % 0.4022

idx3 = kmeans(eta2_lhrh.eta,3,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh3,h] = silhouette(eta2_lhrh.eta,idx3, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh3) % 0.3757

idx4 = kmeans(eta2_lhrh.eta,4,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh4,h] = silhouette(eta2_lhrh.eta,idx4, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh4) % 0.4511

%evaluation by Calinski-Harabasz Criterion
eva=evalclusters(eta2_lhrh.eta,'kmeans','CalinskiHarabasz','KList',1:6);
plot(eva.CriterionValues);

%k=3
idx3' % 2	1	1	3	2	2	3	2	1	2	2	2	3	2
%k=4
idx4' % 1	3	3	2	1	1	2	1	3	1	1	1	2	4
% order: dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r hippo

%  SECTION C: SUBCORTICAL MAPS OF SUBCORTICAL SEEDS
eta2_mni305 = load('scripts/revision_scripts/kmeans_clustering/eta2_mni305_subcorticalSeed.mat');
mean(eta2_mni305.eta(:)) % 0.8173
std(eta2_mni305.eta(:)) % 0.0983

% test k range
idx2 = kmeans(eta2_mni305.eta,2,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh2,h] = silhouette(eta2_mni305.eta,idx2, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh2) % 0.5179

idx3 = kmeans(eta2_mni305.eta,3,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh3,h] = silhouette(eta2_mni305.eta,idx3, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh3) % 0.4975

idx4 = kmeans(eta2_mni305.eta,4,'Distance','cityblock','Display','final','Replicates',10, 'MaxIter', 1000);
[silh4,h] = silhouette(eta2_mni305.eta,idx4, 'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh4) % 0.5875

%evaluation by Calinski-Harabasz Criterion
eva=evalclusters(eta2_mni305.eta,'kmeans','CalinskiHarabasz','KList',1:10);
eva.CriterionValues;

idx3' % 1	2	2	3	1	1	3	1	2	1	1	1	3	1 (same as above)
idx4' % 2	1	3	4	2	2	4	2	1	2	2	2	4	2


%%%%%%%%%%%%%% OLD MANUAL ITERATION METHOD %%%%%%%%%%%%%%%%%%%
%% SECTION A: CORTICAL MAPS OF CORTICAL SEEDS
% order: dpIns_Gianaros pgACC_Gianaros dACC_Wager dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager
eta2_lhrh = load('scripts/revision_scripts/kmeans_clustering/eta2_lhrh_corticalSeed.mat');

cort_ind=[1:7]; % step leftover from skipping dAmy previously
eta2_lhrh.cort = eta2_lhrh.eta(cort_ind, cort_ind);
mean(eta2_lhrh.cort(:))
std(eta2_lhrh.cort(:))

n_iter = 1000;
idx_lhrh_all = nan(size(cort_ind,2),n_iter);

% k means
for i = 1:n_iter
	
	while isnan(idx_lhrh_all(1,i))
		idx_lhrh = kmeans(eta2_lhrh.cort,2);
		idx_lhrh_all(:,i) = idx_lhrh;
	end	
	
	if idx_lhrh(end) == 2
		idx_lhrh(idx_lhrh == 1) = 0;
		idx_lhrh(idx_lhrh == 2) = 1;
		idx_lhrh(idx_lhrh == 0) = 2;
		idx_lhrh_all(:,i) = idx_lhrh;
	end
end

% find frequency
[Au, ia, ic] = unique(idx_lhrh_all','rows','stable');
Counts = accumarray(ic,1);
Out = [Counts Au]
% order: dpIns_Gianaros pgACC_Gianaros dACC_Wager dmIns_Kurth sgACC_Gianaros mvAIns_Harper lvAIns_Wager
% OUTPUT
   592     1     2     2     1     2     2     1
   288     1     2     1     1     2     2     1
    70     1     1     2     2     1     1     1
    50     1     2     1     1     1     1     1


% calculate rand index
rand_index_all = nan(n_iter,n_iter);
for i = 1:n_iter
	for j = 1:n_iter
		rand_index_all(i,j) = rand_index(idx_lhrh_all(:,i),idx_lhrh_all(:,j),'adjusted');
	end
end
rand_index_mean = mean(rand_index_all(:)) % 0.5711

%%  SECTION B: CORTICAL MAPS OF SUBCORTICAL SEEDS
% load data
eta2_lhrh = load('scripts/revision_scripts/kmeans_clustering/eta2_lhrh_subcorticalSeed.mat');
mean(eta2_lhrh.eta(:))
std(eta2_lhrh.eta(:))

n_iter = 1000;
idx_lhrh_all = nan(size(eta2_lhrh.eta,1),n_iter);

% old manual iterations method
% k=2
for i = 1:n_iter
	
	while isnan(idx_lhrh_all(1,i))
		idx_lhrh = kmeans(eta2_lhrh.eta,2);
		idx_lhrh_all(:,i) = idx_lhrh;
	end	
	
	if idx_lhrh(end) == 2
		idx_lhrh(idx_lhrh == 1) = 0;
		idx_lhrh(idx_lhrh == 2) = 1;
		idx_lhrh(idx_lhrh == 0) = 2;
		idx_lhrh_all(:,i) = idx_lhrh;
	end
end

% find frequency
[Au, ia, ic] = unique(idx_lhrh_all','rows','stable');
Counts = accumarray(ic,1);
Out = [Counts Au]
% order: dAmy_Gianaros DR_2020 Hypothalamus LC_l_r LG_l_r MD_Thal_Wager MPB_LPB_l_r Accumbens PAG_fin SC_DCfunc SN_l_r VTA_PBP_l_r VSM_l_r hippo
% OUTPUT
796	1	2	2	2	1	1	2	1	2	1	1	1	2	1
88	1	2	2	1	1	1	1	1	2	1	1	1	1	1
93	1	2	2	2	2	2	2	2	2	2	2	2	2	1
6	1	1	1	2	2	2	2	2	1	2	2	2	1	1
12	1	1	1	2	2	2	2	2	1	2	2	2	2	1
5	1	2	1	2	2	2	2	2	2	2	2	2	1	1

% calculate rand index
rand_index_all = nan(n_iter,n_iter);
for i = 1:n_iter
	for j = 1:n_iter
		rand_index_all(i,j) = rand_index(idx_lhrh_all(:,i),idx_lhrh_all(:,j),'adjusted');
	end
end
rand_index_mean = mean(rand_index_all(:)) % 0.6874

%  SECTION C: SUBCORTICAL MAPS OF SUBCORTICAL SEEDS
eta2_mni305 = load('scripts/revision_scripts/kmeans_clustering/eta2_mni305_subcorticalSeed.mat');
mean(eta2_mni305.eta(:))
std(eta2_mni305.eta(:))

n_iter = 1000;
idx_mni305_all = nan(size(eta2_mni305.eta,1),n_iter);

% k means
for i = 1:n_iter
	
	while isnan(idx_mni305_all(1,i))
		idx_mni305 = kmeans(eta2_mni305.eta,2);
		idx_mni305_all(:,i) = idx_mni305;
	end	
	
	if idx_mni305(end) == 2
		idx_mni305(idx_mni305 == 1) = 0;
		idx_mni305(idx_mni305 == 2) = 1;
		idx_mni305(idx_mni305 == 0) = 2;
		idx_mni305_all(:,i) = idx_mni305;
	end
end

% find frequency
[Au, ia, ic] = unique(idx_mni305_all','rows','stable');
Counts = accumarray(ic,1);
Out = [Counts Au]
% OUTPUT
83	1	2	2	2	2	2	2	2	2	2	2	2	2	1
793	1	2	2	2	1	1	2	1	2	1	1	1	2	1
10	1	2	1	2	2	2	2	2	2	2	2	2	1	1
14	1	1	1	2	2	2	2	2	1	2	2	2	2	1
96	1	2	2	1	1	1	1	1	2	1	1	1	1	1
4	1	1	1	2	2	2	2	2	1	2	2	2	1	1

% calculate rand index
rand_index_all = nan(n_iter,n_iter);
for i = 1:n_iter
	for j = 1:n_iter
		rand_index_all(i,j) = rand_index(idx_mni305_all(:,i),idx_mni305_all(:,j),'adjusted');
	end
end
rand_index_mean = mean(rand_index_all(:)) % 0.6862

