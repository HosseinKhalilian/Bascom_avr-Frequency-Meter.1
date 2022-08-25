'======================================================================='

' Title: LCD Display frequency meter
' Last Updated :  01.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega16 + 16x2 Character lcd display

'======================================================================='

$regfile = "m16def.dat"
$crystal = 8000000

Config Timer1 = Counter , Edge = Rising
Config Timer2 = Timer , Prescale = 8
Config Porta = Input

Config Lcdpin = Pin , Db4 = Portd.4 , Db5 = Portd.5 , Db6 = Portd.6 , _
Db7 = Portd.7 , E = Portd.3 , Rs = Portd.2
Config Lcd = 16 * 2

Dim A As Long
Dim C As Word
Dim D As Byte
Dim F As Single
Dim S As Byte

Enable Ovf1
On Ovf1 Count
Enable Timer2
On Ovf2 Tim

Cursor Off
Cls
Locate 1 , 4
Lcd "ENTER RANGE"

'-----------------------------------------------------------

Main1:

D = Pina

If D = &B00000001 Then
Incr S
If S > 2 Then S = 0

Select Case S

Case Is = 0
Cls
Lcd "RANGE:" ; " Hz"

Case Is = 1
Cls
Lcd "RANGE:" ; " KHz"

Case Is = 2
Cls
Lcd "RANGE:" ; " MHz"

End Select

''''''''''''''''''''''''''''''

Main2:

D = Pina

If D <> 0 Then Goto Main2
End If
If D = &B00000010 Then
Goto Main3
End If
Waitms 100
Goto Main1

''''''''''''''''''''''''''''''

Main3:

Enable Interrupts
Counter1 = 0
Timer2 = 56
Start Timer2

Do

Loop

End

''''''''''''''''''''''''''''''

Tim:

Stop Timer2
Incr C
If C = 5000 Then
F = A * 65536
F = F + Counter1

Select Case S

Case Is = 0
Cls
Home
Lcd "FREQUENCE:"
Lowerline
Lcd F ; " Hz"

Case Is = 1
F = F / 1000
Cls
Home
Lcd "FREQUENCE:"
Lowerline
Lcd F ; " KHz"

Case Is = 2
F = F / 1000000
Cls
Home
Lcd "FREQUENCE:"
Lowerline
Lcd F ; " MHz"

End Select

A = 0
Counter1 = 0
C = 0

End If

Timer2 = 56
Start Timer2

Return

''''''''''''''''''''''''''''''

Count:

Incr A
Counter1 = 0

Return

'-----------------------------------------------------------



