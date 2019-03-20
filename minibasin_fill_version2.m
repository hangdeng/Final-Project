% This code is written by Hang Deng April 24, 2016
% to simulate Sylvester et al.,2015 Minibasin subsidence and filling
% surface based model
% three problems addressed: 1) subsidence curve (non-linear?);
% 2) deposition of Qs (geometry over the subsidence)
% 3) diffusion model of sediment over minibasin
% this model aims to provide an implication of how subsidence and 
% sediment supply interplay with each other to affect the deposition of 
% sediment within such minibasins.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
figure(1)
figure(2)
clf

%% space and time vectors
% time steps
dt = 0.1; % kyrs
tmax = 500; % kyrs
t = 0:dt:tmax;

% x steps
dx = 100; % m
xmax = 10000; % m
x = dx/2:dx:xmax-(dx/2); % x-coordinates of node centers(m)
xedge = 0:dx:xmax; % x coordinate of node edges (m)

j = 0:1:98;

%% initialize
% PARAMETERS
y = -0.0001*x; % initial shallow topography of minibasin
subrate = 3; % subsidence rate m/kyrs
kappa = 5000; % marine diffusivity
%sediment difussion coefficient, usually m^2/kyrs, Assume all sediment deposited

% variations of Qs
% Constant Qs
% Qs1 = 5; % m^2/kyrs
% sinuosoidal Qs
% Qs = 1000*abs(sin(t)); 
b = sin (3.14/6.*t)+1;
b(b<0)=0;
% Related to slope using diffusion model described by Jordan and Flemings,
% Kenyon and Turcotte, 1985 GSA Bulletin
% Qs = -kappa*dHdx

% parabolic subsidence curve
parabola = (-(x-5000).^2+2.5e7)/2.5e7;

% plotting
nplots = 10;
tplot = tmax/nplots;

%% matrix creation
z = zeros(size(x));
H = zeros(size(x));
Zt = 0.0001*x;

%% start loop and run
for i = 1:length(t)
    % calculate slope
    dZtdx = diff(Zt)./dx;
    slope = dZtdx;
    Q = -kappa.*(slope).*b(i);
    Q = [Q(1) Q Q(end)];
    
    % subsidence through time and space
    subsidence = subrate.*dt.*parabola;
    
    % physical laws of sediment diffusion
    dQdx = diff(Q)/dx;
    
    % H (elevation) is the deposit thickness
    dHdt = dQdx;
    % update dHdt to fit the matrix dimensions

    % update H
    H = H - dHdt.*dt;
    
    % how about adding erosion???
    %erorate=0.1*dQdx;
    %erorate = [erorate 0];
    % update elevation
    y = y - subsidence;
    Zt = y + H;
    
    % now for plot
    if rem(t(i),tplot)==0
        disp(['Time: ' num2str(t(i))])
        figure(1)
        plot(x/1000,y,'b-','linewidth',0.5)
        %axis([0 x(end)/1000 3000 5000])
        
        plot(x/1000,Zt,'r--','linewidth',0.5)
        hold on
        
        xlabel('Downstream distance [km]','fontsize',18)
        ylabel('Elevation[m]','fontsize',18)
        legend('Depositional surface','minibasin topographic boundary','location','southeast')
        ylim([-2000 0]);
        set(gca,'fontsize',14)
        pause(0.02)
        %xlim
        %plot(x/1000,dQdx,'k-')
        %hold on
        %xlabel('Downstream distance [km]','fontsize',18)
        %ylabel('flux','fontsize',18)
        figure(2)
        plot(xedge/1000,Q,'r-','linewidth',1)
        hold on
        disp(['Time: ' num2str(t(i))])
        xlabel('Downstream Distance [km]','fontsize',18)
        ylabel('Discharge [m^2/kyrs]','fontsize',18)
        legend('Discharge plot','location','southeast')
        ylim([-6000 6000]);
        pause(0.02);
    end
end
� 2019 GitHub, Inc.