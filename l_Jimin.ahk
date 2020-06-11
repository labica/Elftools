;;----------깃에 올려봄
;;------------------------
;;글로벌 변수
;;------------------------
{
	;#Persistent
	;#SingleInstance force
	;SetTitleMatchMode,2
	
	
	Elf_homepage = http://www.elfism.com	
	Elf_email = labica@gmail.com	
}



;------폴더 안 아이콘 주소 가져오는 함수
getFirstIcon(todoPath){
loop,Files,%todoPath%\*.ico,F
{	
if (A_LoopFileLongPath&&todoPath){
return %A_LoopFileLongPath%
}
}
return false
}

;-------------선택한 폴더 아이콘 정리
setDesktopIconFirst(folderPath){
iconPath := getFirstIcon(folderPath)
;msgbox %iconPath%
desktopiniPath = %folderPath%\desktop.ini
if (!fileExist(desktopiniPath)&&iconPath){
;인코딩을 cp949(한글로처리)
;FileAppend,,%desktopiniPath%,CP949
FileAppend,,%desktopiniPath%
}
if (iconPath){
IniWrite, %iconPath%`,0,%desktopiniPath% , .ShellClassInfo,IconResource
}
run,attrib +s +h +r %desktopiniPath%,,hide
return
}

;-----정한 폴더 내 아이콘 모두 정리
setDesktopIconAll(folderPath){
loop,files,%folderPath%\*.*,D
{
setDesktopIconFirst(A_LoopFileLongPath)
}
return
}





;------------------타로기능. 원래 셔플과 비슷하겡

getTaro(cntArray,rPercent)
{
major := ["바보","마법사","고위여사제","여황제","황제","교황","연인","전차","힘","은둔자","운명의 수레바퀴","정의","매달린 남자","죽음","절제","악마","탑","별","달","태양","심판","세계"]

fullCards := major

resultCard:=[]
taroArray:=[]

;--셔플. 뒤집힐 확률 적용해서 뒤집음
loop,% fullCards.maxindex()
{
Random,cNum,1,% fullCards.maxindex() ;랜덤값 추출.
Random,rPerCal,0,% 1/rPercent
; msgbox % rPerCal
if (rPerCal<1){
	resultCard.push("뒤집힌 " . fullCards[cNum])
} else {
	resultCard.push(fullCards[cNum])
}
fullCards.removeAt(cNum) ;뽑은카드 제거
}

;--3블럭으로 나누기? 딱히 감이 안오네. 

;---숫자 n개반큼 출력

loop, % cntArray.MaxIndex()
{
Random,cNum,1,% resultCard.maxindex() ;랜덤값 추출.

;카드뽑기
taroString := taroString . cntArray[a_index] . ":" . resultCard[cNum] . "`n"

taroArray.push({"name":cntArray[a_index],"card":resultCard[cNum]})

; taroString := taroString . resultCard[cNum] . "/"

resultCard.removeAt(cNum) ;뽑은카드 제거

}




	return taroArray
}







;-----------드래그 버튼 등록
hovermove()
{
	PostMessage, 0xA1, 2,,, A 
	return
}


;------------시작프로그램에 등록. check 면 체크 / on이면 넣기 / off면 지우기/toggle면 반복?
autostart(stype="check")
{
	;--check면 체크
	if stype=check
	{
		IfNotExist %A_Startup%\%A_ScriptName%.lnk
		return false
		else
		return true
	}
	
	if stype=on
	{
		IfNotExist %A_Startup%\%A_ScriptName%.lnk
		{
			FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%
			return True
		}
		else
		return False
	}
	
	if stype=off
	{
		IfExist %A_Startup%\%A_ScriptName%.lnk
		{
			FileDelete,%A_Startup%\%A_ScriptName%.lnk
			return true
		}
		else
		{
			return false
		}
	}
	
	if stype=toggle
	IfNotExist %A_Startup%\%A_ScriptName%.lnk
	{
		FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%
		return True
	}
	else
	{
		FileDelete,%A_Startup%\%A_ScriptName%.lnk
		return False
	}
}







make_backup(fname,max_cnt) ;특정파일명을 순차적으로 백업하기
{
	SplitPath,fname,,OutDir,OutExtension,OutNameNoExt,OutDrive
	
	
	
	loop,%max_cnt% ;제한갯수만큼만 복사하기
	{
		cnt_rev:=max_cnt-A_index , cnt_rev_p:=cnt_rev+1
		backup_from=%OutDir%\%OutNameNoExt%_Bak%cnt_rev%.%OutExtension% ;원본복사
		backup_to=%OutDir%\%OutNameNoExt%_Bak%cnt_rev_p%.%OutExtension% ;사본복사
		ifexist,%backup_from%
		filecopy,%backup_from%,%backup_to%,1
	}
	
	;원본을 복사본으로 복사
	filecopy,%fname%,%OutDir%\%OutNameNoExt%_Bak1.%OutExtension%,1
	return
}



lastclass(lastclass)   ;----------------------------------------------Autohotkey 이외최근 클래스 추출.
{
	;만약 최근 클래스가 들어간 클래스와 같으면, 그대로 뱉음
	
	
	;Gui +LastFound
	WinGetClass,var,A
	if (var="AutoHotkeyGUI")
	var:=lastclass
	;msgbox %var%
	return var
}

lasttitle(lasttitle)   ;----------------------------------------------Autohotkey 이외최근 타이틀 추출.
{
	;만약 최근 클래스가 들어간 클래스와 같으면, 그대로 뱉음
	
	
	;Gui +LastFound
	WinGettitle,var,A
	wingetclass,var2,A
	if (var2="AutoHotkeyGUI")
	var:=lasttitle
	;msgbox %var%
	;traytip,Debug,%var%
	return var
}





