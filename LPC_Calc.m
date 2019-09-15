function [lpc_matrix]=LPC_Calc(matrix,ord)
[framesNumber,~] = size(matrix);
lpc_matrix=zeros(framesNumber,ord);
for p=1:framesNumber
    coeff_With_one=lpc(matrix(p,:),ord);
    check=isnan(coeff_With_one);
    if sum(check)>0
        coeff_With_one=zeros(1,ord+1);
    end
    lpc_matrix(p,:)=coeff_With_one(1,2:end);
end

end
