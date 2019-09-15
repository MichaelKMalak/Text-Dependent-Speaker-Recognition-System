function [minDist, minPos] = Euclidean_Distance(comparingMatrix,vector)
 [rows,~] = size(comparingMatrix); 
distance = zeros(1,rows);
 for iter=1:rows
         distance(iter)=sqrt(sum(((comparingMatrix(iter,:)-vector).^2))); 
 end
 [minDist , minPos] = min(distance);
end
