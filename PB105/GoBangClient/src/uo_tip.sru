$PBExportHeader$uo_tip.sru
forward
global type uo_tip from userobject
end type
type st_1 from statictext within uo_tip
end type
end forward

global type uo_tip from userobject
integer width = 1467
integer height = 328
long backcolor = 16777215
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_1 st_1
end type
global uo_tip uo_tip

type prototypes
Function boolean AnimateWindow ( long hwnd, long dwtime, long dwflags ) library "user32.dll"

end prototypes

type variables

Constant Long  AW_HOR_POSITIVE      = 1
Constant Long AW_HOR_NEGATIVE =  2
Constant Long AW_VER_POSITIVE =  4
Constant Long AW_VER_NEGATIVE = 8
Constant Long AW_CENTER = 16
Constant Long AW_HIDE =   65526
Constant Long AW_ACTIVATE   =  131072
Constant Long AW_SLIDE = 262144
Constant Long AW_BLEND = 524288

end variables
forward prototypes
public subroutine of_text (string as_text)
end prototypes

public subroutine of_text (string as_text);
st_1.text = as_text

end subroutine

on uo_tip.create
this.st_1=create st_1
this.Control[]={this.st_1}
end on

on uo_tip.destroy
destroy(this.st_1)
end on

event constructor;long ll_handle

ll_handle = Handle(this)
AnimateWindow(ll_handle,300,AW_SLIDE+AW_VER_POSITIVE+AW_ACTIVATE)








end event

type st_1 from statictext within uo_tip
integer y = 80
integer width = 1440
integer height = 152
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

