function [] = mainLimitedUpstream() 
%MAINLIMITEDUPSTREAM - One line description of what the function or script performs (H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
%Optional file header info (to give more details about the function than in the H1 line) 
% 
% Syntax:  [output1,output2] = mainLimited(input1,input2,input3) 
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

%% Set up the waitbar
multiWaitbar( 'CloseAll' );
multiWaitbar( 'Overall Progress', 0 , 'Color', 'b');

overallProgressSteps = 2;

%% Load Upstream and Downstream Data - 1 delta
fprintf('\n\n\nLoading in Processed Data...\n');
multiWaitbar( 'Loading in Processed Data...','Busy');
% t = timer; t.ExecutionMode = 'fixedRate'; t.Period = 0.1; t.TimerFcn = @(~, ~)multiWaitbar( 'Loading in Processed Data...','Busy');
% start(t);

dataDir   = '/Volumes/LaCie/MATLAB/Research/Limited Upstream/Processed/Main Data/Heated BL Experiment Data/';
dataFile  = 'upstream_downstream_1d.mat';
dataPath  = [dataDir dataFile];
variables = {'upstream_downstream_1d'};

lengthyLoad(dataPath, variables);
% 
% load(dataPath, '-mat', variables{:});
% stop(t);
multiWaitbar( 'Loading in Processed Data...', 'Reset');
multiWaitbar( 'Loading in Processed Data...', 1, 'Color', 'g' );
multiWaitbar( 'Overall Progress', 'Increment', 1/overallProgressSteps);

%% Compute Global Error - Center strip
fprintf('Computing Global Error from a center strip...\n');
multiWaitbar( 'Computing Global Error Directly (All Modes)...', 0, 'Color', 'r' );

computeGE_centerStrip(upstream_downstream_1d);

multiWaitbar( 'Computing Global Error Directly (All Modes)...', 1, 'Color', 'g' );
multiWaitbar( 'Overall Progress', 'Increment', 1/overallProgressSteps );






%% -------------- END CODE --------------- %% 
end 
%% --------- BEGIN SUBFUNCTIONS ---------- %% 
function lengthyLoadFcn(dataPath, variables)
    load(dataPath, '-mat', variables{:});
end

function lengthyLoad(dataP, var)
    % Start an asynchronous timer to perform the lengthy update
    start(timer('StartDelay',0.5, 'TimerFcn',@(dataPath, variables)lengthyLoadFcn(dataP, var)));
end

 






 % ===== EOF ====== [mainLimitedUpstream.m] ======  

