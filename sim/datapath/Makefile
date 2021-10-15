# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

## Caravel Pointers
CARAVEL_ROOT ?= ../../../../../caravel
CARAVEL_ROOT ?= $(CARAVEL_DIR)
CARAVEL_PATH ?= $(CARAVEL_ROOT)
CARAVEL_FIRMWARE_PATH = $(CARAVEL_PATH)/verilog/dv/caravel
CARAVEL_VERILOG_PATH  = $(CARAVEL_PATH)/verilog
CARAVEL_RTL_PATH = $(CARAVEL_VERILOG_PATH)/rtl
CARAVEL_BEHAVIOURAL_MODELS = $(CARAVEL_VERILOG_PATH)/dv/caravel

## User Project Pointers
UPRJ_VERILOG_PATH ?= ../../
UPRJ_RTL_PATH = $(UPRJ_VERILOG_PATH)/rtl
UPRJ_SRC_PATH = $(UPRJ_VERILOG_PATH)/src
UPRJ_BEHAVIOURAL_MODELS = ../

## Simulation mode: RTL/GL
SIM?=RTL

.SUFFIXES:

PATTERN = cic.vcd

all:  ${PATTERN:=.vcd}


%.vvp: %_tb.v 
ifeq ($(SIM),RTL)
	iverilog -DFUNCTIONAL -DSIM -I $(UPRJ_BEHAVIOURAL_MODELS) \
							    -I $(UPRJ_RTL_PATH) \
							    -I $(UPRJ_SRC_PATH) \
	                            -o $@ \
	                             $<  
else 
## only for datapath
	iverilog -DFUNCTIONAL -DSIM -DGL tbnetlists.v gl/sky130_fd_sc_hd.v  gl/primitives.v  \
	-o $@ \
	$<  
endif

%.vcd: %.vvp
	vvp $<
 
	gtkwave		$(basename $@).vcd		$(basename $@).gtkw

# ---- Clean ----

clean:
	rm -f *.vvp *.vcd *.log

.PHONY: clean all
