function partitioncoef = getpartitioncoef(distributionName)

partitioncoef = NaN(length(distributionName),1);
partitioncoef(1) = 0; 
for i = 1:length(distributionName)
    switch distributionName{i}
        case 'lineardist'
            partitioncoef(i+1) = 1;
        case 'uniform'
            partitioncoef(i+1) = 0;
        case 'vonmises'
            partitioncoef(i+1) = 3;
        case 'gaussian'
            partitioncoef(i+1) = 3;
        case 'cosine'
            partitioncoef(i+1) = 2;
    end
end
