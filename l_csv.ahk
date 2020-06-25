;=======================================
;
;CSV ���� ���̺귯��
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



;--�ش���ġ�� ���� �о����
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

;---�ش���ġ�� �� �����ϱ�
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



;--row ���� ��������
get_rownum(csvdata)
{
	loop,parse,csvdata,`r`n
	{	
	rownum:=A_index
	}
	return rownum
}


;--column ���� ��������
get_columnnum(csvdata)
{
	return columnnum
}


;----row �����
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



;----���͸��ϱ�

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





;---row �߰��ϱ�
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

;-------������ row �ҷ�����
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


;----�ش� row ����
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


;---������ row ����
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



;---�ش� row ���� /- ���� rownum�� 1�̸�, ��������� ����
up_row(csvdata,rownum,cnt="1")
{
	
	;----1�̸� ������ ���
	if rownum=1
	return csvdata
	
	rowitem:=get_row(csvdata,rownum) ;�ش� row���� �ϴ� ��������
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


;----�ش� row �Ʒ��� ���� rownum�� ���ϸ�, ��������� ����
down_row(csvdata,rownum,cnt="1")
{
	row_n=get_rownum(csvdata)
	if (row_n=rownum)
	return csvdata
	
	rowitem:=get_row(csvdata,rownum) ;�ش� row���� �ϴ� ��������
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


;----�ش� column ��������
left_column(csvdata,columnnum,cnt="1")
{
	
}

;----�ش� column ����������
right_column(csvdata,columnnum,cnt="1")
{
	
}