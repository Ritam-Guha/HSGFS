function []=main(str1,str2)
    tic
    x=importdata(strcat('Data/',str1,'/',str2,'/input.mat'));   % Training File 
    %x=x.trainData;
    t=importdata(strcat('Data/',str1,'/',str2,'/input_target.mat'));  % Training label
    %t=t.trainLabel;
    x2=importdata(strcat('Data/',str1,'/',str2,'/test.mat'));   % Training Test File
    %x2=x2.testData;
    t2=importdata(strcat('Data/',str1,'/',str2,'/test_target.mat'));   % Training Test Label
    %t2=t2.testLabel;
    ftrank=importdata(strcat('Data/',str1,'/franks_',str,'.txt'));
    disp('Imports done');

%     x=x(1:1000,:);
%     t=t(1:1000,1:10);
%     x2=x2(1:500,:);
%     t2=t2(1:500,1:10);
    rng('shuffle');
    
    [per,~]=classify(x,t,x2,t2,ones(1,size(x,2)));
    fprintf('Whole accuracy is -%f\n',per);
    
    c=size(x,2);
    n=5;   %number of points being considered
    iter=3;
    
    population=datacreate(n,c);
    classifierArray=cell(1,n);
    rank=zeros(1,n);
    velocities=zeros(n,c);
    max_population = zeros(1,c);
    max_rank = 0;
    [population,rank,classifierArray]=chromosomeRank(x,t,x2,t2,population,rank,classifierArray,1,1);
    gbest=rank(1);
    
    count=0;
    while ((count<=iter) || (gbest>.99))
        count=count+1;
        if(count > iter)
            break;
        end
        fprintf('Iteration - %d\n',count);
        mass=massCalculation(rank);
        [population,rank]=localsearch(x,t,x2,t2,population,rank,ftrank,classifierArray);
        [velocities]=updateVelocities(mass,velocities,population,count,iter);
        [population]=updatePosition(population,velocities);
        [population,rank,classifierArray]=chromosomeRank(x,t,x2,t2,population,rank,classifierArray,1,1);
        if(rank(1,1)>max_rank)
            max_rank = rank(1,1);
            max_population = population(1,:);
        elseif(rank(1,1)==max_rank && (sum(max_population(1,:)==1)>sum(population(1,:))))
            max_rank = rank(1,1);
            max_population = population(1,:);
        end
    end
    fprintf('The best accuracy is %f\n',max_rank);
    fprintf('The number of features is - %d\n',sum(max_population(1,:)==1));
    save(strcat('Results/',str,'/',str,'_result.mat'),'population','rank','max_population','max_rank');
    toc
end
function [dist]=distance(vec1,vec2)
    dist=0;
    for i=1:size(vec1,2)
        dist=dist+((vec1(i)-vec2(i))^2);
    end
end
function [mass]=massCalculation(rank)
    worst=min(rank);
    best=max(rank);
    mass=rank;
    mass=mass-worst;
    mass=mass/(best-worst);
    total=sum(mass(1,:));
    mass=mass/total;
end
function [velocities]=updateVelocities(mass,velocities,population,count,iter)
    rng('shuffle');
    [r,c]=size(velocities);
    force=zeros(r,c);
    k=int16(r+((1-r)*(count-1))/(iter-1));  %linear relation
    g=exp(-20*(count/iter));    %20 should change - decrease over time
    for i=1:r
        for l=1:c
            for j=1:k
                if i~=j
                    temp=g*((mass(i)*mass(j))/(distance(population(i,:),population(j,:)+1)))*(population(j,l)-population(i,l));
                    force(i,l)=force(i,l)+(rand*temp);
                end
            end
        end
    end
    for i=1:r
        force(i,:)=force(i,:)/mass(i);
    end
    c1=(-2*(count^3/iter^3))+2;
    c2=(2*(count^3/iter^3));
    for i=1:r
        for j=1:c
            velocities(i,j)=(rand*velocities(i,j))+c1*force(i,j)+c2*(population(1,j)-population(i,j));
        end
    end
end
function [population]=updatePosition(population,velocities)
    [r,c]=size(population);
    for i=1:r
        for j=1:c
            if (rand < tanh(velocities(i,j)))
                population(i,j)=1-population(i,j);
            end
        end
    end
end