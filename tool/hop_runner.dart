#!/usr/bin/env dart
/**
 * Copyright (C) 2014  Andrea Cantafio kk4r.1m@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
library hop_runner;

import 'package:hop/hop.dart';
import 'package:orm/task.dart';
import 'package:utils/task.dart' as ut;

void main (List<String> args) {
  addTask('install', ut.installTask());
  addTask('add-header', ut.addHeaderTask());
  addTask('enhance', enhanceTask());
  runHop(args);
}