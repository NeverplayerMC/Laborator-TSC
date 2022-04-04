onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/test_clk
add wave -noupdate /top/myio/clk
add wave -noupdate /top/myio/load_en
add wave -noupdate /top/myio/reset_n
add wave -noupdate /top/myio/opcode
add wave -noupdate /top/myio/operand_a
add wave -noupdate /top/myio/operand_b
add wave -noupdate /top/myio/write_pointer
add wave -noupdate /top/myio/read_pointer
add wave -noupdate /top/myio/instruction_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 146
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {21520 ps}
