##0 "hspdef.as"





























































































































































##0 "main.hsp"

























##0 "mod_menu.as"











#uselib "user32.dll"
#func createmenu         "CreateMenu"
#func createpopupmenu    "CreatePopupMenu"
#func appendmenu         "AppendMenuA"           int, int, int, str
#func setmenu            "SetMenu"               int, int
#func drawmenubar        "DrawMenuBar"           int
#func postmessage        "PostMessageA"          int, int, sptr, sptr





#module menumod
goto@hsp *_menumod_exit
##24

#deffunc newmenu var _p1@menumod,int _p2@menumod







if@hsp _p2@menumod=0 : createmenu
if@hsp _p2@menumod=1 : createpopupmenu
_p1@menumod = stat@hsp
return@hsp

#deffunc addmenu int _p1@menumod,str _p2@menumod,int _p3@menumod,int _p4@menumod









appendmenu _p1@menumod, _p4@menumod, _p3@menumod, _p2@menumod
return@hsp

#deffunc applymenu int _p1@menumod






setmenu hwnd@hsp, _p1@menumod      
drawmenubar hwnd@hsp         
return@hsp

*_menumod_exit
#global
##63



##26 "main.hsp"
##0 "mod_stbar.as"






#module stbar
goto@hsp *_stbar_exit
##7
#uselib "user32"
#func getwindowrect@stbar "GetWindowRect" int, var

#deffunc stbar_bye 

act@stbar= ginfo@hsp(3)
if@hsp sthwnd@stbar(act@stbar)=0 : return@hsp
clrobj@hsp stbar(act@stbar)
return@hsp

#deffunc stbar_ini 


act@stbar= ginfo@hsp(3)
winobj@hsp "msctls_statusbar32","",0,$50000000
stbar(act@stbar) = stat@hsp		
if@hsp stbar(act@stbar)<0 : dialog@hsp "ステータスバー作成に失敗しました" : return@hsp
sthwnd@stbar(act@stbar) = objinfo@hsp(stbar(act@stbar), 2)	
dim@hsp stsize@stbar, 4 		
getwindowrect@stbar sthwnd@stbar, stsize@stbar
stbar_sx@stbar(act@stbar) = stsize@stbar(2) - stsize@stbar(0)	
stbar_sy@stbar(act@stbar) = stsize@stbar(3) - stsize@stbar(1)	
return@hsp

#deffunc stbar_text str _p1@stbar

act@stbar= ginfo@hsp(3)
if@hsp sthwnd@stbar(act@stbar)=0 : return@hsp
msg@stbar=_p1@stbar
sendmsg@hsp sthwnd@stbar(act@stbar), $0401, 0, varptr@hsp(msg@stbar) 
return@hsp

#deffunc stbar_resize 

act@stbar= ginfo@hsp(3)
if@hsp sthwnd@stbar(act@stbar)=0 : return@hsp
sendmsg@hsp sthwnd@stbar(act@stbar), $0005, 0, 0	 
return@hsp

*_stbar_exit
#global
##47


##27 "main.hsp"
##0 "mod_fontdlg.as"
#module m0
goto@hsp *_m0_exit
##1
#uselib "gdi32.dll"
#func getobject@m0 "GetObjectA" int,int,var

#uselib "COMDLG32.DLL"
#func choosefont@m0 "ChooseFontA" var




#deffunc fontdlg array prm1@m0,int prm2@m0
mref@hsp bmscr@m0,67
mref@hsp ref@m0,65
noption@m0 = prm2@m0 : if@hsp noption@m0<=0 : noption@m0=0

dim@hsp lpobject@m0,64   
dim@hsp chf@m0,15        
dim@hsp retval@m0,8      

getobject@m0 bmscr@m0(38),60,lpobject@m0


chf@m0(0)  = 60
chf@m0(1)  = hwnd@hsp
chf@m0(3)  = varptr@hsp(lpobject@m0)
chf@m0(5)  = $41|noption@m0
chf@m0(6)  = bmscr@m0(40)
chf@m0(12) = $2000

choosefont@m0 chf@m0
ret@m0=stat@hsp
if@hsp ret@m0!0 {
repeat@hsp 32
prm@m0=peek@hsp(lpobject@m0,28+cnt@hsp)
poke@hsp ref@m0,cnt@hsp,prm@m0
if@hsp prm@m0=0 : break@hsp
loop@hsp
retval@m0(0) = -1*lpobject@m0(0)
if@hsp lpobject@m0(4)>400 : retval@m0(1)=1 : else@hsp : retval@m0(1)=0
if@hsp ((lpobject@m0(5))&&($FF))!0 : retval@m0(1)+=2
retval@m0(2) = chf@m0(4)/10
retval@m0(3) = peek@hsp(chf@m0,24)
retval@m0(4) = peek@hsp(chf@m0,25)
retval@m0(5) = peek@hsp(chf@m0,26)
retval@m0(6) = peek@hsp(lpobject@m0,21)
retval@m0(7) = peek@hsp(lpobject@m0,22)
}
repeat@hsp 8 : prm1@m0(cnt@hsp)=retval@m0(cnt@hsp) : loop@hsp











dim@hsp lpobject@m0,0  : dim@hsp chf@m0,0 : dim@hsp retval@m0,0
return@hsp ret@m0
*_m0_exit
#global
##62
##28 "main.hsp"
##0 "obj.as"






#module llmod_obj
goto@hsp *_llmod_obj_exit
##7

#uselib "user32.dll"
#func _iswindowenabled@llmod_obj "IsWindowEnabled" int
#func _enablewindow@llmod_obj "EnableWindow" int,int
#func _getwindowrect@llmod_obj "GetWindowRect" int,int
#func _movewindow@llmod_obj "MoveWindow" int,int,int,int,int,int
#func _screentoclient@llmod_obj "ScreenToClient" int,int

#deffunc objgray int v1@llmod_obj,int v2@llmod_obj













if@hsp v2@llmod_obj<0 {
_iswindowenabled@llmod_obj objinfo@hsp(v1@llmod_obj,2) 
}else@hsp{
_enablewindow@llmod_obj objinfo@hsp(v1@llmod_obj,2) ,v2@llmod_obj
}
return@hsp stat@hsp


#deffunc p_scrwnd array v4@llmod_obj
















mref@hsp bmscr@llmod_obj,67
prm@llmod_obj=bmscr@llmod_obj.13
_screentoclient@llmod_obj prm@llmod_obj, varptr@hsp(v4@llmod_obj)
return@hsp


#deffunc getobjsize array v1@llmod_obj,int v2@llmod_obj



























mref@hsp bmscr@llmod_obj,67
prm@llmod_obj=bmscr@llmod_obj.13
v1@llmod_obj.5=0

_getwindowrect@llmod_obj objinfo@hsp(v2@llmod_obj,2) , varptr@hsp(v1@llmod_obj)+8
res@llmod_obj=stat@hsp
v1@llmod_obj=v1@llmod_obj.4-v1@llmod_obj.2 , v1@llmod_obj.5-v1@llmod_obj.3
_screentoclient@llmod_obj prm@llmod_obj, varptr@hsp(v1@llmod_obj)+8
_screentoclient@llmod_obj prm@llmod_obj, varptr@hsp(v1@llmod_obj)+16
return@hsp res@llmod_obj


#deffunc resizeobj int v1@llmod_obj,array v2@llmod_obj,int v3@llmod_obj





































sx@llmod_obj=v2@llmod_obj(0):sy@llmod_obj=v2@llmod_obj(1):x@llmod_obj=v2@llmod_obj(2):y@llmod_obj=v2@llmod_obj(3)
if@hsp v3@llmod_obj {			
getobjsize m@llmod_obj,v1@llmod_obj		
if@hsp stat@hsp=-1 : return@hsp stat@hsp
if@hsp v3@llmod_obj=1 : x@llmod_obj=m@llmod_obj(2):y@llmod_obj=m@llmod_obj(3)		
if@hsp v3@llmod_obj=2 : sx@llmod_obj=m@llmod_obj:sy@llmod_obj=m@llmod_obj(1)		
}
_movewindow@llmod_obj objinfo@hsp(v1@llmod_obj,2) ,x@llmod_obj,y@llmod_obj,sx@llmod_obj,sy@llmod_obj,1
return@hsp stat@hsp


*_llmod_obj_exit
#global
##150



##29 "main.hsp"
##0 "mod_xime.as"



































#module local_module
goto@hsp *_local_module_exit
##36

ch@modxime=0
looping@modxime=0

#deffunc loop_end_func@local_module 
loop_end@modxime(ch@modxime,looping@modxime(ch@modxime))=-1
loop_time@modxime(ch@modxime,looping@modxime(ch@modxime))=0
loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime))=0
return@hsp

*_local_module_exit
#global
##47

#module modxime
goto@hsp *_modxime_exit
##49























sdim@hsp mmllist@modxime,,128
sdim@hsp text@modxime
sdim@hsp textline@modxime
sdim@hsp sheet_back@modxime

#deffunc mml_cleanup onexit
_mmlstop 0.0




return@hsp

