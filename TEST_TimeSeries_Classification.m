tic
clear all
close all
dataSetName = 'D:\Git\VDTW\Data\Harran2013.mat';
load (dataSetName);

% Plot Data
means = TS_ComputeNDVIVarianceVector(samples, labels);

%% Crop Labels
% Corn: 8
% Cotton: 34

SampleSizes = 10;


%% This code each time take a random set of elements each class having the same number of training samples
% [endMemberLabels, endMembers, endMemberLabelsTest, endMembersTest]  =...
%     GetEndmembers('leavemeout', samples, labels, SampleSizes, 1);
% 
% testLabel = endMemberLabelsTest;
% testData = endMembersTest;

%% Gets the median of samples
[endMemberLabels, endMembers, endMemberLabelsTest, endMembersTest]  =...
    GetEndmembers('median', samples, labels, SampleSizes, 1);



testLabel = labels;
testData = samples;

predict_label = [];

parfor i = 1:size(testData, 1)
    errRadians = [];
    %     tSortedLabels = [];
    a = testData(i, :)';
    for s = 1:numel(endMemberLabels)
        b = endMembers(s, :)';
        
        
%         errRadians(s) = dtw(a, b );%DTW Classifier
        
%        errRadians(s) = SAM(a, b ); %Spectral Angle Mapper

%         errRadians(s) = vdtw(a, b ); %MATLAB Mex implementation
        errRadians(s) = VDTW(a, b ); %MATLAB implementation
        
    end
    [~, indexY] = sort(errRadians, 'ascend');
    predict_label(i) = endMemberLabels(indexY(1));    
    
end

testLabel = double(testLabel);

tstats = confusionmatStats(predict_label(:) ,testLabel);
accuracy = tstats.accuracy*100
ConfMatsPercentage = tstats.confusionMatPercentage*100;
ConfMats = tstats.confusionMat;
toc