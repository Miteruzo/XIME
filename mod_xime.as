;*******************************************************************************
; ワﾟイル名  : mod_xime.as
; 更新年月日 : 平29/09/08
; 作成者     : Taker32X
; 作成年月日 : 平28/11/03
; 機能       : XIME 式 MML のコンパイルを行ふ
;*******************************************************************************

;------------------------------------ TODO ------------------------------------
;
; 1. ルプは MML 全體ではなくチャンネル單位で行ふ様にする。
;
; 2. 書式 "[?]*" を使つた無限ルプの實現。
;
; 3. コンパイルの高速化を檢討。
;
;------------------------------------------------------------------------------

#ifndef __MOD_XIME__	; 二重定義防止

#define global __MOD_XIME__

#define global __MMLPLAY_DUAL_RUN__

#ifndef __MMLPLAY_DUAL_RUN__

	midi_handle@mod_mmlplay=0
	code__@mod_mmlplay=""
	time__@mod_mmlplay=""
	ch_@mod_mmlplay=""
	no@mod_mmlplay=""
	velocity@mod_mmlplay=""

#endif

#module local_module

	ch@modxime=0
	looping@modxime=0

#deffunc local loop_end_func
	loop_end@modxime(ch@modxime,looping@modxime(ch@modxime))=-1
	loop_time@modxime(ch@modxime,looping@modxime(ch@modxime))=0
	loop_cnt@modxime(ch@modxime,looping@modxime(ch@modxime))=0
	return

#global

#module modxime

#ifndef __MMLPLAY_DUAL_RUN__

#uselib "user32
#func SetTimer "SetTimer" int,int,int,int
#func KillTimer "KillTimer" int,int

#uselib "winmm
#func midiOutReset "midiOutReset" int
#func midiOutClose "midiOutClose" int

#endif

#uselib "kernel32
#func CreateFileMapping "CreateFileMappingA" sptr,sptr,sptr,sptr,sptr,str
#cfunc GetLastError "GetLastError"
#func MapViewOfFile "MapViewOfFile" sptr,sptr,sptr,sptr,sptr
#func UnmapViewOfFile "UnmapViewOfFile" sptr
#func CloseHandle "CloseHandle" sptr

#const FILE_MAP_WRITE $02
#const FILE_MAP_READ $04
#const PAGE_READWRITE $04
#const ERROR_ALREADY_EXISTS $B7

#define swap(%1,%2)\
	kari=%1:\
	%1=%2:\
	%2=kari

#define Sort(%1,%2,%3=0) _Sort Int(%1),Int(%2),%3

;#define global beep(%1=0,%2=100) _beep %1,%2
#define global mmlplay(%1="0") _mmlplay ""+%1
#define global mmlclear(%1=-1) _mmlclear %1
#define global mmlstop(%1=0.0) _mmlstop %1

#deffunc mml_cleanup onexit
	mmlstop
	#ifndef __MMLPLAY_DUAL_RUN__
	midiOutReset midi_handle@mod_mmlplay
	midiOutClose midi_handle@mod_mmlplay
	#endif
	CloseHandle handle_exist
	CloseHandle handle_data
	CloseHandle handle_byte
	return