*compile@modxime
error@modxime=0
warning@modxime=0
warning_num@modxime=0
chord@modxime=0
sdim@hsp mml@modxime,65536
notesel@hsp text@modxime
repeat@hsp  noteinfo@hsp(0)
noteget@hsp textline@modxime,cnt@hsp
split@hsp textline@modxime,";",textline@modxime
split@hsp textline@modxime,"//",textline@modxime
noteadd@hsp textline@modxime,cnt@hsp,1
loop@hsp
mml@modxime=text@modxime
ch@modxime=0
tempo_num@modxime=1
tempo@modxime=120
ct_time@modxime=0.0
repeat@hsp 16
length_@modxime(cnt@hsp)=4.0
octave@modxime(cnt@hsp)=4
velocity@modxime(cnt@hsp)=96
time@modxime(cnt@hsp)=0.0
qlength@modxime(cnt@hsp)=0.0
key_scale@modxime(cnt@hsp)=0
slur@modxime(cnt@hsp)=0
looping@modxime(cnt@hsp)=0
loop@hsp
dim@hsp loop_pos@modxime,16,64
dim@hsp loop_time@modxime,16,64
dim@hsp loop_cnt@modxime,16,64
dim@hsp loop_end@modxime,16,64
sdim@hsp sheet@modxime,65536
sdim@hsp dispos@modxime
notesel@hsp mml@modxime
title_line@modxime=notefind@hsp("#title",1)
copy_line@modxime=notefind@hsp("#copy",1)
if@hsp title_line@modxime!=-1{
sdim@hsp mml_title@modxime,2
noteget@hsp mml_title@modxime,title_line@modxime
notedel@hsp title_line@modxime
noteadd@hsp "",title_line@modxime
mml_title@modxime=strmid@hsp(mml_title@modxime,6,strlen@hsp(mml_title@modxime)-6)
split@hsp mml_title@modxime,"\"",mml_title@modxime
if@hsp stat@hsp>=2{
mml_title@modxime=mml_title@modxime(1)
}
}else@hsp{
mml_title@modxime=0
}
if@hsp copy_line@modxime!=-1{
sdim@hsp copyright@modxime,2
noteget@hsp copyright@modxime,copy_line@modxime
notedel@hsp copy_line@modxime
noteadd@hsp "",copy_line@modxime
copyright@modxime=strmid@hsp(copyright@modxime,5,strlen@hsp(copyright@modxime)-5)
split@hsp copyright@modxime,"\"",copyright@modxime
if@hsp stat@hsp>=2{
copyright@modxime=copyright@modxime(1)
}
}else@hsp{
copyright@modxime=0
}
strrep@hsp mml@modxime,"　","  "
strrep@hsp mml@modxime,"\t\t","  "
repeat@hsp 26
strrep@hsp mml@modxime,strf@hsp("%c",'A'+cnt@hsp),strf@hsp("%c",'a'+cnt@hsp)
loop@hsp
strrep@hsp mml@modxime,"\n","\t\t"
macronum@modxime=0
split@hsp mml@modxime,"}"
dispos@modxime=stat@hsp
split@hsp mml@modxime,"{"
if@hsp stat@hsp==dispos@modxime{
sdim@hsp valiable_@modxime,,dispos@modxime
sdim@hsp value_@modxime,,dispos@modxime
sdim@hsp par@modxime,,100
sdim@hsp par_@modxime,,dispos@modxime,100
 i@modxime=0:*_for_0000@modxime:exgoto@hsp  i@modxime,1,strlen@hsp(mml@modxime),*_break_0000@modxime
char@modxime=strmid@hsp(mml@modxime,i@modxime,1)
if@hsp char@modxime=="{"{
no@modxime=""
valiable@modxime=""
value@modxime=""
namikwat@modxime=0
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp char@modxime=="{"{
namikwat@modxime+
no@modxime+char@modxime
}else@hsp: if@hsp char@modxime=="}"{
if@hsp namikwat@modxime{
namikwat@modxime-
no@modxime+char@modxime
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
}else@hsp{
no@modxime+char@modxime
}
loop@hsp
split@hsp no@modxime,"=",valiable@modxime,value@modxime
:
if@hsp stat@hsp<=1{
 j@modxime=0:*_for_0001@modxime:exgoto@hsp  j@modxime,1,strlen@hsp(valiable@modxime),*_break_0001@modxime
char@modxime=strmid@hsp(valiable@modxime,j@modxime,1)
if@hsp char@modxime=="("{
no_@modxime=""
repeat@hsp
char@modxime=strmid@hsp(valiable@modxime,j@modxime+cnt@hsp+1,1)
if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp: if@hsp char@modxime!=")"{
no_@modxime+char@modxime
}else@hsp{
j@modxime+cnt@hsp
break@hsp
}
loop@hsp
split@hsp no_@modxime,",",par@modxime
}
 *_continue_0001@modxime: j@modxime+=1:goto@hsp *_for_0001@modxime:*_break_0001@modxime
split@hsp valiable@modxime,"(",valiable@modxime
flag@modxime=0
repeat@hsp macronum@modxime
if@hsp valiable@modxime==valiable_@modxime(cnt@hsp){
flag@modxime=1
cnt_@modxime=cnt@hsp
value@modxime=value_@modxime(cnt@hsp)
 j@modxime=0:*_for_0002@modxime:exgoto@hsp  j@modxime,1,length@hsp(par@modxime)-1,*_break_0002@modxime
 k@modxime=j@modxime+1:*_for_0003@modxime:exgoto@hsp  k@modxime,1,length@hsp(par@modxime),*_break_0003@modxime
if@hsp strlen@hsp(par_@modxime(cnt_@modxime,j@modxime))<strlen@hsp(par_@modxime(cnt_@modxime,k@modxime)){
kari@modxime= par_@modxime(cnt_@modxime,j@modxime):	 par_@modxime(cnt_@modxime,j@modxime)=par_@modxime(cnt_@modxime,k@modxime):	par_@modxime(cnt_@modxime,k@modxime)=kari@modxime
kari@modxime= par@modxime(j@modxime):	 par@modxime(j@modxime)=par@modxime(k@modxime):	par@modxime(k@modxime)=kari@modxime
}
 *_continue_0003@modxime: k@modxime+=1:goto@hsp *_for_0003@modxime:*_break_0003@modxime
 *_continue_0002@modxime: j@modxime+=1:goto@hsp *_for_0002@modxime:*_break_0002@modxime
foreach@hsp par@modxime
if@hsp par_@modxime(cnt_@modxime,cnt@hsp)!=""{
strrep@hsp value@modxime,par_@modxime(cnt_@modxime,cnt@hsp),par@modxime(cnt@hsp)
}
loop@hsp
strrep@hsp mml@modxime,"{"+no@modxime+"}",value@modxime
break@hsp
}
loop@hsp
if@hsp flag@modxime==0{
statement_e@modxime="{"
no@modxime+"}"
error@modxime=11
goto@hsp *make_sheet@modxime
}
}else@hsp{
 j@modxime=0:*_for_0004@modxime:exgoto@hsp  j@modxime,1,strlen@hsp(valiable@modxime),*_break_0004@modxime
char@modxime=strmid@hsp(valiable@modxime,j@modxime,1)
if@hsp char@modxime=="("{
no_@modxime=""
repeat@hsp
char@modxime=strmid@hsp(valiable@modxime,j@modxime+cnt@hsp+1,1)
if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp: if@hsp char@modxime!=")"{
no_@modxime+char@modxime
}else@hsp{
j@modxime+cnt@hsp
break@hsp
}
loop@hsp
split@hsp no_@modxime,",",par@modxime
}
 *_continue_0004@modxime: j@modxime+=1:goto@hsp *_for_0004@modxime:*_break_0004@modxime
split@hsp valiable@modxime,"(",valiable@modxime
 j@modxime=0:*_for_0005@modxime:exgoto@hsp  j@modxime,1,macronum@modxime,*_break_0005@modxime
if@hsp valiable@modxime==valiable_@modxime(j@modxime){
statement_e@modxime="{"
no@modxime+"}"
error@modxime=10
goto@hsp *make_sheet@modxime
}
 *_continue_0005@modxime: j@modxime+=1:goto@hsp *_for_0005@modxime:*_break_0005@modxime
valiable_@modxime(macronum@modxime)=valiable@modxime
value_@modxime(macronum@modxime)=value@modxime
foreach@hsp par@modxime
par_@modxime(macronum@modxime,cnt@hsp)=par@modxime(cnt@hsp)
loop@hsp
work@modxime=""
split@hsp no@modxime,"\t\t"
repeat@hsp limit@hsp(stat@hsp-1,0)
work@modxime+"\t\t"
loop@hsp
strrep@hsp mml@modxime,"{"+no@modxime+"}",work@modxime
macronum@modxime+
}
i@modxime=-1
}
 *_continue_0000@modxime: i@modxime+=1:goto@hsp *_for_0000@modxime:*_break_0000@modxime
}else@hsp{
statement_e@modxime=""
no@modxime=""
error@modxime=1
}
if@hsp error@modxime: goto@hsp *make_sheet@modxime
 i@modxime=0:*_for_0006@modxime:exgoto@hsp  i@modxime,1,strlen@hsp(mml@modxime),*_break_0006@modxime
repeat@hsp tempo_num@modxime-1,1
if@hsp ct_time@modxime(tempo_num@modxime-cnt@hsp)<=time@modxime(ch@modxime){
tempo@modxime(0)=tempo@modxime(tempo_num@modxime-cnt@hsp)
break@hsp
}
loop@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime,1)
statement_e@modxime=char@modxime
if@hsp char@modxime=="t"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"{
no@modxime+char@modxime
if@hsp 1>no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 1>no@modxime{
error@modxime=2
 goto@hsp *_break_0006@modxime
}
tempo@modxime(tempo_num@modxime)=0+no@modxime
ct_time@modxime(tempo_num@modxime)=time@modxime(ch@modxime)
tempo_num@modxime+
}else@hsp: if@hsp char@modxime=="l"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"||char@modxime=="."{
no@modxime+char@modxime
if@hsp 0>=no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0>=no@modxime{
error@modxime=3
 goto@hsp *_break_0006@modxime
}
split@hsp no@modxime,"."
period@modxime=stat@hsp
no_@modxime=double@hsp(int@hsp(no@modxime))
no@modxime=0.0
repeat@hsp period@modxime
no@modxime+4.0/no_@modxime/powf@hsp(2,cnt@hsp)
loop@hsp
length_@modxime(ch@modxime)=4.0/no@modxime
}else@hsp: if@hsp char@modxime=="o"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"{
no@modxime+char@modxime
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
if@hsp -1>no@modxime||9<no@modxime||no@modxime==""||(strlen@hsp(no@modxime)>=2&&no@modxime!="-1")||no@modxime=="-"{
break@hsp
}
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp -1>no@modxime||9<no@modxime||no@modxime==""||(strlen@hsp(no@modxime)>=2&&no@modxime!="-1")||no@modxime=="-"{
error@modxime=4
 goto@hsp *_break_0006@modxime
}
octave@modxime(ch@modxime)=0+no@modxime
}else@hsp: if@hsp char@modxime=="v"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"{
no@modxime+char@modxime
if@hsp 0>no@modxime||127<no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0>no@modxime||127<no@modxime{
error@modxime=2
 goto@hsp *_break_0006@modxime
}
velocity@modxime(ch@modxime)=0+no@modxime
}else@hsp: if@hsp peek@hsp(char@modxime,0)>='a'&&peek@hsp(char@modxime,0)<='g'{
scale@modxime=char@modxime
_switch_val@modxime= char@modxime: if@hsp 0 {
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("c") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=0
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("d") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=2
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("e") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=4
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("f") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=5
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("g") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=7
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("a") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=9
 goto@hsp *_switch_0000@modxime
_switch_sw@modxime++} if@hsp _switch_val@modxime == ("b") | _switch_sw@modxime { _switch_sw@modxime = 0
scale_@modxime=11
 goto@hsp *_switch_0000@modxime
 } *_switch_0000@modxime
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="."{
no@modxime+char@modxime
if@hsp no@modxime!=""&&0>=no@modxime&&no@modxime!="."{
break@hsp
}
}else@hsp: if@hsp char@modxime=="+"||char@modxime=="#"{
scale_@modxime+
}else@hsp: if@hsp char@modxime=="-"{
scale_@modxime-
}else@hsp: if@hsp char@modxime=="&"{
chord@modxime=1
}else@hsp: if@hsp char@modxime=="^"{
scale_@modxime+12
}else@hsp: if@hsp char@modxime=="_"{
scale_@modxime-12
}else@hsp: if@hsp char@modxime=="~"{
slur@modxime(ch@modxime)=1
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
length2_@modxime=length_@modxime(ch@modxime)
if@hsp no@modxime!=""{
if@hsp 0>=no@modxime&&no@modxime!="."{
error@modxime=3
 goto@hsp *_break_0006@modxime
}
split@hsp no@modxime,".",no@modxime
period@modxime=stat@hsp
if@hsp no@modxime=="": no@modxime=length2_@modxime
no_@modxime=double@hsp(int@hsp(no@modxime))
no@modxime=0.0
repeat@hsp period@modxime
no@modxime+4.0/no_@modxime/powf@hsp(2,cnt@hsp)
loop@hsp
length2_@modxime=4.0/no@modxime
}
if@hsp slur@modxime(ch@modxime)!=2{
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":"+(12*(octave@modxime(ch@modxime)+1)+scale_@modxime+key_scale@modxime(ch@modxime))+":"+velocity@modxime(ch@modxime)+":"+i@modxime+"\n"
}else@hsp{
slur@modxime(ch@modxime)=0
}
if@hsp qlength@modxime(ch@modxime){
time@modxime(ch@modxime)+(240000.0/tempo@modxime/length2_@modxime)+(240000.0/tempo@modxime/qlength@modxime(ch@modxime))
}else@hsp{
time@modxime(ch@modxime)+(240000.0/tempo@modxime/length2_@modxime)
}
if@hsp slur@modxime(ch@modxime)!=1{
sheet@modxime+""+int@hsp(time@modxime(ch@modxime)-1)+":"+ch@modxime+":"+(12*(octave@modxime(ch@modxime)+1)+scale_@modxime+key_scale@modxime(ch@modxime))+":"+0+":"+i@modxime+"\n"
}else@hsp{
slur@modxime(ch@modxime)=2
}
if@hsp qlength@modxime(ch@modxime){
time@modxime(ch@modxime)-(240000.0/tempo@modxime/qlength@modxime(ch@modxime))
}
if@hsp chord@modxime{
chord@modxime=0
time@modxime(ch@modxime)-(240000.0/tempo@modxime/length2_@modxime)
}
}else@hsp: if@hsp char@modxime=="<"{
no@modxime=""
if@hsp octave@modxime(ch@modxime)>=9{
error@modxime=4
 goto@hsp *_break_0006@modxime
}
octave@modxime(ch@modxime)+
}else@hsp: if@hsp char@modxime==">"{
no@modxime=""
if@hsp octave@modxime(ch@modxime)<=-1{
error@modxime=4
 goto@hsp *_break_0006@modxime
}
octave@modxime(ch@modxime)-
}else@hsp: if@hsp char@modxime=="r"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="."{
no@modxime+char@modxime
if@hsp no@modxime!=""&&0>=no@modxime&&no@modxime!="."{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
length2_@modxime=length_@modxime(ch@modxime)
if@hsp no@modxime!=""{
if@hsp 0>=no@modxime&&no@modxime!="."{
error@modxime=3
 goto@hsp *_break_0006@modxime
}
split@hsp no@modxime,".",no@modxime
period@modxime=stat@hsp
if@hsp no@modxime=="": no@modxime=length2_@modxime
no_@modxime=double@hsp(int@hsp(no@modxime))
no@modxime=0.0
repeat@hsp period@modxime
no@modxime+4.0/no_@modxime/powf@hsp(2,cnt@hsp)
loop@hsp
length2_@modxime=4.0/no@modxime
}
time@modxime(ch@modxime)+(240000.0/tempo@modxime/length2_@modxime)
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":0:0:"+i@modxime+"\n"
}else@hsp: if@hsp char@modxime=="!"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"{
no@modxime+char@modxime
if@hsp 0>no@modxime||15<no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp ch@modxime!=no@modxime&&looping@modxime(ch@modxime)!=0&&loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime))!=0{
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp char@modxime=="!"{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
}else@hsp{
if@hsp 0>no@modxime||15<no@modxime{
error@modxime=5
 goto@hsp *_break_0006@modxime
}
ch@modxime=0+no@modxime
}
}else@hsp: if@hsp char@modxime=="@"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'{
no@modxime+char@modxime
if@hsp 0>no@modxime||127<no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0>no@modxime||127<no@modxime{
error@modxime=6
 goto@hsp *_break_0006@modxime
}
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":@"+no@modxime+"::"+i@modxime+"\n"
}else@hsp: if@hsp char@modxime=="n"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'{
no@modxime+char@modxime
if@hsp 0>no@modxime||127<no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime=="&"{
chord@modxime=1
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0>no@modxime||127<no@modxime{
error@modxime=2
 goto@hsp *_break_0006@modxime
}
scale_@modxime=0+no@modxime
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":"+scale_@modxime+":"+velocity@modxime(ch@modxime)+":"+i@modxime+"\n"
if@hsp qlength@modxime(ch@modxime): time@modxime(ch@modxime)+(240000.0/tempo@modxime/length_@modxime(ch@modxime))+(240000.0/tempo@modxime/qlength@modxime(ch@modxime)) :else@hsp: time@modxime(ch@modxime)+(240000.0/tempo@modxime/length_@modxime(ch@modxime))
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":"+scale_@modxime+":0:"+i@modxime+"\n"
if@hsp qlength@modxime(ch@modxime): time@modxime(ch@modxime)-(240000.0/tempo@modxime/qlength@modxime(ch@modxime))
if@hsp chord@modxime{
chord@modxime=0
time@modxime(ch@modxime)-(240000.0/tempo@modxime/length_@modxime(ch@modxime))
}
}else@hsp: if@hsp char@modxime=="q"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"||char@modxime=="."{
no@modxime+char@modxime
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0==no@modxime{
qlength@modxime(ch@modxime)=0.0
}else@hsp{
split@hsp no@modxime,"."
period@modxime=stat@hsp
no_@modxime=double@hsp(int@hsp(no@modxime))
no@modxime=0.0
repeat@hsp period@modxime
no@modxime+4.0/no_@modxime/powf@hsp(2,cnt@hsp)
loop@hsp
qlength@modxime(ch@modxime)=4.0/no@modxime
}
}else@hsp: if@hsp char@modxime=="k"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"{
no@modxime+char@modxime
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
key_scale@modxime(ch@modxime)=0+no@modxime
}else@hsp: if@hsp char@modxime=="p"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'{
no@modxime+char@modxime
if@hsp 0>no@modxime||127<no@modxime{
break@hsp
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
if@hsp 0>no@modxime||127<no@modxime{
error@modxime=2
 goto@hsp *_break_0006@modxime
}
sheet@modxime+""+int@hsp(time@modxime(ch@modxime))+":"+ch@modxime+":P"+no@modxime+"::"+i@modxime+"\n"
}else@hsp: if@hsp char@modxime=="["{
if@hsp looping@modxime(ch@modxime)>=64{
error@modxime=9
 goto@hsp *_break_0006@modxime
}
loop_pos@modxime(ch@modxime,looping@modxime(ch@modxime))=i@modxime
looping@modxime(ch@modxime)+
}else@hsp: if@hsp char@modxime=="]"{
no@modxime=""
repeat@hsp
char@modxime=strmid@hsp(mml@modxime,i@modxime+cnt@hsp+1,1)
if@hsp peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'{
no@modxime+char@modxime
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
if@hsp looping@modxime(ch@modxime)<1{
break@hsp
}
}else@hsp{
i@modxime+cnt@hsp
break@hsp
}
loop@hsp
looping@modxime(ch@modxime)-
if@hsp looping@modxime(ch@modxime)<0{
error@modxime=7
 goto@hsp *_break_0006@modxime
}
loop_end@modxime(ch@modxime,looping@modxime(ch@modxime))=i@modxime
loop_time@modxime(ch@modxime,looping@modxime(ch@modxime))=0+no@modxime
loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime))+
if@hsp loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime))<loop_time@modxime(ch@modxime,looping@modxime(ch@modxime)){
i@modxime=loop_pos@modxime(ch@modxime,looping@modxime(ch@modxime))-1
}else@hsp{
loop_end_func@local_module
}
}else@hsp: if@hsp char@modxime=="/"{
no@modxime=""
if@hsp looping@modxime(ch@modxime)>0{
if@hsp loop_time@modxime(ch@modxime,looping@modxime(ch@modxime)-1)-loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime)-1)==1{
i@modxime=loop_end@modxime(ch@modxime,looping@modxime(ch@modxime)-1)-1
looping@modxime(ch@modxime)-
loop_end_func@local_module
}
}else@hsp{
error@modxime=8
 goto@hsp *_break_0006@modxime
}
}else@hsp: if@hsp char@modxime==" "||char@modxime=="\t"{
}else@hsp{
warning@modxime(warning_num@modxime)=1
warning_num@modxime+
}
 *_continue_0006@modxime: i@modxime+=1:goto@hsp *_for_0006@modxime:*_break_0006@modxime

