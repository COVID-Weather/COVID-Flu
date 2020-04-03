% We neglect interaction due to people die from both disease
% This seems to be a reasonable assumption in the stage of exponentia growth
% Note that the model is not accurate after death due to any diseases significantly change the total population
% More relistic and simple representation can be acchived using an agent-based model

clear; clc; % close all;

% *************************************************************************
% Set parameters
% *************************************************************************    
[PM,PI,PT,PD,Ptst,Phos] = COVID_parameters;
PM.first_day_COVID      = 100;
PM.day_test             = 110;
PM.day_home_order       = 120;
PM.magnitude_of_tests   = 1;  
PT.Social_dist_new      = 2;  % Social distance after stay-at-home order
PM.do_seasonal_flu      = 0;  % transmission rate of flu changes with specific humidity?

% *************************************************************************
% Load Korea specific humidity and Shanman model for Flu transimisity
% *************************************************************************
file_Korean_AH = '/Users/duochan/Dropbox/Research/COVID-19/Korea_AH.mat';
load(file_Korean_AH);  AH_Korea = AH_Korea([271:end]);
E_I_flu = @(AH) exp(-180*AH + log(3.79 - 0.97)) + 0.97;

% *************************************************************************
% Load Korea testing case and set up a testing scenario
% *************************************************************************
korea_testing = [0 7; 7 30; 14 300; 21 2500; 28 7000; 35 25000; 42 80000; 49 170000; 56 250000;  63 300000];
N_test_cum = round(interp1([0; korea_testing(:,1)+7],[0; korea_testing(:,2)],1:70,'PCHIP'));
daily_test = diff([0 N_test_cum],[],2);
N_test_dy  = [zeros(1,PM.day_test-1) daily_test] * PM.magnitude_of_tests;
Nt   = numel(N_test_dy);
                   
% *************************************************************************
% Initialization
% *************************************************************************
D = COVID_initialization(PM,PI);
Flu_ref = PT.S_Iu_flu;

for ct = 1:Nt
    
    % *********************************************************************
    % Updating parameters
    % *********************************************************************
    % introducing COVID-19 cases
    if PM.first_day_COVID > 1
        if ct == PM.first_day_COVID
            D.Iu_corona(ct) = PI.seed_corona;
        end
    end
    
    % get number of tests on that day
    N_kit = N_test_dy(ct);
    
    % update social distance after stay-at-home order
    if ct == PM.day_home_order
        PT.Social_distance = PT.Social_dist_new;
    end
    
    % Transmicity of Flu can have seasonality
    if PM.do_seasonal_flu == 1
        PT.S_Iu_flu   = E_I_flu(AH_Korea(ct)) ./ nanmean(E_I_flu(AH_Korea(:))) * Flu_ref;
        PT.S_ISu_flu  = PT.S_Iu_flu;
    end

    % *********************************************************************
    % Transimission and development of the disease from yesterday to today
    % *********************************************************************
    if PM.model == 1
        D = COVID_transmission_developement_SIR(D,PM,PI,PT,PD,ct);
    elseif PM.model == 2 
        D = COVID_transmission_developement_SEIR(D,PM,PI,PT,PD,ct);
    end
    
    % *********************************************************************
    % Testing using today's data
    % *********************************************************************
    [D,N_test(ct),N_positive(ct)] = COVID_testing(D,Ptst,ct,N_kit);
    
    % *********************************************************************
    % hospotalization based on today's testing
    % *********************************************************************
    if PM.do_hos == 1
        D = COVID_hospital(D,Phos,ct);
    end
end

figure(1); clf;  
subplot(2,2,1); hold on; clear('h')
h(1) = plot(D.Iu_flu + D.ISu_flu,'k');
h(2) = plot(D.ISu_flu,'k','linewi',2);
h(3) = plot(D.Iu_corona + D.ISu_corona + D.It_corona + D.ISt_corona,'r');
h(4) = plot(D.ISu_corona + D.ISt_corona,'r','linewi',2);
axis([0 180 10 10e5])
xlabel('Days');
ylabel('# of existing case');
legend(h,{'Flu','Flu severe','COVID','COVID severe'},'fontsize',16,'location','northwest');
set(gca,'yscale','log')
set(gca,'fontsize',20,'fontweight','Normal');
grid on;

subplot(2,2,2); hold on;  clear('h')
h(1) = plot(cumsum(N_test),'k');
h(2) = plot(cumsum(N_positive),'k','linewi',2);
axis([0 180 .1 10e5])
xlabel('Days')
ylabel('cumulated # ')
legend(h,{'Test','Confirmed'},'fontsize',16,'location','northwest');
set(gca,'yscale','log')
set(gca,'fontsize',20,'fontweight','Normal');
grid on;

subplot(2,2,3); hold on;
plot(N_positive./N_test,'k','linewi',2)
axis([0 180 0 0.3])
xlabel('Days')
ylabel('Daily Positive Rate')
xlim([0 180])
set(gca,'fontsize',20,'fontweight','Normal');
grid on;

subplot(2,2,4); hold on;  clear('h')
h(1) = plot(D.Iu_corona + D.ISu_corona + D.It_corona + D.ISt_corona,'r');
h(2) = plot(D.It_corona + D.ISt_corona,'r','linewi',2);
axis([0 180 0.1 10e5])
xlabel('Days')
ylabel('# of existing cases')
legend(h,{'Total infected','Tested Confirmed'},'fontsize',16,'location','northwest');
set(gca,'fontsize',20,'fontweight','Normal');
xlim([0 180])
set(gca,'yscale','log')
grid on;

set(gcf,'position',[1 0 15 10],'unit','inches');
set(gcf,'position',[1 0 15 10],'unit','inches');