#deffunc local _Sort int p1,int p2,int p3
/*	
	Repeat 16
		NoteGet work,sheet_line(cnt_)
		cnt_=cnt
		If time(cnt)>work{
			Repeat NoteMax-sheet_line(cnt_)
				NoteGet work,sheet_line(cnt_)
				Split work,":",work
				If time(cnt_)<=work{
					Break
				}
				sheet_line(cnt_)+
			Loop
		}Else{
			Repeat NoteMax-sheet_line(cnt_)
				NoteGet work,sheet_line(cnt_)
				Split work,":",work
				If time(cnt_)>=work{
					Break
				}
				sheet_line(cnt_)-
			Loop
		}
	Loop
*//*
	If p3==1{
;		NoteAdd ""+Int(time(ch))+":"+ch+":@"+p1+":"+p2+":"+i,sheet_line(ch)
		sheet+""+Int(time(ch))+":"+ch+":@"+p1+":"+p2+":"+i+"\n
	}Else: If p3==2{
;		NoteAdd ""+Int(time(ch))+":"+ch+":P"+p1+":"+p2+":"+i,sheet_line(ch)
		sheet+""+Int(time(ch))+":"+ch+":P"+p1+":"+p2+":"+i+"\n
	}Else{
;		NoteAdd ""+int(time(ch))+":"+ch+":"+p1+":"+p2+":"+i,sheet_line(ch)
		sheet+""+Int(time(ch))+":"+ch+":"+p1+":"+p2+":"+i+"\n
	}
*/
	lPoke sheet,put_byte,Int(time(ch))
	Poke sheet,put_byte+4,16*p3 or ch
	Poke sheet,put_byte+5,p1
	Poke sheet,put_byte+6,p2
	lPoke sheet,put_byte+7,i
	put_byte+11
	Return

