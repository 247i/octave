## Copyright (C) 2012-2017 (C) Juan Pablo Carbajal
## 
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
## 
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
## 
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>

## -*- texinfo -*-
## @deftypefn {} {@var{h} = } plotShape (@var{shape})
## @deftypefnx {} {@var{h} = } plotShape (@dots{}, @var{prop}, @var{value})
## Pots a 2D shape defined by piecewise smooth polynomials in the current axis.
##
## @var{shape} is a cell where each elements is a 2-by-(poly_degree+1) matrix
## containing a pair of polynomials.
##
## Additional property value pairs are passed to @code{drawPolygon}.
##
## @seealso{drawPolygon, shape2polygon}
## @end deftypefn

function h = plotShape(shape, varargin)

  #FIXME: make this an option
  tol = 1e-4;

  n  = cell2mat (cellfun (@(x)curveval (x,rand(1, 11)), shape, 'unif', 0));
  dr = tol * ( max (n(:,1)) - min (n(:,1))) * ( max (n(:,2)) - min (n(:,2)) );
  p  = shape2polygon (shape,'tol', dr);
  h  = drawPolygon (p,varargin{:});

endfunction
