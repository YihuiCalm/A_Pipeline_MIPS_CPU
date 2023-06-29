debImport "../sim/CPU_top_tb.v" "../source/ALU.v" "../source/Control_unit.v" \
          "../source/CPU_top.v" "../source/Data_MEM.v" \
          "../source/EX2MEM_reg.v" "../source/ID2EX_reg.v" \
          "../source/IF2ID_reg.v" "../source/Instruction_MEM.v" \
          "../source/MEM2WB_reg.v" "../source/PC_next.v" "../source/PC.v" \
          "../source/Register_MEM.v"
debLoadSimResult \
           /home/yihui/Desktop/Digital_Design/Pipeline_MIPS_CPU/prj_file/CPU_top_tb.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "CPU_top_tb"
verdiDockWidgetMaximize -dock windowDock_nSchema_3
schSelect -win $_nSchema3 -inst "u_CPU_top"
schPushViewIn -win $_nSchema3
verdiDockWidgetRestore -dock windowDock_nSchema_3
wvCreateWindow
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiDockWidgetSetCurTab -dock windowDock_nWave_4
wvCloseWindow -win $_nWave4
wvRestoreSignal -win $_nWave2 \
           "/home/yihui/Desktop/Digital_Design/Pipeline_MIPS_CPU/prj_file/signal.rc" \
           -overWriteAutoAlias on -appendSignals on
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSetCursor -win $_nWave2 457535.691922 -snap {("G6" 0)}
wvSetCursor -win $_nWave2 457535.691922 -snap {("G6" 0)}
wvTpfCloseForm -win $_nWave2
wvGetSignalClose -win $_nWave2
wvCloseWindow -win $_nWave2
verdiDockWidgetMaximize -dock windowDock_nSchema_3
schSetOptions -win $_nSchema3 -portName on
schSetOptions -win $_nSchema3 -pinName on
schZoomIn -win $_nSchema3 -pos 62479 1347
schZoomIn -win $_nSchema3 -pos 62479 1347
schZoomIn -win $_nSchema3 -pos 62479 1346
schZoomIn -win $_nSchema3 -pos 62479 1346
schZoomIn -win $_nSchema3 -pos 62478 1346
schZoomIn -win $_nSchema3 -pos 62478 1346
schZoomIn -win $_nSchema3 -pos 62686 2975
schZoomIn -win $_nSchema3 -pos 62685 2974
schZoomOut -win $_nSchema3 -pos 62853 3135
schZoomOut -win $_nSchema3 -pos 62853 3134
schZoomOut -win $_nSchema3 -pos 62853 3134
schZoomOut -win $_nSchema3 -pos 62853 3134
schZoomOut -win $_nSchema3 -pos 62853 3133
schZoomOut -win $_nSchema3 -pos 62853 3133
schZoomOut -win $_nSchema3 -pos 62852 3133
schZoomOut -win $_nSchema3 -pos 62851 3132
schZoomOut -win $_nSchema3 -pos 62851 3133
schZoomOut -win $_nSchema3 -pos 62850 3133
schZoomOut -win $_nSchema3 -pos 62850 3132
schZoomOut -win $_nSchema3 -pos 59009 -18546
schZoomIn -win $_nSchema3 -pos 59008 -18546
schZoomIn -win $_nSchema3 -pos 59007 -18546
schZoomOut -win $_nSchema3 -pos 59007 -18547
schSelect -win $_nSchema3 -inst "inst_data_MEM"
schProperties -win $_nSchema3
schProperties -win $_nSchema3 -Basic on -Library on
schDeselectAll -win $_nSchema3
schSetOptions -win $_nSchema3 -pinName off
schSetOptions -win $_nSchema3 -portName off
schFit -win $_nSchema3
schSetOptions -win $_nSchema3 -pinName on
schZoomIn -win $_nSchema3 -pos 97122 5595
schZoomIn -win $_nSchema3 -pos 92069 6309
schZoomIn -win $_nSchema3 -pos 89926 6803
schSelect -win $_nSchema3 -inst "inst_Instruction"
schDeselectAll -win $_nSchema3
verdiCaptureWindow -win $_nSchema_3
verdiCloseDialog -win $_nSchema_3 -widget capturePreview
srcPrint -win $_nTrace1 -printScope "file" -column 2 -fontSize 7 -lineNum on \
         -indicator off -annot on -paper E -color -header "%f - %h @ %t" \
         -footer "" -file "test" -type PS2
schZoomOut -win $_nSchema3 -pos 31410 1797
schZoomOut -win $_nSchema3 -pos 31409 1797
schZoomOut -win $_nSchema3 -pos 31410 1797
schFit -win $_nSchema3
schSetPreference -fixFontSize off
schSetPreference -fixFontSize on
schSetPreference -instFontSize 8 -instFontAutoAdjust 0
schSetPreference -instFontSize 36
schSetPreference -moduleFontSize 36 -moduleFontAutoAdjust 0 -instFontSize 36 \
           -instFontAutoAdjust 1
schSetPreference -moduleFontSize 36 -moduleFontAutoAdjust 1 -portFontSize 36 \
           -portFontAutoAdjust 0
schSetPreference -instFontAutoAdjust 0 -portFontAutoAdjust 1
schFit -win $_nSchema3
schFit -win $_nSchema3
schZoomIn -win $_nSchema3 -pos 35527 4862
schZoomIn -win $_nSchema3 -pos 35526 4862
schZoomIn -win $_nSchema3 -pos 35526 4861
schZoomIn -win $_nSchema3 -pos 35525 4861
schZoomIn -win $_nSchema3 -pos 38422 4861
schZoomOut -win $_nSchema3 -pos 47807 3592
schZoomOut -win $_nSchema3 -pos 47828 3592
schZoomOut -win $_nSchema3 -pos 47828 3592
schZoomOut -win $_nSchema3 -pos 47827 3591
schZoomOut -win $_nSchema3 -pos 47826 3591
schZoomOut -win $_nSchema3 -pos 65274 4545
schFit -win $_nSchema3
schFit -win $_nSchema3
schSetOptions -win $_nSchema3 -moduleName off
schSetOptions -win $_nSchema3 -moduleName on
schSetPreference -moduleFontAutoAdjust 0
schCloseWindow -win $_nSchema3
wvCreateWindow
schCreateWindow -delim "." -win $_nSchema1 -scope "CPU_top_tb"
schSelect -win $_nSchema7 -inst "u_CPU_top"
schPushViewIn -win $_nSchema7
verdiDockWidgetMaximize -dock windowDock_nSchema_7
schSetOptions -win $_nSchema7 -pinName on
debExit
