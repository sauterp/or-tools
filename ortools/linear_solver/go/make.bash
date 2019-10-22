#!/bin/bash
INC_DIR=../../../
swig -I$INC_DIR -c++ -go -intgosize 64 -module gowraplp linear_solver.i