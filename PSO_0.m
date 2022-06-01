clear all;
close all;clc;
%% ---------����Ⱥ��ʼ��-----------
c1=1;         % ѧϰ����
c2=1;
c3=2;
maxg=500;          %��������
sizepop=20;         %������
D=9;               %����ά��
popmax=100;         %���λ��
popmin=0;    
R=15;
R1=randi([12 18],D,1);
Vmax=10;
Vmin=-10;
pop0=randi([popmin popmax],D,2) ;
for i=1:sizepop 
%     while  length(unique(sort(randi([popmin popmax],D,2)),'row'))<D  %��popsize���������γ�ʼ��
%         length(unique(sort(randi([popmin popmax],D,2)),'row'))
%     pop0 =randi([popmin popmax],D,2) ; 
%     end
%     length(unique(sort(randi([popmin popmax],D,2)),'row'))
    pop{i}(:,:)=pop0;%��ʼλ��
    
    V{1,i}(:,:)=randi([Vmin,Vmax],D,2);               % ��ʼ�ٶ�
    pop1=pop{i};
    fitness(i)=fugai_1(pop1,D,R1);%������Ӧ��
end
%Ѱ�����Ÿ���
%��Ŀǰ��һ�������䵱ǰȡֵ����ʷ���ţ�ȫ����ֵ����
% [bestfitness,bestindex]=min(fitness);   
[bestfitness,bestindex]=max(fitness);  
%��fitness��Ѱ����Сֵ�����η���ֵ���������ɱ�������
pBest=pop;                              %������ʷ���λ��
gBest=pop{bestindex}; 
gBest1=gBest;
%ȫ����ʷ���λ��
fitnesspbest=fitness;                   %������ʷ�����Ӧ��
fitnessgbest=bestfitness;               %ȫ����ʷ�����Ӧ��
i=1;
%% ---------����Ⱥѭ��-------------
for i=1:maxg             %ÿһ��ѭ��
% figure
% while fitnessgbest/min(D*pi*R^2/popmax^2,1)<=0.95
    for j=1:sizepop      %ÿ������ѭ��
        %�ٶȸ���
        w=1.5;           %����Ȩ��
        w1=c1*randi([0 Vmax]);w2=c2*randi([0 Vmax]);w3=c3*randi([Vmin Vmax]);
        V{1,j}=(w*V{1,j} +w1*(pBest{1,j}-pop{1,j})+w2*(gBest-pop{1,j}));
        V{1,j}=round( V{1,j});
        %Խ�紦��
        V{1,j}(find(V{1,j}(:,:)>Vmax))=Vmax;
        V{1,j}(find(V{1,j}(:,:)<Vmin))=Vmin;
%         V{1,j}
        %λ�ø���
        pop{1,j}=pop{1,j}+V{1,j};
        %Խ�紦��
%         pop(j,find(pop(j,:)>popmax))=randi([1 30]);%popmax;
%         pop(j,find(pop(j,:)<popmin))=randi([1 30]);%popmin;
        pop{1,j}(find(pop{1,j}(:,:)>popmax))=popmax;%popmax;
        pop{1,j}(find(pop{1,j}(:,:)<popmin))=popmin;%popmin;
        pop2=pop{1,j};
        fitness(j)=fugai_1(pop2,D,R1);  %������ʷ���Ÿ���
        if fitness(j)>fitnesspbest(j)
            pBest{1,j}=pop{1,j};
            fitnesspbest(j)=fitness(j);
        end
        
        %Ⱥ����ʷ���Ÿ���
        if fitness(j)>fitnessgbest
            gBest=pop{1,j};
            fitnessgbest=fitness(j);
        end
%          yyy= i*sizepop-sizepop+j;
%          yyy
    end
    i
    result(i)=fitnessgbest;    %��������ȫ����ʷ������Ӧ��ֵ
    result(i)
%     i=i+1;
end

%% -------------��ͼ-----------
figure
plot(result(1:end-50));
axis([0,length(result)-50,result(1)-0.2,min(result(end-50)+0.05,1)]);
grid on;               
title('����������������仯����');
xlabel('��������');
ylabel('������');

figure
for idd=1:D
rectangle('Position',[gBest(idd,1)-R1(idd),gBest(idd,2)-R1(idd),2*R1(idd),2*R1(idd)],'Curvature',[1,1],...
       'EdgeColor','g'),axis equal;
   hold on;
   grid on;
   axis([0,100,0,100]);
end
plot(gBest(:,1),gBest(:,2),'r*');
title('�Ż��󸲸����')
xlabel('X/km');
ylabel('Y/km');
figure
for idd=1:D
rectangle('Position',[pop0(idd,1)-R1(idd),pop0(idd,2)-R1(idd),2*R1(idd),2*R1(idd)],'Curvature',[1,1],...
       'EdgeColor','b'),axis equal;
   hold on;
   grid on;
   axis([0,100,0,100]);
end
plot(pop0(:,1),pop0(:,2),'b*');
title('��ʼ����Ч��')
xlabel('X/km');
ylabel('Y/km');