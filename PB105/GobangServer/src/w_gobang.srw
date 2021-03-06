$PBExportHeader$w_gobang.srw
forward
global type w_gobang from window
end type
type cb_3 from commandbutton within w_gobang
end type
type lb_1 from listbox within w_gobang
end type
type cb_socket from commandbutton within w_gobang
end type
type cb_hq from commandbutton within w_gobang
end type
type dw_coordinates from datawindow within w_gobang
end type
type sle_1 from singlelineedit within w_gobang
end type
type dw_1 from datawindow within w_gobang
end type
type cb_1 from commandbutton within w_gobang
end type
type st_1 from statictext within w_gobang
end type
end forward

global type w_gobang from window
integer width = 3264
integer height = 1852
boolean titlebar = true
string title = "Gobang - Black"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
event socketnotify pbm_custom01
event ue_socketmsg ( string sclientname,  long isocketnum,  integer ievent,  integer iret,  string smsg )
cb_3 cb_3
lb_1 lb_1
cb_socket cb_socket
cb_hq cb_hq
dw_coordinates dw_coordinates
sle_1 sle_1
dw_1 dw_1
cb_1 cb_1
st_1 st_1
end type
global w_gobang w_gobang

type prototypes

end prototypes

type variables
Long il_width = 88, il_height = 70 //square size
Long il_First = 0 //1 white flag, 0 black ○ ●
String is_any_name[],is_any_null[]

String is_white = '○',is_black = '●' //chess pieces
Long is_white_color = 16777215,is_black_color = 0 //background color

Long il_size = 15 //15*15
Long il_num = 5 //5 children are connected, victory condition
Boolean ilb_start = False,ilb_ks = False

uo_tip tip

//socket
SocketStream sServer
Int iPort = 2000 //Port
ULong ulAddr

uo_Socket_Server Socket_Server

Boolean lbl_send = True
Long il_column, il_row

uo_Socket_Server Connects[]

end variables

forward prototypes
public function boolean wf_boolean_column (string as_data)
public subroutine wf_determine_victory ()
public function long wf_retrun_column (string as_name)
public subroutine wf_back ()
public function boolean wf_judge_outcome (integer al_row, long al_column, integer al_qz)
public function integer wf_disconnect (integer isocketnum)
public subroutine wf_tip (string as_msg)
public function any wf_split (string as_bj, string as_input)
public subroutine wf_dwnull ()
end prototypes

event socketnotify;ULong ulClientAddr
Long tmpSocketNum
Int	iClientPort

tmpSocketNum = sServer.Accept(ulClientAddr, iClientPort)

pbhostent tmpHostent

tmpHostent = ws.GetHostByAddr(ulClientAddr)
If IsNull(tmpHostent) Then Return


OpenUserObject(Socket_Server,0,0)
Socket_Server.Event SocketInit(This, tmpSocketNum, ulClientAddr, iClientPort)
Socket_Server.Visible = False


end event

event ue_socketmsg(string sclientname, long isocketnum, integer ievent, integer iret, string smsg);/*
Description: This event is responsible for processing the message returned by the uo_socket_Server object
*/
Long ll_type
String ls_text
Long ll_row, ll_column
String ls_arr[]