*make_sheet@modxime
if@hsp error@modxime{
work@modxime=strmid@hsp(mml@modxime,0,i@modxime+1)
strrep@hsp work@modxime,"\t\t","\n"
if@hsp error@modxime==1{
work@modxime=text@modxime
}
notesel@hsp work@modxime
ern@modxime= noteinfo@hsp(0)
noteunsel@hsp
sheet@modxime=str@hsp(sheet_back@modxime)
return@hsp
}
notesel@hsp sheet@modxime
dim@hsp code@modxime, noteinfo@hsp(0)
dim@hsp code_@modxime, noteinfo@hsp(0)
if@hsp  noteinfo@hsp(0){
repeat@hsp  noteinfo@hsp(0)
noteget@hsp code@modxime(cnt@hsp),cnt@hsp
code_@modxime(cnt@hsp)=0+code@modxime(cnt@hsp)
loop@hsp
repeat@hsp  noteinfo@hsp(0)-1
cnt_@modxime=cnt@hsp
repeat@hsp  noteinfo@hsp(0)-cnt_@modxime-1,cnt_@modxime+1
if@hsp code_@modxime(cnt_@modxime)>code_@modxime(cnt@hsp){
kari@modxime= code_@modxime(cnt_@modxime):	 code_@modxime(cnt_@modxime)=code_@modxime(cnt@hsp):	code_@modxime(cnt@hsp)=kari@modxime
kari@modxime= code@modxime(cnt_@modxime):	 code@modxime(cnt_@modxime)=code@modxime(cnt@hsp):	code@modxime(cnt@hsp)=kari@modxime
}
loop@hsp
loop@hsp
}
sheet@modxime=""
repeat@hsp length@hsp(code@modxime)
sheet@modxime+code@modxime(cnt@hsp)+"\n"
loop@hsp
sheet_back@modxime=sheet@modxime
return@hsp

#deffunc _beep int p1@modxime,int p2@modxime
exec@hsp "beepplay.exe "+p1@modxime+","+p2@modxime
return@hsp








#defcfunc mmlchk 
exist@hsp  dirinfo@hsp(1)+"\\mmlplay"
return@hsp strsize@hsp!=-1



#deffunc _mmlclear int p1@modxime
if@hsp p1@modxime<0{
sdim@hsp mmllist@modxime,,128
}else@hsp{
mmllist@modxime(p1@modxime)=""
}
return@hsp
























#deffunc _mmlplay str p1@modxime
char@modxime=p1@modxime
so_empty@modxime=peek@hsp(char@modxime,0)>='0'&&peek@hsp(char@modxime,0)<='9'||char@modxime=="-"||char@modxime=="+"
if@hsp so_empty@modxime{
notesel@hsp mmllist@modxime(0+p1@modxime)
}else@hsp{
text@modxime=p1@modxime
gosub@hsp *compile@modxime
notesel@hsp sheet@modxime
}
notesave@hsp "xime.dat"
exec@hsp  dirinfo@hsp(1)+"\\mmlplay.exe /s"
exec@hsp  dirinfo@hsp(1)+"\\mmlplay.exe \""+ dirinfo@hsp(0)+"\\xime.dat\""
repeat@hsp
exist@hsp  dirinfo@hsp(1)+"\\mmlplay"
if@hsp strsize@hsp!=-1: break@hsp
loop@hsp
delete@hsp "xime.dat"
if@hsp so_empty@modxime{
return@hsp
}else@hsp{
return@hsp error@modxime
}



#deffunc mmlset int p1@modxime,str text2@modxime
wait@hsp 1
text@modxime=text2@modxime
gosub@hsp *compile@modxime
mmllist@modxime(p1@modxime)=sheet@modxime
return@hsp error@modxime

#defcfunc mmlerr 
return@hsp ern@modxime























#deffunc _mmlstop double p1@modxime
if@hsp p1@modxime*1000{
exec@hsp  dirinfo@hsp(1)+"\\mmlplay.exe /o"+str@hsp(int@hsp(1000.0*p1@modxime))
}else@hsp{
exec@hsp  dirinfo@hsp(1)+"\\mmlplay.exe /s"
}
return@hsp

#deffunc mmlpause double p1@modxime

return@hsp



*_modxime_exit
#global
##870





























































































































##30 "main.hsp"
##0 "llmod3/llmod3.hsp"
































































#uselib "kernel32.dll"
#func loadlibrary "LoadLibraryA" str
#func getprocaddress "GetProcAddress" int,sptr
#func freelibrary "FreeLibrary" int

#func lstrlen "lstrlenA" sptr












dllret = 0



























#module llmod3
goto@hsp *_llmod3_exit
##111






#deffunc dll_getfunc var _v1@llmod3,str _v2@llmod3,int _v3@llmod3
if@hsp(_v3@llmod3 & $FFFFFF00) {
lcl_hinst@llmod3 = _v3@llmod3
} else@hsp {
lcl_hinst@llmod3 = mjrdll@llmod3(_v3@llmod3)
}
getprocaddress lcl_hinst@llmod3,_v2@llmod3
_v1@llmod3 = stat@hsp
if@hsp(_v1@llmod3 == 0) {
dialog@hsp "can not find '"+_v2@llmod3+"'\ndll="+_v3@llmod3
}
return@hsp



















#deffunc _init_llmod 

if@hsp(mjrdll@llmod3) {
return@hsp
}


lcl_cl@llmod3 = 0

sdim@hsp lcl_s@llmod3,64,16
lcl_s@llmod3(		0)	= "kernel32"
lcl_s@llmod3(		1)	= "user32"
lcl_s@llmod3(		2)	= "shell32"
lcl_s@llmod3(		3)	= "comctl32"
lcl_s@llmod3(		4)	= "comdlg32"
lcl_s@llmod3(		5)	= "gdi32"

repeat@hsp 6
loadlibrary lcl_s@llmod3(cnt@hsp)
mjrdll@llmod3(cnt@hsp) = stat@hsp
loop@hsp



lcl_s@llmod3 = "GetActiveWindow"
repeat@hsp 1
getprocaddress mjrdll@llmod3(		1),lcl_s@llmod3.cnt@hsp
mjrfunc@llmod3.cnt@hsp = stat@hsp
loop@hsp

 sdim@hsp lcl_s@llmod3,64

return@hsp






#deffunc dllproc str funcname@llmod3,array prms@llmod3,int prm_n@llmod3,int dll_no@llmod3
if@hsp(dll_no@llmod3 & $FFFFFF00) {
lcl_hinst@llmod3 = dll_no@llmod3
} else@hsp {
lcl_hinst@llmod3 = mjrdll@llmod3(dll_no@llmod3)
}
getprocaddress lcl_hinst@llmod3,funcname@llmod3
func@llmod3 = stat@hsp
if@hsp(func@llmod3) {
_stat@llmod3 = callfunc@hsp(prms@llmod3,func@llmod3,prm_n@llmod3)
} else@hsp {
dialog@hsp "can not find '"+funcname@llmod3+"'\ndll="+dll_no@llmod3
getkey@hsp a@llmod3,16
if@hsp(a@llmod3) {
end@hsp
}
}
return@hsp _stat@llmod3






#deffunc getmjrdll var v1@llmod3,int v2@llmod3
v1@llmod3 = mjrdll@llmod3(v2@llmod3)
return@hsp






#deffunc getmjrfunc var v1@llmod3,int v2@llmod3
v1@llmod3 = mjrfunc@llmod3(v2@llmod3)
return@hsp




























#deffunc _get_active_window var v1@llmod3
v1@llmod3 = callfunc@hsp(prm@llmod3,mjrfunc@llmod3.	0,0)
return@hsp







#deffunc setwndlong var v1@llmod3,int v2@llmod3









if@hsp(v2@llmod3) {
lcl_s@llmod3 = "G"
a@llmod3 = 2		
} else@hsp {
lcl_s@llmod3 = "S"
a@llmod3 = 3		
}
lcl_s@llmod3 += "etWindowLongA"
dllproc lcl_s@llmod3,v1@llmod3,a@llmod3,		1

return@hsp






#deffunc _null_sep_str var _v1@llmod3,int _n1@llmod3

l@llmod3 = strlen@hsp(_v1@llmod3)
a@llmod3 = 0
prm@llmod3 = 0
repeat@hsp l@llmod3
a@llmod3 = peek@hsp(_v1@llmod3,cnt@hsp)
if@hsp(a@llmod3 == _n1@llmod3) {
poke@hsp _v1@llmod3,cnt@hsp,0
prm@llmod3++
}
loop@hsp

return@hsp prm@llmod3







#deffunc _makewnd array handle@llmod3,str s2@llmod3

pos@hsp handle@llmod3.0,handle@llmod3.1
winobj@hsp s2@llmod3,"",handle@llmod3.6,handle@llmod3.4,handle@llmod3.2,handle@llmod3.3,0,0
handle@llmod3 = stat@hsp

return@hsp






#deffunc _is_wnd int v1@llmod3
_v1@llmod3 = v1@llmod3
dllproc "IsWindow",_v1@llmod3,1,		1
return@hsp







#deffunc _hspobjhandle int v1@llmod3
return@hsp objinfo@hsp(v1@llmod3,2)







#deffunc _hspobjid int v1@llmod3
mref@hsp bmscr@llmod3,67
_stat@llmod3 = -1
repeat@hsp bmscr@llmod3.72
if@hsp(v1@llmod3 == objinfo@hsp(cnt@hsp,2)) : _stat@llmod3 = cnt@hsp : break@hsp
loop@hsp
return@hsp _stat@llmod3



























#deffunc charupper var v1@llmod3
 p@llmod3 = varptr@hsp(v1@llmod3)
dllproc "CharUpperA",p@llmod3,1,		1
return@hsp







#deffunc charlower var v1@llmod3
 p@llmod3 = varptr@hsp(v1@llmod3)
dllproc "CharLowerA",p@llmod3,1,		1
return@hsp






*_llmod3_exit
#global
##398

