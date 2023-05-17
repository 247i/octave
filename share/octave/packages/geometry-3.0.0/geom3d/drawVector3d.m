## Copyright (C) 2004-2011 David Legland <david.legland@grignon.inra.fr>
## Copyright (C) 2004-2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)
## Copyright (C) 2012 Adapted to Octave by Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
##     1 Redistributions of source code must retain the above copyright notice,
##       this list of conditions and the following disclaimer.
##     2 Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in the
##       documentation and/or other materials provided with the distribution.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ''AS IS''
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
## ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
## SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{h} =} function_name (@var{pos}, @var{vect})
## Draw vector at a given position
##
##   Example
## @example
##     figure; hold on;
##     drawVector3d([2 3 4], [1 0 0]);
##     drawVector3d([2 3 4], [0 1 0]);
##     drawVector3d([2 3 4], [0 0 1]);
##     view(3);
## @end example
##
## @seealso{quiver3}
## @end deftypefn

function varargout = drawVector3d(pos, vect, varargin)

  h = quiver3 (pos(:, 1), pos(:, 2), pos(:, 3), ...
      vect(:, 1), vect(:, 2), vect(:, 3), varargin{:});

  # format output
  if nargout > 0
      varargout{1} = h;
  end

endfunction

%!demo
%!     figure; hold on;
%!     drawVector3d([2 3 4], [1 0 0]);
%!     drawVector3d([2 3 4], [0 1 0]);
%!     drawVector3d([2 3 4], [0 0 1]);
%!     view(3);