filelist(folder,ext) ;-----------------------특정 폴더 안의 특정 확장자 파일 긁어오기
{
	var=
	Loop, %folder%\*.%ext%
	{
		if a_index=1
		var=%A_LoopFileName%
		else
		var=%var%`n%A_LoopFileName%
	}
	return var
}

;--------------------------------
; 스트링 변환 관련
;--------------------------------

;--------------ini 이름 쉽게 설정
set_ininame(stype=0)
{
	StringTrimRight,Script_name,A_ScriptName,4
	if stype=0
	ini_name=%A_ScriptDir%\%Script_name%.ini
	else
	ini_name=%A_ScriptDir%\%Script_name%_%A_ComputerName%.ini
	return ini_name
}


;-------하드 주소를 받아서 media 형태로 변경.삽입편하게.
;하드주소만큼 빼고, 
drop2media(hardpath,droppath="D:\Dropbox")
{
	stringreplace,val,hardpath,%droppath%\dokuwiki\data\media,,ALL
	stringreplace,val,val,`\,:,ALL
	return val
}


;하드주소를 빼서,
drop2public(hardpath,droppath,publicpath="https://dl.dropboxusercontent.com/u/31323/")
{
	stringreplace,val,hardpath,%droppath%,%publicpath%,ALL
	stringreplace,val,val,`\,/,ALL
	return val
}

drop2publicimg(hardpath,droppath,publicpath="https://dl.dropboxusercontent.com/u/31323/") ;썸네일폴더에 썸네일이 있을경우 썸네일링크 / 아님 그냥
{
	loop,parse,hardpath,`r`n
	{
		if A_loopfield
		{
			thumb_img:=drop2media(a_loopfield,droppath)
			stringreplace,val,A_loopfield,%droppath%,%publicpath%,ALL
			stringreplace,val,val,`\,/,ALL
			SplitPath, val,thname,thDir ;
			SplitPath, A_loopfield,,rtDir
			stringreplace,thumb_img,thumb_img,%thname%,thumb:%thname%
			ifexist,%rtDir%\thumb\%thname%
				;val_temp=%val_temp%[[%thdir%/%thname%|{{%thdir%/thumb/%thname%}}]]`r`n
				val_temp=%val_temp%[[%thdir%/%thname%|{{%thumb_img%}}]]`r`n
			else
				val_temp=%val_temp%{{%thdir%/%thname%}}`r`n
		}
	}
	
	
	return val_temp
}

