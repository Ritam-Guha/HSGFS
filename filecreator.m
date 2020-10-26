function [] = filecreator(str,train_no,test_no)
    x = importdata(strcat('Data/',str,'/',str,'.xlsx'));
    x = x.Sheet1;
    total = train_no + test_no;
    k = 1;
    input_target = zeros(12*train_no,12);
    test_target = zeros(12*test_no,12);
%     input = zeros(12 * train);
%     test = zeros(12 * test);
    for i = 0 : 11
        input_target(i*train_no+1 : i*train_no + train_no,i+1) = 1;
        for j = 1 : train_no
            input(k,:) = x(i*total+j,:);
            k = k + 1;
        end
    end
    k = 1;
    for i = 0 : 11
        test_target(i*test_no+1 : i*test_no + test_no,i+1) = 1;
        for j = 1 : test_no
            test(k,:) = x(i*total+train_no+j,:);
            k = k + 1;
        end
    end
    for i = 1 : (12 * train_no)
        pos = find(input_target(i,:)==1);
        if(pos == 1)
            target_char(i,1) = 'A';
        elseif(pos == 2)   
            target_char(i,1) = 'B';
        elseif(pos == 3)   
            target_char(i,1) = 'C';
        elseif(pos == 4)   
            target_char(i,1) = 'D';
        elseif(pos == 5)   
            target_char(i,1) = 'E';
        elseif(pos == 6)   
            target_char(i,1) = 'F';
        elseif(pos == 7)   
            target_char(i,1) = 'G';
        elseif(pos == 8)   
            target_char(i,1) = 'H';
        elseif(pos == 9)   
            target_char(i,1) = 'I';
        elseif(pos == 10)   
            target_char(i,1) = 'J';
        elseif(pos == 11)   
            target_char(i,1) = 'K';
        elseif(pos == 12)   
            target_char(i,1) = 'L';
        end
    end
    save(strcat('Data/',str,'/','input.mat'),'input');
    save(strcat('Data/',str,'/','input_target.mat'),'input_target');
    save(strcat('Data/',str,'/','test.mat'),'test');
    save(strcat('Data/',str,'/','test_target.mat'),'test_target');
    save(strcat('Data/',str,'/','target_char.mat'),'target_char');