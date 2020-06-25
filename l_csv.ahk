;=======================================
;
;CSV 관련 라이브러리
;
;=======================================




push_cell(csvdata,row,cell)
{
	csv_temp=
	
	
		loop,parse,csvdata,`r`n
	{
		rowitem:=a_loopfield
		
		if (A_index=1)
		{
			sper=
			}
			else{
			sper=`n	
				}
			
		
		if (row=A_index)
		{
		csv_temp=%csv_temp%%sper%%rowitem%,%cell%
		}
		else
		{
		csv_temp=%csv_temp%%sper%%rowitem%
			}
		
	}
	return csvtemp
	
	
	
return cell	
	}



;--해당위치의 셀값 읽어오기
get_cell(csvdata,row,column)
{
	loop,parse,csvdata,`r`n
	{
		rowitem:=a_loopfield
		if (row=A_index)
		{
			loop,parse,rowitem,`,
			{
				if (column=A_index)
				{
					cell:=A_loopfield
					break
				}
			}
			break
		}
	}
	return cell
}

;---해당위치에 셀 삽입하기
put_cell(csvdata,row,column,cell)
{
	csv_temp:=
	loop,parse,csvdata,`r`n
	{
		rowitem:=a_loopfield
		if (row=A_index)
		{
			row_temp:=
			loop,parse,rowitem,`,
			{
				if (column=A_index)
				{
					row_temp=%row_temp%%cell%,
				}
				else
				{
					row_temp=%row_temp%%A_loopfield%,
				}
			}
			stringtrimright,row_temp,row_temp,1
			if row=1
			csv_temp=%csv_temp%%row_temp%
			else
			csv_temp=%csv_temp%`n%row_temp%
			
		}
		else
		{
			if A_index=1
			csv_temp=%csv_temp%%rowitem%
			else 
			csv_temp=%csv_temp%`n%rowitem%
		}	
	}
	return csv_temp
}



;--row 갯수 가져오기
get_rownum(csvdata)
{
	loop,parse,csvdata,`r`n
	{	
	rownum:=A_index
	}
	return rownum
}


;--column 갯수 가져오기
get_columnnum(csvdata)
{
	return columnnum
}


;----row 덮어쓰기
overwrite_row(csvdata,rownum,rowdata)
{
		csv_temp:=
	loop,parse,csvdata,`r`n
	{	
		rowitem:=a_loopfield
		if (rownum=A_index)
		{
			if A_index=1
			csv_temp=%csv_temp%%rowdata%
			else	
			csv_temp=%csv_temp%`n%rowdata%	
		}
		else
		{
			if A_index=1
			csv_temp=%csv_temp%%rowitem%
			else 
			csv_temp=%csv_temp%`n%rowitem%
		}	
	}
	return csv_temp
	}



;----필터링하기

filter_csv(csvdata,f_data,columnnum="0")
{
	cnt=0
	csv_temp:=
	loop,parse,csvdata,`r`n
{
	row_data:=
	csv_item:=
	if columnnum=0
	{
	ifinstring,A_loopfield,%f_data%
	{
	cnt:=cnt+1
	rowdata:=A_loopfield
			if cnt=1
			csv_temp=%csv_temp%%rowdata%
			else	
			csv_temp=%csv_temp%`n%rowdata%	
	}
	}
	else
	{
	stringsplit,csv_item,A_loopfield,`,
	ck=csv_item%columnnum%
	ck:=%ck%
	ifinstring,ck,%f_data%
	{
	cnt:=cnt+1
	rowdata:=A_loopfield
				if cnt=1
			csv_temp=%csv_temp%%rowdata%
			else	
			csv_temp=%csv_temp%`n%rowdata%	
	}
	}
}
	return csv_temp
}





;---row 추가하기
add_row(csvdata,rownum,rowdata)
{
	csv_temp:=
	loop,parse,csvdata,`r`n
	{	
		rowitem:=a_loopfield
		if (rownum=A_index)
		{
			if A_index=1
			csv_temp=%csv_temp%%rowdata%`n%rowitem%
			else	
			csv_temp=%csv_temp%`n%rowdata%`n%rowitem%	
		}
		else
		{
			if A_index=1
			csv_temp=%csv_temp%%rowitem%
			else 
			csv_temp=%csv_temp%`n%rowitem%
		}	
		
		
	}
	return csv_temp
}

;-------선택한 row 불러오기
get_row(csvdata,rownum)
{
	loop,parse,csvdata,`r`n
	{	
		if (rownum=A_index)
		{
			return A_loopfield
			break
		}
	}
}	


;----해당 row 제거
delete_row(csvdata,rownum)
{
	csv_temp:=
	loop,parse,csvdata,`r`n
	{	
		rowitem:=a_loopfield
		if (rownum=A_index)
		{
			csv_temp=%csv_temp%
		}
		else
		{
			if A_index=1
			csv_temp=%csv_temp%%rowitem%
			else 
			csv_temp=%csv_temp%`n%rowitem%
		}	
		
		
	}
	return csv_temp
}


;---마지막 row 제거
delete_lastrow(csvdata)
{
	csv_temp:=
	loop,parse,csvdata,`r`n
	{	
	if a_index=1
	{
	csv_temp=
	rowitem:=a_loopfield
	}
	else if a_index=2
	{
	csv_temp=%csv_temp%%rowitem%
	rowitem:=a_loopfield
	}
	else
	{
	csv_temp=%csv_temp%`n%rowitem%
	rowitem:=a_loopfield		
		}
	}
	return csv_temp
}





add_column(csvdata,columnnum,columndata)
{
	
	
	return csvdata
}



;---해당 row 위로 /- 만약 rownum이 1이면, 원래값대로 리턴
up_row(csvdata,rownum,cnt="1")
{
	
	;----1이면 원래값 뱉기
	if rownum=1
	return csvdata
	
	rowitem:=get_row(csvdata,rownum) ;해당 row값을 일단 가져오기
	csv_temp:=
	loop,parse,csvdata,`r`n
	{	
	if (rownum=A_index)
	{
	csv_temp:=csv_temp
	}
	else if ((rownum-cnt)=A_index)
	{
	if A_index=1
	csv_temp=%rowitem%`n%A_loopfield%
	else
	csv_temp=%csv_temp%`n%rowitem%`n%A_loopfield%
	}
	else
	{
	if A_index=1
	csv_temp=%A_loopfield%
	else
	csv_temp=%csv_temp%`n%A_loopfield%
	}
	}
	return csv_temp
}


;----해당 row 아래로 만약 rownum이 최하면, 원래값대로 리턴
down_row(csvdata,rownum,cnt="1")
{
	row_n=get_rownum(csvdata)
	if (row_n=rownum)
	return csvdata
	
	rowitem:=get_row(csvdata,rownum) ;해당 row값을 일단 가져오기
	csv_temp:=
	loop,parse,csvdata,`r`n
	{	
	if (rownum=A_index)
	{
	csv_temp:=csv_temp
	}
	else if ((rownum+cnt)=A_index)
	{
	if A_index=1
	csv_temp=%A_loopfield%`n%rowitem%
	else
	csv_temp=%csv_temp%`n%A_loopfield%`n%rowitem%
	}
	else
	{
	if A_index=1
	csv_temp=%A_loopfield%
	else
	csv_temp=%csv_temp%`n%A_loopfield%
	}
	}
	return csv_temp	
}


;----해당 column 왼쪽으로
left_column(csvdata,columnnum,cnt="1")
{
	
}

;----해당 column 오른쪽으로
right_column(csvdata,columnnum,cnt="1")
{
	
}