global N mean_arrive mean_service queue_limit device_amount t runsFileName factorPlanFileName nFeatures effectsPlanFileName regressionFileName economicsFileName plan;
N = 1000;
mean_arrive = 20;
mean_service = 60;
queue_limit = 25;
device_amount = 4;
t = 1.96;
runsFileName = 'pre_model.xlsx';
factorPlanFileName = 'factorPlan.xlsx';
effectsPlanFileName = 'effects.xlsx';
regressionFileName = 'regression.xlsx';
economicsFileName = 'economics.xlsx';
nFeatures = 7;

%столбец 1 = девайсы ; столбец 2 = очередь; столбец 3 = время обслуживания
plan = [
    '-','-','-' ;
    '+','-','-' ;
    '-','+','-' ;
    '+','+','-' ;
    '-','-','+' ;
    '+','-','+' ;
    '-','+','+' ;
    '+','+','+' ;
];