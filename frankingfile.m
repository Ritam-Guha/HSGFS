function []=frankingfile(str)
    x=importdata(strcat('Data/',str,'/input.mat'));
%     display(size(x));
    tar = importdata(strcat('Data/',str,'/target_char.mat'));
%     display(size(tar));
    k=10;
%     tar=tar';
    [ftrank,weights] = relieff(x,tar,k,'method','classification');%feature ranking
    bar(weights(ftrank));
    xlabel('Predictor rank');
    ylabel('Predictor importance weight');
    clear tar k;
    fp=fopen('franks.txt','w');
    [~,c]=size(x);
    for i=1:c
        fprintf(fp,'%d\t',ftrank(i));
%         fprintf('%d\t',ftrank(i));
    end
    fprintf('\n');
end