drop2publicthumb(hardpath,droppath,publicpath="https://dl.dropboxusercontent.com/u/31323/") ;마크용 썸네일폴더에 썸네일이 있을경우 썸네일링크 / 아님 그냥 이미지 보여주기
{
	loop,parse,hardpath,`r`n
	{
		if A_loopfield
		{
			stringreplace,val,A_loopfield,%droppath%,%publicpath%,ALL
			stringreplace,val,val,`\,/,ALL
			SplitPath, val,thname,thDir ;
			SplitPath, A_loopfield,,rtDir
			ifexist,%rtDir%\thumb\%thname%
			val_temp=%val_temp%[![](%thdir%/thumb/%thname%)](%thdir%/%thname% "클릭하면 커집니다.")`r`n
			else
			val_temp=%val_temp%![](%thdir%/%thname%)`r`n
		}
	}
	return val_temp
}		


simple2list(context)
{
	;심플위키의 글을 마크다운리스트화
	
stringreplace,val_context,context,`t`t`t`t,%A_space%%A_space%%A_space%%A_space%*%A_space%,ALL
stringreplace,val_context,val_context,`t`t`t,%A_space%%A_space%%A_space%*%A_space%,ALL
stringreplace,val_context,val_context,`t`t,%A_space%%A_space%*%A_space%,ALL
stringreplace,val_context,val_context,`t,##%A_space%,ALL
	
	
	return val_context
}






drop2page(hardpath,droppath="D:\Dropboxdokuwiki")
{
	stringreplace,val,hardpath,%droppath%\dokuwiki\data\pages,,ALL
	stringreplace,val,val,`\,:,ALL
	stringtrimright,val,val,4
	return val
}


dropmedia2web(hardpath,droppath="D:\Dropbox",webpath="http://elfism.com")
{
	
	stringreplace,val,hardpath,%droppath%\dokuwiki\data\media,%webpath%/_media,ALL
	return val
}



block2div(contents)
{
contents:=regexreplace(contents,"<block\s(\d+)(px|%)\s(\w+)>","<div class='wrap_$3' style='width:$1$2;'>")
stringreplace,contents,contents,</block>,</div>,ALL
	return contents
}




;-----------시간을 '분전'으로 표현하기
smooth_time(time_val)
{
	time_val -= A_now,Minutes
	time_val :=abs(time_val)
	if time_val<60
	time_val:=abs(time_val) . "분전"
	else if time_val<1440
	time_val:=ceil(abs(time_val/60)) . "시간전"
	else if time_val<2880
	time_val:="어제"
	else
	time_val:="예~전에"
	return time_val
}



sec_to_time(time_sec,t_title,t_hour,t_min,t_sec) ;;csv에 들어갈 시간단위추출용 12:30:20 형태.
{
	ep_hour:=time_sec//3600 ;;시 추출
	if ep_hour < 10
	{
		ep_hour=0%ep_hour%
	}
	ep_min:=(time_sec-(ep_hour*3600))//60 ;;분 추출
	if ep_min < 10
	{
		ep_min=0%ep_min%
	}
	ep_sec:=mod(time_sec,60) ;;초 추출
	if ep_sec < 10
	{
		ep_sec=0%ep_sec%
	}
	ep_text = %t_title%%ep_hour%%t_hour%%ep_min%%t_min%%ep_sec%%t_sec% ;;정리.
	
	return ep_text
	
}



;;;---Time_Stamp :YYYYDDMM형태로 변경해서 전달.
;;ex(Time_Stamp("YYYYMMDD_")
time_stamp(time_type)
{
	formattime,a,%A_Now%,%time_type%
	return %a%
}





;-------------시간을 입력하면, 2015/50/20 형태로 뱉기. -> 저 형태 넣으면 YYYYMMddDDmm형태로 변경
change_time(d_time)
{
	
	if d_time!
	return
	
	
	ifinstring,d_time,/
	{
		stringreplace,val,d_time,/,,ALL
		val=%val%130000
	}
	else
	{
		formattime val,%d_time%,yyyy/MM/dd
	}
	
	
	return %val%
}
















short_text(longtext,cnt=20,direct="r") ;너무 긴 글자는 줄이기
{
	textlen:=strlen(longtext)
	
	if (textlen>(cnt))
	{
		
		
		if (direct!="r")
		stringleft,sl,longtext,%cnt%
		
		if (direct!="l")
		stringright,sr,longtext,%cnt%
		
		
		short_text=%sl%...%sr%
	}
	else
	short_text:=longtext
	
	return short_text
}




count_next(c_text)  ;; 문자+숫자형태일 경우 다음 숫자열 뱉기 ex)kakaka01_0032  --> kakaka01_0033
{
	val=
	
	b:=regexmatch(c_text,"\d+$") ;;문자에서 숫자찾기
	if b=0
	return %c_text%
	
	c:=substr(c_text,b)
	f:=substr(c_text,1,b-1)
	d:=c+1
	e:=strlen(c)-strlen(d)
	if e>0
	{
		loop,%e%
		{
			val=0%val%
		}
		val=%val%%d%
	}
	else
	val=%d%
	;c의 전체길이 - d의 전체길이만큼 앞에 0을 더하기
	
	val=%f%%val%
	
	return %val%
}




group_multiline(content,is_group=0) ;멀티라인을 합쳤다가 풀기 0:묶기 / 1:풀기
{
	if is_group=0
	{
		stringreplace,content,content,`,,[s],ALL
		stringreplace,content,content,`n,[n],ALL
		stringreplace,content,content,`r,[r],ALL
		stringreplace,content,content,`t,[t],ALL
	}
	else
	{
		stringreplace,content,content,[s],`,,ALL
		stringreplace,content,content,[n],`n,ALL
		stringreplace,content,content,[r],`r,ALL
		stringreplace,content,content,[t],`t,ALL
	}
	
	return content	
}	




;---------------------클립보드 타입을 가져오는 기능
get_cliptype() ;클립타입체크
{
	var=etc
	check:=winclip.getfiles()
	if check
	{
		var:="Files"
		check=
	}
	check:=winclip.gethtml()
	if check
	{
		var:="Html"
		check=
	}
	check:=winclip.getrtf()
	if check
	{
		var:="Rtf"
		check=
	}
	check:=winclip.getbitmap()
	if check
	{
		var:="Bitmap"
		check=
	}
	if(var="Etc")
	{
		check:=winclip.gettext()
		if check
		{
			var:="Text"
			check=
		}
	}
	return var
}


;----이전 클립보드랑 비교해서 다르면 true/ 같으면 false 뱉기

check_clipboard(old_clipboard)
{
	;new_clipboard:=clipboard
	if (clipboard!=old_clipboard)
	return true
	else
	return false
}





Random_Talk(talk_data) ;;자연어 처리.엔터로 처리된 여러줄 중 한줄을 랜덤으로 출력해줌.
{
	talk_cnt:=line(talk_data,0)
	
	random,sline,1,%talk_cnt%
	
	talk_line := line(talk_data,sline)
	
	return talk_line
}

gui_talk(t_value,talk_data,gui_name="") ;;특정 클래스(t_value)에 타자치는 효과 넣기. random_talk와 같이 쓰면 효과만점
{
	t_len := StrLen(talk_data)
	loop,%t_len%
	{
		StringLeft,t_block , talk_data, %a_index%
		guicontrol,%gui_name%,%t_value%,%t_block%
		sleep, 70
	}
	return
}



;--------------------------------
; INI 관련
;--------------------------------

ini_read_all(i_file,ini_list,Section_name) ;;ini 다 읽기. ini이름, ini리스트(쉼표로 구분된 변수),[섹션이름]
{
	;global ini_file,log_file,language_file
	stringreplace,ini_list,ini_list,`n,,All
	;;;;------------------ini값 읽어오기
	loop,parse,ini_list,`,
	{
		setting_block =%A_loopfield%
		setting_value := %A_loopfield%
		
		;msgbox % %setting_block%
		iniread %A_loopfield%,%i_file%,%Section_name%,%A_loopfield%,%setting_value%
		stringreplace,%A_loopfield%,%A_loopfield%,[[n]],`n,all
	}
	return
}

ini_write(i_file,Section,Keyname) ;;섹션과 키 이름을 주면 알아서 저장.꼭 ""로 감싸야 함.
{
	;	global ini_file
	;	if ini_file =
	;	{
		
		;		stringtrimright,tname,A_scriptname,4
		;		ini_file = %tname%.ini
	;	}
	Keyvalue := %Keyname%
	stringreplace,Keyvalue,Keyvalue,`n,[[n]],all
	iniwrite,%Keyvalue%,%i_file%,%Section%,%Keyname%
	return
}


ini_write_all(i_file,ini_list,Section_name) ;;ini 다 저장하기
{
	
	stringreplace,ini_list,ini_list,`n,,All
	;;;;------------------ini값 읽어오기
	loop,parse,ini_list,`,
	{
		setting_block =%A_loopfield%
		setting_value := %A_loopfield%
		;msgbox % %setting_block%
		iniwrite %setting_value%,%i_file%,%Section_name%,%A_loopfield%
		stringreplace,%A_loopfield%,%A_loopfield%,[[n]],`n,all
	}
	return	
	
	return	
}





showhide_multigui(win_name,gui_name) ;;특정 gui를 열고 닫음.gui이름 동일할 필요있음.
{
	IfWinnotExist,%win_name%
	gui,%gui_name%:show,,%win_name%
	else
	{
		IfWinExist,%win_name%
		gui,%gui_name%:hide
	}
	return
}


line(l_contents,cnt="0")
{
	if cnt=0
	{
		loop,parse,l_contents,`n,`r
		{
			han = %A_index%
		}
		return %han%
	}
	else
	loop,parse,l_contents,`n,`r
	{
		k=%A_loopfield%
		if A_index = %cnt%
		{
			break
		}
	}
	return %k%
}

;;;----------------- 메뉴 관련
Submenu_checker(menu_list,select_menu)  ;메뉴를 클릭했을때 체크를 해주는 함수
{
	loop,parse,menu_list,`,
	{
		if A_index = 1
		{
			sub_menu=%A_loopfield%
		}
		else
		{
			stringsplit,single_menu,A_loopfield,|
			menu,%sub_menu%,unCheck,%single_menu1%
		}
	}
	menu,%sub_menu%,Check,%select_menu%
	return
}


Submenu_maker(menu_list) ;;서브메뉴를 만들어주는 함수 데이터 형태는 (서브메뉴묶음,서브1|라벨1,서브2|라벨2 형태)
{
	loop,parse,menu_list,`,
	{
		if A_index = 1
		{
			sub_menu=%A_loopfield%
		}
		else if A_loopfield <>
		{
			stringsplit,single_menu,A_loopfield,|
			menu,%sub_menu%,add,%single_menu1%,%single_menu2%
			
		}
		else
		{
			menu,%sub_menu%,add
		}
	}
	if sub_menu <>tray
	{
		menu,tray,add,%sub_menu%,:%sub_menu%
	}
	return
}

submenu_toggle(var_name,var,main_menu,sub_menu)  ;;; 바값을 읽어서 y/n을 변경하며 체크도 알아서 해 줌. ("a_mode",a_mode,"엘프","하루")
{
	if var = y
	{
		var = n
		menu,%main_menu%,uncheck,%sub_menu%
	}
	else
	{
		var = y
		menu,%main_menu%,check,%sub_menu%
	}
	return var
}


change_checkbox(sub,var_name) ;;체크박스보고 채크해주기
{
	
	if (%var_name% = 1)
	guicontrol,%sub%,%var_name%,1
	else
	guicontrol,%sub%,%var_name%,0
	return
}




;;;----------------- 파싱 관련
parse_change(o_data,cnt,c_data,sper="`,")  ;전체 내용, 갯수, 바꿔칠 내용 입력하면, 바꿔준다.무헷~
{
	loop,parse, o_data,%sper% ;;,로 파싱
	{
		p_block = %A_loopfield%
		
		if A_index = %cnt%
		{
			p_block = %c_data%
		}
		
		if A_index=1
		{
			p_block_f = %p_block%
		}
		else
		{
			p_block_f = %p_block_f%%sper%%p_block%
		}
	}
	return p_block_f
}


parse_select(o_data,cnt,sper="`,")
{
	loop,parse, o_data,%sper% ;;,로 파싱
	{
		p_block = %A_loopfield%
		
		if A_index = %cnt%
		{
			break
		}
	}
	return p_block
}

parse_cnt(o_data,sper="`,") ;;총 데이터값 추출
{
	loop,parse, o_data,%sper% ;;,로 파싱
	{
		p_block = %A_index%
	}
	return p_block
}

fill(data1,data2) ;;Powerpro의 fill 과 동일.
{
	data2_cnt := strlen(data2) ;;갯수파악
	stringtrimright,data,data1,%data2_cnt%  ;;data2 갯수만큼 오른쪽에서 빼기
	data = %data%%data2%
	
	return %data%
}




to_NoteTaker(t_text) ;;특정함수를 노트테이커로 날리기.
{
	ControlSetText,Edit4,%t_text%,notetaker
	return
}



get_block(stime=700) ;;;선택한 부분을 변수로 출력하는 간단한 함수
{
	if clipboardall
	clip_temp := clipboardall
	if clipboard
	clip_temp2 := clipboard
	
	;send,^c
	;clipwait,%stime%
	winclip.Copy()
	;sleep,%stime%
	clip_block := clipboard
	;clip_block := winclip.gethtml()
	;clip_block := regexreplace(clip_block,"^[^<]+","")
	
	;fileappend,%clip_block%,log.txt,utf-8
	if (clip_block! && clipboardall)
	{
		clip_block := clip_temp2 ;;만약 블럭이 안잡혔으면, 원래 클립보드를 넘김
		clipboard := clip_temp
	}
	return %clip_block%
}


m_paste(content,url="BloggingKit") ;;컨텐츠를 붙이기
{
	clip_temp := clipboardall
	winclip.sethtml(content,url)
	winclip.settext(content)
	send,^v
	sleep,1000
	clipboard := clip_temp
	return	
}


convert_smileys(contents,smileys_path,smileys_local,ctype="markdown") ;컨텐츠의 내용을 변경
{
	smileys_result=
	fileread,smileys_contents,%smileys_local%
	
	
	loop,parse,smileys_contents,`r`n
	{
		if(a_index>5 && a_loopfield)
		{
			smileys_block:=a_loopfield
			smileys_block:=regexreplace(smileys_block,"([^\s]+)\s+([^\s]+)","$1,$2")
			smileys_result=%smileys_block%`n%smileys_result%
			}
		}
	loop,parse,smileys_result,`r`n
	{
	ct_block=
	ct_block1=
	ct_block2=
		stringsplit,ct_block,a_loopfield,`,
		ifinstring,contents,%ct_block1%
		{
		if (ctype="markdown")
		stringreplace,contents,contents,%ct_block1%,![](%smileys_path%%ct_block2%),ALL	
			}

		}
	
	
	
	;msgbox %contents%
	return contents
	}









doku2mk(contents,smileys_path="",smileys_local="no") ;도쿠문서를 마크다운 문서로 변경
{
	;msgbox %smileys_path%`n%smileys_local%
	contents_changed =
		if smileys_local!=no
		contents:=convert_smileys(contents,smileys_path,smileys_local) ;스마일리 변환. 도쿠에서 땡겨옴
		
		
		contents:=block2div(contents) ;block 구조 변경
		
		
		
		
	loop,parse,contents,`r`n	
	{	
		content_block = %A_loopfield%
		content_block := RegExReplace(content_block,"^====([^=].*)====","### $1")
		content_block := RegExReplace(content_block,"^=====([^=].*)=====","## $1")
		content_block := RegExReplace(content_block,"^======([^=].*)======","# $1")
		content_block := RegExReplace(content_block,"{{(https*://[\w\.\?\=/&\%-_]+\.[\w\.\?\=/&\%_-]+\..{3})([^}]*)}}","![]($1)") ;만약 일반 이미지 일 경우
		content_block := RegExReplace(content_block,"\[\[(https*://[\w\.\?\=/&\%]+\.[\w\.\?\=/&\%_-]+\..{3})\|{{(https*://[\w\.\?\=/&\%-_]+\.[\w\.\?\=/&\%_-]+\..{3})}}\]\]","[![]($2)]($1)") ;링크가 포함된 이미지일 경우

		contents_changed = %contents_changed%`n%content_block%
	}
	
	return contents_changed
}

mk2doku(contents) ;마크다운을 도쿠위키 문서로 변경
{
	contents_changed =
	loop,parse,contents,`r`n	
	{
		content_block = %A_loopfield%
		content_block := RegExReplace(content_block,"^###([^=].*)","==== $1 ====`n")
		content_block := RegExReplace(content_block,"^##([^=].*)","===== $1 =====`n")
		content_block := RegExReplace(content_block,"^#([^=].*)","===== $1 =====`n")
		content_block := RegExReplace(content_block,"^\[\!\[.*\]\((https*://[\w\.\?\=/&\%]+\.[\w\.\?\=/&\%_]+\..{3})\)\]\((https*://[\w\.\?\=/&\%]+\.[\w\.\?\=/&\%_]+\..{3}).*\)","[[$2|{{$1}}]]`n")
		content_block := RegExReplace(content_block,"^\!\[\]\((https*://[\w\.\?\=/&\%]+\.[\w\.\?\=/&\%_]+\..{3})\)","{{$1}}`n")
		contents_changed = %contents_changed%`n%content_block%
	}
	
	return contents_changed
}


doku2html(contents) ;도쿠문서를 html로 변경
{
	br_cnt=1
	contents_changed =
	loop,parse,contents,`r`n	
	{
	
	if a_loopfield!
	br_cnt:=br_cnt+1
	else
	{
		content_block = %A_loopfield%
		content_block := RegExReplace(content_block,"^====([^=].*)====","<h3>$1</h3>")
		content_block := RegExReplace(content_block,"^=====([^=].*)=====","<h2>$1</h2>")
		content_block := RegExReplace(content_block,"^======([^=].*)======","<h1>$1</h1>")
		content_block := RegExReplace(content_block,"^\s*\*\s(.*)","<li>$1</li>")
		content_block := RegExReplace(content_block,"^\s*-\s(.*)","<ol>$1</ol>")
		content_block := RegExReplace(content_block,"\*\*(.*)\*\*","<b>$1</b>")
		content_block := RegExReplace(content_block,"\\\\(.*)","<br>$1")
		;content_block := RegExReplace(content_block,"\[\[(https*.+)([^|]*)\]\]","<a href='$1'>$1</a>")
		content_block := RegExReplace(content_block,"\[\[(https*.+)\|(.*)\]\]","<a href='$1'>$2</a>")
		content_block := RegExReplace(content_block,"{{(https*.+)}}","<img src='$1'>")

		if br_cnt>=1
		contents_changed = %contents_changed%<br>%content_block%
		else
		contents_changed = %contents_changed%%content_block%
		br_cnt:=0
	}	
	}
	
	return contents_changed
	}

mk2html(contents) ;마크다운을 html으로 변경

{
	sum_br=0
	contents_changed =
	loop,parse,contents,`r`n	
	{
	    if A_loopfield
		{
		content_block = %A_loopfield%
		content_block := RegExReplace(content_block,"^###([^=].*)","<h3> $1 </h3>")
		content_block := RegExReplace(content_block,"^##([^=].*)","<h2> $1 </h2>")
		content_block := RegExReplace(content_block,"^#([^=].*)","<h1> $1 </h1>")
		content_block := RegExReplace(content_block,"\!\[([^\]]*)\]\((https*://[\w\.\?\=/-_&\%]+\.[\w\.\?\=/&\%_-]+\..{3})\)","<img src='$2' alt='$1'>")
		content_block := RegExReplace(content_block,"^\*\s(.*)","<li> $1 <li>")
		content_block := RegExReplace(content_block,"\[([^\]]*)\]\((https*://[^\)]+)","<a href='$2'>$1</a>")
		content_block := RegExReplace(content_block,"^\-([^\-].*[^\-]$)","<li>$1</li>") ;; *로 시작하고 *로 안끝나면 li
		content_block := RegExReplace(content_block,"\*\*([^\*].*)\*\*","<b>$1</b>") ;; **가 있고, **가 또 있으면 <b>로 감싸기
		contents_changed = %contents_changed%`n%content_block%
		sum_br=0
		}
		else if (sum_br>1)
		{
		contents_changed = %contents_changed%<br>
		sum_br=0
		}
		else
		sum_br=sum_br+1
	}
	
	return contents_changed	
}

;;----------위키마크업으로 변경
wiki_replace(contents) 
{
	contents_changed =
	loop,parse,contents,`n
	{
		content_block = %A_loopfield%
		
		content_block := RegExReplace(content_block,"^=([^=].*)=","<h1>$1</h1>")  ;=로 시작되고 =로 끝나면 h1으로 변경
		content_block := RegExReplace(content_block,"^==([^=].*)==","<h2>$1</h2>")
		content_block := RegExReplace(content_block,"^===([^=].*)===","<h3>$1</h3>")
		content_block := RegExReplace(content_block,"^====([^=].*)====","<h4>$1</h4>")
		content_block := RegExReplace(content_block,"^=====([^=].*)=====","<h5>$1</h5>")
		content_block := RegExReplace(content_block,"^\-([^\-].*[^\-]$)","<li>$1</li>") ;; *로 시작하고 *로 안끝나면 li
		content_block := RegExReplace(content_block,"\*\*([^\*].*)\*\*","<b>$1</b>") ;; **가 있고, **가 또 있으면 <b>로 감싸기
		content_block := RegExReplace(content_block,"--([^-].*)--","<s>$1</s>") ;; --가 있고, --가 또 있으면 <s>로 감싸기
		content_block := RegExReplace(content_block,"\[\[(https*://.*\..*[^\|])\]\]","<a href='$1'>$1</a>") ;; [[]]로 감싸고, http:// . 이고, |가 없으 경우 걍 진행
		
		{
			;;요 아래는 http:일때 확장자/혹은 속성에 따른 자동치환
			content_block_temp := content_block
			;img
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.jpg)","<img src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.bmp)","<img src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.gif)","<img src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.png)","<img src='$1'>")
			;embed
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.wmv)","<embed src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.swf)","<embed src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.wma)","<embed src='$1'>")
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%_]+\.asf)","<embed src='$1'>")
			;dropbox일 경우 iframe으로 처리
			content_block := RegExReplace(content_block,"(^http://dl\.dropbox\.com/[0-9A-Za-z\.\?\=/&\%_]+)","<iframe src='$1' id='contentFrame' name='contentFrame' marginwidth='0' marginheight='0' frameborder='0' scrolling='no' width='100%'>
			</iframe>")
			;;만약 위에꺼 다 하고도 변화가 없으면...걍 링크로...
			if content_block_temp = content_block
			content_block := RegExReplace(content_block,"(https*://[0-9A-Za-z\.\?\=/&\%]+\.[0-9A-Za-z\.\?\=/&\%]+)","<a href='$1'>$1</a>")
		}
		
		;contents_changed = %contents_changed%`n%content_block%
		content_block := RegExReplace(content_block,"(.*[^>]$)","$1<br>")
		contents_changed = %contents_changed%`n%content_block%
	}
	
	return %contents_changed%
}

/*
범용 툴.
html_replace(내용,문법리스트,바꿀텍스트
ex: 아이콘용 html_replace(contents,blog_icon_list,"<img src='[[2]]' alt='[[1]]'>")
*/
html_replace(contents,change_list,change_text)
{
	loop,parse,change_list,`n
	{
		stringsplit,change_block,A_loopfield,`,
		stringreplace,changing_url,change_text,[[2]],%change_block2%,all
		stringreplace,changing_url,changing_url,[[3]],%change_block3%,all
		stringreplace,changing_url,changing_url,[[4]],%change_block4%,all
		stringreplace,contents,contents,%change_block1%,%changing_url%,all
		stringreplace,contents,contents,[[1]],%change_block1%,all 
		
	}
	return %contents%
}



;;----------------------------------
;; todozombie(투두좀비) 관련
;;----------------------------------





;;문장을 읽고, 해당주제어를 찾아 제시하는 기능
check_similar(word_list,sentence)
{
	first_word=
	first_word_last=Nothing
	similar_point_last=1
	loop,parse,word_list,`r`n
	{
		word_set:=A_loopfield
		first_word=
		similar_point=0
		loop,parse,word_set,`, ;두번째 루프
		{
			if first_word!
			first_word:=A_loopfield ;만약 첫번째 글자가 없으면 첫번째 글자 세팅
			
			ifinstring,sentence,%A_loopfield%
			similar_point:=similar_point+1 ;만약 있으면 점수가 +1
		}
		;마지막 점수랑 비교해서 마지막 점수가 적으면, 교체.
		if similar_point>=%similar_point_last%
		{
			first_word_last:=first_word
			similar_point_last:=similar_point
		}
		;traytip,Test,%first_word_last%`n%similar_point_last%
	}
	return,%first_word_last%
}





;;----------------------------------
;; 토탈커맨더 관련
;;----------------------------------





;;---------토탈커맨더 패스 얻기 (숫자1:left/숫자2:right/숫자3:자동)
get_TPathPanel(tc_num)
{

	if (tc_num=3){
	ControlGetFocus,focusControl,ahk_class TTOTAL_CMD
	if (focusControl="LCLListBox1") {
		tc_num=2
		}
if (focusControl="LCLListBox2") {
	tc_num=1
	}
	}
	
	tc_ctr_name=TPathPanel%tc_num%
	controlgettext,panel_path,%tc_ctr_name%,ahk_class TTOTAL_CMD

	;traytip, debug,%panel_path% 
	
	if panel_path!
	{
		tc_ctr_num:= 11+((tc_num-1)*5) ;11,16을 추출하기 위함.
		controlgettext,panel_path,Window%tc_ctr_num%,ahk_class TTOTAL_CMD
		;traytip,debug,Window%tc_ctr_num%
	}

		if panel_path!
	{
		tc_ctr_num:= 12+((tc_num-1)*5) ;12,17일때도 있음.
		controlgettext,panel_path,Window%tc_ctr_num%,ahk_class TTOTAL_CMD
		;traytip,debug,Window%tc_ctr_num%
	}
	
	StringGetPos, panel_path_pos,panel_path,\, R
	panel_path_pos := panel_path_pos+1
	stringleft,panel_path,panel_path,panel_path_pos
	return %panel_path%
}


put_openwindow(contents,o_class) ;열기창에 특정문구(주로 주소) 붙여넣기
{
	contents:=ltrim(contents)
	controlclick,Edit1,ahk_class %o_class%
	ControlSettext,Edit1,%contents%\,ahk_class %o_class%
	;controlsend,Edit1,{left}{enter},ahk_class %o_class%

	ControlGetText,chkButton,Button1,ahk_class %o_class%
	if (chkButton) ;있으면 열기버튼이라 치고
	{
	controlsend,Edit1,{right}{left}{enter},ahk_class %o_class%
	controlsend,Button1,{enter},ahk_class %o_class%
	} else { ;없으면 저장버튼이라 치자
	controlsend,Edit1,{right}{left}{enter},ahk_class %o_class%
	controlsend,Button1,{enter},ahk_class %o_class%
	}
	return	
}

;----윈텐용텟
get_opendialog_pathTen(o_class){

ControlGetText, thisPath,ToolbarWindow322, ahk_class %o_class%
if (!instr(thisPath,":\"))
ControlGetText, thisPath,ToolbarWindow323, ahk_class %o_class%
if (!instr(thisPath,":\"))
ControlGetText, thisPath,ToolbarWindow324, ahk_class %o_class%

thisPath=%thisPath%\

thisPath:=StrReplace(thisPath,"\\" ,"\")
thisPath:=StrReplace(thisPath,"주소: " ,"")

return thisPath
}


get_opendialog_path(o_class) ;현재 열기창 폴더위치 찾아오기
{
	thispath=
	winget,o_id,,%o_class%
	if A_OSVersion = WIN_7
	{
		controlgettext,thispath,ToolbarWindow322,ahk_id %o_id%
		stringreplace,thispath,thispath,주소: ,
		if thispath
		{
			thispath = %thispath%`\
		}
	}
	if (A_OSVersion = "WIN_VISTA" || instr(A_OSVersion,"10.0."))
	{
		ControlGetPos, ToolbarPos,,,, ToolbarWindow322, ahk_id %o_id%
		if ToolbarPos !=
		{
			Send, !d ; Set focus on addressbar to enable Edit2
			Sleep, 100
			ControlGetText, ThisPath, Edit2, ahk_id %o_id%
		}
	}





	;traytip 1,%thispath%
	if ThisPath = ; nothing retrieved, maybe it's an old open/save dialog
	{
		ControlGetText, ThisFolder, ComboBox1,ahk_id %o_id%; current folder name
		ControlGet, List, List,, ComboBox1, ahk_id %o_id% ; list of folders on the path
		Loop, Parse, List, `n ; create array and get position of this folder
		{
			List%A_Index% = %A_LoopField%
			if A_LoopField = %ThisFolder%
			ThisIndex = %A_Index%
		}
		Loop, %ThisIndex% ; add path till root
		{
			Index0 := ThisIndex - A_Index + 1 ; ThisIndex ~ 1
			IfInString, List%Index0%, : ; drive root
			{
				ThisPath := SubStr(List%Index0%, InStr(List%Index0%, ":")-1, 2) . "\" . ThisPath
				break
			}
			ThisPath := List%Index0% . "\" . ThisPath
		}
		StringTrimRight, ThisPath, ThisPath, 1
	}
	
	;;그래도 안나오면... explorer인걸로 생각해서...
	if ThisPath =
	{
		controlgettext,ThisPath,Edit1,%o_class%
		StringMid, is_folderpath, Thispath, 2,1
		if is_folderpath != :
		Thispath =
		
	}
	
	;;불필요한 코드 제거  
	userfolder := compare_min(A_APPDATA,A_MyDocuments)
	;traytip %A_UserName%,%userfolder%
	stringreplace,ThisPath,ThisPath,%A_UserName%`\,%userfolder%
	stringreplace,ThisPath,ThisPath,내 문서,%A_MyDocuments%
	stringreplace,ThisPath,ThisPath,바탕화면,%A_Desktop%
	stringreplace,ThisPath,ThisPath,바탕 화면,%A_Desktop%
	stringreplace,ThisPath,ThisPath,내 그림,My Pictures
	stringreplace,ThisPath,ThisPath,내 음악,My Music
	
	stringgetpos,Thispath_pos,Thispath,:,R
	Thispath_pos := Thispath_pos -1
	Stringtrimleft,Thispath,Thispath,Thispath_pos
	
	stringright,Thispath_end,Thispath,1 ;끝이 \가 아니면 추가하기.
	if Thispath_end != `\
	Thispath = %Thispath%`\
	
	StringMid, is_folderpath, Thispath, 2,1
	if is_folderpath != :
	Thispath =
	
	
	
	Return %ThisPath%
}


get_tc_activepanel()  ;;토탈커맨더의 액티브패널이 오른쪽인지 왼쪽인지 확인 (왼쪽:1 오른쪽:2)
{
	active_num = 0
	;1.만약 현재 액티브창이면 포커스 찾기	
	ifwinactive,ahk_class TTOTAL_CMD
	{
		ControlGetFocus,ac_control,ahk_class TTOTAL_CMD
		ifinstring,ac_control,TMyListBox2
		active_num = 1
		
		ifinstring,ac_control,TMyListBox1
		active_num = 2
		traytip,%ac_control%,%ac_control%
	}
	else
	{
		controlgettext,l_path,TPathPanel1,ahk_class TTOTAL_CMD
		controlgettext,r_path,TPathPanel2,ahk_class TTOTAL_CMD
		controlgettext,s_path,TMyPanel3,ahk_class TTOTAL_CMD
		stringtrimright,s_path,s_path,1
		if l_path=s_path
		active_num=1
		
		if r_path=s_path
		active_num=2
	}	
	;2.만약 액티브창이 없으면, TPathPanel2과 TMyPanel3 비교	
	return %active_num%
}



set_tc_panelpath(p_path) ;특정주소를 토커패널에 날리기
{
	controlgettext,temp_path,Edit1,ahk_class TTOTAL_CMD
	controlsettext,Edit1,cd %p_path%,ahk_class TTOTAL_CMD
	controlsend,Edit1,{left}{enter},ahk_class TTOTAL_CMD
	sleep,500
	;controlsettext,Edit1,%temp_path% ,ahk_class TTOTAL_CMD
	return
}


smartOpenDirectory(path) ;만약 토커면, 토커창에, 아니면 다른 창에
{
wingetclass,a_class,A
if (a_class="#32770") ;열기창이면
{
put_openwindow(path,a_class)
} else {
set_tc_panelpath(path)
}




return
}









compare_min(a,b) ;두 값을 비교해서 공통분모 뱉기
{
	stringlen,a_len,a
	stringlen,b_len,b
	if a_len>b_len
	all_len:= b_len
	else
	all_len:= a_len
	;traytip %a_len%,%b_len%
	loop,%a_len%
	{
		stringleft,a_trim,a,%a_index%
		stringleft,b_trim,b,%a_index%
		if a_trim = %b_trim%
		c := a_trim
		else
		break
	}
	return %c%	
}	

mousegetcontrol() ;;현재 마우스 위치의 컨트롤 가져오기
{
	mousegetpos,,,,now_control
	return %now_control%
}




sidekick(mainClass,sideClass,winPosData,w,isActive=True) ;;------------메인창 옆에 사이드창 붙이는 기능
{

if (isActive){
winValue:=WinActive(mainClass)
} else {
winValue:=WinExist(mainClass)
}

;만약 main이랑 side가 동일하면 빠져나오기

winget,mainId,ID,%mainClass%
winget,sideId,ID,%sideClass%
; if(mainId=sideId)
; {
; 	return
; }


;winget,activeEXE,ProcessName,A ;현재창 파악
;---창이 chrome.exe고 사이드가 typora.exe일 경우 발동
if (winValue && WinExist(sideClass)) 
{
;--메인창 크기 받아오기
WinGetPos,X,Y,Width,Height,%mainClass%
;--얻어온값 합치기
mX:= X+width-14
winPosDatafromMainClass = %mX%,%Y%,%w%,%Height%

winget,windows,List
loop,%windows%
{
id:=windows%A_index%


WinGetTitle,wt,ahk_id %id%
wingetpos,sX,sY,sW,sH,ahk_id %id%
winPosDatafromSideClass=%sX%,%sY%,%sW%,%sH%
if(instr(wt,sideClass) && winPosDatafromMainClass!=winPosDatafromSideClass && id!=mainId)
WinMove,ahk_id %id%, , %mX%,%Y%,%w%,%Height%
}
}
	return %winPosDatafromMainClass%
}


;;{mainClass:,sideClass,winPosData,w:,is_Active:True,gluePos:,}
sideKick2(conf) ;;-------------오브젝트 형태로 데이터 받기
{
subData:={x:0,y:0,width:0,height:0} ;메인창
mainData:={x:0,y:0,width:0,height:0} ;서브창
calData:={x:0,y:0,width:0,height:0} ;이동할 창
if (conf.isActive){
winValue:=WinActive(conf.mainClass)
} else {
winValue:=WinExist(conf.mainClass)
}

;만약 main이랑 side가 동일하면 빠져나오기

winget,mainId,ID,% conf.mainClass
winget,sideId,ID,% conf.sideClass

;메인창이 있고, 사이드 창이 존재하면
if (winValue && WinExist(conf.sideClass)) 
{
;-------메인창 크기 받아오기
WinGetPos,x,y,width,height,% conf.mainClass
mainData:={x:x,y:y,width:width,height:height}
;-------서브창 크기 받아오기
WinGetPos,dx,dy,dwidth,dheight,% conf.sideClass
subData:={x:dx,y:dy,width:dwidth,height:dheight}
;------받아온 값 전환하기
;가로세로 퍼센트 기준이면 메인창 크기기반으로 처리. 아니면 그냥입력
calData.width:= calPercent(mainData.width,conf.width)
calData.height:= calPercent(mainData.height,conf.height)
;-------위치계산
;위치기준이 left면 메인위치 - 창크기 
if (conf.position="left"){
	calData.x := mainData.x - calData.width + conf.marginX
	calData.y := mainData.y + conf.marginY
}
if (conf.position="right"){
	calData.x := mainData.x + mainData.width + conf.marginX
	calData.y := mainData.y + conf.marginY
}
if (conf.position="top"){
	calData.x := mainData.x + conf.marginX
	calData.y := mainData.y - calData.height + conf.marginY
}
if (conf.position="bottom"){
	calData.x := mainData.x + conf.marginX
	calData.y := mainData.y + mainData.height + conf.marginY
}

; msgbox % mainData.x . "-" . calData.x


;----붙이기
winget,windows,List
loop,%windows%
{
id:=windows%A_index%
WinGetTitle,wt,ahk_id %id% ;창 제목
wingetpos,x,y,width,height,ahk_id %id% ;창 위치
winPosDatafromSideClass={x:x,y:y,width:width,height:height} ;실제 위치 추척
if(instr(wt,conf.sideClass) && calData!=winPosDatafromSideClass && id!=mainId)
WinMove,ahk_id %id%, , % calData.x,% caldata.y,% calData.width,% calData.height
}

}





	return conf
}

calPercent(data,str){


if (instr(str,"%")){
stringtrimright,result,str,1
return result:=floor(result/100*data)
}

	return str
}



;;----------------------------------
;; 회사관련
;;----------------------------------

material_addlightmap(contents) ; 라이트맵 적용하기? 파일이름 뽑아서, 라이트맵구조로 변경하기.물어보게 할깡...
{
	
lm_top=
(
material
{
	ambient 0.0 0.0 0.0
	technique
	{
		pass
		{
			shader_group LightMap
			texture_unit
			{
				texture example_lm.dds
				color_blend add texture diffuse
			}
			texture_unit
			{
				texture
)
	
lm_bottom=
(
tex_coord_set 1
				filtering none
				color_blend modulate texture current
			}
		}
	}
}
)
	
	
;loop돌려서 texture 뽑아내기

loop,parse,contents,`r`n
{
ifinstring,a_loopfield,texture%A_space%	
{
stringreplace,n_block,a_loopfield,texture%a_space%
stringreplace,n_block,n_block,`t,,ALL
n_contents=%n_contents%%n_block%`n
}
}

;돌린 내용으로 다시 붙여넣기

loop,parse,n_contents,`r`n
{
if A_loopfield
nn_contents=%nn_contents%%lm_top%%A_space%%A_loopfield%`n`t`t`t`t%lm_bottom%`n
}

return nn_contents
}




get_svn() ;svn 로그내용 쉽게 긁어오기
{
	seper_key=<br>
	dev_folder =dev
	dist_folder =dist
	dev_manager =박진영,노승환
	dist_manager =진명근, 하홍일
	dev_server_type =개발/QA
	dist_server_type = 베타/서비스존
	dev_svn_type = 개발 SVN
	dist_svn_type = 배포 SVN
	
	svn_title=로그 메시지 - TortoiseSVN
	
	;rev_server_type=개발존
	
	FormatTime, today , %A_NOW%,MMdd
	
	WinGetTitle, rev_title, %svn_title%
	
	ifinstring,rev_title,%dev_folder%
	{
		rev_server_type:=dev_server_type
		path_manager:=dev_manager
		svn_type:=dev_svn_type
	}
	ifinstring,rev_title,%dist_folder%
	{
		rev_server_type:=dev_server_type
		path_manager:=dist_manager
		svn_type:=dist_svn_type
	}
	
	ControlGet, rev_List, List, Selected, SysListView321,%svn_title%
	ControlGet, rev_path, List,, SysListView322,%svn_title%
	stringsplit,rev_List,rev_List,`t
	
	loop,parse,rev_path,`r`n
	{
		stringsplit,rev_path_block,A_loopfield,`t
		rev_path_total=%rev_path_total%%rev_path_block1%%seper_key%
	}
	
	rev_titlename =[%today%][%rev_server_type%존]%rev_list6%
	rev_result =<b>[적용존]</b>%seper_key%%rev_server_type% 존%seper_key%%seper_key%<b>[Revision]</b>%seper_key%%svn_type% : %rev_list1%%seper_key%%seper_key%<b>[변경내용]</b>%seper_key%%rev_list6%%seper_key%%seper_key%<b>[파일목록]</b>%seper_key%%rev_path_total%%seper_key%<b>[세부사항]</b>%seper_key%%seper_key%
	
	content =%rev_titlename%%seper_key%%seper_key%%rev_result% 
	
	;winclip.sethtml(content,"BloggingKit")
	;winclip.settext(content)
	;msgbox %rev_titlename%`n`n%rev_result% 
	traytip,Result,SVN정보 복사완료.`n패치매니저:%path_manager%
	return %content%
}


get_parents_id(o_class) ;부모창 id가져오기 ex)get_parents_id("ahk_class #32770")
{
	ID := DllCall("GetParent", UInt,WinExist(o_class)), ID := !ID ? WinExist(o_class) : ID
	WinGetClass, Class, ahk_id %id%
	WinGetTitle, Title, ahk_id %id%
	return %id%
}


Ram()
{
	h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", DllCall("GetCurrentProcessId")),DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1),DllCall("CloseHandle", "Int", h)
	return
}



SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
	BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
	
	SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
	,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
	,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
	,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
	
	If Cursor = ; empty, so create blank cursor 
	{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1 ; flag for later
	}
	Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
	{
		Loop, Parse, SystemCursors, `,
		{
			CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
			CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
			SystemCursor = 1
			If ( CursorName = Cursor )
			{
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				Break					
			}
		}	
		If CursorHandle = ; invalid cursor name given
		{
			Msgbox,, SetCursor, Error: Invalid cursor name
			CursorHandle = Error
		}
	}	
	Else If FileExist( Cursor )
	{
		SplitPath, Cursor,,, Ext ; auto-detect type
		If Ext = ico 
		uType := 0x1	
		Else If Ext in cur,ani
		uType := 0x2		
		Else ; invalid file ext
		{
			Msgbox,, SetCursor, Error: Invalid file type
			CursorHandle = Error
		}		
		FileCursor = 1
	}
	Else
	{	
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error ; raise for later
	}
	If CursorHandle != Error 
	{
		Loop, Parse, SystemCursors, `,
		{
			If BlankCursor = 1 
			{
				Type = BlankCursor
				%Type%%A_Index% := DllCall( "CreateCursor"
				, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}			
			Else If SystemCursor = 1
			{
				Type = SystemCursor
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				%Type%%A_Index% := DllCall( "CopyImage"
				, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )		
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If FileCursor = 1
			{
				Type = FileCursor
				%Type%%A_Index% := DllCall( "LoadImageA"
				, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
				DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )			
			}          
		}
	}	
}


RestoreCursors()
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}


RelativePath(MasterPath, SlavePath, s="\"){
    len := InStr(MasterPath, s, "", InStr(MasterPath, s . s) + 2) ;get server or drive string length
    If SubStr(MasterPath, 1, len ) <> SubStr(SlavePath, 1, len )  ;different server or drive
        Return SlavePath                                              ;return absolut path
    MasterPath := SubStr(MasterPath, len + 1 )                    ;remove server or drive from MasterPath
    SlavePath := SubStr(SlavePath, len + 1 )                      ;remove server or drive from SlavePath
    If InStr(MasterPath, s, "", 0) = StrLen(MasterPath)           ;remove last \ from MasterPath if any
        StringTrimRight, MasterPath, MasterPath, 1
    If InStr(SlavePath, s, "", 0) = StrLen(SlavePath)             ;remove last \ from SlavePath if any
        StringTrimRight, SlavePath, SlavePath, 1
    Loop{
        If !MasterPath                                            ;when there is nothing didentical
            Return s SlavePath                                         ;return SlavePath in root
        If InStr(SlavePath s, MasterPath s){                      ;when parts of paths match
            If !r                                                      ;no relative part yet
                r = .%s%                                                   ;SlavePath is in the MasterPath
            Return r . SubStr(SlavePath,StrLen(MasterPath) + 2)        ;return relative path
        }Else{                                                    ;otherwise
            r .= ".." s                                                ;add relative part
            MasterPath := SubStr(MasterPath, 1, InStr(MasterPath, s, "", 0) - 1)   ;remove one folder from MasterPath
          }
      }
  }


AbsolutePath(AbsolutPath, RelativePath, s="\") {
    len := InStr(AbsolutPath, s, "", InStr(AbsolutPath, s . s) + 2) - 1   ;get server or drive string length
    pr := SubStr(AbsolutPath, 1, len)                                     ;get server or drive name
    AbsolutPath := SubStr(AbsolutPath, len + 1)                           ;remove server or drive from AbsolutPath
    If InStr(AbsolutPath, s, "", 0) = StrLen(AbsolutPath)                 ;remove last \ from AbsolutPath if any
        StringTrimRight, AbsolutPath, AbsolutPath, 1
    If InStr(RelativePath, s, "", 0) = StrLen(RelativePath)               ;remove last \ from RelativePath if any
        StringTrimRight, RelativePath, RelativePath, 1
    If InStr(RelativePath, s) = 1                                         ;when first char is \ go to AbsolutPath of server or drive
        AbsolutPath := "", RelativePath := SubStr(RelativePath, 2)            ;set AbsolutPath to nothing and remove one char from RelativePath
    Else If InStr(RelativePath,"." s) = 1                                 ;when first two chars are .\ add to current AbsolutPath directory
        RelativePath := SubStr(RelativePath, 3)                               ;remove two chars from RelativePath
    Else {                                                                ;otherwise
        StringReplace, RelativePath, RelativePath, ..%s%, , UseErrorLevel     ;remove all ..\ from RelativePath
        Loop, %ErrorLevel%                                                    ;for all ..\
            AbsolutPath := SubStr(AbsolutPath, 1, InStr(AbsolutPath, s, "", 0) - 1)  ;remove one folder from AbsolutPath
      }
    Return, pr . AbsolutPath . s . RelativePath                             ;concatenate server + AbsolutPath + separator + RelativePath
  }