*compile
	put_byte=0
	error=0
	Dim warning,1
	warning_num=0
	chord=0
	sdim mml,65536
	notesel text
		repeat notemax
			noteget textline,cnt
			split textline,";",textline
			split textline,"//",textline
			noteadd textline,cnt,1
		loop
	noteunsel
	mml=text
	ch=0
	tempo_num=1
	tempo=120
	ct_time=0.0
	repeat 16
		length_(cnt)=4.0
		octave(cnt)=4
		velocity(cnt)=96
		time(cnt)=0.0
		qlength(cnt)=0.0
		key_scale(cnt)=0
		slur(cnt)=0
		looping(cnt)=0
	loop
	dim loop_pos,16,64
	dim loop_time,16,64
	dim loop_cnt,16,64
	dim loop_end,16,64
	Dim sheet_line,16
	sdim sheet,3145728
	sdim dispos
	notesel mml
		title_line=notefind("#title",1)
		copy_line=notefind("#copy",1)
		if title_line!=-1{
			sdim mml_title,2
			noteget mml_title,title_line
			notedel title_line
			noteadd "",title_line
			mml_title=strmid(mml_title,6,strlen(mml_title)-6)
			split mml_title,"\"",mml_title
			if stat>=2{
				mml_title=mml_title(1)
			}
		}else{
			mml_title=0
		}
		if copy_line!=-1{
			sdim copyright,2
			noteget copyright,copy_line
			notedel copy_line
			noteadd "",copy_line
			copyright=strmid(copyright,5,strlen(copyright)-5)
			split copyright,"\"",copyright
			if stat>=2{
				copyright=copyright(1)
			}
		}else{
			copyright=0
		}
	noteunsel
	strrep mml,"　","  "
	strrep mml,"\t\t","  "
	repeat 26
		strrep mml,strf("%c",'A'+cnt),strf("%c",'a'+cnt)
	loop
	strrep mml,"\n","\t\t"
	macronum=0
	split mml,"}"
	dispos=stat
	split mml,"{"
	if stat==dispos{
		sdim valiable_,,dispos
		sdim value_,,dispos
		sdim par,,100
		sdim par_,,dispos,100
		for i,0,strlen(mml)
			char=strmid(mml,i,1)
			if char=="{"{
				no="
				valiable="
				value="
				namikwat=0
				repeat
					char=strmid(mml,i+cnt+1,1)
					if char=="{"{
						namikwat+
						no+char
					}else: if char=="}"{
						if namikwat{
							namikwat-
							no+char
						}else{
							i+cnt
							break
						}
					}else{
						no+char
					}
				loop
				split no,"=",valiable,value
				if stat<=1{
					for j,0,strlen(valiable)
						char=strmid(valiable,j,1)
						if char=="("{
							no_="
							repeat
								char=strmid(valiable,j+cnt+1,1)
								if char==" "||char=="\t"{
								}else: if char!=")"{
									no_+char
								}else{
									j+cnt
									break
								}
							loop
							split no_,",",par
						}
					next
					split valiable,"(",valiable
					flag=0
					repeat macronum
						if valiable==valiable_(cnt){
							flag=1
							cnt_=cnt
							value=value_(cnt)
							for j,0,length(par)-1
								for k,j+1,length(par)
									if strlen(par_(cnt_,j))<strlen(par_(cnt_,k)){
										swap par_(cnt_,j),par_(cnt_,k)
										swap par(j),par(k)
									}
								next
							next
							foreach par
								if par_(cnt_,cnt)!=""{
									strrep value,par_(cnt_,cnt),par(cnt)
								}
							loop
							strrep mml,"{"+no+"}",value
							break
						}
					loop
					if flag==0{
						statement_e="{
						no+"}
						error=11
						GoTo *make_sheet
					}
				}else{
					for j,0,strlen(valiable)
						char=strmid(valiable,j,1)
						if char=="("{
							no_="
							repeat
								char=strmid(valiable,j+cnt+1,1)
								if char==" "||char=="\t"{
								}else: if char!=")"{
									no_+char
								}else{
									j+cnt
									break
								}
							loop
							split no_,",",par
						}
					next
					split valiable,"(",valiable
					for j,0,macronum
						if valiable==valiable_(j){
							statement_e="{
							no+"}
							error=10
							goto *make_sheet
						}
					next
					valiable_(macronum)=valiable
					value_(macronum)=value
					foreach par
						par_(macronum,cnt)=par(cnt)
					loop
					work="
					split no,"\t\t
					repeat limit(stat-1,0)
						work+"\t\t
					loop
					strrep mml,"{"+no+"}",work
					macronum+
				}
				i=-1
			}
		next
	}else{
		statement_e="
		no="
		error=1
	}
	if error: goto *make_sheet
	for i,0,strlen(mml)
		repeat tempo_num-1,1
			if ct_time(tempo_num-cnt)<=time(ch){
				tempo(0)=tempo(tempo_num-cnt)
				break
			}
		loop
		char=strmid(mml,i,1)
		statement_e=char
		if char=="t"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"{
					no+char
					if 1>no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 1>no{
				error=2
				_break
			}
			tempo(tempo_num)=0+no
			ct_time(tempo_num)=time(ch)
			tempo_num+
		}else: if char=="l"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"||char=="."{
					no+char
					if 0>=no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0>=no{
				error=3
				_break
			}
			split no,"."
			period=stat
			no_=double(int(no))
			no=0.0
			repeat period
				no+4.0/no_/powf(2,cnt)
			loop
			length_(ch)=4.0/no
		}else: if char=="o"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"{
					no+char
					if -1>no||9<no||no=""||(strlen(no)>=2&&no!="-1"){
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if -1>no||9<no||no==""||(strlen(no)>=2&&no!="-1")||no=="-"{
				error=4
				_break
			}
			octave(ch)=0+no
		}else: if char=="v"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"{
					no+char
					if 0>no||127<no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0>no||127<no{
				error=2
				_break
			}
			velocity(ch)=0+no
		}else: if peek(char,0)>='a'&&peek(char,0)<='g'{
			scale=char
			switch char
				case "c"
					scale_=0
					swbreak
				case "d"
					scale_=2
					swbreak
				case "e"
					scale_=4
					swbreak
				case "f"
					scale_=5
					swbreak
				case "g"
					scale_=7
					swbreak
				case "a"
					scale_=9
					swbreak
				case "b"
					scale_=11
					swbreak
			swend
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="."{
					no+char
					if no!=""&&0>=no&&no!="."{
						break
					}
				}else: if char=="+"||char=="#"{
					scale_+
				}else: if char=="-"{
					scale_-
				}else: if char=="&"{
					chord=1
				}else: if char=="^"{
					scale_+12
				}else: if char=="_"{
					scale_-12
				}else: if char=="~"{
					slur(ch)=1
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			the_scale=12*(octave(ch)+1)+scale_+key_scale(ch)
			If the_scale<0||the_scale>127{
				error=12
				_break
			}
			length2_=length_(ch)
			if no!=""{
				if 0>=no&&no!="."{
					error=3
					_break
				}
				split no,".",no
				period=stat
				if no=="": no=length2_
				no_=double(int(no))
				no=0.0
				repeat period
					no+4.0/no_/powf(2,cnt)
				loop
				length2_=4.0/no
			}
			if slur(ch)!=2{
				Sort the_scale,velocity(ch)
			}else{
				slur(ch)=0
			}
			if qlength(ch){
				time(ch)+(240000.0/tempo/length2_)+(240000.0/tempo/qlength(ch))
			}else{
				time(ch)+(240000.0/tempo/length2_)
			}
			if slur(ch)!=1{
				time(ch)-
				Sort the_scale,0
				time(ch)+
			}else{
				slur(ch)=2
			}
			if qlength(ch){
				time(ch)-(240000.0/tempo/qlength(ch))
			}
			if chord{
				chord=0
				time(ch)-(240000.0/tempo/length2_)
			}
		}else: if char=="<"{
			no="
			if octave(ch)>=9{
				error=4
				_break
			}
			octave(ch)+
		}else: if char==">"{
			no="
			if octave(ch)<=-1{
				error=4
				_break
			}
			octave(ch)-
		}else: if char=="r"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="."{
					no+char
					if no!=""&&0>=no&&no!="."{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			length2_=length_(ch)
			if no!=""{
				if 0>=no&&no!="."{
					error=3
					_break
				}
				split no,".",no
				period=stat
				if no=="": no=length2_
				no_=double(int(no))
				no=0.0
				repeat period
					no+4.0/no_/powf(2,cnt)
				loop
				length2_=4.0/no
			}
			time(ch)+(240000.0/tempo/length2_)
			Sort 0,0
		}else: if char=="!"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"{
					no+char
					if 0>no||15<no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if ch!=no&&looping(ch)!=0&&loop_cnt(ch,looping(ch))!=0{
				repeat
					char=strmid(mml,i+cnt+1,1)
					if char=="!"{
						i+cnt
						break
					}
				loop
			}else{
				if 0>no||15<no{
					error=5
					_break
				}
				ch=0+no
			}
		}else: if char=="@"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'{
					no+char
					if 0>no||127<no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0>no||127<no{
				error=6
				_break
			}
			Sort no,0,1
		}else: if char=="n"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'{
					no+char
					if 0>no||127<no{
						break
					}
				}else: if char=="&"{
					chord=1
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0>no||127<no{
				error=2
				_break
			}
			scale_=0+no
			Sort scale_,velocity(ch)
			if qlength(ch): time(ch)+(240000.0/tempo/length_(ch))+(240000.0/tempo/qlength(ch)) :else: time(ch)+(240000.0/tempo/length_(ch))
			Sort scale_,0
			if qlength(ch): time(ch)-(240000.0/tempo/qlength(ch))
			if chord{
				chord=0
				time(ch)-(240000.0/tempo/length_(ch))
			}
		}else: if char=="q"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"||char=="."{
					no+char
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0==no{
				qlength(ch)=0.0
			}else{
				split no,"."
				period=stat
				no_=double(int(no))
				no=0.0
				repeat period
					no+4.0/no_/powf(2,cnt)
				loop
				qlength(ch)=4.0/no
			}
		}else: if char=="k"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"{
					no+char
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			key_scale(ch)=0+no
		}else: if char=="p"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'{
					no+char
					if 0>no||127<no{
						break
					}
				}else: if char==" "||char=="\t"{
				}else{
					i+cnt
					break
				}
			loop
			if 0>no||127<no{
				error=2
				_break
			}
			Sort no,0,2
		}else: if char=="["{
			if looping(ch)>=64{
				error=9
				_break
			}
			loop_pos(ch,looping(ch))=i
			looping(ch)+
		}else: if char=="]"{
			no="
			repeat
				char=strmid(mml,i+cnt+1,1)
				if peek(char,0)>='0'&&peek(char,0)<='9'{
					no+char
				}else: if char==" "||char=="\t"{
					if looping(ch)<1{
						break
					}
				}else{
					i+cnt
					break
				}
			loop
			looping(ch)-
			if looping(ch)<0{
				error=7
				_break
			}
			loop_end(ch,looping(ch))=i
			loop_time(ch,looping(ch))=0+no
			loop_cnt(ch,looping(ch))+
			if loop_cnt(ch,looping(ch))<loop_time(ch,looping(ch)){
				i=loop_pos(ch,looping(ch))-1
			}else{
				loop_end_func@local_module
			}
		}else: if char=="/"{
			no="
			if looping(ch)>0{
				if loop_time(ch,looping(ch)-1)-loop_cnt(ch,looping(ch)-1)==1{
					i=loop_end(ch,looping(ch)-1)-1
					looping(ch)-
					loop_end_func@local_module
				}
			}else{
				error=8
				_break
			}
		}else: if char==" "||char=="\t"{
		}else{
			warning(warning_num)=1
			warning_num+
		}
	next
	LogMes sheet

