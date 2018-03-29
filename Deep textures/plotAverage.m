% directory management
motherShip = fileparts(which(mfilename)); % The program directory
cd(motherShip) % go there just in case we are far away
addpath(genpath(motherShip)); % add the folder and subfolders to pathcd('results')
files = dir('results/*Correct.mat');
names = {files.name};

stimFiles = dir('crowdingOutput/left/*.jpg');
stimNames = {stimFiles.name};
stimTypes = {};
for i = 1:length(stimNames)
    stimTypes{i} = stimNames{i}(1:end-6);
end
stimTypes = unique(stimTypes);

cd('results')
allCorrect = zeros(length(files),10);
distFromChance = zeros(length(files),10);
for i = 1:length(names)
    temp = loadSingleVariableMATFile(names{i});
    allCorrect(i,:) = temp;
    distFromChance(i,:) = abs(temp - 50*ones(size(allCorrect(i,:))));
end
cd(motherShip)

meanCorrect = mean(allCorrect);
stderror = std(allCorrect)./sqrt(length(names));
meanDistFromChance = mean(distFromChance);
distFromAvgStdErr = std(distFromChance)./sqrt(length(names));


figure()
bar(meanCorrect(end-1:end))
hold on
h = errorbar(meanCorrect(end-1:end),stderror(end-1:end));
set(h,'linestyle','none')
ylim([0 100])
ylabel('percent correct')
set(gca,'XTickLabel',stimTypes(end-1:end))
% title('Average performance')
hold off

figure()
bar(meanDistFromChance(end-1:end))
hold on
h = errorbar(meanDistFromChance(end-1:end),distFromAvgStdErr(end-1:end));
set(h,'linestyle','none')
ylim([0 25])
ylabel('average distance from chance level')
set(gca,'XTickLabel',stimTypes(end-1:end))
% title('Average distance from chance level')
hold off
