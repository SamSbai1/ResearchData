function servpath(sdir)

% SERVPATH add the counting processes and random number
% directories to the path. 
% Alternatively, you may add to your startup.m:
%  addpath('path_to_stsim\service', ...
%          'path_to_stsim\ranvar')
%  
%  servpath([sdir])
%
% Input: 
%      sdir - optional; path to the main directory with the
%         files. Default - current directory.

% Authors: R.Gaigalas, I.Kaj
% v1.0 17-Dec-05

  if nargin<1
    sdir = pwd;
  end

 addpath(sdir, regexprep(sdir, 'service', 'ranvar'));
 
