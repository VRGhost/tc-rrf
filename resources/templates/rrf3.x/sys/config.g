; Configuration file for Duet WiFi / Ethernet running RRF3 on E3D Tool Changer
; executed by the firmware on start-up

; General preferences
M111 S0 						; Debugging off
G21 							; Work in millimetres
G90 							; Send absolute coordinates...
M83 							; ...but relative extruder moves
M555 P2 						; Set firmware compatibility to look like Marlin
M667 S1 						; Select CoreXY mode	

; Network
M550 P"ToolChanger" 			; Set machine name
;M587 S"ssid" P"password"		; WiFi Settings
;M552 S1 P"ssid"				; Enable WiFi Networking
M552 S1							; Enable Networking
M586 P0 S1 						; Enable HTTP
M586 P1 S0 						; Disable FTP
M586 P2 S0 						; Disable Telnet

; Drive direction
M569 P0 S0 						; Drive 0 X
M569 P1 S0 						; Drive 1 Y
M569 P2 S1 						; Drive 2 Z
M569 P3 {{ 'S0' if motors.E0.reversed else 'S1' }} 						; Drive 3 E0
M569 P4 {{ 'S0' if motors.E1.reversed else 'S1' }} 						; Drive 4 E1
M569 P5 {{ 'S0' if motors.E2.reversed else 'S1' }} 						; Drive 5 E2
M569 P6 {{ 'S0' if motors.E3.reversed else 'S1' }} 						; Drive 6 E3
M569 P7 S0 						; Drive 7 COUPLER
M569 P8 S0 						; Drive 8 UNUSED
M569 P9 S0 						; Drive 9 UNUSED

M584 X0 Y1 Z2 C7 E3:4:5:6 								; Apply custom drive mapping
M208 X{{ axis.X.min }}:{{ axis.X.min + axis.X.width }} Y{{ axis.Y.min }}:{{ axis.Y.min + axis.Y.width }} Z{{ axis.Z.min }}:{{ axis.Z.min + axis.Z.width }} C{{ axis.C.min }}:{{ axis.C.min + axis.C.width }}	 				; Set axis maxima & minima
M92 X{{ motors.X.steps }} Y{{ motors.Y.steps }} Z{{ motors.Z.steps }} C{{ motors.C.steps }} E{{ motors.E0.steps }}:{{ motors.E1.steps }}:{{ motors.E2.steps }}:{{ motors.E3.steps }}				; Set steps per mm assuming x16 microstepping
M350 E16:16:16:16 I1 									; Configure microstepping with interpolation
M350 C16 I10											; Configure microstepping without interpolation
M350 X16 Y16 Z16 I1										; Configure microstepping with interpolation
M906 X1800 Y1800 Z1330 I30                          ; Idle motion motors to 30%
M906 E1000:1000:1000:1000 C500 I10                          ; Idle extruder motors to 10%

{% macro apply_global_settings() -%}
; ----- apply_global_settings()
; This macro applies all global settings that can be overriden in some other scripts
{% if extra_settings -%}
{% for (cmd, params) in extra_settings.items() -%}

{{ cmd }} {{ py.format_gcode_param_str(params) }}

{% endfor -%}
{% endif -%}
; ----- apply_global_settings() END
{% endmacro -%}

{{ apply_global_settings() }}

; Endstops
M574 X1 S1 P"xstop"   ; X min active high endstop switch
M574 Y1 S1 P"ystop"   ; Y min active high endstop switch
M574 C0 Z0  						; No C Z endstop

; Z probe
M558 P8 C"zstop" H3 F360 I0 T20000 	; Set Z probe type to switch, the axes for which it is used and the dive height + speeds
G31 P200 X0 Y0 Z0	 				; Set Z probe trigger value, offset and trigger height
M557 X10:290 Y20:180 S40 			; Define mesh grid

;Stall Detection
M915 X Y S3 F0 H400 R2				; X / Y Axes

; Heaters
M308 S0 P"bedtemp" Y"thermistor" A"Bed" T100000 B4138 C0 		; Set thermistor 
M950 H0 C"bedheat" T0											; Bed heater
M143 H0 S225 													; Set temperature limit for heater 0 to 225C
M140 H0															; Bed heater is heater 0

M308 S1 P"e0temp" Y"thermistor" A"T0" T100000 B4725 C7.06e-8 	; Set thermistor
M950 H1 C"e0heat" T1											; Extruder 0 heater
M143 H1 S305 													; Set temperature limit for heater 1 to 300C

M308 S2 P"e1temp" Y"thermistor" A"T1" T100000 B4725 C7.06e-8 	; Set thermistor
M950 H2 C"e1heat" T2											; Extruder 0 heater
M143 H2 S305 													; Set temperature limit for heater 2 to 300C

M308 S3 P"e2temp" Y"thermistor" A"T2" T100000 B4725 C7.06e-8 	; Set thermistor
M950 H3 C"duex.e2heat" T3										; Extruder 0 heater
M143 H3 S305 													; Set temperature limit for heater 3 to 300C

M308 S4 P"e3temp" Y"thermistor" A"T3" T100000 B4725 C7.06e-8 	; Set thermistor
M950 H4 C"duex.e3heat" T4										; Extruder 0 heater
M143 H4 S305 													; Set temperature limit for heater 4 to 300C


; Tools
M563 P0 S"T0" D0 H1 F2 					; Define tool 0
G10 P0 X0 Y0 Z0 						; Reset tool 0 axis offsets
G10 P0 R0 S0 							; Reset initial tool 0 active and standby temperatures to 0C

M563 P1 S"T1" D1 H2 F4 					; Define tool 1
G10 P1 X0 Y0 Z0 						; Reset tool 1 axis offsets
G10 P1 R0 S0 							; Reset initial tool 1 active and standby temperatures to 0C

M563 P2 S"T2" D2 H3 F6 					; Define tool 2
G10 P2 X0 Y0 Z0 						; Reset tool 2 axis offsets
G10 P2 R0 S0 							; Reset initial tool 2 active and standby temperatures to 0C

M563 P3 S"T3" D3 H4 F8 					; Define tool 3
G10 P3 X0 Y0 Z0 						; Reset tool 3 axis offsets
G10 P3 R0 S0 							; Reset initial tool 3 active and standby temperatures to 0C

; Fans
M950 F1 C"fan1"
M950 F2 C"fan2"
M950 F3 C"duex.fan3"
M950 F4 C"duex.fan4"
M950 F5 C"duex.fan5"
M950 F6 C"duex.fan6"
M950 F7 C"duex.fan7"
M950 F8 C"duex.fan8"

M106 P1 S255 H1 T70				; T0 HE
M106 P2 S0						; T0 PCF
M106 P3 S255 H2 T70 			; T1 HE
M106 P4 S0						; T1 PCF 
M106 P5 S255 H3 T70 			; T2 HE 
M106 P6 S0 						; T2 PCF
M106 P7 S255 H4 T70				; T3 HE
M106 P8 S0						; T3 PCF

M593 F42.2						; cancel ringing at 42.2Hz (https://forum.e3d-online.com/threads/accelerometer-and-resonance-measurements-of-the-motion-system.3445/)
;M376 H15						; bed compensation taper


M98 P"/sys/usr/reset_tool_offsets.g"


M575 P1 S1 B57600				; Enable LCD
G29 S2							    ; disable mesh
T-1								      ; deselect tools

M501                    ; load config-override.g

M98 P"/sys/usr/global_vars.g"