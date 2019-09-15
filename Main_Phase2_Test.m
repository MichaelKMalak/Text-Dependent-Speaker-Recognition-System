% DSP Project: Phase 2
%
% May 11th, 2019
%
% Authors:
% Michael Khalil
% Ziad Khalid
% Karim El Rashidy
%

clear;
clc;
%% --------------------------   Testing: Inputs  ------------------------------------
txt_path=('src\txtFiles');
audio_path=('src\testingData');
folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms

% Read Speakers' Codebooks
for i=1:length(speakers)
    speakerCodebook16(:,:,i) = dlmread(strcat(txt_path, '\' ,speakers(i,:).name,'_16' ,'.txt'));
    speakerCodebook32(:,:,i) = dlmread(strcat(txt_path, '\' ,speakers(i,:).name,'_32' ,'.txt'));
end

% Variable Duration Length Parameters
STARTING_SECOND = 5;
DURATION_STEP = 0.02;
DURATION_LENGTH = 30;
duration = STARTING_SECOND+DURATION_STEP : DURATION_STEP : STARTING_SECOND + DURATION_STEP*DURATION_LENGTH;
performance_16 = zeros(1,length(duration));
performance_32 = zeros(1,length(duration));
%% --------------------------   Testing ------------------------------------
for iter = 1:length(duration)
    confusionMatrix_16=zeros(length(speakers));
    confusionMatrix_32=zeros(length(speakers));
    filesNum = 0;
    for i=1:length(speakers)
        recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name]);
        recordingsPerSpeaker = recordingsPerSpeaker(3:end);
        for j=1:length(recordingsPerSpeaker)
            [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\' recordingsPerSpeaker(j).name]);
            filesNum = filesNum+1;      
            % Variable Duration
            startingSample = ceil(STARTING_SECOND *fs);
            endingSample = ceil(duration(iter)*fs);
            mfccMatrix = melcepst(sampledData(startingSample:endingSample,1).', fs, 'M',MFCC_ORDER, fs*FRAME_DURATION);          
            %Speaker Identification
            speakerPosition_16 = Euclidean_Distance_Codebook(speakerCodebook16,mfccMatrix);
            speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32,mfccMatrix);   
            %Updating Confusion Matrix
            confusionMatrix_16(i, speakerPosition_16)= confusionMatrix_16(i, speakerPosition_16) + 1;
            confusionMatrix_32(i, speakerPosition_32)= confusionMatrix_32(i, speakerPosition_32) + 1;
        end
    end
    % Estimating Overall Performance
    performance_16(iter) = (sum(diag(confusionMatrix_16))./filesNum )*100;
    performance_32(iter) = (sum(diag(confusionMatrix_32))./filesNum )*100;
    %Exporting Confusion Matrices
    dlmwrite(strcat(txt_path, '\_duration',int2str(iter),'_16.txt'), confusionMatrix_16, 'delimiter', ' ','newline', 'pc', 'precision',10);
    dlmwrite(strcat(txt_path, '\_duration',int2str(iter),'_32.txt'), confusionMatrix_32, 'delimiter', ' ','newline', 'pc', 'precision',10);
end

%% --------------------------   Testing: Plotting  ------------------------------------
figure
plot(duration-STARTING_SECOND, performance_16, 'r', 'LineWidth',3);
xlabel('Testing Duration (seconds)');
ylabel('Performance');
grid on;
hold on
plot(duration-STARTING_SECOND, performance_32, 'b', 'LineWidth',3);
legend ('codebook 16','codebook 32');
hold off