*make_sheet
	if error{
		work=strmid(mml,0,i+1)
		strrep work,"\t\t","\n
		if error==1{
			work=text
		}
		notesel work
			ern=notemax
		noteunsel
		MemCpy sheet,sheet_back,back_byte
		return
	}
	if put_byte/11{
		Dim code,put_byte/11
		Dim code2,put_byte/11
		Dim code3,put_byte/11
		Dim code4,put_byte/11
		Repeat put_byte/11
			code(cnt)=lPeek(sheet,cnt*11)
			code2(cnt)=lPeek(sheet,cnt*11+4)
			code3(cnt)=wPeek(sheet,cnt*11+8)
			code4(cnt)=Peek(sheet,cnt*11+10)
		Loop
		#ifndef __COMPILE_HSP35__
			repeat put_byte/11-1
				cnt_=cnt
				repeat put_byte/11-cnt_-1,cnt_+1
					if code(cnt_)>code(cnt){
						cnt__=cnt
							Swap code(cnt_),code(cnt)
							Swap code2(cnt_),code2(cnt)
							Swap code3(cnt_),code3(cnt)
							Swap code4(cnt_),code4(cnt)
					}
				loop
			loop
		#else
			SortVal code
		#endif
	}
	sDim sheet,put_byte
	Repeat put_byte/11
		lPoke sheet,cnt*11,code(cnt)
		#ifndef __COMPILE_HSP35__
			lPoke sheet,cnt*11+4,code2(cnt)
			wPoke sheet,cnt*11+8,code3(cnt)
			Poke sheet,cnt*11+10,code4(cnt)
		#else
			SortGet work_code,cnt
			lPoke sheet,cnt*11+4,code2(work_code)
			wPoke sheet,cnt*11+8,code3(work_code)
			Poke sheet,cnt*11+10,code4(work_code)
		#endif
	Loop
	sDim sheet_back,put_byte
	MemCpy sheet_back,sheet,put_byte
	back_byte=put_byte
	return

