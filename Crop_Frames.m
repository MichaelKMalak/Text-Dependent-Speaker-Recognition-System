function [frames, lastTestingFrame] = Crop_Frames(frames, durationPercentage)
[~,c] = size(frames);
lastTestingFrame = floor(c*durationPercentage);
frames = frames(:,1:lastTestingFrame);
end

