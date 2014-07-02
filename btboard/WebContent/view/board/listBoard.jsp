<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>BT�Խ���</title>
	<style>
    #align {  
        width:100%;  
        height:100px;
        text-align:center;  
    }
    
    A:link    {color:blue;text-decoration:none;} /* ���� �湮���� ������� */
	A:visited {color:blue; text-decoration:none; } /* �ѹ� �̻� �湮�� ��ũ ó�� */
	A:active  {color:blue; text-decoration:none; }/* ���콺�� Ŭ���ϴ� ���� */
	A:hover  {color:blue; text-decoration:none; } /* ���콺 ��ũ �� �÷� �������� */
	
    </style>

    
    <script language="javascript">
		//�˻��� null ��ȿ�� �˻�	
		function checkIt(){
			inputForm=eval("document.searchForm");
			
			if(!searchForm.userinput.value){
				alert("�˻�� �������ּ���.");
				inputForm.userinput.focus();
				return false;
			}
		}
		
		//�˻������� ���ڼ� ���� ��ũ��Ʈ
		function CheckStrLen(maxChars, theField) {
			var temp; //������ ���ڰ�.
			var msglen;
			msglen = maxChars * 2;
			var value = theField.value;
	
			l = theField.value.length;
			tmpstr = "";
	
			if (l == 0) {
				value = maxChars * 2;
			} else {
				for (k = 0; k < l; k++) {
					temp = value.charAt(k);
	
					if (escape(temp).length > 4)
						msglen -= 2;
					else
						msglen--;
	
					if (msglen < 0) {
						alert("������ ���� " + (maxChars * 2) + "�� �ѱ� " + maxChars
								+ "�� ���� �Է°����մϴ�. (���� �� ���� ����)");
						theField.value = tmpstr;
						break;
					} else {
						tmpstr += temp;
					}
				}
			}
		}
	</script>
	
</head>

<h1 align="center">BT�Խ���</h1>

<body>
	
	<!-- �Խ��� ����Ʈ -->
	
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="5" width="700" align="right">
				<c:if test="${searchingNow == 0}">
					���� <font color="red"><b>��ü ��(${total})</b></font>�� ���� ��ʴϴ�. <br/>
				</c:if>
				<c:if test="${searchingNow == 1}">
					<input name="stopSearching" type="button"  value="��ü �� ����" onClick="javascript:location.href='/btboard/listBoard.do'" /> <br/>
					���� "<font size="4" color="green">${tempInput}</font>" �� <font color="red"><b>�˻� ��(${totalCount})</b></font>�� ���� ��ʴϴ�. 
				</c:if>
			</td>
		</tr>
	</table>
	
	<table border="2" align="center" cellpadding="0" cellspacing="0" bordercolor="#B2EBF4">
		<tr>
			<td width="70" align="center" bgcolor="#E7E7E7"><font size="4"><b>�� ��ȣ</b></font></td>
			<td width="320" align="center" bgcolor="#E7E7E7"><font size="4"><b>����</b></font></td>
			<td width="120" align="center" bgcolor="#E7E7E7"><font size="4"><b>�ۼ���</b></font></td>
			<td width="120" align="center" bgcolor="#E7E7E7"><font size="4"><b>�ۼ���¥</b></font></td>
			<td width="70" align="center" bgcolor="#E7E7E7"><font size="4"><b>��ȸ��</b></font></td>
		</tr>
		
		
		
		<c:forEach var="list" items="${list}">
			<c:url var="url" value="/readBoard.do"> 
				<c:param name="board_seq_num" value="${list.board_seq_num}"/>
				<c:param name="currentPage" value="${currentPage}"/>
				<c:param name="searchingNow" value="${searchingNow}"/>
				<c:if test="${searchingNow == 1}">
					<c:param name="searchType" value="${searchType}"/>
					<c:param name="userinput" value="${userinput}"/>
				</c:if>
			</c:url>
			
			<tr>
				<td align="center">
				
					<c:if test="${list.board_relevel == 0}">
						<c:out value="${number}" />
						<c:set var="number" value="${number-1}"/>
					</c:if>
					
					<c:if test="${list.board_relevel != 0}">
						&nbsp;
					</c:if>
					
				</td>
				<td align="left">
					<a href=${url}>
						<!-- �鿩���� -->
						<c:forEach var="a" begin="0" end="${list.board_relevel}" step="1"> 
						    &nbsp;&nbsp;
						</c:forEach> 
						
						<font color="#0054FF">${list.board_subject}</font>
					</a>
				</td>
				<td align="center">${list.board_writer}</td>
				<td align="center"><fmt:formatDate value="${list.board_reg_date}" pattern="yyyy��MM��dd�� HH:mm:ss"/></td>
				<td align="center">${list.board_readcnt}</td>
			</tr>
		</c:forEach>
		
		<c:if test="${total == 0}">
		<tr>
			<td colspan="5" align="center">
				<pre>��ϵ� �Խù��� �����ϴ�.</pre>
			</td>
		</tr>
		</c:if>
	</table>
	
	<form name="searchForm" action="/btboard/listSearchBoard.do" method="post">
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr align="right">
			<td width="700" colspan="5" align="right">
				<br/>
				<!-- �˻� �Է� �ʵ� -->
				<select name = "searchType"> 
                   <option value = "subject"> ����</option> 
                   <option value = "content"> ����</option> 
                   <option value = "writer"> �ۼ���</option> 
               </select> 
				<input type="text" name="userinput" id="userinput"  onKeyUp="CheckStrLen('200',this);" />
				<input name="submit" type="submit"  value="�˻�" onClick="return checkIt()" /> 
				<!-- .�˻� �Է� �ʵ� ���� -->
				
				<input name="insert" type="button"  value="�� ����" onClick="javascript:location.href='/btboard/insertBoardForm.do'" /> <br/>
				<font color = "gray" size="2">�˻��� ���ڼ� ������ �ִ� 200�� �Դϴ�.</font> <br/>
			</td>
		</tr>
	</table>
	</form>
	<!-- .�Խ��� ����Ʈ ���� -->
	
	
	<!-- ����¡ -->
	<div id="align">
		<br/>${pagingHtml}
	</div>
	<!-- .����¡���� -->
	
</body>
</html>
