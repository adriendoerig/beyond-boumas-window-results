% directory management
motherShip = fileparts(which(mfilename)); % The program directory
cd(motherShip) % go there just in case we are far away
addpath(genpath(motherShip)); % add the folder and subfolders to path
Lpath = [motherShip, '/crowdingOutput/left'];
Rpath = [motherShip, '/crowdingOutput/right'];

% get file names and create stimuli order
filesL = dir('crowdingOutput/left/*.jpg');
namesL = {filesL.name};
filesR = dir('crowdingOutput/right/*.jpg');
namesR = {filesR.name};

stimTypes = {};
for i = 1:length(namesL)
    stimTypes{i} = namesL{i}(1:end-6);
end
stimTypes = unique(stimTypes);

imageSequence = cell(2,2*length(namesL));
imageSequence(1,:) = [namesL, namesR];
imageSequence(2,1:length(namesL)) = {'L'};
imageSequence(2,length(namesL)+1:end) = {'R'};

order = randperm(2*length(namesL));
imageSequence(1,:) = imageSequence(1,order);
imageSequence(2,:) = imageSequence(2,order);

responses = cell(1, length(imageSequence));

% present all stimuli and ask for response
for i = 1:length(responses)
    if imageSequence{2,i} == 'L'
        cd(Lpath)
    elseif imageSequence{2,i}(1) == 'R'
        cd(Rpath)
    else
        error('Error: cannot reach data')
    end
    h = figure(1);
    %Set the correct position of the figure
    set(h, 'Position', [1 400 500 500]);
    img = imread(imageSequence{1,i});
    imshow(img)
    
    inputOK = 0;
    responses{i} = inputdlg('Do you think the image was made from a LEFT of a RIGHT stimulus? Enter 1 for LEFT or 3 for RIGHT.');
    while inputOK == 0
        if strcmpi(responses{i},'1')
            responses{i} = 'L';
            inputOK = 1;
        elseif strcmpi(responses{i},'3')
            responses{i} = 'R';
            inputOK = 1;
        else
            responses{i} = inputdlg('You did not enter a valid key, please enter 1 for LEFT or 3 for RIGHT.');
        end
    end
    
    cd(motherShip)
end

% compute percent correct
correct = zeros(1,length(stimTypes));
stimOccurences = zeros(1,length(stimTypes));
for stim = 1:length(stimTypes)
    for im = 1:length(responses)
        if length(imageSequence{1,im}(1:end-6)) == length(stimTypes{stim})
            if imageSequence{1,im}(1:end-6) == stimTypes{stim}
                stimOccurences(stim) = stimOccurences(stim)+1;
                if strcmpi(responses{im},imageSequence{2,im})
                    correct(stim) = correct(stim)+1;
                end
            end
        end
    end
end
correct = correct./stimOccurences.*100;
            
figure(2)
bar(correct)
ylim([0 100])
ylabel('percent correct')
set(gca,'XTickLabel',stimTypes)