lb_1.AddItem(String(Today(), "yyyy-mm-dd") + ' '+String(Now(), "hh:mm:ss"))
Choose Case iEvent
	Case ws.FD_READ
		If iret = -1 Then
			MessageBox("Prompt","FD_READ unknown")
		Else
			ls_arr = wf_split(':',sMsg)
			il_row = Long(ls_arr[1])
			il_column = Long(ls_arr[2])
			ll_type = Long(ls_arr[3])
			
			If ll_type = 1 Then //Receive
				ilb_start = True
				dw_1.Event Clicked(1,1,il_row,dw_1.Object.a_1)
				lb_1.AddItem('white chess point [' + String(il_row) +':' +String(il_column)+']')
			ElseIf ll_type = 2 Then // apply for repentance
				If MessageBox('Prompt message','White applies for repentance, do you agree?',Question! ,YesNo! , 1 ) = 1 Then
					ls_text = 'White applies for repentance - agree'
					ilb_start = False
					Socket_Server.Write_Data = Blob('1:1:3')
					wf_back()
				Else
					ls_text = 'White applies for repentance - disagree'
					ilb_start = True
					Socket_Server.Write_Data = Blob('1:0:3')
				End If
				lb_1.AddItem(ls_text)
				Socket_Server.WriteMsg()
			ElseIf ll_type = 3 Then //repent
				If il_column = 1 Then
					ls_text = 'White agrees to repent'
					ilb_start = True
					wf_back()
				Else
					ls_text = 'White does not agree to repent'
					ilb_start = False
					MessageBox("Prompt","White does not agree to repent")
				End If
				lb_1.AddItem(ls_text)
			End If
		End If
	Case ws.FD_WRITE
		If iret = -1 Then
			lb_1.AddItem('Sending data failed')
		ElseIf iret = 0 Then
			cb_3.TriggerEvent(Clicked!)
			lb_1.AddItem('Start the game')
			wf_tip('Start the game')
			Timer(2)
			ilb_ks = True
		Else
			ls_arr = wf_split(':',sMsg)
			il_row = Long(ls_arr[1])
			il_column = Long(ls_arr[2])
			ll_type = Long(ls_arr[3])
			If ll_type = 1 Then lb_1.AddItem('own chess point [' + String(il_row) +':' +String(il_column)+']')
		End If
		
	Case ws.FD_CLOSE
		MessageBox("","Object closed")
	Case ws.FD_OOB
		ls_text = 'Unknown error'
		lb_1.AddItem(ls_text)
	Case Else
		ls_text = "Unknown communication event:" + String(iEvent)
		lb_1.AddItem(ls_text)
End Choose
lb_1.AddItem(Fill('-', 50))
lb_1.SetTop(lb_1.TotalItems())

end event

public function boolean wf_boolean_column (string as_data);//Check if column exists
Boolean lbl_bool = False

Long ll_count,ll_i

ll_count = Long(dw_1.Describe("DataWindow.Column.Count"))

For ll_i = 1 To UpperBound(is_any_name)
	If as_data = is_any_name[ll_i] Then Return True
Next

Return False

end function

public subroutine wf_determine_victory ();
end subroutine

public function long wf_retrun_column (string as_name);//reverse serial number
Long ll_i,ll_column = 0

For ll_i = 1 To UpperBound(is_any_name)
	If as_name = is_any_name[ll_i] Then
		ll_column = ll_i
		Exit
	End If
Next

Return ll_column

end function

public subroutine wf_back ();//regret
Long ll_rowcount
Long ll_row,ll_column,ll_First

ll_rowcount = dw_coordinates.RowCount()

If ll_rowcount > 0 Then
	ll_row = dw_coordinates.Object.a[ll_rowcount]
	ll_column = dw_coordinates.Object.b[ll_rowcount]
	ll_First = dw_coordinates.Object.c[ll_rowcount]
	
	dw_1.SetItem(ll_row,ll_column,'')
	il_First = ll_First
	
	dw_coordinates.DeleteRow(ll_rowcount)
	
	If il_First = 1 Then
		This.BackColor = is_white_color
	Else
		This.BackColor = is_black_color
	End If
End If


end subroutine

public function boolean wf_judge_outcome (integer al_row, long al_column, integer al_qz);//is_any_name
Long ll_i,ll_column
String ls_qz

ll_column = al_column //wf_retrun_column(as_name)
// ● ○ 
If al_qz = 1 Then
	ls_qz = is_white
Else
	ls_qz = is_black
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

public function integer wf_disconnect (integer isocketnum);CloseUserObject(Socket_Server)
If ilb_ks Then
	wf_tip("White throws in the towel")
End If
Return 1

end function

public subroutine wf_tip (string as_msg);//
If IsValid(tip) Then
	CloseUserObject(tip)
End If

tip = Create uo_tip
tip.st_1.Text = as_msg
OpenUserObject(tip,(This.Width/2) - (tip.Width/2),(This.Height/2) - (tip.Height/2))

end subroutine

public function any wf_split (string as_bj, string as_input);//====================================================
// split string by symbol
//==================================================
String ls_list[] //Receive the returned string list
String ls_temp
Integer i = 1
Long ll_pos
Integer li_len

