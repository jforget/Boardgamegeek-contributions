#!/usr/bin/lua
-- -*- encoding: utf-8; indent-tabs-mode: nil -*-
--[[

Utility script to build the index of proper names in Wings of the Motherland scenarios
Copyright (C) 2020, 2023 Jean Forget

This program is distributed under the GNU Public License version 1 or later.

See the summary of GPL in the POD documentation below.

]]

function normalize(name)
  name = string.gsub(name, "é", "e");
  name = string.gsub(name, "ö", "o");
  name = string.gsub(name, "ü", "u");
  name = string.gsub(name, "ž", "z");
  return string.upper(name)
end

function extract(normal_tag, italic_tag)

local filename = "list-WotM.txt";
local scenario
local tag
local name
local data  = {}
local names = {}
local normalized_name = {}
local bsl   = string.char(92)

local f = assert(io.open(filename, 'r'))
for line in f:lines() do
  --print(line)
  tag, name = string.match(line, "^(%a%a?)%s%s?(.*)")
  if tag == "S" and name ~= nil then
    scenario = name
  end
  if (tag == normal_tag or tag == italic_tag) and name ~= nil then
    if data[name] == nil then
      data[name] = { }
      table.insert(names, name);
      normalized_name[name] = normalize(name);
      -- print(name, '->', normalize(name));
    end
    if tag == normal_tag then
      table.insert(data[name], scenario);
    end
    if tag == italic_tag then
      table.insert(data[name], bsl .. 'textit{' .. scenario .. '}');
    end
  end
end



table.sort(names, function (a, b) return normalized_name[a] < normalized_name[b] end)
for i, n in ipairs(names) do
  sep = ''
  line = string.gsub(n, ' "', ' ``')
  line = string.gsub(line, '"', "''")
  line = string.format("%s :", line)
  for j, sc in ipairs(data[n]) do
    line = line .. string.format("%s %s", sep, sc)
    sep = ','
  end
  tex.print(line)
  tex.print('')
end
end

-- extract("A", "M")

--[[

=encoding utf-8

=head1 Description

Utility script to build the index of proper names in Wings of the Motherland scenarios

=head1 Usage

The program is  meant to be called from a  LuaLaTeX document. There is
no provision to call it from the command line.

This   program   uses   a   text  file   with   a   hard-coded   name,
F<list-WotM.txt>. This file contains lines with a 1- or 2-letter code,
some space, and then some data. These codes and the corresponding
data are:

=over 4

=item  * S Scenario code: an  alphabetic code  plus the
scenario number, e.g. A109. In case of mission-scale scenarios,
a S<v> or S<e> suffix designates the variant paragraph or the random encounter
tables. The  alphabetic code gives the category of
the scenario:

=over 4

=item * A for air-combat scenarios

=item * G for ground attack scenarios

=item * N for ship attack scenarios (N is for Naval)

=item * M for mission-scale scenarios

=back

=item * P Person taking an active part in the scenario.

=item * MP Person mentioned in the scenario, without being really part of it.

=item * L Location or event directly involved in the scenario.

=item * ML Location or event mentioned in the scenario, without being really part of it.

=item * U Unit appearing in the scenario

=item * MU Unit mentioned in the scenario

=item * A aircraft type used in the scenario

=item * MA aircraft type mentioned in the scenario

=item * B ships (named or class) used in the scenario

=item * MB ships (named or class) mentioned in the scenario

=item * E Errata mentioning a typo in the booklet

=back

Other lines (such as blank lines) are ignored.

=head1 Copyright and License

Copyright (c) 2020, 2023 Jean Forget

This program is distributed under the  GNU Public License version 1 or
later.

Here is the summary of GPL:

This program is  free software; you can redistribute  it and/or modify
it under the  terms of the GNU General Public  License as published by
the Free  Software Foundation; either  version 1, or (at  your option)
any later version.

This program  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR  A PARTICULAR  PURPOSE.  See the  GNU
General Public License for more details.

You should  have received  a copy  of the  GNU General  Public License
along  with  this  program;  if   not,  write  to  the  Free  Software
Foundation, Inc., L<https://www.fsf.org/>.

]]
