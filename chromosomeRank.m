function [population,rank,classifierArray]=chromosomeRank(x,t,x2,t2,population,rank,classifierArray,flag,dflag)
%1st flag if 1 then chromosomes ranked
%2nd flag if 1 then display the population
    rng('shuffle');
    [r,c]=size(population);
    temp=zeros(1,c);
    if flag==1
        for i=1:r
            [rank(i),classifierArray{i}]=classify(x,t,x2,t2,population(i,:));
            %rank(i)=rand(1);
        end
    end
    %{
    for i=1:r
        fprintf('R - %f\tnum- %d\n',rank(i),sum(population(i,1:c)==1));
    end
    fprintf('\n');
    %}
    for i =1:r
        for j =1:r-1
            if (rank(j)<rank(j+1)||(rank(j)==rank(j+1) && (sum(population(j,:)==1)>sum(population(j+1,:)==1))))%in 1-r accuracy decreases
                val=rank(j);
                rank(j)=rank(j+1);
                rank(j+1)=val;
                
                temp(1:c)=population(j,1:c);
                population(j,1:c)=population(j+1,1:c);
                population(j+1,1:c)=temp(1:c);
                
                nettemp=classifierArray{j};
                classifierArray{j}=classifierArray{j+1};
                classifierArray{j+1}=nettemp;
                
           
            end
        end
        %{
        for j=1:r
            fprintf('R - %f\tnum- %d\n',rank(j),sum(population(j,1:c)==1));
        end
        fprintf('\n');
        %}
    end
    if (dflag==1)
        fprintf('\nPopulation now - \n');
        for i=1:r
            fprintf('R - %f\tnum- %d\n',rank(i),sum(population(i,1:c)==1));
        end
        fprintf('\n');
    end
end
            