li_len = Len(as_bj) //The length of the separator
ll_pos = Pos(as_input,as_bj)

Do
	If ll_pos = 0 Then
		ls_list[i] = as_input
	Else
		ls_list[i] = Left(as_input, ll_pos - 1)
		i++
		as_input = Mid(as_input,ll_pos + li_len)
		ll_pos = Pos(as_input,as_bj)
		If ll_pos = 0 Then ls_list[i] = as_input
	End If
Loop While ll_pos <> 0

Return ls_list

end function

public subroutine wf_dwnull ();Long ll_row
For ll_row = 1 To dw_1.RowCount()
	dw_1.Object.pd[ll_row] = 0
Next

end subroutine

on w_gobang.create
this.cb_3=create cb_3
this.lb_1=create lb_1
this.cb_socket=create cb_socket
this.cb_hq=create cb_hq
this.dw_coordinates=create dw_coordinates
this.sle_1=create sle_1
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_1=create st_1
this.Control[]={this.cb_3,&
this.lb_1,&
this.cb_socket,&
this.cb_hq,&
this.dw_coordinates,&
this.sle_1,&
this.dw_1,&
this.cb_1,&
this.st_1}
end on

on w_gobang.destroy
destroy(this.cb_3)
destroy(this.lb_1)
destroy(this.cb_socket)
destroy(this.cb_hq)
destroy(this.dw_coordinates)
destroy(this.sle_1)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_1)
end on

event open;Int iret

sServer = Create SocketStream
sServer.WSAAsyncSelect(Handle(This),1024,ws.FD_ACCEPT)

//Get the computer host name
sHostName = Space(64)
ws.GetHostName(sHostName,Len(sHostName))

iHostent = ws.GetHostByName(sHostName)
If IsNull(iHostent) Then
	MessageBox("server: error", "Failed to get local IP!")
	Destroy sServer
	Return
End If


ulAddr = iHostent.h_addr_list[1]

ULong ultmp1, ultmp2, ultmp, i, j
String ls_add[4]
ultmp2 = ulAddr
j = 6
For i = 1 To 4
	ultmp = 16^j
	j = j - 2
	ultmp1 = ultmp2 / ultmp
	ls_add[5 - i] = String(ultmp1)
	ultmp2 = ultmp2 - ultmp1 * ultmp
Next

This.Title = This.Title + "[" +ls_add[1] + "." + ls_add[2] + "." + ls_add[3] + "." + ls_add[4]+"]"

cb_1.TriggerEvent(Clicked!)

end event

event close;If IsValid(sServer) Then
	sServer.CloseSocket()
	Destroy sServer
End If

end event

event timer;If IsValid(tip) Then
	CloseUserObject(tip)
End If
Timer(0)

end event

type cb_3 from commandbutton within w_gobang
boolean visible = false
integer x = 2789
integer y = 44
integer width = 375
integer height = 128
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "draw chessboard"
end type

event clicked;long ll_count,ll_i
string ls_visible,ls_name,ls_msg,ls_column
long ll_x,ll_y,ll_width,ll_height,ll_total_width = 0
long ll_for
long ll_insertrow 
string ls_syntax,ls_err = ''

//====================================================================
//initial
dw_1.reset()
dw_coordinates.reset()
ilb_start = true
is_any_name = is_any_null
il_size = long(sle_1.text)
il_First = 0
lb_1.reset( )

parent.closeuserobject(tip)
tip= create uo_tip
if il_First = 1 then
	parent.backcolor = is_white_color  
else
	parent.backcolor = is_black_color 
end if

dw_1.setredraw( false)
//====================================================================
//Create DW
ls_syntax = "release 10.5;~r~n" +&
        "table("
for ll_for = 1 to il_size
	 ls_column = 'a_'+string(ll_for)
	 is_any_name[upperbound(is_any_name) + 1] = ls_column
    ls_syntax=  ls_syntax +'column=(type=char(10) updatewhereclause=no name='+ls_column+' dbname="'+ls_column+'" )~r~n'
next
ls_syntax=  ls_syntax +'column=(type=number updatewhereclause=no name=pd dbname="pd" )~r~n'
ls_syntax = ls_syntax +")"