#deffunc _beep int p1,int p2
	exec "beepplay.exe "+p1+","+p2
	return

#ifndef __MMLPLAY_DUAL_RUN__

#defcfunc mmlchk
	return playing

#else

#defcfunc mmlchk
	return mmlplay_exist

#endif

#deffunc _mmlclear int p1
	if p1<0{
		sdim mmllist,3145728,128
	}else{
		mmllist(p1)=""
	}
	return

#deffunc mmlInit
	Randomize
	code_mapping=""
	Repeat 16
		code_mapping+StrF("%c",Rnd('z'-'a'+1)+'a')
	Loop
	CreateFileMapping -1,0,PAGE_READWRITE,0,4,"mod_xime_exist_"+code_mapping
	handle_exist=stat
	MapViewOfFile handle_exist,FILE_MAP_WRITE,0,0,0
	pointer_exist=stat
	DupPtr mmlplay_exist,pointer_exist,4,VarType("int")
	CreateFileMapping -1,0,PAGE_READWRITE,0,4,"mod_xime_byte_"+code_mapping
	handle_byte=stat
	MapViewOfFile handle_byte,FILE_MAP_WRITE,0,0,0
	pointer_byte=stat
	DupPtr mmlplay_byte,pointer_byte,4,VarType("int")
	Return

