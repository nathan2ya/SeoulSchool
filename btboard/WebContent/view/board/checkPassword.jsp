<%@ page language="java" contentType="text/html; charset=euc-kr"pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
<head>
	<title>��й�ȣ üũ</title>
	
	<SCRIPT type="text/javascript">
		//null ��ȿ���˻�
		function checkIt(){
			inputForm=eval("document.checkPassword");
			var password = ${pw};
		 
			if(!inputForm.checkPwInput.value){
				alert("��й�ȣ�� �Է����ּ���.");
				checkPassword.checkPwInput.focus();
				return false;
			}
			if(inputForm.checkPwInput.value != password){
				alert("��й�ȣ�� Ȯ�����ּ���");
				checkPassword.checkPwInput.focus();
				return false;
			}
		}
		
	</script>
</head>


<body>

	<!-- ���� ������ -->
	<c:if test="${requestType==1}">
		<form name="checkPassword" action="/btboard/deleteBoard.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}" method="post">
	</c:if>
	<!-- �Ҵ�� ������ -->
	<c:if test="${requestType==2}">
		<form name="checkPassword" action="/btboard/deleteReplay.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&replay_seq_num=${replay_seq_num}" method="post" >
	</c:if>
		
		<table align="center">
			<tr>
				<td align="center">
					<br/><br/><br/><br/><br/>
					��й�ȣ�� �Է����ּ���. <br/>
					<input type="text" name="checkPwInput" id="checkPwInput" /> <br/>
					<input type="submit" value="Ȯ ��" onClick="return checkIt()" />
				</td>
			</tr>
		</table>
		
	</form>
</body>