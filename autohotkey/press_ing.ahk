G::
CoordMode, Mouse , Screen
MouseGetPos, pngX, pngY
Msgbox % "Current_position" . pngX . ", " . pngY
Return


A::
CoordMode, Mouse , Screen
__ClickX:=pngX
__ClickY:=pngY
Click, Up
MouseMove, %__ClickX%, %__ClickY%
Sleep % 50
Click, Down
while GetKeystate("a"){
    MouseMove, %__ClickX%, %__ClickY%
}
Click, Up
Sleep % 50
Return


D::
CoordMode, Mouse , Screen
__ClickX:=(pngX+50)
__ClickY:=pngY
Click, Up
MouseMove, %__ClickX%, %__ClickY%
Sleep % 50
Click, Down
while GetKeystate("d"){
    MouseMove, %__ClickX%, %__ClickY%
}
Click, Up
Return

S::
CoordMode, Mouse , Screen
__ClickX:=(pngX+100)
__ClickY:=pngY
Click, Up
MouseMove, %__ClickX%, %__ClickY%
Sleep % 50
Click, Down
while GetKeystate("s"){
    MouseMove, %__ClickX%, %__ClickY%
}
Click, Up
Return
