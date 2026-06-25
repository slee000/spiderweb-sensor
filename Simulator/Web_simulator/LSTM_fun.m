function [ net , accuracy , info ] = LSTM_fun( XTrain , YTrain , XTest , YTest , isPlot )
%% LSTM
inputSize = numel( XTrain{1}(:,1) );
numHiddenUnits = 100;
numClasses = length(unique(YTrain));

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 100;
options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ... % 'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','none',... % 'training-progress',...
    'ValidationData',{XTest{1},YTest{1}});

[ net , info ] = trainNetwork(XTrain,YTrain,layers,options);

%% test accuracy
for j = 1 : numel( XTest )
    YPred = classify(net,XTest{j}, ...
        'SequenceLength','longest');
    accuracy(j) = sum(YPred == YTest{j})./numel(YTest{j});
end


