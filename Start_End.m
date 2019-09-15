function [startt,endd] = Start_End(E,ZCR)

Etl= 0.1*max(E(1:10));
Eth=0.8*max(E(1:10));
Zt= 0.4*max(ZCR(1:10));

start1 = find(E>=Eth);
start1 = start1(1);
start2 = find(E(1:start1)<=Etl);

if (isempty(start2)) 
    startt=start1;
else 
    start2 = start2(end);
    startt=start2;
end

if (ZCR(startt)>Zt)
   temp = find (ZCR(1:startt)<=Zt);
   if isempty(temp)=='0', startt = temp(end); end
end

end1 = find(E>=Eth);
end1 = end1(end);
end2 = find(E(end1:end)<=Etl);
if (isempty(end2)) 
    endd=end1;
else 
    end2 = end2(1);
    endd=end1+end2-1;
end

if (ZCR(endd)>Zt)
   temp = find (ZCR(endd:end)<=Zt);
    endd = endd + temp(1) - 1;
end

end

