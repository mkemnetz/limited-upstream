function [error_final] = computeGE_1d(dataStructInput, varargin) 
%COMPUTEGE_CENTERSTRIP - One line description of what the function or script performs (H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
% 
% Syntax:  [output1,output2] = computeGE_centerStrip(input1,input2,input3) 
% 
% Inputs: 
%    input1 - Description 
%    input2 - Description 
%    input3 - Description 
% 
% Outputs: 
%    output1 - Description 
%    output2 - Description 
% 
% Example: 
%    Line 1 of example 
%    Line 2 of example 
%    Line 3 of example 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% 
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2 
 
% Author: Matthew Kemnetz 
% Hessert Laboratory for Aerospace Research B034 
% email: mkemnetz@nd.edu, kemnetz.m@gmail.com 
% Website: http://www.matthewkemnetz.com 
% October 2017; Last revision: 11-October-2017 
% Copyright 2017, Matthew Kemnetz, All rights reserved. 
 
%% ------------- BEGIN CODE -------------- %% 
%% Define Global Variables
global overallProgressSteps

%% Parse Inputs
p = inputParser;

defaultMach      = 0.2;
defaultTotalTemp = 78.4;
defaultfsamp     = 40300;
defaultPlotFlag  = 0;

addRequired(p, 'dataStructInput', @isstruct);
addParameter(p, 'mach', defaultMach, @isnumeric)
addParameter(p, 'temp_t', defaultTotalTemp, @isnumeric)
addParameter(p, 'fsamp', defaultfsamp, @isnumeric)
addParameter(p, 'plotFlag', defaultPlotFlag, @isnumeric)

parse(p,dataStructInput, varargin{:});

dataStruct = p.Results.dataStructInput;
M_inf      = p.Results.mach;
T_t        = p.Results.temp_t;
fsamp      = p.Results.fsamp;
plotFlag   = p.Results.plotFlag;

if ~isempty(p.UsingDefaults)
   disp('Using defaults: ')
   disp(p.UsingDefaults)
end
%% Update the waitbar
t = timer; t.ExecutionMode = 'fixedRate'; t.Period = 0.05; t.TimerFcn = @(~, ~)multiWaitbar( 'Computing Global from a 1d separation...', 'Busy');
start(t);
%%
params.N    = 1000;
params.fine = 100;
[ dataZero.x,  dataZero.y,   dataZero.phase ] = refineWF2( dataStruct.zero.phase,  dataStruct.zero.x,  dataStruct.zero.y,  params);
[ dataOne.x,   dataOne.y,   dataOne.phase   ] = refineWF2( dataStruct.one.phase,   dataStruct.one.x,   dataStruct.one.y,   params);

params.fine = params.N*10;
[ dataZero.x,  dataZero.y,   dataZero.phase ] = refineWFt(dataZero.phase,  dataZero.x,  dataZero.y,  params);
[ dataOne.x,  dataOne.y,   dataOne.phase ] = refineWFt(dataOne.phase,  dataOne.x,  dataOne.y,  params);

%%
phase_L = dataZero.phase;
phase_R1 = dataOne.phase;

%%
OPDrms = zeros(1, params.N);
for i = 1:params.N
    temp1 = reshape( phase_L(:, :, i)   , 1, numel(phase_L(:, :, i)));
    OPDrms(i) = rms(temp1);
end

OPDrms = mean(OPDrms);


%%  Full Aperture Error
stop(t);
multiWaitbar( 'Computing Global from a 1d separation...', 'Reset');

e2_1         = zeros(2, 100);
N            = size(dataZero.phase, 3);
delaysTest   = 1000;
for i = 1:delaysTest
    if (mod(i, 10) ==0)
        multiWaitbar( 'Computing Global from a 1d separation...', i/delaysTest);
    end
    delay  = i;
    error1 = zeros(1, N-delay);
    index = 1;
    for k = 1:N-delay
        A = phase_L(:, :, k);
        B1 = phase_R1(:, :, k+delay);
%         diff  = abs(A-B);
%         temp  = reshape(diff, 1, numel(diff));
% 
%         error(index) = rms(temp)./OPDrms;
        diff1  = A-B1;

        temp1  = reshape(diff1, 1, numel(diff1));

        error1(index) = std(temp1)./OPDrms;

        index = index+1;
    end
    e2_1(2, i) = mean(error1(1, :));
    e2_1(1, i) = (1*0.0156)/(i*machToVel(M_inf, T_t)*(1/fsamp));
    
end

error_final = e2_1;

%%
if(plotFlag == 1)
    figure();
    set(gcf,'units','centimeters','position',[0 0 1.2*8 8]);
    plot(e2_1(1, :), e2_1(2, :)); 
    axis([0.4 1.4 0 1.5]); 
    title('Error vs. $Uc/U_\infty$', 'interpreter', 'latex'); 
    xlabel('$Uc/U_\infty$', 'interpreter', 'latex'); 
    ylabel('$\Sigma(U_c)$', 'interpreter', 'latex'); 
    hleg = legend('$1 \delta$');
    hleg.Interpreter  = 'latex';
    hleg.Location     = 'southwest';
    hleg.Title.String = 'Separation'; 
    % set(hleg, 'interpreter', 'latex', 'location', 'southwest', 'title', 'test');
    % v = get(hleg,'title');
    % set(v,'string','Legend Title');
    grid on;
    grid minor;
end

%% -------------- END CODE --------------- %% 
end 
%% --------- BEGIN SUBFUNCTIONS ---------- %% 









 % ===== EOF ====== [computeGE_centerStrip.m] ======  

