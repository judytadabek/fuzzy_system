clc

% read in the data for Fuzzy System
testData = ('testdata.xls');
fertilityData = xlsread(testData);



%==========================================================================

a = newfis('Biological Conditions Assessment');

a=addvar(a,'input','BBT (C)',[32 40]); 

a=addmf(a,'input',1,'Too Low','trapmf',[0 2 35.5 36.2]); 
a=addmf(a,'input',1,'Perfect','trapmf',[35.5 36.6 37.3 37.7]); 
a=addmf(a,'input',1,'Too High','trapmf',[37.3 38 40 42]);

a=addvar(a,'input','Mucus Thickness (ml)',[0 0.4]); 

a=addmf(a,'input',2,'None','trimf',[-1 0.00 0.05]); %why?
a=addmf(a,'input',2,'Medium','gauss2mf',[0.05 0.15 0.1 0.1]); %why?
a=addmf(a,'input',2,'Very Thick','trapmf',[0.29 0.3 0.4 0.5]);



a=addvar(a,'output','Bio Conditions',[0 100]);

% a=addmf(a,'output',1,'Perfect','trimf',[0 0 25]);
% a=addmf(a,'output',1,'Pretty Good','trimf',[20 32.5 45]);
% a=addmf(a,'output',1,'Likely','trimf',[40 52.5 65]);
% a=addmf(a,'output',1,'Poor','trimf',[60 72 85]);
% a=addmf(a,'output',1,'Insufficient','trimf',[80 100 100]);
a=addmf(a,'output',1,'Perfect','trapmf',[0 0 20 25]);
a=addmf(a,'output',1,'Pretty Good','trapmf',[15 20 40 45]);
a=addmf(a,'output',1,'Likely','trapmf',[35 40 60 65]);
a=addmf(a,'output',1,'Poor','trapmf',[55 60 80 85]);
a=addmf(a,'output',1,'Insufficient','trapmf',[75 80 100 110]);

% % Create rules for the FIS, the last value is for AND or OR
rule1 = [1 1 5 1 1];
rule2 = [1 2 5 1 1];
rule3 = [1 3 5 1 1];
rule4 = [2 1 5 1 1];
rule5 = [2 2 2 1 1];
rule6 = [2 3 1 1 1];
rule7 = [3 1 5 1 1];
rule8 = [3 2 4 1 1];
rule9 = [3 3 3 1 1];
% 
% 
% %rule base
ruleListA = [rule1; rule2; rule3; rule4; rule5;
    rule6; rule7; rule8; rule9];

% % Add the rules to the FIS
a = addrule(a,ruleListA);
% 
% % Print the rules to the workspace
rule = showrule(a);
% 
% %defuzzification methods
%a.defuzzMethod = 'centroid';
%a.defuzzMethod = 'bisector';
%a.defuzzMethod = 'mom';
%a.defuzzMethod = 'lom';
%a.defuzzMethod = 'som';
% 
% for i=1:size(fertilityData,1)
%         evalBioConditions = evalfis([fertilityData(i, 1), fertilityData(i, 2)], a);
%         fprintf('%d) In(1): %.2f, In(2) %.2f,  => Out: %.2f \n\n',i,fertilityData(i, 1),fertilityData(i, 2), evalBioConditions);  
%         xlswrite('testdata.xls', evalBioConditions, 1, sprintf('C%d',i+1));
% end

figure(1)
subplot(3,1,1), plotmf(a, 'input', 1)
subplot(3,1,2), plotmf(a, 'input', 2)
subplot(3,1,3), plotmf(a, 'output', 1)






%=========================================================================%
% SECOND SYSTEM %

b = newfis('Fertility Assessment');

b=addvar(b,'input','Age',[16 60]);

b=addmf(b,'input',1,'Young','trapmf',[16 16 24 28]);
b=addmf(b,'input',1,'Mature','gaussmf',[2 30]);
b=addmf(b,'input',1,'Middle', 'gaussmf', [2 37.5]);
b=addmf(b,'input',1,'Elder','gaussmf', [3 45]);
b=addmf(b,'input',1,'Inactive','trapmf',[45 50 60 65]);

b=addvar(b, 'input', 'Bio Conditions', [0 100]);
b=addmf(b,'input',2,'Perfect','trapmf', [0 0 20 25]);
b=addmf(b,'input',2,'Pretty Good','trapmf', [15 20 40 45]);
b=addmf(b,'input',2,'Likely','trapmf', [35 40 60 65]);
b=addmf(b,'input',2,'Poor','trapmf', [55 60 80 85]);
b=addmf(b,'input',2,'Insufficient','trapmf', [75 80 100 110]);

b=addvar(b,'output','Fertility',[0 100]);

% b=addmf(b,'output',1,'Very High','trimf',[0 0 25]);
% b=addmf(b,'output',1,'High','trimf',[20 32.5 45]);
% b=addmf(b,'output',1,'Medium','trimf',[40 52.5 65]);
% b=addmf(b,'output',1,'Less Likely','trimf',[60 72 85]);
% b=addmf(b,'output',1,'Infertile','trimf',[80 100 100]);
b=addmf(b,'output',1,'Very High','trapmf',[0 0 15 20]);
b=addmf(b,'output',1,'High','trapmf',[10 15 25 35]);
b=addmf(b,'output',1,'Medium','trapmf',[30 35 45 55]);
b=addmf(b,'output',1,'Less Likely','trapmf',[45 50 70 75]);
b=addmf(b,'output',1,'Infertile','trapmf',[65 70 100 100]);