_init_llmod		




##31 "main.hsp"
##0 "llmod3/msgdlg.hsp"









































































#module _msgdlg
goto@hsp *__msgdlg_exit
##74




#deffunc msgdlg str msg@_msgdlg,str capt@_msgdlg,int type@_msgdlg,int ico@_msgdlg

a@_msgdlg = strlen@hsp(msg@_msgdlg)  : if@hsp(a@_msgdlg >= 64) : sdim@hsp lcl_msg@_msgdlg,a@_msgdlg + 1
a@_msgdlg = strlen@hsp(capt@_msgdlg) : if@hsp(a@_msgdlg >= 64) : sdim@hsp lcl_capt@_msgdlg,a@_msgdlg + 1
_ico@_msgdlg = ico@_msgdlg
lcl_msg@_msgdlg = msg@_msgdlg	
lcl_capt@_msgdlg = capt@_msgdlg

dim@hsp lcl_os@_msgdlg,37 : lcl_os@_msgdlg.0 = 148
 p@_msgdlg = varptr@hsp(lcl_os@_msgdlg)
dllproc "GetVersionExA",p@_msgdlg,1,		0

a@_msgdlg = 0
if@hsp(_ico@_msgdlg & $100) : a@_msgdlg = $30 : _ico@_msgdlg = _ico@_msgdlg - $100
dllproc "MessageBeep",a@_msgdlg,1,		1

prm@_msgdlg.0 = 40
_get_active_window a@_msgdlg
prm@_msgdlg.1 = a@_msgdlg
 a@_msgdlg = hinstance@hsp
prm@_msgdlg.2 = a@_msgdlg

 prm@_msgdlg.3 = varptr@hsp(lcl_msg@_msgdlg)
 prm@_msgdlg.4 = varptr@hsp(lcl_capt@_msgdlg)

if@hsp(_ico@_msgdlg == 5) : _ico@_msgdlg = $80 : else@hsp : _ico@_msgdlg = _ico@_msgdlg << 4
prm@_msgdlg.5 = type@_msgdlg + _ico@_msgdlg
prm@_msgdlg.6 = 128
 p@_msgdlg = varptr@hsp(prm@_msgdlg)

dllproc "MessageBoxIndirectA",p@_msgdlg,1,		1
p@_msgdlg = stat@hsp

 sdim@hsp lcl_msg@_msgdlg,64
 sdim@hsp lcl_capt@_msgdlg,64

return@hsp p@_msgdlg

*__msgdlg_exit
#global
##117



##32 "main.hsp"
##0 "llmod3/input.hsp"

















































































































































#module _input
goto@hsp *__input_exit
##146






#deffunc keybd_event int v1@_input,int v2@_input,int v3@_input
if@hsp(pkeybd_event@_input == 0) {
dll_getfunc pkeybd_event@_input,"keybd_event",		1
if@hsp(pkeybd_event@_input == 0) : return@hsp
}




prm@_input = v1@_input,v3@_input,v2@_input
prm@_input.3 = 0
prm@_input.4 = 0


if@hsp(prm@_input.2) {
if@hsp(prm@_input.2 > 0) : prm@_input.2 = 2 : else@hsp : prm@_input.2 = 0 : prm@_input.4 = 1
}

dllret@_input = callfunc@hsp( prm@_input,pkeybd_event@_input,4)
if@hsp(prm@_input.4) : prm@_input.2 = 2 : dllret@_input = callfunc@hsp( prm@_input,pkeybd_event@_input,4)
return@hsp






#deffunc mouse_event int v1@_input,int v2@_input,int v3@_input,int v4@_input
if@hsp(pgetmessageextrainfo@_input == 0) {
dll_getfunc pgetmessageextrainfo@_input,"GetMessageExtraInfo",		1
dll_getfunc pmouse_event@_input,"mouse_event",		1
if@hsp(pgetmessageextrainfo@_input == 0)|(pmouse_event@_input == 0) : return@hsp
}











prm@_input.0 = v1@_input,v2@_input,v3@_input,v4@_input

dllret@_input = callfunc@hsp(prm@llmod3, pgetmessageextrainfo@_input,0)
prm@_input.4 = dllret@_input

dllret@_input = callfunc@hsp( prm@_input,pmouse_event@_input,5)
return@hsp


*__input_exit
#global
##206


##33 "main.hsp"
##0 "hspprint.as"






#uselib "hspprint.dll"





#func prnflags prnflags $202
#func enumprn enumprn $202
#func propprn propprn $202
#func execprn execprn $202
#func getdefprn getdefprn $202
#func prndialog prndialog $202



##34 "main.hsp"









#uselib "user32
#func setwindowpos "SetWindowPos" sptr,sptr,sptr,sptr,sptr,sptr,sptr
#cfunc getwindowlong "GetWindowLongA" int,int
#func setwindowlong "SetWindowLongA" int,int,int
#cfunc getsystemmetrics "GetSystemMetrics" int
#cfunc getsystemmenu "GetSystemMenu" int,nullptr
#func deletemenu "DeleteMenu" int,int,nullptr
#func enablewindow "EnableWindow" int,int
#cfunc iszoomed "IsZoomed" int
#cfunc isiconic "IsIconic" int
#func createwindowex "CreateWindowExA" int,str,str,int,int,int,int,int,int,int,int,int
#func movewindow "MoveWindow" int,int,int,int,int,int
#func setfocus "SetFocus" int
#cfunc getdc "GetDC" int
#func releasedc "ReleaseDC" int,int
#uselib "gdi32
#func createsolidbrush "CreateSolidBrush" int
#cfunc getdevicecaps "GetDeviceCaps" int,int
#cfunc createfontindirect "CreateFontIndirectA" int
#func getobject "GetObjectA" int,int,int
#uselib "kernel32
#func getprivateprofilestring "GetPrivateProfileStringA" sptr,sptr,sptr,var,int,sptr
#func writeprivateprofilestring "WritePrivateProfileStringA" sptr,sptr,sptr,sptr
















































#module m1
goto@hsp *_m1_exit
##115

#uselib "user32
#cfunc findwindow@m1 "FindWindowA" var,int
#func getwindowrect@m1 "GetWindowRect" int,var
#uselib "shell32
#func shappbarmessage@m1 "SHAppBarMessage" int,var





#deffunc _gsel int p1@m1,int p2@m1
data@m1= ginfo@hsp(3)
gsel@hsp p1@m1,p2@m1
return@hsp

#deffunc _gunsel int p1@m1
gsel@hsp data@m1,p1@m1
return@hsp

#deffunc objint var p1@m1,int p2@m1
objprm@hsp p2@m1,strf@hsp("%g",double@hsp(p1@m1))
return@hsp

#defcfunc pos_taskbar 
gosub@hsp *get_iroiro@m1
if@hsp rc@m1(1)>0: tsk@m1=0
if@hsp rc@m1(3)<( ginfo@hsp(21)-1): tsk@m1=1
if@hsp rc@m1(2)<( ginfo@hsp(20)-1): tsk@m1=2
if@hsp rc@m1(0)>0: tsk@m1=3
return@hsp tsk@m1

#defcfunc width_taskbar 
gosub@hsp *get_iroiro@m1
return@hsp rc@m1(2)-rc@m1(0)

#defcfunc height_taskbar 
gosub@hsp *get_iroiro@m1
return@hsp rc@m1(3)-rc@m1(1)

*get_iroiro@m1
dim@hsp appbdata@m1,6
dim@hsp rc@m1,4
uxoxo@m1="Shell_TrayWnd"
appbdata@m1=24,findwindow@m1(uxoxo@m1,0)
shappbarmessage@m1 5,appbdata@m1
getwindowrect@m1 findwindow@m1(uxoxo@m1,0),rc@m1
return@hsp

#defcfunc rep_easy str p3@m1,int p1@m1,int p2@m1
sen@m1=p3@m1
if@hsp p2@m1{
sdim@hsp seg@m1
sdim@hsp esy@m1
seg@m1="しう", "行は","使は","遣ひ","終は","ゐ","ゑ"
esy@m1="しゅう","行わ","使わ","遣い","終わ","い","え"
foreach@hsp seg@m1
strrep@hsp sen@m1,seg@m1(cnt@hsp),esy@m1(cnt@hsp)
loop@hsp
}
if@hsp p1@m1{
sdim@hsp seg@m1
sdim@hsp esy@m1
seg@m1="檢","橫","縱","數","參","寫","實","裝","號","變","餘","讀","擇","假","體","區"
esy@m1="検","横","縦","数","参","写","実","装","号","変","余","読","択","仮","体","区"
foreach@hsp seg@m1
strrep@hsp sen@m1,seg@m1(cnt@hsp),esy@m1(cnt@hsp)
loop@hsp
}
return@hsp sen@m1

#defcfunc rep_large str p1@m1,int p2@m1
sen@m1=p1@m1
if@hsp p2@m1{
sdim@hsp little@m1
sdim@hsp large@m1
little@m1="ぁ","ぃ","ぅ","ぇ","ぉ","ゃ","ゅ","ょ","ゎ"
large@m1 ="あ","い","う","え","お","や","ゆ","よ","わ"
if@hsp p2@m1==2{
little@m1(length@hsp(little@m1))="ァ","ィ","ゥ","ェ","ォ","ヵ","ヶ","ャ","ュ","ョ","ヮ"
large@m1 (length@hsp(large@m1 ))="ア","イ","ウ","エ","オ","カ","ケ","ヤ","ユ","ヨ","ワ"
}
foreach@hsp little@m1
strrep@hsp sen@m1,little@m1(cnt@hsp),large@m1(cnt@hsp)
loop@hsp
}
return@hsp sen@m1

#defcfunc how_many str p1@m1,str p2@m1
string@m1=p1@m1
split@hsp string@m1,p2@m1
return@hsp stat@hsp-1

#deffunc prints str p1@m1,str p2@m1,int p3@m1
font@hsp p2@m1,p3@m1
text@m1=p1@m1
notesel@hsp text@m1
 i@m1=0:*_for_0007@m1:exgoto@hsp  i@m1,1, noteinfo@hsp(0),*_break_0007@m1
noteget@hsp text_data@m1,i@m1
repeat@hsp 0.5+1f*strlen@hsp(text_data@m1)/2
pos@hsp  ginfo@hsp(12), ginfo@hsp(13)
print@hsp strmid@hsp(text_data@m1,cnt@hsp*2,2)
pos@hsp double@hsp(1f*p3@m1-1f* ginfo@hsp(14))/2+cnt@hsp*p3@m1,double@hsp(p3@m1- ginfo@hsp(15))/2+p3@m1*i@m1
print@hsp strmid@hsp(text_data@m1,cnt@hsp*2,2)
loop@hsp
 *_continue_0007@m1: i@m1+=1:goto@hsp *_for_0007@m1:*_break_0007@m1
noteunsel@hsp
return@hsp

#deffunc searching int p1@m1
if@hsp used_box==0{
search_text=text
search_keyword@m1=keyword
if@hsp distinguish==0{
repeat@hsp 26
strrep@hsp search_text,strf@hsp("%c",'A'+cnt@hsp),strf@hsp("%c",'a'+cnt@hsp)
strrep@hsp search_keyword@m1,strf@hsp("%c",'A'+cnt@hsp),strf@hsp("%c",'a'+cnt@hsp)
loop@hsp
}
if@hsp p1@m1==0{
_gsel  0,1
sendmsg@hsp hmesbox,$B0,0,varptr@hsp(locate)
search_pos=instr@hsp(search_text,locate,search_keyword@m1)
if@hsp search_pos==-1{
_gsel  7,0
dialog@hsp rep_easy("終はりまで檢索しました。",kanzi,kana)
_gunsel 0
}else@hsp{
objsel@hsp 0
sendmsg@hsp hmesbox,$B1,locate+search_pos,locate+search_pos+strlen@hsp(search_keyword@m1)
if@hsp search_dialog{
_gsel  7,1
_gunsel 0
}
}
_gunsel 0
}
if@hsp p1@m1==1{
_gsel  0,1
keyword_work@m1=""
repeat@hsp strlen@hsp(search_keyword@m1)
keyword_work@m1+strmid@hsp(search_keyword@m1,strlen@hsp(search_keyword@m1)-cnt@hsp-1,1)
loop@hsp
search_text_work@m1=""
repeat@hsp strlen@hsp(search_text)
search_text_work@m1+strmid@hsp(search_text,strlen@hsp(search_text)-cnt@hsp-1,1)
loop@hsp
sendmsg@hsp hmesbox,$B0,varptr@hsp(locate)
search_pos=instr@hsp(search_text_work@m1,strlen@hsp(search_text_work@m1)-locate,keyword_work@m1)
if@hsp search_pos==-1{
_gsel  7,0
dialog@hsp rep_easy("終はりまで檢索しました。",kanzi,kana)
_gunsel 0
}else@hsp{
objsel@hsp 0
sendmsg@hsp hmesbox,$B1,locate-search_pos,locate-(search_pos+strlen@hsp(search_keyword@m1))
if@hsp search_dialog{
_gsel  7,1
_gunsel 0
}
}
_gunsel 0
}
_gsel  0,1
objsel@hsp 0
_gunsel 0
}
return@hsp

#defcfunc box_hwnd int p1@m1
if@hsp p1@m1==0{
return@hsp hmesbox
}
if@hsp p1@m1==1{
return@hsp hrich
}
return@hsp -1

