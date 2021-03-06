$PBExportHeader$w_gobang_grid.srw
forward
global type w_gobang_grid from window
end type
type st_3 from statictext within w_gobang_grid
end type
type st_2 from statictext within w_gobang_grid
end type
type sle_1 from singlelineedit within w_gobang_grid
end type
type dw_1 from datawindow within w_gobang_grid
end type
type cb_1 from commandbutton within w_gobang_grid
end type
type st_1 from statictext within w_gobang_grid
end type
end forward

global type w_gobang_grid from window
integer width = 3803
integer height = 2204
boolean titlebar = true
string title = "Gobang"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_3 st_3
st_2 st_2
sle_1 sle_1
dw_1 dw_1
cb_1 cb_1
st_1 st_1
end type
global w_gobang_grid w_gobang_grid

type variables
long il_width = 88, il_height =70 //square size
long il_detail_height = 88
long il_First = 1 //1 white flag, 0 black chess ● ○
string is_any_name[],is_any_null[]

long il_size = 15 //15*15
long il_num = 5 //win condition
boolean ilb_start = true
end variables

forward prototypes
public function boolean wf_boolean_column (string as_data)
public subroutine wf_determine_victory ()
public function boolean wf_boolean_victory (integer al_row, string as_name, integer al_qz)
end prototypes

public function boolean wf_boolean_column (string as_data);Boolean lbl_bool = False

Long ll_count,ll_i

ll_count = Long(dw_1.Describe("DataWindow.Column.Count"))

For ll_i = 1 To UpperBound(is_any_name)
	If as_data = is_any_name[ll_i] Then Return True
Next

Return False

end function

public subroutine wf_determine_victory ();
end subroutine

public function boolean wf_boolean_victory (integer al_row, string as_name, integer al_qz);//is_any_name
Long ll_i,ll_column
String ls_qz

For ll_i = 1 To UpperBound(is_any_name)
	If as_name = is_any_name[ll_i] Then
		ll_column = ll_i
		Exit
	End If
Next

// ● ○ 
If al_qz = 1 Then
	ls_qz = '○'
Else
	ls_qz = '●'
End If


Long ll_for
Long ll_top,ll_below
Long ll_left,ll_right
Long ll_number = 1
Boolean lbl_bool_one = True,lbl_bool_two = True
//up and down
For ll_for = 1 To il_num - 1
	ll_top = al_row - ll_for
	If ll_top > 0 Then
		If lbl_bool_one And dw_1.GetItemString(ll_top,ll_column) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_one = False
		End If
	End If
	
	ll_below = al_row + ll_for
	If ll_below <= dw_1.RowCount() Then
		If lbl_bool_two And dw_1.GetItemString(ll_below,ll_column) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_two = False
		End If
	End If
	
	If ll_number >= il_num Then
		Return True
	End If
Next


ll_number = 1
lbl_bool_one = True
lbl_bool_two = True

//left and right
For ll_for = 1 To il_num - 1
	ll_left = ll_column - ll_for
	If ll_left > 0 Then
		If lbl_bool_one And dw_1.GetItemString(al_row,ll_left) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_one = False
		End If
	End If
	
	ll_right = ll_column + ll_for
	If ll_right <= il_size Then
		If lbl_bool_two And dw_1.GetItemString(al_row,ll_right) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_two = False
		End If
	End If
	
	If ll_number >= il_num Then
		Return True
	End If
Next



ll_number = 1
lbl_bool_one = True
lbl_bool_two = True

//left top right bottom
For ll_for = 1 To il_num -1
	ll_top = al_row - ll_for
	ll_left = ll_column - ll_for
	If ll_left > 0 And ll_top > 0 Then
		If lbl_bool_one And dw_1.GetItemString(ll_top,ll_left) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_one = False
		End If
	End If
	
	ll_top = al_row + ll_for
	ll_right = ll_column + ll_for
	If ll_right <= il_size And ll_top <= dw_1.RowCount() Then
		If lbl_bool_two And dw_1.GetItemString(ll_top,ll_right) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_two = False
		End If
	End If
	
	If ll_number >= il_num Then
		Return True
	End If
Next

ll_number = 1
lbl_bool_one = True
lbl_bool_two = True

//Bottom left top right
For ll_for = 1 To il_num - 1
	ll_top = al_row + ll_for
	ll_left = ll_column - ll_for
	If ll_left > 0 And ll_top <= dw_1.RowCount() Then
		If lbl_bool_one And dw_1.GetItemString(ll_top,ll_left) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_one = False
		End If
	End If
	ll_top = al_row - ll_for
	ll_right = ll_column + ll_for
	
	If ll_right <= il_size And ll_top > 0 Then
		If lbl_bool_two And dw_1.GetItemString(ll_top,ll_right) = ls_qz Then
			ll_number = ll_number + 1
		Else
			lbl_bool_two = False
		End If
	End If
	
	If ll_number >= il_num Then
		Return True
	End If
Next

Return False

end function

on w_gobang_grid.create
this.st_3=create st_3
this.st_2=create st_2
this.sle_1=create sle_1
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_1=create st_1
this.Control[]={this.st_3,&
this.st_2,&
this.sle_1,&
this.dw_1,&
this.cb_1,&
this.st_1}
end on

on w_gobang_grid.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_1)
end on

event open;cb_1.triggerevent(clicked!)
end event

type st_3 from statictext within w_gobang_grid
integer x = 1193
integer y = 108
integer width = 338
integer height = 76
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Black"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_gobang_grid
integer x = 1207
integer y = 28
integer width = 338
integer height = 76
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "White"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_gobang_grid
integer x = 416
integer y = 44
integer width = 256
integer height = 96
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "15"
end type

