function ft_flush_data(filename, varargin)

% FT_FLUSH_DATA removes all data from the data queue
%
% Use as
%   ft_flush_data(filename, ...)
%
% See also FT_FLUSH_HEADER, FT_FLUSH_EVENT

% Copyright (C) 2007-2010 Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.ru.nl/neuroimaging/fieldtrip
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id: ft_flush_data.m 2528 2011-01-05 14:12:08Z eelspa $

% set the defaults
dataformat = keyval('dataformat', varargin); if isempty(dataformat), dataformat = ft_filetype(filename); end

switch dataformat
  case 'disp'
    % nothing to do

  case 'fcdc_buffer'
    [host, port] = filetype_check_uri(filename);
    buffer('flush_dat', [], host, port);

  case 'fcdc_mysql'
    % open the database
    [user, password, server, port] = filetype_check_uri(filename);
    if ~isempty(port)
      server = sprintf('%s:%d', server, port);
    end
    mysql('open', server, user, password);
    % remove all previous data
    cmd = 'TRUNCATE TABLE fieldtrip.data';
    mysql(cmd);
    mysql('close');
    
  case 'matlab'
    if exist(filename, 'file')
      warning('deleting existing file ''%s''', filename);
      delete(filename);
    end

  otherwise
    error('unsupported data format');
end