#deffunc error_mes str p1@m1
dialog@hsp p1@m1+"\n"+ifs(statement_e@modxime==""&&no@modxime=="","","--> ")+statement_e@modxime+no@modxime+" (error "+stat@hsp+" : line "+mmlerr()+")",1
return@hsp

#deffunc realtime 
mml_data@m1=mml@modxime
strrep@hsp mml_data@m1,"  ","\n"
_gsel  9,0
r@m1= ginfo@hsp(16)
g@m1= ginfo@hsp(17)
b@m1= ginfo@hsp(18)
color@hsp 0,0,0
boxf@hsp
color@hsp 255,255,255
prints mml_data@m1, "ＭＳ ゴシック",16
color@hsp r@m1,g@m1,b@m1
_gunsel 0
return@hsp

#defcfunc ifs int p1@m1,str p2@m1,str p3@m1
if@hsp p1@m1{
return@hsp p2@m1
}else@hsp{
return@hsp p3@m1
}

#deffunc groupbox str p1@m1
button@hsp gosub@hsp p1@m1,*dummy@m1
id@m1=stat@hsp
sendmsg@hsp objinfo@hsp(id@m1,2) ,$F4,7
objskip@hsp id@m1,3
return@hsp

*dummy@m1
return@hsp

*_m1_exit
#global
##330

screen@hsp 1,,, (2)
repeat@hsp 2
_gsel  cnt@hsp,0
mwhw(cnt@hsp)=hwnd@hsp
loop@hsp

screen@hsp 2,512,320,6
gosub@hsp *win_dialog
title@hsp "印刷"
gosub@hsp *update_pinfo
print_width=40
print_height=36
print_pts=10.5
print_top=20f
print_bottom=20f
print_left=20f
print_right=20f
print_fname= "ＭＳ 明朝"
print_width_=print_width
print_height_=print_height
print_top_=print_top
print_bottom_=print_bottom
print_left_=print_left
print_right_=print_right
print_pts_=print_pts
print_fname_=print_fname

screen@hsp 4, ginfo@hsp(20), ginfo@hsp(21),6
gosub@hsp *win_dialog

gosub@hsp *screen_5

screen@hsp 6,280,90,6
gosub@hsp *win_dialog
syscolor@hsp 4
boxf@hsp
syscolor@hsp 7
title@hsp "指定行に移動"
font@hsp "ＭＳ Ｐゴシック",16
pos@hsp 20,15
print@hsp "何行目に移動しますか："
pos@hsp 53,45
objsize@hsp 80,24
input@hsp what_line
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
pos@hsp  ginfo@hsp(22)+100, ginfo@hsp(23)-24
objsize@hsp 64,24
button@hsp gosub@hsp "OK",*gline_ok
pos@hsp  ginfo@hsp(22)-20, ginfo@hsp(23)-20
font@hsp  "ＭＳ ゴシック",16
print@hsp "行"

keyword=""
search_down=1
gosub@hsp *screen_7

keyword_rep=""
gosub@hsp *screen_8

screen@hsp 9,640,480, (2)
cls@hsp 4
gosub@hsp *win_dialog

_gsel  0,0
onexit@hsp gosub@hsp *vofari
sdim@hsp text,64000
sdim@hsp text_hangout,64000
exist@hsp  dirinfo@hsp(1)+"\\xime.ini"
gosub@hsp *normal_set
if@hsp strsize@hsp==-1{
gosub@hsp *format_set
}
gosub@hsp *load_set
filename=""
dim@hsp fontis,8
bcolour=255,255,255

screen@hsp 0, ginfo@hsp(20), ginfo@hsp(21),2
gosub@hsp *make_bone
font@hsp fontname,fontsize,fontstyle
objmode@hsp 2,0
pos@hsp 0,0
gosub@hsp *set_mesbox
stbar_ini
stbar_text "Ready"
if@hsp in_status==0{
clrobj@hsp 1,1
}
gosub@hsp *set_menu

screen@hsp 1, ginfo@hsp(20), ginfo@hsp(21),2
gosub@hsp *make_bone
stbar_ini
stbar_text "Ready"
loadlibrary "riched32"
richx= ginfo@hsp(12)
richy= ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status
createwindowex 0,"RichEdit","",$50B110C4,0,0,richx,richy,hwnd@hsp,0,hinstance@hsp,0
hrich=stat@hsp
sendmsg@hsp hrich,$435,0,$7FFFFFFD
movewindow hrich,0,0, ginfo@hsp(12)+1, ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status,1
setwindowpos hrich,0,0,0, ginfo@hsp(12), ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status,$40
sendmsg@hsp hrich,$44D,4,$1000000
gosub@hsp *chg_font
if@hsp in_status==0{
clrobj@hsp 0,0
}
gosub@hsp *set_menu

screen@hsp 32,,, (2)
work="あいうえお"
mesbox@hsp work,100
work=objinfo@hsp(stat@hsp,2) 
sendmsg@hsp work,$B1,0,-1
sendmsg@hsp work,$B0,0,varptr@hsp(work)
if@hsp work==5{
box_index=1
}

repeat@hsp 2
_gsel  used_box^cnt@hsp^1,cnt@hsp
oncmd@hsp gosub@hsp *command_,$111
oncmd@hsp gosub@hsp *label,5
loop@hsp
onkey@hsp gosub@hsp *shortcut
gosub@hsp *label
setfocus (used_box==0)*hmesbox  |(used_box==1)*hrich
gsel_works=-1
active_work=-1

*main
repeat@hsp
if@hsp windlg==0&&( ginfo@hsp(3)==0|| ginfo@hsp(3)==1){
if@hsp text_hangout!=text{
addchr=" *"
}else@hsp{
addchr=""
}
if@hsp filename==""{
title@hsp prgname+" - (無題)"+addchr
}else@hsp{
title@hsp prgname+" - "+getpath@hsp(filename,8)+addchr
}
gosub@hsp *set_msgline
if@hsp msgline!=msgline_hangout{
stbar_text strf@hsp("line : %d",msgline+1)
}
msgline_hangout=msgline
if@hsp (iszoomed(mwhw(used_box))||isiconic(mwhw(used_box)))==0{
winx= ginfo@hsp(10)
winy= ginfo@hsp(11)
winpx= ginfo@hsp(4)
winpy= ginfo@hsp(5)
}
}
if@hsp  ginfo@hsp(3)!=gsel_works|| ginfo@hsp(2)!=active_work{
:
gsel_works= ginfo@hsp(3)
active_work= ginfo@hsp(2)
}
wait@hsp 15	
loop@hsp
stop@hsp

*label
if@hsp  ginfo@hsp(3)==0|| ginfo@hsp(3)==1{
if@hsp  ginfo@hsp(3)==0{
setwindowpos hmesbox,0,0,0,lparam@hsp  &$FFFF,(lparam@hsp>>16) &$FFFF,0
winsize= ginfo@hsp(12), ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status,0,0
resizeobj 0,winsize,1
}else@hsp{
movewindow hrich,0,0, ginfo@hsp(12), ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status,1
}
stbar_resize
}
return@hsp

