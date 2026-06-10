# 5 bit DAC R-2R

This repository contains the documentation and Verilog files of a 5-bit R-2R Ladder Digital to Analog Converter, developed as a course project for Computer Analysis of Electronic Circuits in Cadence Virtuoso.

## Overview

The goal of this project is to implement a 5-bit R-2R ladder architecture. The design is optimized for specific signal-tracking requirements. The project focuses on schematic design and simulation; layout is not included.

## Specifications

Resolution -- 5 bit
Digital steering -- 2 types of signals: Sawtooth/Triangle
Period -- 2* 32t_clk (t_clk = 2ms)
5 incline rates
Vout range -- 0-2V
Keys -- SPDT TGates
OPamp -- 2-stage amplifier, phase margin +70, gain ~75dB