#ifndef __MMLPLAY_DUAL_RUN__

#deffunc _mmlplay str p1
	char=p1
	so_empty=peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"||char=="+"
	if so_empty{
		MemCpy sheet@mod_mmlplay,mmllist(0+p1),memsize(0+p1)
	}else{
		text=p1
		gosub *compile
		sheet@mod_mmlplay=sheet
	}
	playing=1
	THE_TIME@mod_mmlplay=0
	SetTimer hwnd,1,1,0
	if so_empty{
		return
	}else{
		return error
	}

#else

#deffunc _mmlplay str p1
	char=p1
	so_empty=peek(char,0)>='0'&&peek(char,0)<='9'||char=="-"||char=="+"
;	sDim work,8
	If already_mapped{
		mmlStop
		UnmapViewOfFile pointer_data
		CloseHandle handle_data
		Dim mmlplay_data
		mmlInit
		already_mapped=0
	}
	if so_empty{
;		bSave "xime.dat",mmllist(0+p1),mmlsize(0+p1)
		If mmlsize(0+p1){
			mmlplay_byte=mmlsize(0+p1)
			CreateFileMapping -1,0,PAGE_READWRITE,0,mmlsize(0+p1),"mod_xime_data_"+code_mapping
			handle_data=stat
			MapViewOfFile handle_data,FILE_MAP_WRITE,0,0,0
			pointer_data=stat
			DupPtr mmlplay_data,pointer_data,mmlsize(0+p1),VarType("str")
			MemCpy mmlplay_data,mmllist(0+p1),mmlsize(0+p1)
			already_mapped=1
		}
;		lPoke work,0,VarPtr(mmllist(0+p1))
;		lPoke work,4,StrLen(mmllist(0+p1))+1
	}else{
		text=p1
		gosub *compile
;		bSave "xime.dat",sheet,put_byte
		If put_byte{
			mmlplay_byte=put_byte
			CreateFileMapping -1,0,PAGE_READWRITE,0,mmlplay_byte,"mod_xime_data_"+code_mapping
			handle_data=stat
			MapViewOfFile handle_data,FILE_MAP_WRITE,0,0,0
			pointer_data=stat
			DupPtr mmlplay_data,pointer_data,mmlplay_byte,VarType("str")
			MemCpy mmlplay_data,sheet,put_byte
			already_mapped=1
		}
;		lPoke work,0,VarPtr(sheet)
;		lPoke work,4,StrLen(sheet)+1
	}
;	bSave "xime.dat",work,8
	exec dir_exe+"\\mmlplay.exe /s \""+code_mapping+"\"
	exec dir_exe+"\\mmlplay.exe \""+code_mapping+"\"
;	delete "xime.dat
	if so_empty{
		return
	}else{
		return error
	}

#endif

#deffunc mmlset int p1,str text2
	wait 0
	text=text2
	gosub *compile
	MemCpy mmllist(p1),sheet,put_byte
	mmlsize(p1)=put_byte
	return error

#defcfunc mmlerr
	return ern

#ifndef __MMLPLAY_DUAL_RUN__

#deffunc _mmlstop double p1
	if p1*1000{
		fochk@mod_mmlplay=1000.0*p1
	}else{
		playing@modxime=0
		THE_TIME@mod_mmlplay=0
		KillTimer@modxime hwnd,1
	}
	return

#deffunc mmlpause double p1
	pause@mod_mmlplay=1
	return

#deffunc mmlcont double p1
	pause@mod_mmlplay=0
	return

#else

#deffunc _mmlstop double p1
	if p1*1000{
		exec dir_exe+"\\mmlplay.exe /o"+str(int(1000.0*p1))+" \""+code_mapping+"\"
	}else{
		exec dir_exe+"\\mmlplay.exe /s \""+code_mapping+"\"
	}
	return

#deffunc mmlpause double p1
;	if p1*1000: exec "mmlplay /
	return