%RULES FOR THE 2ND SUBSYSTEM
% 
% If ('Age' is 'Young') and ('Bio Conditions 2' is 'Perfect') then ('Fertility' is 'Very High') (1)			
rule1=[1 1 1 1 1];
% If ('Age' is 'Young') and ('Bio Conditions 2' is 'Pretty Good') then ('Fertility' is 'High') (1)			
rule2=[1 2 2 1 1];
% If ('Age' is 'Young') and ('Bio Conditions 2' is 'Likely') then ('Fertility' is 'Medium') (1)				
rule3=[1 3 3 1 1];
% If ('Age' is 'Young') and ('Bio Conditions 2' is 'Poor') then ('Fertility' is 'Less Likely') (1)			
rule4=[1 4 4 1 1];
% If ('Age' is 'Young') and ('Bio Conditions 2' is 'Insufficient') then ('Fertility' is 'Less Likely') (1)	
rule5=[1 5 4 1 1];
% 
% If ('Age' is 'Mature') and ('Bio Conditions 2' is 'Perfect') then ('Fertility' is 'High') (1)				
rule6=[2 1 2 1 1];
% If ('Age' is 'Mature') and ('Bio Conditions 2' is 'Pretty Good') then ('Fertility' is 'High') (1)			
rule7=[2 2 2 1 1];
% If ('Age' is 'Mature') and ('Bio Conditions 2' is 'Likely') then ('Fertility' is 'Less Likely') (1)			
rule8=[2 3 4 1 1];
% If ('Age' is 'Mature') and ('Bio Conditions 2' is 'Poor') then ('Fertility' is 'Infertile') (1)				
rule9=[2 4 5 1 1];
% If ('Age' is 'Mature') and ('Bio Conditions 2' is 'Insufficient') then ('Fertility' is 'Infertile') (1)		
rule10=[2 5 5 1 1];
% 
% If ('Age' is 'Middle') and ('Bio Conditions 2' is 'Perfect') then ('Fertility' is 'Medium') (1)				
rule11=[3 1 3 1 1];
% If ('Age' is 'Middle') and ('Bio Conditions 2' is 'Pretty Good') then ('Fertility' is 'Less Likely') (1)	
rule12=[3 2 4 1 1];
% If ('Age' is 'Middle') and ('Bio Conditions 2' is 'Likely') then ('Fertility' is 'Less Likely') (1)			
rule13=[3 3 4 1 1];
% If ('Age' is 'Middle') and ('Bio Conditions 2' is 'Poor') then ('Fertility' is 'Infertile') (1)				
rule14=[3 4 5 1 1];
% If ('Age' is 'Middle') and ('Bio Conditions 2' is 'Insufficient') then ('Fertility' is 'Infertile') (1)		
rule15=[3 5 5 1 1];
% 
% If ('Age' is 'Elder') and ('Bio Conditions 2' is 'Perfect') then ('Fertility' is 'Less Likely') (1)			
rule16=[4 1 4 1 1];
% If ('Age' is 'Elder') and ('Bio Conditions 2' is 'Pretty Good') then ('Fertility' is 'Less Likely') (1)		
rule17=[4 2 4 1 1];
% If ('Age' is 'Elder') and ('Bio Conditions 2' is 'Likely') then ('Fertility' is 'Infertile') (1)			
rule18=[4 3 5 1 1];
% If ('Age' is 'Elder') and ('Bio Conditions 2' is 'Poor') then ('Fertility' is 'Infertile') (1)				
rule19=[4 4 5 1 1];
% If ('Age' is 'Elder') and ('Bio Conditions 2' is 'Insufficient') then ('Fertility' is 'Infertile') (1)		
rule20=[4 5 5 1 1];

% If ('Age' is 'Inactive') and ('Bio Conditions 2' is 'Perfect') then ('Fertility' is 'Infertile') (1)		
rule21=[5 1 5 1 1];
% If ('Age' is 'Inactive') and ('Bio Conditions 2' is 'Pretty Good') then ('Fertility' is 'Infertile') (1)	
rule22=[5 2 5 1 1];
% If ('Age' is 'Inactive') and ('Bio Conditions 2' is 'Likely') then ('Fertility' is 'Infertile') (1)			
rule23=[5 3 5 1 1];
% %If ('Age' is 'Inactive') and ('Bio Conditions 2' is 'Poor') then ('Fertility' is 'Infertile') (1)			
rule24=[5 4 5 1 1];
%If ('Age' is 'Inactive') and ('Bio Conditions 2' is 'Insufficient') then ('Fertility' is 'Infertile') (1)	
rule25=[5 5 5 1 1];


% %rule base
ruleListB = [rule1; rule2; rule3; rule4; rule5; rule6; rule7; rule8; rule9; rule10; rule11; rule12; rule13; rule14; rule15; rule16; rule17;rule18; rule19; rule20; rule21; rule22; rule23; rule24; rule25];

% % Add the rules to the FIS
b = addrule(b, ruleListB);
% 
% % Print the rules to the workspace
rule = showrule(b);
% 


% %defuzzification methods
%b.defuzzMethod = 'centroid';
%b.defuzzMethod = 'bisector';
%b.defuzzMethod = 'mom';
b.defuzzMethod = 'som';
%b.defuzzMethod = 'lom';
% 
for i=1:size(fertilityData,1)
        evalFertility = evalfis([fertilityData(i, 4), fertilityData(i, 3)], b);
        fprintf('%d) In(1): %.2f, In(2) %.2f,  => Out: %.2f \n\n',i,fertilityData(i, 4),fertilityData(i, 3), evalFertility);  
        xlswrite('testdata.xls', evalFertility, 1, sprintf('E%d',i+1));
end

figure(2)
subplot(3, 1, 1), plotmf(b, 'input', 1)
subplot(3, 1, 2), plotmf(b, 'input', 2)
subplot(3, 1, 3), plotmf(b, 'output', 1)