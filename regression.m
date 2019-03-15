arguments
global factorPlanFileName nFeatures regressionPlanFileName;

factorPlanResult = xlsread(factorPlanFileName, 1, "A2:G9");

e1 = zeros(1, nFeatures);
e2 = zeros(1, nFeatures);
e3 = zeros(1, nFeatures);
e12 = zeros(1, nFeatures);
e13 = zeros(1, nFeatures);
e23 = zeros(1, nFeatures);

for i=1:1:nFeatures
    currentFactor = factorPlanResult(:, i);
    e1(i) = (currentFactor(2) - currentFactor(1) + currentFactor(4) - currentFactor(3) + currentFactor(6) - currentFactor(5) + currentFactor(8) - currentFactor(7)) / 4;
    e2(i) = (currentFactor(3) - currentFactor(1) + currentFactor(4) - currentFactor(2) + currentFactor(7) - currentFactor(5) + currentFactor(8) - currentFactor(6)) / 4;
    e3(i) = (currentFactor(5) - currentFactor(1) + currentFactor(6) - currentFactor(2) + currentFactor(7) - currentFactor(3) + currentFactor(8) - currentFactor(4)) / 4;
    
    e12(i) = (currentFactor(4) - currentFactor(3) + currentFactor(8) - currentFactor(7) / 4) - ((currentFactor(2) - currentFactor(1) + currentFactor(6) - currentFactor(5)) / 4);
    e13(i) = (currentFactor(6) - currentFactor(5) + currentFactor(8) - currentFactor(7) / 4) - ((currentFactor(2) - currentFactor(1) + currentFactor(4) - currentFactor(3)) / 4);
    e23(i) = (currentFactor(7) - currentFactor(5) + currentFactor(8) - currentFactor(6) / 4) - ((currentFactor(3) - currentFactor(1) + currentFactor(4) - currentFactor(2)) / 4);
    
    e123(i) = ((currentFactor(8) - currentFactor(7) - currentFactor(6) + currentFactor(5) / 4)) - ((currentFactor(4) - currentFactor(3) - currentFactor(2) + currentFactor(1)) / 4);
end

factor_headers = ["p", "Tq", "Ts", "Nq", "Ns", "Ca", "Cr"];
e_headers = ["e1"; "e2"; "e3"; "e12"; "e13"; "e23"; "e123"];
e = [e1; e2; e3; e12; e13; e23; e123];

xlswrite(regressionPlanFileName, e_headers, 1, "A2:A8"); 
xlswrite(regressionPlanFileName, factor_headers, 1, "B1:H1");
xlswrite(regressionPlanFileName, e, 1, "B2:H8");
