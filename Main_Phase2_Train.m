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
%% ------------------------------ Training: Inputs ------------------------------------
txt_path=('src\txtFiles');
audio_path=('src\trainingData');
folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms frame length
%% --------------------------   Training: MFCC  ------------------------------------
for i=1:length(speakers)
    speakerMatrix=[];
    recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name]);
    recordingsPerSpeaker = recordingsPerSpeaker(3:end);
    for k=1:length(recordingsPerSpeaker)
        [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\' recordingsPerSpeaker(k).name]);
        frameLength=floor(fs *  FRAME_DURATION);
        mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
        speakerMatrix = [speakerMatrix ; mfccMatrix];
    end
    [temp, ~, ~] =  kmeanlbg(speakerMatrix, 16);
    dlmwrite(strcat(txt_path, '\' , speakers(i).name,'_16.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    
    [temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
    dlmwrite(strcat(txt_path, '\' ,speakers(i).name,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
end