#endif

#global

#ifndef __MMLPLAY_DUAL_RUN__

#module mod_mmlplay

#uselib "winmm
#func midiOutOpen "midiOutOpen" int,int,int,int,int
#func midiOutShortMsg "midiOutShortMsg" int,int

#deffunc jeterjajfq34utjiq34j
	notesel sheet
		if playing@modxime{
			if THE_TIME==0{
				repeat 16
					midiOutShortMsg midi_handle,$c0 or cnt
				loop
				volume_=1.0
				volume=volume_
				fadeout=""
				fochk=0
				start_time=0
				dim time_,128
				k=0
				playing=1
				new_time=(gettime(7)+gettime(6)*1000+gettime(5)*60000+gettime(4)*3600000)
			}
			repeat notemax-k,k
				noteget code__,k
				if code__==""{
					k+
					continue
				}
				split code__,":",time__,ch_,no,velocity
				if strmid(no,0,1)=="@"{
					midiOutShortMsg midi_handle,(($c0 or ch_)and$ff)or(($ff and strmid(no,1,strlen(no)-1))<<8)
				}else: if strmid(no,0,1)=="P"{
					midiOutShortMsg midi_handle,(($b0 or ch_)and$ff)or($0a<<8)or(($ff and strmid(no,1,strlen(no)-1))<<16)
				}else: if strmid(ch_,0,4)=="GOTO"{
					goto_=0+no
					start_time=goto_
					repeat notemax
						noteget code__,cnt
						if code__=="": continue
						split code__,":",time__,ch_,no,velocity
						if goto_<=time__: k=cnt-1: break
					loop
					break
				}else{
					ch_=0+ch_
					no=0+no
					velocity=0+velocity
					now_time=THE_TIME
					if (now_time-start_time)>=time__{
						if velocity{
							midiOutShortMsg midi_handle,(($90 or ch_)and$ff)or((no and$ff)<<8)or(($ff and(volume*velocity))<<16)
						}else{
							midiOutShortMsg midi_handle,(($80 or ch_)and$ff)or((no and$ff)<<8)
						}
						k=cnt+1
					}
			/*		if ch_==1{
						if velocity{
							time_(no)=0+time__
						}else{
							if time_(no)=0{
								beep 0+powf(2,double(no-69)/12)*440,0+time__-time_-1
								await 1
							}else{
								await time_(no)
							}
						}
					}*/
					if fochk{
						fadeout=fochk
						if fadeout: fadeout=1.0/fadeout
						fotime=now_time-start_time
						fochk_=1
						fochk=0
					}
					if fochk_: volume=volume_-fadeout*(now_time-start_time-fotime)
					if volume<=0:{
						playing@modxime=0
						THE_TIME=0
						KillTimer@modxime hwnd,1
					}
				}
			loop
			if volume<=0.0{
				playing@modxime=0
				THE_TIME=0
				KillTimer@modxime hwnd,1
			}
			if pause==0{
				so_new_time=(gettime(7)+gettime(6)*1000+gettime(5)*60000+gettime(4)*3600000)
				THE_TIME+limit(so_new_time-new_time,0)
			}
			new_time=(gettime(7)+gettime(6)*1000+gettime(5)*60000+gettime(4)*3600000)
		}
		if k==notemax{
			playing@modxime=0
			THE_TIME=0
			KillTimer@modxime hwnd,1
		}
	noteunsel
	return

#global

#endif

#ifndef __MMLPLAY_DUAL_RUN__

	goto *eriaqutu328j3uioasjeitfgew8hj

*fq3ehjtjqewrj43fewoie
	jeterjajfq34utjiq34j
	return

*eriaqutu328j3uioasjeitfgew8hj
	midi_handle@mod_mmlplay=0
	midiOutOpen@mod_mmlplay varptr(midi_handle@mod_mmlplay),-1,0,0,0
	oncmd gosub *fq3ehjtjqewrj43fewoie,$113

#endif

	sdim mmllist@modxime,3145728,32

#endif	; End of (#ifndef __MOD_XIME__)
