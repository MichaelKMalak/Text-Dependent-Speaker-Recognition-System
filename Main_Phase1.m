% DSP Project: Phase 1
%
% May 9th, 2019
%
% Authors:
% Michael Khalil
% Ziad Khalid
% Karim El Rashidy
%

clear;
clc;
%% ------------------------------ Inputs ------------------------------------
OVERLAPPING=50;
LPC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms frame length
%% ------------------------------ Training Inputs ------------------------------------
audio_path=('src\trainingData');
folders=dir(audio_path);
speakers = folders(3:end);
%% --------------------------   Training: LPCs and Averaging  ------------------------------------
trainingMatrix=zeros(length(speakers),LPC_ORDER);
for i=1:length(speakers)
    speakerMatrix=zeros(1,LPC_ORDER);
    recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name]);
    recordingsPerSpeaker = recordingsPerSpeaker(3:end);
    for j=1:length(recordingsPerSpeaker)
        [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\' recordingsPerSpeaker(j).name]);
        frameLength=floor(fs *  FRAME_DURATION);
        [frames, energy, zerocrossingRate] = Framming_Overlapped (sampledData(:,1)', frameLength, OVERLAPPING);
        [startFrame,endFrame] = Start_End(energy,zerocrossingRate);
        [LPCs]=LPC_Calc(frames(:,startFrame:endFrame)',LPC_ORDER);
        [LPCsAvg]=Matrix_Average(LPCs);
        speakerMatrix = speakerMatrix + LPCsAvg;
    end
    speakerMatrix = speakerMatrix ./length(recordingsPerSpeaker);  %average LPC of each speaker.
    trainingMatrix(i,:)=speakerMatrix;
end

%% --------------------------   Testing: Inputs  ------------------------------------
audio_path=('src\testingData');
folders=dir(audio_path);
speakers = folders(3:end);
DURATION_ITERATION = 5; %Divide testing file into five increasing segments
%% --------------------------   Testing: LPCs and Averaging  ------------------------------------
performance = zeros(1,DURATION_ITERATION);
for durationPercentage = 1/DURATION_ITERATION : 1/DURATION_ITERATION : 1
    filesNum=0;
    confusionMatrix=zeros(length(speakers));
    for i=1:length(speakers)
        speakerMatrix=zeros(1,LPC_ORDER);
        recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name]);
        recordingsPerSpeaker = recordingsPerSpeaker(3:end);
        for j=1:length(recordingsPerSpeaker)
            [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\' recordingsPerSpeaker(j).name]);
            frameLength=floor(fs *  FRAME_DURATION);
            [frames, energy, zerocrossingRate] = Framming_Overlapped (sampledData(:,1)', frameLength, OVERLAPPING);
            [frames,lastTestingFrame] = Crop_Frames(frames, durationPercentage);
            [startFrame,endFrame] = Start_End(energy,zerocrossingRate);
            if(endFrame>lastTestingFrame)
                endFrame=lastTestingFrame;
            end
            [LPCs] = LPC_Calc(frames(:,startFrame:endFrame)',LPC_ORDER);
            [LPCsAvg] = Matrix_Average(LPCs);
            [~,speakerPosition] = Euclidean_Distance(trainingMatrix,LPCsAvg);
            confusionMatrix(i, speakerPosition)= confusionMatrix(i, speakerPosition) + 1;
            filesNum=filesNum+1;
        end
    end
    iterationNum = int8(durationPercentage*DURATION_ITERATION);
    performance(iterationNum) = (sum(diag(confusionMatrix))./filesNum )*100;
end
%% --------------------------   Testing: Plotting  ------------------------------------
plot(1/DURATION_ITERATION:1/DURATION_ITERATION:1, performance, 'b', 'LineWidth',3);
xlabel("Testing Files' Frame Duration Percentage");
ylabel('Performance');
grid on;