dw_1.create(ls_syntax, ls_err)
if len(ls_err) > 0 then
   messageBox('Error', 'Create DW failed! ~r~n' + ls_err)
   return
end if
dw_1.object.datawindow.detail.height = il_height
dw_1.object.datawindow.Header.height = il_height

//=====================================================================


//Insert square (field)
for ll_for = 1 to il_size
	ll_insertrow = dw_1.insertrow(0)
	ls_column = 'a_'+string(ll_for)
	ll_x = il_width * (ll_for - 1) +il_width
	dw_1.Modify('create column(band=detail id='+string(ll_for)+' alignment="2" tabsequence=32766 border="0" color="33554432~tif (pd = '+string(ll_for)+',255,0)" x="'+string(ll_X) +'" y="6" ' +&
		'height="'+string(il_height)+'" width="'+string(il_width)+'" format="[general]" html.valueishtml="0"  name='+ls_column+' visible="1" edit.limit=0 edit.case=any ' +&
		'edit.autoselect=yes edit.imemode=0  font.face="Arial" font.height="-14" font.weight="400"  font.family="2" ' +&
		'font.pitch="2" font.charset="134" background.mode="2" background.color="16777215" )')
next
//messagebox("",dw_1.Describe("datawindow.syntax"))

//=====================================================================
//vertical bar
ll_x = 0
for ll_i = 1 to il_size
		ls_name = is_any_name[ll_i]
		ll_x = long(dw_1.describe(ls_name+".x"))
		ll_width = long(dw_1.describe(ls_name+".width"))
		ll_total_width = ll_total_width + ll_width 
		
		ll_x = (ll_x+ll_width -3) - (il_width / 2)
		ll_y = (il_height / 2 ) + 8
		//subsequent lines
		dw_1.Modify('create line(band=detail x1="'+string(ll_x)+'" x2="'+string(ll_x)+'" '+& 
		'y1="0~tif(getrow() = 1,'+string(ll_y)+',0)" y2="'+string(ll_y)+'~tif(getrow() = '+string(il_size)+','+string(ll_y)+','+string(il_height)+')"  name=l_1 visible="1" pen.style="0"'  +&
		'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")') 

		
next

//=====================================================================
ll_y = (il_height / 2) + 5
ll_x = (il_width / 2) + il_width
ll_total_width = ll_total_width + ll_width + ll_width
//horizontal line
dw_1.Modify('create line(band=detail y1="'+string(ll_y)+'"  y2="'+string(ll_y)+'" x1="'+string(ll_x)+'"  x2="'+string(ll_total_width - ll_x )+'" name=l_2 visible="1" pen.style="0"'  +&
		'pen.width="4" pen.color="33554432"  background.mode="2" background.color="1073741824")')

////increase serial number
dw_1.Modify("create compute(band=Detail"  +  &
" color='0' alignment='2' border='0'" + &
" x='0' y='0' height='"+string(il_height)+"' width='"+string(il_width)+"'" + &
" name=serial  expression='getrow()' " + &
" font.height='-12' font.face='Arial' background.mode='2' background.color='16777215')")

ll_x= 0
for ll_i = 1 to il_size
		dw_1.Modify("create text(band=Header"  +  &
		"  alignment='2' border='0'"  +  &
		"  x='"+string(ll_x+il_width)+"' y='"+string(0)+"' height='"+string(il_height)+"' width='"+string(il_width)+"'  text='"+string(ll_i)+"' name=t_serialnumber "  +  &
		"  font.height='-12' font.face='Arial' background.mode='2' background.color='16777215')")
		ll_x = ll_x + il_width
next


dw_1.setredraw(true)
dw_1.Object.DataWindow.Selected.Mouse='No' 

//dw_1.width = il_width * il_size
//dw_1.height = (il_height + 1) * il_size 
//parent.width = (il_width * il_size) + PixelsToUnits(dw_1.x,XPixelsToUnits!)
//parent.height = (il_height * il_size) + 400
//parent.center= true




end event

type lb_1 from listbox within w_gobang
integer x = 18
integer y = 8
integer width = 1262
integer height = 1668
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type cb_socket from commandbutton within w_gobang
boolean visible = false
integer x = 2482
integer y = 28
integer width = 457
integer height = 124
integer taborder = 40
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Socket"
end type

