
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a35t2default:defaultZ17-349h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px? 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
22default:defaultZ35-254h px? 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px? 
B
-Phase 1 Build RT Design | Checksum: dabb720a
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:25 ; elapsed = 00:00:22 . Memory (MB): peak = 1716.031 ; gain = 81.9452default:defaulth px? 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px? 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px? 
A
,Phase 2.1 Create Timer | Checksum: dabb720a
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:25 ; elapsed = 00:00:23 . Memory (MB): peak = 1716.031 ; gain = 81.9452default:defaulth px? 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px? 
M
8Phase 2.2 Fix Topology Constraints | Checksum: dabb720a
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:25 ; elapsed = 00:00:23 . Memory (MB): peak = 1722.074 ; gain = 87.9882default:defaulth px? 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px? 
F
1Phase 2.3 Pre Route Cleanup | Checksum: dabb720a
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:25 ; elapsed = 00:00:23 . Memory (MB): peak = 1722.074 ; gain = 87.9882default:defaulth px? 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px? 
C
.Phase 2.4 Update Timing | Checksum: 132c46b15
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:26 ; elapsed = 00:00:24 . Memory (MB): peak = 1727.598 ; gain = 93.5122default:defaulth px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-0.918 | TNS=-132.484| WHS=-0.155 | THS=-6.767 |
2default:defaultZ35-416h px? 
I
4Phase 2 Router Initialization | Checksum: 18ec9b503
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:27 ; elapsed = 00:00:24 . Memory (MB): peak = 1727.598 ; gain = 93.5122default:defaulth px? 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px? 
q

Phase %s%s
101*constraints2
3.1 2default:default2"
Global Routing2default:defaultZ18-101h px? 
D
/Phase 3.1 Global Routing | Checksum: 18ec9b503
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:27 ; elapsed = 00:00:24 . Memory (MB): peak = 1732.172 ; gain = 98.0862default:defaulth px? 
C
.Phase 3 Initial Routing | Checksum: 1c7fa646b
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:28 ; elapsed = 00:00:25 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
?
>Design has %s pins with tight setup and hold constraints.

%s
244*route2
12default:default2?
?The top 5 pins with tight setup and hold constraints:

+--------------------------+--------------------------+----------------------------------------------------------------------------------------------------------+
|       Launch Clock       |      Capture Clock       |                                                 Pin                                                      |
+--------------------------+--------------------------+----------------------------------------------------------------------------------------------------------+
|              sys_clk_pin |              sys_clk_pin |                                                            i_arm/i_controller/i_Cond_Logic/Flags_reg[2]/D|
+--------------------------+--------------------------+----------------------------------------------------------------------------------------------------------+

File with complete list of pins: tight_setup_hold_pins.txt
2default:defaultZ35-580h px? 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px? 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2L
8| WNS=-2.846 | TNS=-1870.463| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.1 Global Iteration 0 | Checksum: 23fc30986
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:35 ; elapsed = 00:00:30 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2L
8| WNS=-2.364 | TNS=-1274.146| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.2 Global Iteration 1 | Checksum: 22c377b8b
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:42 ; elapsed = 00:00:36 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
u

Phase %s%s
101*constraints2
4.3 2default:default2&
Global Iteration 22default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-2.201 | TNS=-853.061| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.3 Global Iteration 2 | Checksum: 13a4a56e6
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:00:50 ; elapsed = 00:00:42 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
u

Phase %s%s
101*constraints2
4.4 2default:default2&
Global Iteration 32default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-1.998 | TNS=-762.945| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.4 Global Iteration 3 | Checksum: 17cfc8365
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:04 ; elapsed = 00:00:52 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
u

Phase %s%s
101*constraints2
4.5 2default:default2&
Global Iteration 42default:defaultZ18-101h px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-2.033 | TNS=-612.017| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.5 Global Iteration 4 | Checksum: 18f6579cb
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:17 ; elapsed = 00:01:02 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
F
1Phase 4 Rip-up And Reroute | Checksum: 18f6579cb
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:17 ; elapsed = 00:01:02 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 5.1.1 Update Timing | Checksum: 1d3c2ebb4
*commonh px? 
?

%s
*constraints2p
\Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1732.828 ; gain = 98.7422default:defaulth px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-1.919 | TNS=-669.277| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
C
.Phase 5.1 Delay CleanUp | Checksum: 14fd40e70
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px? 
M
8Phase 5.2 Clock Skew Optimization | Checksum: 14fd40e70
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
O
:Phase 5 Delay and Skew Optimization | Checksum: 14fd40e70
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 6.1.1 Update Timing | Checksum: 12d30b3ca
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
?
Intermediate Timing Summary %s164*route2K
7| WNS=-1.897 | TNS=-640.720| WHS=0.108  | THS=0.000  |
2default:defaultZ35-416h px? 
C
.Phase 6.1 Hold Fix Iter | Checksum: 12d30b3ca
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
A
,Phase 6 Post Hold Fix | Checksum: 12d30b3ca
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px? 
B
-Phase 7 Route finalize | Checksum: 1997f81fe
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:18 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px? 
I
4Phase 8 Verifying routed nets | Checksum: 1997f81fe
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:19 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px? 
E
0Phase 9 Depositing Routes | Checksum: 1641e2a0d
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:19 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px? 
?
Estimated Timing Summary %s
57*route2K
7| WNS=-1.897 | TNS=-640.720| WHS=0.108  | THS=0.000  |
2default:defaultZ35-57h px? 
B
!Router estimated timing not met.
128*routeZ35-328h px? 
G
2Phase 10 Post Router Timing | Checksum: 1641e2a0d
*commonh px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:19 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
@
Router Completed Successfully
2*	routeflowZ35-16h px? 
?

