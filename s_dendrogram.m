% read Matlab help first
% https://www.mathworks.com/help/bioinfo/examples/working-with-the-clustergram-function.html

load bc_train_filtered
load bc_proggenes231

[tf, idx] = ismember(bcProgGeneList.Accession, bcTrainData.Accession);
progValues = bcTrainData.Log10Ratio(idx, :);
progAccession = bcTrainData.Accession(idx);
progSamples = bcTrainData.Samples;

progValues = progValues([1:35 197:231],:);
progAccession = progAccession([1:35 197:231]);

cg_s = clustergram(progValues, 'RowLabels', progAccession,...
                               'ColumnLabels', progSamples,...
                               'Cluster', 'Row',...
                               'ImputeFun', @knnimpute)

cg_s.ColumnPDist

cg_s.ColumnPDist = 'correlation';

get(cg_s)


cg = clustergram(progValues, 'RowLabels', progAccession,...
                             'ColumnLabels', progSamples,...
                             'RowPdist', 'correlation',...
                             'ColumnPdist', 'correlation',...
                             'ImputeFun', @knnimpute)
                         
cg.Dendrogram = 0;

cg.Colormap = redbluecmap;
cg.DisplayRange = 2;

gene_markers = struct('GroupNumber', {34, 50},...
                      'Annotation', {'A', 'B'},...
                      'Color', {'b', 'm'});
                  
                  
                  
sample_markers = struct('GroupNumber', {63, 65},...
                      'Annotation', {'Recurrences', 'Non-recurrences'},...
                      'Color', {[1 1 0], [0.6 0.6 1]});
                  
cg.RowGroupMarker = gene_markers;
cg.ColumnGroupMarker = sample_markers;

cg_all = clustergram(bcTrainData.Log10Ratio,...
                                'RowLabels', bcTrainData.Accession,...
                                 'ColumnLabels', bcTrainData.Samples,...
                                 'RowPdist', 'correlation',...
                                 'ColumnPdist', 'correlation',...
                                 'Displayrange', 0.6,...
                                 'Standardize', 3,...
                                 'ImputeFun', @knnimpute)
                             
cg_all.Colormap = redbluecmap;
cg_all.DisplayRange = 2;                             
                  

