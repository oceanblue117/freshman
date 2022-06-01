clear all;
close all;clc;
%% ---------粒子群初始化-----------
c1=1;         % 学习因子
c2=1;
c3=2;
maxg=500;          %迭代次数
sizepop=20;         %粒子数
D=9;               %粒子维度
popmax=100;         %最大位置
popmin=0;    
R=15;
R1=randi([12 18],D,1);
Vmax=10;
Vmin=-10;
pop0=randi([popmin popmax],D,2) ;
for i=1:sizepop 
%     while  length(unique(sort(randi([popmin popmax],D,2)),'row'))<D  %将popsize个粒子依次初始化
%         length(unique(sort(randi([popmin popmax],D,2)),'row'))
%     pop0 =randi([popmin popmax],D,2) ; 
%     end
%     length(unique(sort(randi([popmin popmax],D,2)),'row'))
    pop{i}(:,:)=pop0;%初始位置
    
    V{1,i}(:,:)=randi([Vmin,Vmax],D,2);               % 初始速度
    pop1=pop{i};
    fitness(i)=fugai_1(pop1,D,R1);%计算适应度
end
%寻找最优个体
%因目前第一代，故其当前取值即历史最优，全部赋值即可
% [bestfitness,bestindex]=min(fitness);   
[bestfitness,bestindex]=max(fitness);  
%从fitness中寻找最小值，依次返回值和索引，由变量接收
pBest=pop;                              %个体历史最佳位置
gBest=pop{bestindex}; 
gBest1=gBest;
%全局历史最佳位置
fitnesspbest=fitness;                   %个体历史最佳适应度
fitnessgbest=bestfitness;               %全局历史最佳适应度
i=1;
%% ---------粒子群循环-------------
for i=1:maxg             %每一代循环
% figure
% while fitnessgbest/min(D*pi*R^2/popmax^2,1)<=0.95
    for j=1:sizepop      %每个粒子循环
        %速度更新
        w=1.5;           %惯性权重
        w1=c1*randi([0 Vmax]);w2=c2*randi([0 Vmax]);w3=c3*randi([Vmin Vmax]);
        V{1,j}=(w*V{1,j} +w1*(pBest{1,j}-pop{1,j})+w2*(gBest-pop{1,j}));
        V{1,j}=round( V{1,j});
        %越界处理
        V{1,j}(find(V{1,j}(:,:)>Vmax))=Vmax;
        V{1,j}(find(V{1,j}(:,:)<Vmin))=Vmin;
%         V{1,j}
        %位置更新
        pop{1,j}=pop{1,j}+V{1,j};
        %越界处理
%         pop(j,find(pop(j,:)>popmax))=randi([1 30]);%popmax;
%         pop(j,find(pop(j,:)<popmin))=randi([1 30]);%popmin;
        pop{1,j}(find(pop{1,j}(:,:)>popmax))=popmax;%popmax;
        pop{1,j}(find(pop{1,j}(:,:)<popmin))=popmin;%popmin;
        pop2=pop{1,j};
        fitness(j)=fugai_1(pop2,D,R1);  %个体历史最优更新
        if fitness(j)>fitnesspbest(j)
            pBest{1,j}=pop{1,j};
            fitnesspbest(j)=fitness(j);
        end
        
        %群体历史最优更新
        if fitness(j)>fitnessgbest
            gBest=pop{1,j};
            fitnessgbest=fitness(j);
        end
%          yyy= i*sizepop-sizepop+j;
%          yyy
    end
    i
    result(i)=fitnessgbest;    %储存历代全局历史最优适应度值
    result(i)
%     i=i+1;
end

%% -------------绘图-----------
figure
plot(result(1:end-50));
axis([0,length(result)-50,result(1)-0.2,min(result(end-50)+0.05,1)]);
grid on;               
title('覆盖率随进化代数变化曲线');
xlabel('进化代数');
ylabel('覆盖率');

figure
for idd=1:D
rectangle('Position',[gBest(idd,1)-R1(idd),gBest(idd,2)-R1(idd),2*R1(idd),2*R1(idd)],'Curvature',[1,1],...
       'EdgeColor','g'),axis equal;
   hold on;
   grid on;
   axis([0,100,0,100]);
end
plot(gBest(:,1),gBest(:,2),'r*');
title('优化后覆盖情况')
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
title('初始覆盖效果')
xlabel('X/km');
ylabel('Y/km');