%s
*constraints2q
]Time (s): cpu = 00:01:19 ; elapsed = 00:01:03 . Memory (MB): peak = 1734.871 ; gain = 100.7852default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
6012default:default2
12default:default2
02default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
route_design: 2default:default2
00:01:222default:default2
00:01:052default:default2
1734.8712default:default2
112.4302default:defaultZ17-268h px? 
H
&Writing timing data to binary archive.266*timingZ38-480h px? 
D
Writing placer database...
1603*designutilsZ20-1893h px? 
=
Writing XDEF routing.
211*designutilsZ20-211h px? 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px? 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2)
Write XDEF Complete: 2default:default2
00:00:012default:default2 
00:00:00.2732default:default2
1742.7032default:default2
7.8322default:defaultZ17-268h px? 
?
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2q
]C:/School/Fall_2021/eece351/ARM_MultiCycle/ARM_MultiCycle.runs/impl_1/ARM_TopLevel_routed.dcp2default:defaultZ17-1381h px? 
?
%s4*runtcl2?
yExecuting : report_drc -file ARM_TopLevel_drc_routed.rpt -pb ARM_TopLevel_drc_routed.pb -rpx ARM_TopLevel_drc_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
lreport_drc -file ARM_TopLevel_drc_routed.rpt -pb ARM_TopLevel_drc_routed.pb -rpx ARM_TopLevel_drc_routed.rpx2default:defaultZ4-113h px? 
>
IP Catalog is up to date.1232*coregenZ19-1839h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
?
#The results of DRC are in file %s.
586*	vivadotcl2?
aC:/School/Fall_2021/eece351/ARM_MultiCycle/ARM_MultiCycle.runs/impl_1/ARM_TopLevel_drc_routed.rptaC:/School/Fall_2021/eece351/ARM_MultiCycle/ARM_MultiCycle.runs/impl_1/ARM_TopLevel_drc_routed.rpt2default:default8Z2-168h px? 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px? 
?
%s4*runtcl2?
?Executing : report_methodology -file ARM_TopLevel_methodology_drc_routed.rpt -pb ARM_TopLevel_methodology_drc_routed.pb -rpx ARM_TopLevel_methodology_drc_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
?report_methodology -file ARM_TopLevel_methodology_drc_routed.rpt -pb ARM_TopLevel_methodology_drc_routed.pb -rpx ARM_TopLevel_methodology_drc_routed.rpx2default:defaultZ4-113h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
Y
$Running Methodology with %s threads
74*drc2
22default:defaultZ23-133h px? 
?
2The results of Report Methodology are in file %s.
609*	vivadotcl2?
mC:/School/Fall_2021/eece351/ARM_MultiCycle/ARM_MultiCycle.runs/impl_1/ARM_TopLevel_methodology_drc_routed.rptmC:/School/Fall_2021/eece351/ARM_MultiCycle/ARM_MultiCycle.runs/impl_1/ARM_TopLevel_methodology_drc_routed.rpt2default:default8Z2-1520h px? 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px? 
?
%s4*runtcl2?
?Executing : report_power -file ARM_TopLevel_power_routed.rpt -pb ARM_TopLevel_power_summary_routed.pb -rpx ARM_TopLevel_power_routed.rpx
2default:defaulth px? 
?
Command: %s
53*	vivadotcl2?
|report_power -file ARM_TopLevel_power_routed.rpt -pb ARM_TopLevel_power_summary_routed.pb -rpx ARM_TopLevel_power_routed.rpx2default:defaultZ4-113h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px? 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
6132default:default2
12default:default2
02default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px? 
?
%s4*runtcl2y
eExecuting : report_route_status -file ARM_TopLevel_route_status.rpt -pb ARM_TopLevel_route_status.pb
2default:defaulth px? 
?
%s4*runtcl2?
?Executing : report_timing_summary -max_paths 10 -file ARM_TopLevel_timing_summary_routed.rpt -pb ARM_TopLevel_timing_summary_routed.pb -rpx ARM_TopLevel_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px? 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px? 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px? 
?
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px? 
?
%s4*runtcl2i
UExecuting : report_incremental_reuse -file ARM_TopLevel_incremental_reuse_routed.rpt
2default:defaulth px? 
g
BIncremental flow is disabled. No incremental reuse Info to report.423*	vivadotclZ4-1062h px? 
?
%s4*runtcl2i
UExecuting : report_clock_utilization -file ARM_TopLevel_clock_utilization_routed.rpt
2default:defaulth px? 
?
%s4*runtcl2?
?Executing : report_bus_skew -warn_on_violation -file ARM_TopLevel_bus_skew_routed.rpt -pb ARM_TopLevel_bus_skew_routed.pb -rpx ARM_TopLevel_bus_skew_routed.rpx
2default:defaulth px? 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px? 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px? 


End Record