*command_
_switch_val= wparam@hsp  &$FFFF: if@hsp 0 {
_switch_sw++} if@hsp _switch_val == ( 1) | _switch_sw { _switch_sw = 0
fontdlg fontis
if@hsp stat@hsp{
fontname=refstr@hsp
fontsize=fontis(0)
fontstyle=fontis(1) | fontis(6)<<2  | fontis(7)<<3
if@hsp  ginfo@hsp(3)==0{
font@hsp fontname,fontsize,fontstyle
color@hsp fontis(3) | fontis(4)<<8  | fontis(5)<<16
clrobj@hsp 0,0
pos@hsp 0,0
gosub@hsp *set_mesbox
}else@hsp: if@hsp  ginfo@hsp(3)==1{
gosub@hsp *chg_font
}
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 2) | _switch_sw { _switch_sw = 0
dialog@hsp,32
bcolour= ginfo@hsp(16)  |  ginfo@hsp(17)<<8  |  ginfo@hsp(18)<<16



_gsel  1,0
sendmsg@hsp hrich,$443,0,bcolour
setfocus hrich
_gsel  used_box,0
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 3) | _switch_sw { _switch_sw = 0
gosub@hsp *save_set
gosub@hsp *hangout
if@hsp status: end@hsp
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 4) | _switch_sw { _switch_sw = 0
mmlset 0,text
gosub@hsp *comperr
if@hsp stat@hsp==0||stat@hsp==-1{
_mmlplay ""+ 0
realtime
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 5) | _switch_sw { _switch_sw = 0
gosub@hsp *choose_all
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 6) | _switch_sw { _switch_sw = 0
_mmlstop 0.0
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 7) | _switch_sw { _switch_sw = 0
gosub@hsp *hangout
if@hsp status{
text=""
text_hangout=text
objprm@hsp 0,text
filename=""
if@hsp notedit: gosub@hsp *notedit_
gosub@hsp *set_menu
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 8) | _switch_sw { _switch_sw = 0
gosub@hsp *load
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 9) | _switch_sw { _switch_sw = 0
if@hsp filename!=""{
overwrite=1
}else@hsp{
overwrite=0
}
gosub@hsp *save
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 10) | _switch_sw { _switch_sw = 0
overwrite=0
gosub@hsp *save
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 11) | _switch_sw { _switch_sw = 0
keybd_event 17,0
keybd_event 'Z',-1
keybd_event 17,1
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 12) | _switch_sw { _switch_sw = 0
sendmsg@hsp (used_box==0)*hmesbox  |(used_box==1)*hrich,$300
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 13) | _switch_sw { _switch_sw = 0
sendmsg@hsp (used_box==0)*hmesbox  |(used_box==1)*hrich,$301
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 14) | _switch_sw { _switch_sw = 0
sendmsg@hsp (used_box==0)*hmesbox  |(used_box==1)*hrich,$302
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 16) | _switch_sw { _switch_sw = 0
gosub@hsp *out_midi
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 17) | _switch_sw { _switch_sw = 0
gosub@hsp *in_midi
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 18) | _switch_sw { _switch_sw = 0
if@hsp filename!=""{
msgdlg rep_easy("變更内容を破棄して再讀込を行ひます。よろしう御座いますか。",kanzi,kana),rep_easy("再讀込",kanzi,kana),$104,3
if@hsp stat@hsp==7:  goto@hsp *_switch_0001
noteload@hsp filename
text_hangout=text
objprm@hsp 0,text
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 19) | _switch_sw { _switch_sw = 0
gosub@hsp *notedit_
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 20) | _switch_sw { _switch_sw = 0
_mmlplay ""+ 0
realtime
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 21) | _switch_sw { _switch_sw = 0
mmlset 0,text
gosub@hsp *comperr
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 22) | _switch_sw { _switch_sw = 0
gosub@hsp *printout
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 23) | _switch_sw { _switch_sw = 0
_gsel  used_box,0
enablewindow hwnd@hsp,0
_gsel  5,1
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 24) | _switch_sw { _switch_sw = 0
gosub@hsp *help
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 25) | _switch_sw { _switch_sw = 0
gosub@hsp *make_mesbox
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 15) | _switch_sw { _switch_sw = 0
sendmsg@hsp (used_box==0)*hmesbox  |(used_box==1)*hrich,$303
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 26) | _switch_sw { _switch_sw = 0
gosub@hsp *goto_top
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 27) | _switch_sw { _switch_sw = 0
gosub@hsp *goto_line
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 28) | _switch_sw { _switch_sw = 0
gosub@hsp *goto_bottom
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 29) | _switch_sw { _switch_sw = 0
in_status^1
repeat@hsp 2
_gsel  used_box^(1-cnt@hsp),0
gosub@hsp *label
if@hsp in_status{
stbar_ini
stbar_text strf@hsp("line : %d",msgline+1)
}else@hsp{
clrobj@hsp  ginfo@hsp(3)^1, ginfo@hsp(3)^1
}
gosub@hsp *set_menu
loop@hsp
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 30) | _switch_sw { _switch_sw = 0
auto_indent^1
gosub@hsp *set_menu
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 31) | _switch_sw { _switch_sw = 0
msgdlg rep_easy("設定を初期化します。よろしう御座いますか。\n(保存した File は削除せられません。)",kanzi,kana),"設定の初期化",$104,2
if@hsp stat@hsp==6{
gosub@hsp *format_set
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 32) | _switch_sw { _switch_sw = 0
if@hsp used_box!=0{
_gsel  0,1
_gsel  used_box,-1
_gsel  0,0
used_box=0
gosub@hsp *set_menu
width@hsp winx- ginfo@hsp(10)+ ginfo@hsp(12)+10,winy- ginfo@hsp(11)+ ginfo@hsp(13)+31,winpx,winpy
setfocus hmesbox
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 33) | _switch_sw { _switch_sw = 0
if@hsp used_box!=1{
_gsel  1,1
_gsel  used_box,-1
_gsel  1,0
used_box=1
gosub@hsp *set_menu
width@hsp winx- ginfo@hsp(10)+ ginfo@hsp(12),winy- ginfo@hsp(11)+ ginfo@hsp(13)+21,winpx,winpy
setfocus hrich
}
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 34) | _switch_sw { _switch_sw = 0
gosub@hsp *search
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 35) | _switch_sw { _switch_sw = 0
gosub@hsp *search_next
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 36) | _switch_sw { _switch_sw = 0
gosub@hsp *search_back
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 37) | _switch_sw { _switch_sw = 0
gosub@hsp *replace_
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 38) | _switch_sw { _switch_sw = 0
kana=0
gosub@hsp *set_menu
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 39) | _switch_sw { _switch_sw = 0
kana=1
gosub@hsp *set_menu
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 40) | _switch_sw { _switch_sw = 0
kanzi=0
gosub@hsp *screen_5
gosub@hsp *screen_7
gosub@hsp *screen_8
_gsel  used_box,0
gosub@hsp *set_menu
 goto@hsp *_switch_0001
_switch_sw++} if@hsp _switch_val == ( 41) | _switch_sw { _switch_sw = 0
kanzi=1
gosub@hsp *screen_5
gosub@hsp *screen_7
gosub@hsp *screen_8
_gsel  used_box,0
gosub@hsp *set_menu
 goto@hsp *_switch_0001
 } if@hsp 1 {
 goto@hsp *_switch_0001
 } *_switch_0001
return@hsp

*set_menu
newmenu the_menu,0
newmenu menu_file,1
newmenu menu_edit,1
newmenu menu_search,1
newmenu menu_view,1
newmenu menu_xime,1
newmenu menu_set,1
newmenu set_editor,1
newmenu set_kana,1
newmenu set_kanzi,1
newmenu menu_tool,1
newmenu menu_help,1
addmenu the_menu,"&File",menu_file,$10
addmenu menu_file,"&N/新規作成\tCTRL+N",7
addmenu menu_file,rep_easy("&L/讀込...\tCTRL+L",kanzi,kana),8
addmenu menu_file,rep_easy("&R/再讀込",kanzi,kana),18,(filename=="")*3
addmenu menu_file,"&S/上書き保存\tCTRL+S",9
addmenu menu_file,"&A/名前を付けて保存...\tCTRL+SHIFT+S",10
addmenu menu_file,"",,$800
addmenu menu_file,"&P/印刷... [不完全]\tCTRL+P",22
addmenu menu_file,"&U/ Page 設定...",23
addmenu menu_file,"",,$800
addmenu menu_file,"&Q/終了\tGRPH+f･4",3
addmenu the_menu,"&E/編輯",menu_edit,$10
addmenu menu_edit,"&U/元に戻す\tCTRL+Z",11
addmenu menu_edit,"",,$800
addmenu menu_edit,"&M/移動\tCTRL+X",12
addmenu menu_edit,rep_easy("&C/複寫\tCTRL+C",kanzi,kana),13
addmenu menu_edit,"&P/貼付\tCTRL+V",14
addmenu menu_edit,"&D/削除\tDEL",15
addmenu menu_edit,"",,$800
addmenu menu_edit,rep_easy("&A/全て選擇\tCTRL+A",kanzi,kana),5
addmenu menu_edit,"&E/編輯禁止",19,notedit*8
addmenu menu_edit,"",,$800
addmenu menu_edit,"&T/先頭行に移動\tCTRL+T",26
addmenu menu_edit,"&B/最終行に移動\tCTRL+B",28
addmenu menu_edit,"&J/指定行に移動...\tSHIFT+f･5",27
addmenu the_menu,rep_easy("&S/檢索",kanzi,kana),menu_search,$10
addmenu menu_search,rep_easy("&F/文字列の檢索...\tCTRL+F",kanzi,kana),34
addmenu menu_search,rep_easy("&N/次を檢索\tf･3",kanzi,kana),35
addmenu menu_search,rep_easy("&B/前を檢索\tSHIFT+f･3",kanzi,kana),36
addmenu menu_search,"&R/文字列の置換...\tCTRL+R",37
addmenu the_menu,"&V/表示",menu_view,$10
addmenu menu_view,"&W/右端で折り返す",25,(used_box==0)*cuck_mbox*8+(used_box==1)*3
addmenu menu_view,"&S/ステイタス・バァ",29,in_status*8
addmenu the_menu,"&XIME",menu_xime,$10
addmenu menu_xime,"&C/コンパイル+再生\tf･5",4
addmenu menu_xime,"&P/再生\tf･6",20
addmenu menu_xime,"&O/コンパイルのみ\tf･7",21
addmenu menu_xime,"&S/停止\tESC",6
addmenu the_menu,"&T/道具",menu_tool,$10
addmenu menu_tool,rep_easy("&I/ MIDI File から取り込む... [未實裝]",kanzi,kana),17,3
addmenu menu_tool,"&O/ MIDI File に出力...\tCTRL+f･9",16
addmenu the_menu,"&O/オプション",menu_set,$10
addmenu menu_set,"&Font...",1
addmenu menu_set,rep_easy("&B/背景色... [未實裝]",kanzi,kana),2,3
addmenu menu_set,"&A/自動インデント [不完全]",30,auto_indent*8
addmenu menu_set,"&E/エディタ [未實裝]",set_editor,$13
addmenu set_editor,"&N/標準 (メモ帳式)",32,(used_box^1)*8
addmenu set_editor,"&R/リッチ・エディット (ワードパッド式)",33,used_box*8
addmenu menu_set,rep_easy("&S/假名遣ひ",kanzi,kana),set_kana,$10
addmenu set_kana,rep_easy("&T/歴史的假名遣",kanzi,0),38,(kana^1)*8
addmenu set_kana,rep_easy("&S/表音假名遣ひ",kanzi,1),39,kana*8
addmenu menu_set,rep_easy("&T/字體",kanzi,kana),set_kanzi,$10
addmenu set_kanzi,rep_easy("&T/正字體",0,kana),40,(kanzi^1)*8
addmenu set_kanzi,rep_easy("&S/略字體",1,kana),41,kanzi*8
addmenu menu_set,"&C/初期化...",31
addmenu the_menu,"&H/ヘルプ",menu_help,$10
addmenu menu_help,rep_easy("&H/ヘルプの表示... [未實裝]\tSHIFT+f･1",kanzi,kana),24,3
applymenu the_menu
return@hsp

*shortcut
if@hsp windlg==0&&( ginfo@hsp(3)==0|| ginfo@hsp(3)==1){
stbar_text strf@hsp("line : %d",msgline+1)
}
keybd=wparam@hsp  &$FF
if@hsp (keybd==0)||(lparam@hsp>>30)||(keybd<19)&&(keybd>15): return@hsp
getkey@hsp indexus,16
keybd  | indexus<<8
getkey@hsp indexus,17
keybd  | indexus<<9
if@hsp ( ginfo@hsp(2)==0|| ginfo@hsp(2)==1)&&( ginfo@hsp(3)==0|| ginfo@hsp(3)==1){
if@hsp (keybd==116)||(keybd==123){
mmlset 0,text
if@hsp stat@hsp==0: _mmlplay ""+ 0
gosub@hsp *comperr
}
if@hsp keybd==27{
_mmlstop 0.0
}
if@hsp keybd==($200  |'A'){
gosub@hsp *choose_all
}
if@hsp keybd==($200  |'N'){
gosub@hsp *hangout
if@hsp status{
text=""
text_hangout=text
objprm@hsp 0,text
filename=""
if@hsp notedit: gosub@hsp *notedit_
gosub@hsp *set_menu
}
}
if@hsp keybd==($200  |'L')||keybd==($200  |'O'){
gosub@hsp *load
}
if@hsp keybd==($200  |'S'){
if@hsp filename!=""{
overwrite=1
}else@hsp{
overwrite=0
}
gosub@hsp *save
}
if@hsp keybd==($200  |$100  |'S'){
overwrite=0
gosub@hsp *save
}
if@hsp keybd==($200  | 120){
gosub@hsp *out_midi
}
if@hsp keybd==117{
_mmlplay ""+ 0
}
if@hsp keybd==118{
mmlset 0,text
gosub@hsp *comperr
}
if@hsp keybd==112{
keybd_event 121,-1
}
if@hsp keybd==113{
keybd_event 18,0
keybd_event 'E',-1
keybd_event 18,1
}
if@hsp keybd==($200  |'P'){
gosub@hsp *printout
}
if@hsp keybd==($100  | 112){
gosub@hsp *help
}
if@hsp keybd==($200  |'T'){
gosub@hsp *goto_top
keybd_event 17,0
}
if@hsp keybd==($100  | 116){
gosub@hsp *goto_line
}
if@hsp keybd==($200  |'B'){
keybd_event 17,1
gosub@hsp *goto_bottom
keybd_event 17,0
}
if@hsp (keybd  &$FF)==13{
if@hsp auto_indent{
notesel@hsp text
noteget@hsp dispos,msgline
tab_indent=""
repeat@hsp
if@hsp peek@hsp(dispos,cnt@hsp)==9||peek@hsp(dispos,cnt@hsp)==32{
tab_indent+strf@hsp("%c",peek@hsp(dispos,cnt@hsp))
}else@hsp{
break@hsp
}
loop@hsp
wait@hsp 1
sendmsg@hsp hmesbox,$C2,,tab_indent
noteget@hsp dispos,msgline
if@hsp how_many(dispos,"{")-how_many(dispos,"}")+1>1&&strmid@hsp(dispos,strlen@hsp(dispos)-1,1)=="="{
keybd_event 9,-1
}
noteunsel@hsp
}
}
if@hsp keybd==($100  | 221){
if@hsp auto_indent{
notesel@hsp text
noteget@hsp dispos,msgline
sendmsg@hsp hmesbox,$B0,varptr@hsp(locate)
sendmsg@hsp hmesbox,$BB,msgline
repeat@hsp locate-stat@hsp
if@hsp strmid@hsp(dispos,cnt@hsp,1)=="\t"||strmid@hsp(dispos,cnt@hsp,1)==" "{
if@hsp cnt@hsp==locate-stat@hsp-1{
repeat@hsp 2
keybd_event 8,-1
loop@hsp
keybd_event 221,-1
}
}else@hsp{
break@hsp
}
loop@hsp
noteunsel@hsp
}
}
if@hsp keybd==115||keybd==($200  |'F'){
gosub@hsp *search
}
if@hsp keybd==114{
gosub@hsp *search_next
}
if@hsp keybd==($100  | 114){
gosub@hsp *search_back
}
if@hsp keybd==($200  |'R'){
gosub@hsp *replace_
}
}
if@hsp  ginfo@hsp(3)==2{
if@hsp keybd==27{
gosub@hsp *print_end
}
}
if@hsp  ginfo@hsp(3)==4{
if@hsp keybd==27{
gosub@hsp *view_end
}
}
if@hsp  ginfo@hsp(3)==5{
if@hsp keybd==27{
gosub@hsp *page_end
}
}
if@hsp  ginfo@hsp(3)==6{
if@hsp keybd==27{
gosub@hsp *gline_end
}
if@hsp keybd==13{
gosub@hsp *gline_ok
}
}
if@hsp  ginfo@hsp(2)==7{
if@hsp keybd==27{
gosub@hsp *search_end
}
if@hsp keybd==13{
gosub@hsp *search_next
}
}
if@hsp  ginfo@hsp(2)==8{
if@hsp keybd==27{
gosub@hsp *replace_end
}
if@hsp keybd==13{
gosub@hsp *search_next
}
}
return@hsp

*choose_all
sendmsg@hsp (used_box==0)*hmesbox+(used_box==1)*hrich,$B1,0,-1
return@hsp

*hangout
dim@hsp status
if@hsp text_hangout!=text{
msgdlg rep_easy("内容が變更せられてゐます。\n保存しますか。",kanzi,kana),"確認",3+$200,2
dialog_choice=stat@hsp
if@hsp dialog_choice==2: status=0
if@hsp dialog_choice==6{
if@hsp filename!=""{
overwrite=1
}else@hsp{
overwrite=0
}
gosub@hsp *save
dim@hsp overwrite
}
if@hsp dialog_choice==7: status=1
}else@hsp{
status=1
}
dim@hsp dialog_choice
return@hsp

*save
if@hsp overwrite{
notesel@hsp text
notesave@hsp filename
text_hangout=text
status=1
}else@hsp{
notesel@hsp text
dialog@hsp "xim",17
if@hsp stat@hsp{
if@hsp getpath@hsp(refstr@hsp,2)==""{
filename=refstr@hsp+".xim"
}else@hsp{
filename=refstr@hsp
}
notesave@hsp filename
text_hangout=text
status=1
}else@hsp{
status=0
}
gosub@hsp *set_menu
}
return@hsp

*vofari
if@hsp iparam@hsp==0{
if@hsp wparam@hsp==0||wparam@hsp==1{
gosub@hsp *save_set
gosub@hsp *hangout
if@hsp status: end@hsp
}
if@hsp wparam@hsp==2{
gosub@hsp *print_end
return@hsp
}
if@hsp wparam@hsp==4{
gosub@hsp *view_end
return@hsp
}
if@hsp wparam@hsp==5{
gosub@hsp *page_end
return@hsp
}
if@hsp wparam@hsp==6{
gosub@hsp *gline_end
return@hsp
}
if@hsp wparam@hsp==7{
gosub@hsp *search_end
return@hsp
}
if@hsp wparam@hsp==8{
gosub@hsp *replace_end
return@hsp
}
}
return@hsp

*save_set
 winx=str@hsp( winx):writeprivateprofilestring  "window","sizex",winx, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winx=int@hsp( winx)}
 winy=str@hsp( winy):writeprivateprofilestring  "window","sizey",winy, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winy=int@hsp( winy)}
 winpx=str@hsp( winpx):writeprivateprofilestring  "window","posx",winpx, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winpx=int@hsp( winpx)}
 winpy=str@hsp( winpy):writeprivateprofilestring  "window","posy",winpy, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winpy=int@hsp( winpy)}
 fontname=str@hsp( fontname):writeprivateprofilestring  "font","name",fontname, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "str"=="int"{ fontname=int@hsp( fontname)}
 fontsize=str@hsp( fontsize):writeprivateprofilestring  "font","size",fontsize, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ fontsize=int@hsp( fontsize)}
 fontstyle=str@hsp( fontstyle):writeprivateprofilestring  "font","style",fontstyle, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ fontstyle=int@hsp( fontstyle)}
 in_status=str@hsp( in_status):writeprivateprofilestring  "object","stbar",in_status, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ in_status=int@hsp( in_status)}
 cuck_mbox=str@hsp( cuck_mbox):writeprivateprofilestring  "object","return",cuck_mbox, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ cuck_mbox=int@hsp( cuck_mbox)}
 auto_indent=str@hsp( auto_indent):writeprivateprofilestring  "object","indent",auto_indent, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ auto_indent=int@hsp( auto_indent)}
 used_box=str@hsp( used_box):writeprivateprofilestring  "object","rich",used_box, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ used_box=int@hsp( used_box)}
