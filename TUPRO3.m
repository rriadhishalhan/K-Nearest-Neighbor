%% TRAINING CODE
% IMPORT CSV
DataTrain = csvread('DataTrain_Tugas3_AI.csv',1,0);

Train(1,1)=0;
Valid(1,1)=0;

K=1;
maxK=K;
maxAkurasi=0;

%PECAH DATA TRAINING
for i=1:600
    Train(i,1)=DataTrain(i,1);
    Train(i,2)=DataTrain(i,2);
    Train(i,3)=DataTrain(i,3);
    Train(i,4)=DataTrain(i,4);
    Train(i,5)=DataTrain(i,5);
    Train(i,6)=DataTrain(i,6);
    Train(i,7)=DataTrain(i,7);
end

%PECAH DATA VALIDASI
j=1;
for i=601:800
    Valid(j,1)=j;
    Valid(j,2)=DataTrain(i,2);
    Valid(j,3)=DataTrain(i,3);
    Valid(j,4)=DataTrain(i,4);
    Valid(j,5)=DataTrain(i,5);
    Valid(j,6)=DataTrain(i,6);
    Valid(j,7)=DataTrain(i,7);
    j=j+1;
end


%MENCARI K OPTIMUM
for K=1:100
   
%======================================================KNN============================================
    for i=1:200
        %MENCARI JARAK
        for j=1:600
                Train(j,8)=sqrt(((Valid(i,2)-Train(j,2))^2)+((Valid(i,3)-Train(j,3))^2)+((Valid(i,4)-Train(j,4))^2)+((Valid(i,5)-Train(j,5))^2));  
        end%END LOOP MENCARI JARAK

        sortTrain= sortrows(Train,8);  %Urutkan berdasarakan kolom 8 terkecil
        
        num0=0;
        num1=0;
        num2=0;
        num3=0;
        for p=1:K           %HITUNG BANYAKNYA KLASIFIKASI SEBANYAK K 
            if sortTrain(p,7)==0
                num0=num0+1;
            elseif sortTrain(p,7)==1
                num1=num1+1;
            elseif sortTrain(p,7)==2
                num2=num2+1;
            elseif sortTrain(p,7)==3
                num3=num3+1;
            end        
        end
        
       %VOTING KLASIFIKASI TERBANYAK
        if num0>num1 && num0>num2 && num0>num3
            Valid(i,8)=0;
        elseif num1>num0 && num1>num2 && num1>num3
            Valid(i,8)=1;
        elseif num2>num0 && num2>num1 && num2>num3
            Valid(i,8)=2;
        elseif num3>num0 && num3>num1 && num3>num2
            Valid(i,8)=3;
        end
    end %END LOOP KNN

    %JUMLAH BENAR   
    count=0;
    for t=1:length(Valid)
        if Valid(t,7)==Valid(t,8)
            count=count+1;
        end
    end %end LOOP JUMLAH BENAR
    
    %OUTPUT AKURASI K
    jumlah=length(Valid);
    double(K);
    fprintf('Saat K = %.0f',K);
    a = ' Akurasiya %.1f%% \n';
    
    % HITUNG AKURASI
    acc= double(count/jumlah)*100;
    
    %CARI AKURASI MAKSIMAL
    if acc>maxAkurasi
        maxAkurasi=acc;
        maxK=K;
    end
    fprintf(a,acc);
end %END LOOP OPTIMUM K

disp('========================================================================');
fprintf('Max Akurasi yang didapat %.1f%%',maxAkurasi);
fprintf(' Dengan K = %.0f \n',maxK);

lanjut = input('Lanjutkan ke Testing?(Y/N) = ','s');

%% TESTING CODE
if lanjut=='Y' || lanjut=='y'    
    % import csv
    DataTest = csvread('DataTest_Tugas3_AI.csv',1,0);
    DataTrain =csvread('DataTrain_Tugas3_AI.csv',1,0);

    i=0;
    j=0;
    tebakan(1,1)=0;

    for i=1:length(DataTest)
        %MENCARI JARAK
        for j=1:length(DataTrain)
           DataTrain(j,8)=sqrt(((DataTest(i,2)-DataTrain(j,2))^2)+((DataTest(i,3)-DataTrain(j,3))^2)+((DataTest(i,4)-DataTrain(j,4))^2)+((DataTest(i,5)-DataTrain(j,5))^2));       
        end %END LOOP MENCARI JARAK

        sortDataTrain= sortrows(DataTrain,8);  %Urutkan berdasarakan kolom 8 terkecil
        num0=0;
        num1=0;
        num2=0;
        num3=0;
        for p=1:maxK           %HITUNG BANYAKNYA KLASIFIKASI SEBANYAK maxK 
            if sortDataTrain(p,7)==0
                num0=num0+1;
            elseif sortDataTrain(p,7)==1
                num1=num1+1;
            elseif sortDataTrain(p,7)==2
                num2=num2+1;
            elseif sortDataTrain(p,7)==3
                num3=num3+1;
            end
        end
        %VOTING KLASIFIKASI TERBANYAK
        if num0>num1 && num0>num2 && num0>num3
            DataTest(i,7)=0;
        elseif num1>num0 && num1>num2 && num1>num3
            DataTest(i,7)=1;
        elseif num2>num0 && num2>num1 && num2>num3
            DataTest(i,7)=2;
        elseif num3>num0 && num3>num1 && num3>num2
            DataTest(i,7)=3;
        end

        tebakan(i,1)=DataTest(i,7);
    end

    %write ke csv
    csvwrite('TebakanTugas3.csv',tebakan);
     type('TebakanTugas3.csv');
    disp('====================WRITTEN TO TebakanTugas3.csv========================');       
else
%     TERMINATED
    disp('==========================Process finished==============================');
end
