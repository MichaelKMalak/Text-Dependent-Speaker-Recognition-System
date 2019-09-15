function [matrix_avg]=Matrix_Average(matrix)
[x,~]=size(matrix);
matrix_avg = sum(matrix,1)./x;
end