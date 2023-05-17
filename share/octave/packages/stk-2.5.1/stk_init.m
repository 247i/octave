% STK_INIT initializes the STK
%
% CALL: stk_init ()
%
% STK_INIT sets paths and environment variables

% Copyright Notice
%
%    Copyright (C) 2015-2017 CentraleSupelec
%    Copyright (C) 2011-2014 SUPELEC
%
%    Authors:  Julien Bect       <julien.bect@centralesupelec.fr>
%              Emmanuel Vazquez  <emmanuel.vazquez@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of
%
%            STK: a Small (Matlab/Octave) Toolbox for Kriging
%               (http://sourceforge.net/projects/kriging)
%
%    STK is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    STK is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with STK.  If not, see <http://www.gnu.org/licenses/>.

%% PKG_ADD: stk_init ('pkg_load');

%% PKG_DEL: stk_init ('pkg_unload');

function output = stk_init (command)

if nargin == 0
    command = 'pkg_load';
end

% Deduce the root of STK from the path to this script
root = fileparts (mfilename ('fullpath'));

switch command
    
    case 'pkg_load'
        stk_init__pkg_load (root);
        
    case 'pkg_unload'
        stk_init__pkg_unload (root);
        
    case 'prune_mole'
        stk_init__config_mole (root, false, true);  % prune, but do not add to path
        
    case 'clear_persistents'
        % Note: this implies munlock
        stk_init__clear_persistents ();
        
    case 'munlock'
        stk_init__munlock ();
        
    case 'addpath'
        % Add STK subdirectories to the search path
        stk_init__addpath (root);
        
    case 'rmpath'
        % Remove STK subdirectories from the search path
        stk_init__rmpath (root);
        
    case 'genpath'
        % Return the list of all STK "public" subdirectories
        output = stk_init__genpath (root);
        
    otherwise
        error ('Unknown command.');
        
end % switch

end % function

%#ok<*NODEF,*WNTAG,*SPERR,*SPWRN,*LERR,*CTCH,*SPERR>


function stk_init__pkg_load (root)

% Unlock all possibly mlock-ed STK files and clear all STK functions
% that contain persistent variables
stk_init__clear_persistents ();

% Add STK subdirectories to the path
stk_init__addpath (root);

% Set default options
stk_options_set ();

% Select default "parallelization engine"
stk_parallel_engine_set ();

% Hide some warnings about numerical accuracy
warning ('off', 'STK:stk_predict:NegativeVariancesSetToZero');
warning ('off', 'STK:stk_cholcov:AddingRegularizationNoise');
warning ('off', 'STK:stk_param_relik:NumericalAccuracyProblem');

% Uncomment this line if you want to see a lot of details about the internals
% of stk_dataframe and stk_factorialdesign objects:
% stk_options_set ('stk_dataframe', 'disp_format', 'verbose');

end % function


function stk_init__pkg_unload (root)

% Unlock all possibly mlock-ed STK files and clear all STK functions
% that contain persistent variables
stk_init__clear_persistents ();

% Remove STK subdirectories from the path
stk_init__rmpath (root);

end % function


function stk_init__munlock ()

filenames = {                 ...
    'stk_optim_fmincon',      ...
    'stk_options_set',        ...
    'stk_parallel_engine_set' };

for i = 1:(length (filenames))
    name = filenames{i};
    if mislocked (name)
        munlock (name);
    end
end

end % function


function stk_init__clear_persistents ()

stk_init__munlock ();

filenames = {                 ...
    'stk_disp_progress',      ...
    'stk_gausscov_iso',       ...
    'stk_gausscov_aniso',     ...
    'stk_materncov_aniso',    ...
    'stk_materncov_iso',      ...
    'stk_materncov32_aniso',  ...
    'stk_materncov32_iso',    ...
    'stk_materncov52_aniso',  ...
    'stk_materncov52_iso',    ...
    'stk_optim_fmincon',      ...
    'stk_options_set',        ...
    'stk_parallel_engine_set' };

for i = 1:(length (filenames))
    clear (filenames{i});
end

end % function


function stk_init__addpath (root)

path = stk_init__genpath (root);

% Check for missing directories
for i = 1:length (path)
    if ~ exist (path{i}, 'dir')
        error (sprintf (['Directory %s does not exist.\n' ...
            'Is there a problem in stk_init__genpath ?'], path{i}));
    end
end

% Add STK folders to the path
addpath (path{:});

% Selectively add MOLE subdirectories to compensate for missing functions
stk_init__config_mole (root, true, false);  % (add to path, but do not prune)

end % function


function path = stk_init__genpath (root)

path = {};

% main function folders
path = [path {                           ...
    fullfile(root, 'arrays'            ) ...
    fullfile(root, 'arrays', 'generic' ) ...
    fullfile(root, 'core'              ) ...
    fullfile(root, 'covfcs'            ) ...
    fullfile(root, 'covfcs', 'rbf'     ) ...
    fullfile(root, 'lm'                ) ...
    fullfile(root, 'param', 'classes'  ) ...
    fullfile(root, 'param', 'estim'    ) ...
    fullfile(root, 'sampling'          ) ...
    fullfile(root, 'utils'             ) }];

% 'misc' folder and its subfolders
misc = fullfile (root, 'misc');
path = [path {                 ...
    fullfile(misc, 'design'  ) ...
    fullfile(misc, 'dist'    ) ...
    fullfile(misc, 'distrib' ) ...
    fullfile(misc, 'error'   ) ...
    fullfile(misc, 'optim'   ) ...
    fullfile(misc, 'options' ) ...
    fullfile(misc, 'parallel') ...
    fullfile(misc, 'pareto'  ) ...
    fullfile(misc, 'plot'    ) ...
    fullfile(misc, 'test'    ) ...
    fullfile(misc, 'text'    ) }];

% folders that contain examples
path = [path {                                             ...
    fullfile(root, 'examples', '01_kriging_basics'       ) ...
    fullfile(root, 'examples', '02_design_of_experiments') ...
    fullfile(root, 'examples', '03_miscellaneous'        ) ...
    fullfile(root, 'examples', 'datasets'                ) ...
    fullfile(root, 'examples', 'test_functions'          ) }];

end % function


function stk_init__rmpath (root)

s = path ();

regex1 = strcat ('^', escape_regexp (root));

try
    % Use the modern name (__octave_config_info__) if possible
    apiver = __octave_config_info__ ('api_version');
    assert (ischar (apiver));
catch
    % Use the old name instead
    apiver = octave_config_info ('api_version');
end
regex2 = strcat (escape_regexp (apiver), '$');

while ~ isempty (s)
    
    [d, s] = strtok (s, pathsep);  %#ok<STTOK>
    
    if (~ isempty (regexp (d,  regex1, 'once'))) ...
            && (isempty (regexp (d, regex2, 'once'))) ...
            && (~ strcmp (d, root))  % Only remove subdirectories, not the root
        
        rmpath (d);
        
    end
end

end % function


function s = escape_regexp (s)

s = strrep (s, '\', '\\');
s = strrep (s, '+', '\+');
s = strrep (s, '.', '\.');

end % function


function stk_init__config_mole (root, do_addpath, prune_unused)

mole_dir = fullfile (root, 'misc', 'mole');
isoctave = (exist ('OCTAVE_VERSION', 'builtin') == 5);

if isoctave
    recursive_rmdir_state = confirm_recursive_rmdir (0);
end

opts = {root, mole_dir, do_addpath, prune_unused};

% Provide missing octave functions for Matlab users
% TODO: extract functions that are REALLY needed in separate directories
%       and get rid of the others !
if (exist ('OCTAVE_VERSION', 'builtin') ~= 5)  % if Matlab
    if do_addpath
        addpath (fullfile (mole_dir, 'matlab'));
    end
elseif prune_unused
    rmdir (fullfile (mole_dir, 'matlab'), 's');
end

% graphics_toolkit
%  * For Octave users: graphics_toolkit is missing in some old version of Octave
%  * For Matlab users: there is no function named graphics_toolkit in Matlab.
%    Our implementation returns either 'matlab-jvm' or 'matlab-nojvm'.
install_mole_function ('graphics_toolkit', opts{:});

% isrow
%  * For Octave users: ?
%  * For Matlab users: missing in R2007a
install_mole_function ('isrow', opts{:});

% linsolve
%  * For Octave users: linsolve has been missing in Octave for a long time
%    (up to 3.6.4)
%  * For Matlab users: ?
install_mole_function ('linsolve', opts{:});

% quantile
%  * For Octave users: ?
%  * For Matlab users: quantile is missing from Matlab itself, but it provided
%    by the Statistics toolbox if you're rich enough to afford it.
install_mole_function ('quantile', opts{:});

% cleanup
if isoctave
    confirm_recursive_rmdir (recursive_rmdir_state);
end

end % function


function install_mole_function (funct_name, ...
    root, mole_dir, do_addpath, prune_unused)

function_dir = fullfile (mole_dir, funct_name);

w = which (funct_name);

if (isempty (w)) || (~ isempty (strfind (w, root)))  % if the function is absent
    
    function_mfile = fullfile (function_dir, [funct_name '.m']);
    
    if exist (function_dir, 'dir') && exist (function_mfile, 'file')
        
        % fprintf ('[MOLE]  Providing function %s\n', function_name);
        if do_addpath
            addpath (function_dir);
        end
        
    else
        
        warning (sprintf ('[MOLE]  Missing function: %s\n', funct_name));
        
    end
    
elseif prune_unused && (exist (function_dir, 'dir'))
    
    rmdir (function_dir, 's');
    
end

end % function