return@hsp

*load_set
winx="":getprivateprofilestring  "window","sizex",winx,winx,10, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winx=int@hsp( winx)}
winy="":getprivateprofilestring  "window","sizey",winy,winy,10, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winy=int@hsp( winy)}
winpx="":getprivateprofilestring  "window","posx",winpx,winpx,10, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winpx=int@hsp( winpx)}
winpy="":getprivateprofilestring  "window","posy",winpy,winpy,10, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ winpy=int@hsp( winpy)}
fontname="":getprivateprofilestring  "font","name",fontname,fontname,100, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "str"=="int"{ fontname=int@hsp( fontname)}
fontsize="":getprivateprofilestring  "font","size",fontsize,fontsize,6, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ fontsize=int@hsp( fontsize)}
fontstyle="":getprivateprofilestring  "font","style",fontstyle,fontstyle,3, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ fontstyle=int@hsp( fontstyle)}
in_status="":getprivateprofilestring  "object","stbar",in_status,in_status,2, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ in_status=int@hsp( in_status)}
cuck_mbox="":getprivateprofilestring  "object","return",cuck_mbox,cuck_mbox,2, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ cuck_mbox=int@hsp( cuck_mbox)}
auto_indent="":getprivateprofilestring  "object","indent",auto_indent,auto_indent,2, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ auto_indent=int@hsp( auto_indent)}
used_box="":getprivateprofilestring  "object","rich",used_box,used_box,2, ( dirinfo@hsp(1)+"\\xime.ini"):if@hsp "int"=="int"{ used_box=int@hsp( used_box)}
if@hsp winpx>= ginfo@hsp(20){
winpx=( ginfo@hsp(20)-winx)/2
}
if@hsp  ginfo@hsp(21)>winpy{
 winpy=int@hsp( winpy)
}else@hsp{
winpy=( ginfo@hsp(21)-winy)/2
}
 fontsize=int@hsp( fontsize)
 fontstyle=int@hsp( fontstyle)
 in_status=int@hsp( in_status)
 cuck_mbox=int@hsp( cuck_mbox)
 auto_indent=int@hsp( auto_indent)
 used_box=int@hsp( used_box)
return@hsp

*out_midi
dialog@hsp "mid;*.midi",17,"スタンダァド MIDI File"
if@hsp stat@hsp{
mmlset 0,text
if@hsp stat@hsp{
gosub@hsp *comperr
return@hsp
}
sheet=mmllist@modxime(0)
notesel@hsp sheet
sdim@hsp binary_data,25+ noteinfo@hsp(0)*7+3
scale_data='M','T','h','d',0,0,0,6,0,0,0,1,1,244,'M','T','r','k',0,0,0,0
byte=22
foreach@hsp scale_data
poke@hsp binary_data,cnt@hsp,scale_data(cnt@hsp)
loop@hsp
repeat@hsp  noteinfo@hsp(0)
if@hsp cnt@hsp{
noteget@hsp sheet_data_,cnt@hsp-1
}else@hsp{
sheet_data_="0:0:0:0"
}
noteget@hsp sheet_data,cnt@hsp
split@hsp sheet_data,":",time,ch,no,vel
split@hsp sheet_data_,":",time_
time=0+time
ch=0+ch
vel=0+vel
repeat@hsp (time-time_)/128+1
naru(cnt@hsp)=(time-time_)/powf@hsp(128,cnt@hsp)\128
loop@hsp
repeat@hsp limit@hsp((time-time_)/128,0)
if@hsp naru((time-time_)/128-cnt@hsp)!=0{
poke@hsp binary_data,byte,naru((time-time_)/128-cnt@hsp)+$80
byte+
}
loop@hsp
poke@hsp binary_data,byte,naru(0)
byte+
if@hsp strmid@hsp(no,0,1)=="@"{
poke@hsp binary_data,byte,$C0+ch
poke@hsp binary_data,byte+1,0+strmid@hsp(no,1,strlen@hsp(no)-1)
byte+2
}else@hsp: if@hsp strmid@hsp(no,0,1)=="P"{
poke@hsp binary_data,byte,$B0+ch
poke@hsp binary_data,byte+1,$0A
poke@hsp binary_data,byte+2,0+strmid@hsp(no,1,strlen@hsp(no)-1)
byte+3
}else@hsp{
no=0+no
poke@hsp binary_data,byte+1,no
if@hsp vel{
poke@hsp binary_data,byte,$90+ch
poke@hsp binary_data,byte+2,vel
}else@hsp{
poke@hsp binary_data,byte,$80+ch
poke@hsp binary_data,byte+2,0
}
byte+3
}
loop@hsp
if@hsp vartype@hsp(mml_title@modxime)==2{
poke@hsp binary_data,byte,0
poke@hsp binary_data,byte+1,$FF
poke@hsp binary_data,byte+2,3
byte+3
repeat@hsp 4
naru(cnt@hsp)=strlen@hsp(mml_title@modxime)/powf@hsp(128,cnt@hsp)\128
loop@hsp
repeat@hsp 3
if@hsp naru(3-cnt@hsp)!=0{
poke@hsp binary_data,byte,naru(3-cnt@hsp)+$80
byte+
}
loop@hsp
poke@hsp binary_data,byte,naru(0)
byte+
repeat@hsp strlen@hsp(mml_title@modxime)
poke@hsp binary_data,byte,peek@hsp(mml_title@modxime,cnt@hsp)
byte+
loop@hsp
}
poke@hsp binary_data,byte,0
poke@hsp binary_data,byte+1,$FF
poke@hsp binary_data,byte+2,$2F
poke@hsp binary_data,byte+3,0
byte+4
repeat@hsp 4
poke@hsp binary_data,cnt@hsp+18,(byte-22)/powf@hsp(256,3-cnt@hsp)\256
loop@hsp
if@hsp getpath@hsp(refstr@hsp,2)==""{
filename_midi=refstr@hsp+".mid"
}else@hsp{
filename_midi=refstr@hsp
}
bsave@hsp filename_midi,binary_data,byte
dialog@hsp "MIDI 出力が完了しました。\n["+filename_midi+"]",0,"MIDI 出力"
}
return@hsp

*in_midi
return@hsp

*load
gosub@hsp *hangout
if@hsp status{
notesel@hsp text
dialog@hsp "xim",16
if@hsp stat@hsp{
if@hsp getpath@hsp(refstr@hsp,2)==""{
filename=refstr@hsp+".xim"
}else@hsp{
filename=refstr@hsp
}
noteload@hsp filename
text_hangout=text
objprm@hsp 0,text
if@hsp notedit: gosub@hsp *notedit_
gosub@hsp *set_menu
}
}
return@hsp

*notedit_
notedit^1
clrobj@hsp 0,0
pos@hsp 0,0
gosub@hsp *set_mesbox
gosub@hsp *set_menu
return@hsp

*comperr
_switch_val= stat@hsp: if@hsp 0 {
_switch_sw++} if@hsp _switch_val == ( 1) | _switch_sw { _switch_sw = 0
error_mes "マクロの記述に誤りが有ります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 2) | _switch_sw { _switch_sw = 0
error_mes "アトリビュト値が異常であります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 3) | _switch_sw { _switch_sw = 0
error_mes "音長が異常であります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 4) | _switch_sw { _switch_sw = 0
error_mes "オクタヴが異常であります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 5) | _switch_sw { _switch_sw = 0
error_mes "チャンネル値が異常であります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 6) | _switch_sw { _switch_sw = 0
error_mes rep_easy("プログラム・チェインヂ番號が異常であります。",kanzi,kana)
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 7) | _switch_sw { _switch_sw = 0
error_mes "Loop の記述に誤りが有ります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 8) | _switch_sw { _switch_sw = 0
error_mes rep_easy("Loop 外で \"/\" が使はれてゐます。",kanzi,kana)
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 9) | _switch_sw { _switch_sw = 0
error_mes "Loop のネストが深すぎます。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 10) | _switch_sw { _switch_sw = 0
error_mes "定義済みのマクロであります。"
 goto@hsp *_switch_0002
_switch_sw++} if@hsp _switch_val == ( 11) | _switch_sw { _switch_sw = 0
error_mes "未定義のマクロであります。"
 goto@hsp *_switch_0002
 } *_switch_0002
objsel@hsp 0
return@hsp

*help
return@hsp

*printout
if@hsp cannot_printout{
dialog@hsp rep_easy("hspprint.dll が見つからないため印刷を行はれません。",kanzi,kana),1,"エラー"
return@hsp
}
if@hsp pnum==0{
dialog@hsp rep_easy("利用可能なプリンタが見つからないため印刷を行はれません。",kanzi,kana),1,"エラー"
return@hsp
}
_gsel  used_box,0
wx_= ginfo@hsp(4)
wy_= ginfo@hsp(5)
enablewindow hwnd@hsp,0
propprn sx,sy,useid,0
propprn sx_,sy_,useid,3
sx=limit@hsp(sx,1):sy=limit@hsp(sy,1)
sx_=limit@hsp(sx_,1):sy_=limit@hsp(sy_,1)
pmx_time=1.*sx/sx_
pmy_time=1.*sy/sy_
buffer@hsp 3,sx,sy
font@hsp print_fname,(pmx_time+pmy_time)*(0.352778*print_pts) /2
color@hsp 0,0,0
print_text=text+"\n"
strrep@hsp print_text,"\t","        "
notesel@hsp print_text
 i=0:*_for_0008:exgoto@hsp  i,1, noteinfo@hsp(0),*_break_0008
noteget@hsp test_data,i
if@hsp print_width*2<strlen@hsp(test_data){
noteadd@hsp strmid@hsp(test_data,print_width*2,strlen@hsp(test_data)-print_width*2),i+1,0
}
test_data=strmid@hsp(test_data,0,print_width*2)
repeat@hsp strlen@hsp(test_data)
dat_byte=peek@hsp(test_data,cnt@hsp)
if@hsp char_full{
char_full=0
}else@hsp{
if@hsp $20<=dat_byte&&dat_byte<=$7E||($A1<=dat_byte&&dat_byte<=$DF){
pos@hsp pmx_time*((0.0+sx_-print_left-print_right)*cnt@hsp/(print_width*2)+((0.0+sx_-print_left-print_right)/(print_width*2)-(0.352778*print_pts) /2)/2+print_left),pmy_time*((0.0+sy_-print_top-print_bottom)*i/print_height+((0.0+sy_-print_top-print_bottom)/print_height-(0.352778*print_pts) )/2+print_top)
print@hsp strf@hsp("%c",dat_byte)
}else@hsp: if@hsp $81<=dat_byte&&dat_byte<=$9F||($E0<=dat_byte&&dat_byte<=$FC)&&(cnt@hsp<strlen@hsp(test_data)-1){
pos@hsp pmx_time*((0.0+sx_-print_left-print_right)*cnt@hsp/(print_width*2)+((0.0+sx_-print_left-print_right)/print_width-(0.352778*print_pts) )/2+print_left),pmy_time*((0.0+sy_-print_top-print_bottom)*i/print_height+((0.0+sy_-print_top-print_bottom)/print_height-(0.352778*print_pts) )/2+print_top)
print@hsp strf@hsp("%c%c",dat_byte,peek@hsp(test_data,cnt@hsp+1))
char_full=1
}
}
loop@hsp
 *_continue_0008: i+=1:goto@hsp *_for_0008:*_break_0008
noteunsel@hsp
color@hsp 255,255,255
repeat@hsp 4
boxf@hsp (cnt@hsp==3)*(-pmx_time*print_right+ ginfo@hsp(26)),(cnt@hsp==1)*(-pmy_time*print_bottom+ ginfo@hsp(27)),(cnt@hsp!=2)* ginfo@hsp(26)+(cnt@hsp==2)*(pmx_time*print_left)-1,(cnt@hsp!=0)* ginfo@hsp(27)+(cnt@hsp==0)*(pmy_time*print_top)-1
loop@hsp
color@hsp 0,0,0
_gsel  2,0
width@hsp ,,wx_+16,wy_+16
_gsel  2,1
return@hsp

*set_printer
prndialog useid
return@hsp

*go_printout
_gsel  3,0
if@hsp filename!=""{
doc_name=getpath@hsp(filename,8)
}else@hsp{
doc_name="(無題)"
}
execprn useid,0,0,sx,sy,0,0,sx,sy,doc_name
gosub@hsp *print_end
return@hsp

