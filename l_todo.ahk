

;;----------------------------------
;; todo.txt
;;----------------------------------


todo_test(todo_data){ ;문법 테스트용
path=%A_scriptDir%\todo.txt ;집
fileread,path_var,%path%
item_test:=list_todo2ever(path_var)
return item_test
}


todo2ever()
{
global path_todo
fileread,path_var,%path_todo%
item_test:=list_todo2ever(path_var)
return item_test
}



ever2todo(todo_data)
{
global path_todo
global path_done
	
get_todo:=list_ever2todo(todo_data)	 ;투두형태로 변환
list_todo:=get_todo_list(get_todo) ;todo만 뽑기
list_done:=get_done_list(get_todo) ;done만 뽑기

filedelete,%path_todo%
fileappend,%list_todo%,%path_todo%,UTF-8

fileread,done_data,%path_done%
traytip, Debug, %done_data%
done_data=%done_data%`n%list_done%

sort,done_data,U
filedelete,%path_done%
fileappend,%done_data%,%path_done%,UTF-8
;list_html:=list_todo2ever(list_todo)

return list_html
}




todo_archive(todo_data) ;완료된 것만 뱉기. 하루 마무리.
{
	
	global path_todo
global path_done

list_done:=get_done_list(get_todo) ;done만 뽑기
list_html:=list_todo2ever(list_done)

	
return list_html	
}








item_todo2html(item,is_ever=""){  ;todo.txt문법을 에버노트용으로 파싱. 상황에 맞춰 글자두께/색깔 변경.
	
	tag_color=255,175,0
	project_color=20,113,145
	context_color=229, 0, 255
	date_color=222,87,0
	Priority_a_color=227, 0, 0
	Priority_b_color=222,87,0
	Priority_c_color=65,173,28
	done_color=100,100,100
	

	if is_ever!
	{
	loop,parse,item,`r`n
	{
	
	item_html:=regexreplace(A_loopfield,"(\+[^\s\r]+)","<span style='color: rgb(" . project_color . ");'><b>$1</b></span>" )
	item_html:=regexreplace(item_html,"(\d{4}-\d{2}-\d{2})\s","<span style='color: rgb(" . date_color . ");'>$1 </span> " )
	item_html:=regexreplace(item_html,"(@[^\s\r]+)","<span style='color: rgb(" . context_color . ");'>$1</span> " )
	item_html:=regexreplace(item_html,"(#[^\s\r]+)","<span style='color: rgb(" . tag_color . ");'><b>$1</b></span> " )
	item_html:=regexreplace(item_html,"^(\(A\))\s","<span style='color: rgb(" . Priority_a_color . ");'><b>$1</b></span> " )
	item_html:=regexreplace(item_html,"^(\(B\))\s","<span style='color: rgb(" . Priority_b_color . ");'><b>$1</b></span> " )
	item_html:=regexreplace(item_html,"^(\(B\))\s","<span style='color: rgb(" . Priority_c_color . ");'><b>$1</b></span> " )
	item_html:=regexreplace(item_html,"^x\s(.+)","<span style='color: rgb(" . done_color . ");'>$1</span>" )	
	
	;item_html_full=%item_html_full%[ ] %item_html%`n
	item_html_full=%item_html_full%<div><span><object class="en-todo"></object> %item_html%</span></div>
	}
	
	}
	
	return item_html_full
}


item_ever2todo(item,exclude_text=""){ ;에버노트용 내용을 todo.txt로 변경.제거할게 있으면 제거.
	
	if exclude_text
	stringreplace,item_todo,item,%exclude_text%,,ALL
	
	item_todo:=regexreplace(item_todo,"\[X\]","x")
	item_todo:=regexreplace(item_todo,"\[\s\]","")
	
	return item_todo
}




list_todo2ever(todo_data){ ;todo데이터를 받아서 내 식대로 가공.

company_asap:=list_todo2block(todo_data,"@회사","@ASAP")
company_Someday:=list_todo2block(todo_data,"@회사","@SOMEDAY")
company_wait:=list_todo2block(todo_data,"@회사","@WaitFor")
company_Repeat:=list_todo2block(todo_data,"@회사","@REPEAT")
home_asap:=list_todo2block(todo_data,"@HOME","@ASAP","@HOME")
home_Someday:=list_todo2block(todo_data,"@HOME","@SOMEDAY")
home_Repeat:=list_todo2block(todo_data,"@HOME","@REPEAT")
home_wait:=list_todo2block(todo_data,"@HOME","@WaitFor")
home_uncontext:=list_uncontext(todo_data)
ever_html = %company_asap%%company_wait%%company_Someday%%company_Repeat%
ever_html = %ever_html%<br><hr>%home_asap%%home_uncontext%%home_Someday%%home_Repeat%%home_wait%

return ever_html
}





