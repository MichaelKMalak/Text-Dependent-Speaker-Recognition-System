function [H, Energy_H, ZCR_H] = Framming_Overlapped (y, N, overlapPercentage)
    n = N - (overlapPercentage / 100 ) *N ;
    n = round (n);
    zeroPadding = N - ( length(y) - (ceil( (length(y)-N)/n ) * n) );
    y = [y zeros(1,zeroPadding)];
    
     M = zeros(N, ceil(length(y) / n));
     H = M;
    for i = 1:n:length(y)-N+1
         M(:,((i-1)/n)+1) = y(i : i+N-1);
    end
    for i= 1:size(H,2)
        H(:,i) = M(:,i).*hamming(N); 
    end
                
    Energy_H = sum (H.^2, 1);
    
    signed=sign(H);
    signed = signed(1:end-1,:)-signed(2:end,:);
    ZCR_H = sum(abs(signed)./2);
    
end
