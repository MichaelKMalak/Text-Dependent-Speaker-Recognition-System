function   speakerPosition = Euclidean_Distance_Codebook(speakerCodebook,mfccMatrix)
    [~,~,SPEAKER_NUMBER] = size(speakerCodebook);
    [FRAME_NUMBER,~] = size(mfccMatrix);
    averageDistance = zeros(1,SPEAKER_NUMBER);
    for speaker = 1:SPEAKER_NUMBER
        minDist = zeros(1, FRAME_NUMBER);
        for frame = 1:FRAME_NUMBER
            [minDist(frame), ~] = Euclidean_Distance(speakerCodebook(:,:,speaker),mfccMatrix(frame,:));
        end
        averageDistance(speaker) = sum(minDist)/FRAME_NUMBER;
    end
    [~, speakerPosition] = min(averageDistance);
end

