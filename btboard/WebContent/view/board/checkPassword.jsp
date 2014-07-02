<%@ page language="java" contentType="text/html; charset=euc-kr"pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
<head>
	<title>비밀번호 체크</title>
	
	<SCRIPT type="text/javascript">
		//null 유효성검사
		function checkIt(){
			inputForm=eval("document.checkPassword");
			var password = ${pw};
		 
			if(!inputForm.checkPwInput.value){
				alert("비밀번호를 입력해주세요.");
				checkPassword.checkPwInput.focus();
				return false;
			}
			if(inputForm.checkPwInput.value != password){
				alert("비밀번호를 확인해주세요");
				checkPassword.checkPwInput.focus();
				return false;
			}
		}
		
	</script>
</head>


<body>

	<!-- 원글 삭제시 -->
	<c:if test="${requestType==1}">
		<form name="checkPassword" action="/btboard/deleteBoard.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}" method="post">
	</c:if>
	<!-- 소댓글 삭제시 -->
	<c:if test="${requestType==2}">
		<form name="checkPassword" action="/btboard/deleteReplay.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&replay_seq_num=${replay_seq_num}" method="post" >
	</c:if>
		
		<table align="center">
			<tr>
				<td align="center">
					<br/><br/><br/><br/><br/>
					비밀번호를 입력해주세요. <br/>
					<input type="text" name="checkPwInput" id="checkPwInput" /> <br/>
					<input type="submit" value="확 인" onClick="return checkIt()" />
				</td>
			</tr>
		</table>
		
	</form>
</body>