#module Toolbar

#uselib "comctl32.dll" 
	#func InitCommonControls "InitCommonControls" 
	#func CreateToolbarEx "CreateToolbarEx" int,int,int,int,int,int,var,int,int,int,int,int,int 

#uselib "user32.dll"
	#func LoadImage "LoadImageA" int,str,int,int,int,int

#deffunc ToolInit str p1,int p2,int p3,int p4
	size_x=p2:size_y=p3
	tool_how=p4
	InitCommonControls
	LoadImage 0,p1,0,p2*p4,p3,$8010
	hImg=stat
	Dim tb,5,1
	tool_num=0
	sep_num=0
	Return

#deffunc ToolAdd int p2,int p1
	If p1==$800{
		tb(0,tool_num+sep_num)=0,0,256,0,0
		sep_num+
	}Else{
		tb(0,tool_num+sep_num)=tool_num,p2,4,0,0
		tool_num+
	}
	Return

#deffunc ToolApply label p1
	CreateToolbarEx hwnd,$50000000,0,tool_how,0,hImg,tb,tool_num+sep_num,size_x,size_y,0,0,20
	hToolbar=stat
	SendMsg hToolbar,$421,0,0
	OnCmd GoSub p1,$111
	Return

#global