event clicked;Int iRet

If Not IsValid(sServer) Then
	sServer = Create SocketStream
	sServer.WSAAsyncSelect(Handle(This),1024,ws.FD_ACCEPT)
End If

iRet = sServer.bind(ulAddr,iPort)
If iRet = ws.SOCKET_ERROR Then
	MessageBox("Server error:" + String(ws.WSAGetLastError()), "Cannot bind port:" + String(iPort))
	Return -1
End If

iRet = sServer.Listen(5)
If iRet = ws.SOCKET_ERROR Then
	MessageBox("Server error:" + String(ws.WSAGetLastError()), "Listening port:" + String(iPort) + "Failed!")
	Return -1
End If

end event

type cb_hq from commandbutton within w_gobang
integer x = 2235
integer y = 40
integer width = 229
integer height = 128
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Back"
end type

event clicked;String ls_send

If il_First = 1 Then
	//send
	If IsValid(Socket_Server) Then
		ls_send = '1:1:2'
		Socket_Server.Write_Data = Blob(ls_send)
		Socket_Server.WriteMsg()
	End If
End If

//
//wf_back()
//	if il_First = 1 then
//	parent.backcolor = is_white_color  
//	else
//		parent.backcolor = is_black_color 
//	end if

end event

type dw_coordinates from datawindow within w_gobang
boolean visible = false
integer y = 1660
integer width = 549
integer height = 320
integer taborder = 30
string title = "none"
string dataobject = "d_coordinates"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_gobang
integer x = 1472
integer y = 52
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
boolean enabled = false
string text = "20"
end type

type dw_1 from datawindow within w_gobang
integer x = 1285
integer y = 184
integer width = 1856
integer height = 1492
integer taborder = 20
string title = "none"
boolean border = false
boolean livescroll = true
end type

event clicked;String ls_data,ls_name
Boolean lbl_bool
String ls_text = ''
Long ll_insertrow,ll_column,ll_row
String ls_send
Blob rn

This.AcceptText( )

If row > 0 And wf_boolean_column(dwo.Name) And ilb_start Then
	If il_First = 0 Then //self
		ll_column = wf_retrun_column(dwo.Name)
		ll_row = row
	Else //Receive
		ll_column = il_column
		ll_row = il_row
	End If
	ls_data = This.GetItemString(ll_row,ll_column)
	If IsNull(ls_data) Then ls_data = ''
	
	If ls_data <> is_white And ls_data <> is_black Then
		//Record the chess point
		ll_insertrow = dw_coordinates.InsertRow(0)
		dw_coordinates.Object.a[ll_insertrow] = ll_row
		dw_coordinates.Object.b[ll_insertrow] = ll_column
		dw_coordinates.Object.c[ll_insertrow] = il_First
		wf_dwnull()
		
		If il_First = 1 Then
			This.SetItem(row,'pd',ll_column)
			This.SetItem(ll_row,ll_column,is_white)
			lbl_bool = wf_judge_outcome(ll_row,ll_column,il_First)
			il_First = 0
			ls_text = 'White wins'
			Parent.BackColor = is_black_color
		Else
			This.SetItem(ll_row,ll_column,is_black)
			lbl_bool = wf_judge_outcome(ll_row,ll_column,il_First)
			il_First = 1
			ls_text = 'Black wins'
			Parent.BackColor = is_white_color
			//send
			If IsValid(Socket_Server) Then
				ls_send = String(ll_row) + ':' + String(ll_column) + ':1'
				Socket_Server.Write_Data = Blob(ls_send)
				Socket_Server.WriteMsg()
				ilb_start = False
			End If
		End If
		
		//Finish
		If lbl_bool Then
			wf_tip(ls_text)
			ilb_start = False
			ilb_ks = False
		End If
	End If
End If

end event

type cb_1 from commandbutton within w_gobang
integer x = 1774
integer y = 40
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

event clicked;cb_Socket.triggerevent(clicked!)
wf_tip('Waiting for players to enter...')


end event

type st_1 from statictext within w_gobang
integer x = 1312
integer y = 48
integer width = 155
integer height = 104
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Size"
alignment alignment = center!
boolean focusrectangle = false
end type