list_todo2block(todo_data,context1,context2,title="") ;컨텍스트 2개를 교차검증하는 내용을 뽑고, 제목붙여서 출력.
{
	if title!
	title:=context2
	
	;msgbox %todo_data%
	
	loop,parse,todo_data,`r`n
	{
		if (InStr(a_loopfield,context1)>0 && instr(a_loopfield,context2)>0)
		{
		stringreplace,item,A_loopfield,%context1%,,ALL
		stringreplace,item,item,%context2%,,ALL
		item_full=%item_full%%item%`n
		}
		}
	
	item_full:=item_todo2html(item_full)
	item_full=<b>%title%</b><br>%item_full%<br>
	
	return item_full
	}


	
list_uncontext(todo_data) ; 정규 컨텍스트(@HOME/@회사/@ASAP@TODAY@SOMEDAY@REPEAT)가 없는 리스트만 뽑기.TODO에서 대충 적을때 대비
{
	loop,parse,todo_data,`r`n
	{
	if(instr(a_loopfield,"@HOME") && instr(a_loopfield,"@회사") && instr(a_loopfield,"@ASAP") && instr(a_loopfield,"@TODAY") && instr(a_loopfield,"@SOMEDAY") && instr(a_loopfield,"@REPEAT") && instr(a_loopfield,"@WaitFor"))
	item_full=%item_full%%a_loopfield%`n
	}
return item_full
}
	
	



list_ever2todo(ever_data) ;에버노트를 복사해서 todo 구조로 변경.
{
	;ever_data=%ever_data%
	
	;msgbox %ever_data%

	ever_context1:="@회사"
	loop,parse,ever_data,`r`n
	{
	
		if (A_loopfield="@ASAP" or A_loopfield="@TODAY")
		ever_context2=@ASAP
		else if (A_loopfield="@SOMEDAY")
		ever_context2=@SOMEDAY
		else if (A_loopfield="@REPEAT")
		ever_context2=@REPEAT
			else if (A_loopfield="@WaitFor")
		ever_context2=@WaitFor
		else if (A_loopfield="@HOME")
		{
		ever_context1=@HOME
		ever_context2=@ASAP
		}
		else if A_loopfield
		{
		item_todo:=A_loopfield
		;item:=item_ever2todo(item)
		item_todo:=regexreplace(item_todo,"\[X\]","x")
		item_todo:=regexreplace(item_todo,"\[\s\]","")
		item=%item_todo% %ever_context1% %ever_context2%
		item_full=%item_full%%item%`n
		}
		
		}
	
	
	
	
	
	sort,item_full
	
	
	
	return item_full
	}


	
get_done_list(todo_data) ; 리스트에서 완성된 리스트만 추출하기.다 추출하면 done.txt로 넘기기?
{
	loop,parse,todo_data,`r`n
	{
	stringleft,left_block,a_loopfield,2

	if (left_block="x " and instr(a_loopfield,"@REPEAT")=0)
	item_full=%item_full%%a_loopfield% @end%A_YYYY%-%A_MM%-%A_DD%`n
	}
	return item_full
	}

get_todo_list(todo_data) ; 리스트에서 완성안된 리스트만 추출하기.다 추출하면 todo.txt로 넘기기?
{
	loop,parse,todo_data,`r`n
	{
	stringleft,left_block,a_loopfield,2

	item:=A_loopfield
	
	if (left_block!="x " or instr(a_loopfield,"@REPEAT")>0)
	{
	item:=regexreplace(item,"^x\s(.+)","$1" )
	item_full=%item_full%%item%`n
	}
	}
	return item_full
	}
	

	


filter_todo(data_todo,find_word,is_exclude=""){ ;특정글자만 들어간 todo만 필터링
	data_filter=
	tm=0
	loop,parse,data_todo,`r`n
	{
		ifinstring,A_loopfield,%find_word%
		{
			if tm=0
			{
				data_filter=%A_loopfield%
				tm=1
			}
			else
			data_filter=%data_filter%`n%A_loopfield%
		}
	}
	sort,data_filter

	if is_exclude=1
	stringreplace,data_filter,data_filter,%find_word%,,ALL
	return data_filter
}