type dw_1 from datawindow within w_gobang_grid
integer x = 64
integer y = 184
integer width = 1330
integer height = 1412
integer taborder = 20
string title = "none"
boolean border = false
boolean livescroll = true
end type

event clicked;String ls_data,ls_name
Boolean lbl_bool

This.AcceptText( )

If row > 0 And wf_boolean_column(dwo.Name) And ilb_start Then
	ls_data =  This.GetItemString(row,String(dwo.Name))
	If IsNull(ls_data) Then ls_data = ''
	
	If ls_data = '' Then
		If il_First = 1 Then
			il_First = 0
			This.SetItem(row,dwo.Name,'○')
			lbl_bool = wf_boolean_victory(row,dwo.Name,1)
			st_3.TextColor = 255
			st_2.TextColor = 0
		Else
			il_First = 1
			This.SetItem(row,dwo.Name,'●')
			lbl_bool = wf_boolean_victory(row,dwo.Name,0)
			st_2.TextColor = 255
			st_3.TextColor = 0
		End If
		
		If lbl_bool Then
			If il_First = 1 Then
				MessageBox("Tips","Black Victory")
			Else
				MessageBox("Tips","White wins")
			End If
			ilb_start = False
		End If
	End If
End If



end event

type cb_1 from commandbutton within w_gobang_grid
integer x = 690
integer y = 28
integer width = 430
integer height = 128
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Start Game"
end type

event clicked;Long ll_count,ll_i
String ls_visible,ls_name,ls_msg,ls_column
Long ll_x,ll_width,ll_height,ll_total_width = 0
Long ll_for
Long ll_insertrow
String ls_syntax,ls_err = ''

st_2.TextColor = 255
st_3.TextColor = 0
ilb_start = True
dw_1.Reset()
is_any_name = is_any_null
il_size = Long(sle_1.Text)
dw_1.SetRedraw( False)
//====================================================================
//Create DW
ls_syntax = "release 10.5;~r~n" +&
	"table("
For ll_for = 1 To il_size
	ls_column = 'a_'+String(ll_for)
	is_any_name[UpperBound(is_any_name) + 1] = ls_column
	ls_syntax =  ls_syntax +'column=(type=char(10) updatewhereclause=no name='+ls_column+' dbname="'+ls_column+'" )~r~n'
Next
ls_syntax = ls_syntax +")"

dw_1.Create(ls_syntax, ls_err)
If Len(ls_err) > 0 Then
	MessageBox('Error', 'Create DW failed! ~r~n' + ls_err)
	Return
End If
dw_1.Object.datawindow.detail.Height = il_detail_height

//=====================================================================
//Insert square (field)
For ll_for = 1 To il_size
	ll_insertrow = dw_1.InsertRow(0)
	ls_column = 'a_'+String(ll_for)
	dw_1.Modify('create column(band=detail id='+String(ll_for)+' alignment="0" tabsequence=32766 border="0" color="33554432" x="'+String(il_width * (ll_for - 1)) +'" y="6" ' +&
		'height="'+String(il_height)+'" width="'+String(il_width)+'" format="[general]" html.valueishtml="0"  name='+ls_column+' visible="1" edit.limit=0 edit.case=any ' +&
		'edit.autoselect=yes edit.imemode=0  font.face="Arial" font.height="-14" font.weight="400"  font.family="2" ' +&
		'font.pitch="2" font.charset="134" background.mode="2" background.color="1073741824" )')
Next
//messagebox("",dw_1.Describe("datawindow.syntax"))

//=====================================================================
// vertical line
// first line
dw_1.Modify('create line(band=detail x1="0" y1="0" x2="0" y2="'+String(il_detail_height)+'"  name=l_1 visible="1" pen.style="0"'  +&
	'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")')
For ll_i = 1 To UpperBound(is_any_name)
	ls_name = is_any_name[ll_i]
	ll_x = Long(dw_1.Describe(ls_name+".x"))
	ll_width = Long(dw_1.Describe(ls_name+".width"))
	ll_total_width = ll_total_width + ll_width
	ll_x = ll_x+ll_width
	
	//subsequent lines
	dw_1.Modify('create line(band=detail x1="'+String(ll_x)+'" y1="0" x2="'+String(ll_x)+'" y2="'+String(il_detail_height)+'"  name=l_1 visible="1" pen.style="0"'  +&
		'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")')
Next
//=====================================================================
//horizontal
// first line
dw_1.Modify('create line(band=detail x1="0" y1="1" x2="'+String(ll_total_width)+'" y2="1"  name=l_2 visible="1~tif (getrow() = 1,1,0)" pen.style="0"'  +&
	'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")')
//subsequent lines	
dw_1.Modify('create line(band=detail x1="0" y1="'+String(il_detail_height - 10)+'" x2="'+String(ll_total_width)+'" y2="'+String(il_detail_height - 10)+'"  name=l_2 visible="1" pen.style="0"'  +&
	'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")')

dw_1.SetRedraw( True)
dw_1.Object.datawindow.Selected.Mouse = 'No'

dw_1.Width = ll_total_width + 10
dw_1.Height = il_detail_height * il_size + 10
Parent.Width = ll_total_width + 200
Parent.Height = (il_detail_height * il_size) + 400
Parent.center = True


end event

type st_1 from statictext within w_gobang_grid
integer x = 64
integer y = 44
integer width = 366
integer height = 108
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Size："
boolean focusrectangle = false
end type