*update_pinfo
exist@hsp  dirinfo@hsp(1)+"\\hspprint.dll"
if@hsp strsize@hsp==-1{
cannot_printout=1
return@hsp
}
syscolor@hsp 4
boxf@hsp
syscolor@hsp 7
enumprn plist
pnum=stat@hsp
getdefprn def_printer
notesel@hsp plist
repeat@hsp pnum
noteget@hsp s1,cnt@hsp
if@hsp s1==def_printer{
useid=cnt@hsp
noteadd@hsp s1+" (規定)",cnt@hsp,1
}
loop@hsp
noteunsel@hsp
objsize@hsp 480
objmode@hsp 2,1
pos@hsp ( ginfo@hsp(12)-480)/2,16
print@hsp rep_easy("プリンタを選擇してください：",kanzi,kana)
listbox@hsp useid,150,plist
button@hsp gosub@hsp "印刷",*go_printout
button@hsp gosub@hsp "印刷 Preview",*print_view
button@hsp gosub@hsp "プリンタの設定",*set_printer
button@hsp gosub@hsp "プリンタ情報の更新",*update_pinfo
return@hsp

*print_end
_gsel  2,-1
_gsel  used_box,1
enablewindow hwnd@hsp,1
return@hsp

*view_end
_gsel  4,-1
_gsel  used_box,1
enablewindow hwnd@hsp,1
windlg=0
return@hsp

*print_view
windlg=1
gosub@hsp *print_end
_gsel  used_box,0
enablewindow hwnd@hsp,0
_gsel  4,0
title@hsp "印刷 Preview"
width@hsp double@hsp(sx)/(1.1*sy/ ginfo@hsp(21)),1f* ginfo@hsp(21)/1.1,(pos_taskbar()==2)*width_taskbar(),(pos_taskbar()==1)*height_taskbar()
gzoom@hsp  ginfo@hsp(12), ginfo@hsp(13),3,0,0,sx,sy,1
_gsel  4,1
return@hsp

*win_dialog
setwindowlong hwnd@hsp,-16,getwindowlong(hwnd@hsp,-16) &$70000^getwindowlong(hwnd@hsp,-16)
setwindowlong hwnd@hsp,-8,mwhw(used_box)
setwindowpos hwnd@hsp,0,0,0,0,0,39
deletemenu getsystemmenu(hwnd@hsp),$F000
deletemenu getsystemmenu(hwnd@hsp),$F020
deletemenu getsystemmenu(hwnd@hsp),$F030
deletemenu getsystemmenu(hwnd@hsp),$F120
return@hsp

*page_ok
print_width=print_width_
print_height=print_height_
print_top=print_top_
print_bottom=print_bottom_
print_left=print_left_
print_right=print_right_
print_pts=print_pts_
print_fname=print_fname_
gosub@hsp *page_end
return@hsp

*page_end
_gsel  5,-1
objint print_width,2
objint print_height,3
objint print_left,4
objint print_top,5
objint print_right,6
objint print_bottom,7
objint print_pts,8
objprm@hsp 9,print_fname
_gsel  used_box,1
enablewindow hwnd@hsp,1
return@hsp

*print_font
fontdlg dispos
if@hsp stat@hsp{
print_fname_=refstr@hsp
print_pts_=dispos(2)
}
objprm@hsp 9,print_fname_
objint print_pts_,8
return@hsp

*make_mesbox
cuck_mbox^1
clrobj@hsp 0,0
pos@hsp 0,0
gosub@hsp *set_mesbox
gosub@hsp *set_menu
return@hsp

*goto_top
if@hsp used_box==0{
sendmsg@hsp hmesbox,$B1
}else@hsp: if@hsp used_box==1{
sendmsg@hsp hrich,$B1
sendmsg@hsp hrich,$B7
}
return@hsp

*goto_line
_gsel  used_box,0
wx_= ginfo@hsp(4)
wy_= ginfo@hsp(5)
enablewindow hwnd@hsp,0
_gsel  6,0
objprm@hsp 0,msgline+1
width@hsp ,,wx_,wy_+45
_gsel  6,1
objsel@hsp 0
return@hsp

*gline_ok
gline_ok_=1
gosub@hsp *gline_end
return@hsp

*gline_end
_gsel  6,-1
_gsel  used_box,1
enablewindow hwnd@hsp,1
objsel@hsp 0
if@hsp gline_ok_{
if@hsp used_box==0{












notesel@hsp text
go_line=0
repeat@hsp what_line-1
noteget@hsp work,cnt@hsp
go_line+strlen@hsp(work)+2
loop@hsp
sendmsg@hsp hmesbox,$B1,go_line,go_line
noteunsel@hsp
}else@hsp: if@hsp used_box==1{
sendmsg@hsp hrich,$B1,-1
sendmsg@hsp hrich,$BB,what_line-1
go_line(0)=stat@hsp
sendmsg@hsp hrich,$BB,what_line
go_line(1)=stat@hsp
sendmsg@hsp hrich,$B7,0,go_line(0)
sendmsg@hsp hrich,$B1,go_line(0),go_line(0)
sendmsg@hsp hrich,$B1,go_line(0),go_line(1)-2
sendmsg@hsp hrich,$B7,0,go_line(0)
}
gline_ok_=0
}
return@hsp

*goto_bottom
if@hsp used_box==0{
sendmsg@hsp hmesbox,$BA
line_max=stat@hsp
notesel@hsp text
go_line=0
repeat@hsp line_max-1
noteget@hsp work,cnt@hsp
go_line+strlen@hsp(work)+2
loop@hsp
sendmsg@hsp hmesbox,$B1,go_line,go_line
noteunsel@hsp
}else@hsp: if@hsp used_box==1{
sendmsg@hsp hrich,$BA
line_max=stat@hsp
sendmsg@hsp hrich,$BB,line_max
go_line=stat@hsp
sendmsg@hsp hrich,$B1,go_line,go_line
sendmsg@hsp hrich,$B7
}
return@hsp

*set_msgline
sendmsg@hsp (used_box==0)*hmesbox  |(used_box==1)*hrich,$C9,-1
msgline=stat@hsp
return@hsp

*set_mesbox
mesbox@hsp text, ginfo@hsp(12), ginfo@hsp(13)-stbar_sy@stbar( ginfo@hsp(3))*in_status,5-notedit-4*cuck_mbox
hmesbox=objinfo@hsp(stat@hsp,2) 
return@hsp

*make_bone
prgname="XIME Is not Music Environment!!"
width@hsp winx- ginfo@hsp(10)+ ginfo@hsp(12),winy- ginfo@hsp(11)+ ginfo@hsp(13),winpx,winpy
setwindowlong hwnd@hsp,-16,getwindowlong(hwnd@hsp,-16) |$10000  |$40000
return@hsp

*chg_font
sendmsg@hsp hrich,$B1,0,-1
mref@hsp bmscr,67
dim@hsp cformat,15
dc=getdc(hrich)
cformat=60,$E800000F,fontstyle,0+1f*fontsize*1440/getdevicecaps(dc,$5A)
releasedc hrich,dc
cformat(5)=bmscr(40)
poke@hsp cformat,24,$80
poke@hsp cformat,26,fontname
logfont=bmscr(39)
if@hsp bmscr(38)!=logfont{
logfont=bmscr(38)
getobject holdfon,60,varptr@hsp(lf)
hfont=createfontindirect(varptr@hsp(lf))
}
sendmsg@hsp hrich,$30,hfont,1
sendmsg@hsp hrich,$444,1,varptr@hsp(cformat)
sendmsg@hsp hrich,$B1
setfocus hrich
return@hsp

*format_set
gosub@hsp *normal_set
width@hsp,,( ginfo@hsp(20)- ginfo@hsp(12))/2,( ginfo@hsp(21)- ginfo@hsp(13))/2
gosub@hsp *save_set
return@hsp

*search_next
repeat@hsp 2
_gsel  7,0
sendmsg@hsp objinfo@hsp(3-cnt@hsp,2) ,$F0
if@hsp stat@hsp{
searching cnt@hsp
}
_gsel  used_box,1
loop@hsp
return@hsp

*search_back
repeat@hsp 2
_gsel  7,0
sendmsg@hsp objinfo@hsp(2+cnt@hsp,2) ,$F0
if@hsp stat@hsp{
searching cnt@hsp
}
_gsel  used_box,1
loop@hsp
return@hsp

*search
search_dialog=1
_gsel  7,1
width@hsp,,winpx+80,winpy+64
objsel@hsp 0
_gunsel 0
return@hsp

*search_end
search_dialog=0
_gsel  7,-1
_gsel  used_box,1
if@hsp used_box==0{
objsel@hsp 0
}
return@hsp

*normal_set
fontname="FixedSys"
fontsize="19"
fontstyle="0"
in_status="1"
cuck_mbox="0"
auto_indent="0"
used_box="0"
return@hsp

*replace_
_gsel  8,1
width@hsp,,winpx+80,winpy+64
objsel@hsp 0
_gunsel 0
return@hsp

*replace_all
if@hsp used_box==0{
_gsel  0,1
if@hsp keyword!=""{
strrep@hsp text,keyword,keyword_rep
}
objprm@hsp 0,text
_gunsel 0
}
return@hsp

*replace_end
_gsel  8,-1
_gunsel  1
if@hsp used_box==0{
objsel@hsp 0
}
return@hsp

*screen_5
screen@hsp 5,18*16,17*16+32,6
gosub@hsp *win_dialog
title@hsp "Page 設定"
syscolor@hsp 4
boxf@hsp
syscolor@hsp 7
objsize@hsp 100,24
pos@hsp ( ginfo@hsp(12)/2-100)/2,17*16+4
button@hsp gosub@hsp "OK",*page_ok
pos@hsp ( ginfo@hsp(12)/2*3-100)/2,17*16+4
button@hsp gosub@hsp "キャンセル",*page_end
objsize@hsp 48,16
pos@hsp 64,32
input@hsp print_width_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
pos@hsp 12*16,32
input@hsp print_height_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
pos@hsp 64,112
input@hsp print_left_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
input@hsp print_top_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
pos@hsp 12*16,112
input@hsp print_right_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
input@hsp print_bottom_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
objsize@hsp 96,16
pos@hsp 96,224
input@hsp print_pts_
setwindowlong objinfo@hsp(stat@hsp,2) ,-16,$50010082
objsize@hsp 128,16
pos@hsp 96,208
input@hsp print_fname_
pos@hsp 14*16,208
objsize@hsp 32,32
button@hsp gosub@hsp rep_easy("參照",kanzi,kana),*print_font
pos@hsp 0,0
prints rep_easy({"
┏━━字數━━━━━━━━━━━━┓
┃　　　　　　　　　　　　　　　　┃
┃　橫：　　　字　　縱：　　　字　┃
┃　　　　　　　　　　　　　　　　┃
┗━━━━━━━━━━━━━━━━┛
┏━━餘白━━━━━━━━━━━━┓
┃　　　　　　　　　　　　　　　　┃
┃　左：　　　mm　　右：　　　mm　┃
┃　上：　　　mm　　下：　　　mm　┃
┃　　　　　　　　　　　　　　　　┃
┗━━━━━━━━━━━━━━━━┛
┏━━Font━━━━━━━━━━━━┓
┃　　　　　　　　　　　　　　　　┃
┃　名前　：　　　　　　　　　　　┃
┃　サイズ：　　　　　　pts.　　　┃
┃　　　　　　　　　　　　　　　　┃
┗━━━━━━━━━━━━━━━━┛
"},kanzi,kana), "ＭＳ ゴシック",16
objint print_width_,2
objint print_height_,3
objint print_left_,4
objint print_top_,5
objint print_right_,6
objint print_bottom_,7
objint print_pts_,8
return@hsp

*screen_7
screen@hsp 7,484,111,6
gosub@hsp *win_dialog
title@hsp rep_easy("檢索",kanzi,kana)
syscolor@hsp 4
boxf@hsp
syscolor@hsp 7
font@hsp  "ＭＳ ゴシック",12
pos@hsp 8,12
print@hsp rep_easy("檢索する文字列",kanzi,kana)
pos@hsp 96,6
input@hsp keyword,294,24
pos@hsp  ginfo@hsp(12), ginfo@hsp(13)
print@hsp "大文字と小文字を区別する"
objsize@hsp  ginfo@hsp(14)+32, ginfo@hsp(15)
pos@hsp 8,80
chkbox@hsp rep_easy("大文字と小文字を區別する",kanzi,kana),distinguish
objsize@hsp 50
pos@hsp 300,55
chkbox@hsp "上へ",search_up
sendmsg@hsp objinfo@hsp(stat@hsp,2) ,$F4,9
pos@hsp 300,75
chkbox@hsp "下へ",search_down
sendmsg@hsp objinfo@hsp(stat@hsp,2) ,$F4,9
objsize@hsp 108,70
pos@hsp 280,35
groupbox "方向"
objsize@hsp 80,24
pos@hsp 395,6
button@hsp gosub@hsp rep_easy("次を檢索",kanzi,kana),*search_next
pos@hsp  ginfo@hsp(22), ginfo@hsp(23)+5
button@hsp gosub@hsp "キャンセル",*search_end
return@hsp

*screen_8
screen@hsp 8,500,156,6
gosub@hsp *win_dialog
title@hsp "置換"
syscolor@hsp 4
boxf@hsp
syscolor@hsp 7
input@hsp keyword,320,24
input@hsp keyword_rep,320,24
button@hsp gosub@hsp rep_easy("次を檢索",kanzi,kana),*search_next
button@hsp gosub@hsp "全て置換",*replace_all
return@hsp
