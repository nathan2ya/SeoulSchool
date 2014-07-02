<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>

<html>
<head>
	<title>답글 입력</title>
	
	<SCRIPT type="text/javascript">
		//null 유효성검사
		function checkIt(){
			inputForm=eval("document.insertBoardForm");
		 
			if(!inputForm.board_subject.value){
				alert("제목을 입력해주세요.");
				insertBoardForm.board_subject.focus();
				return false;
			}
			if(!inputForm.board_writer.value){
				alert("작성자를 입력해주세요.");
				insertBoardForm.board_writer.focus();
				return false;
			}
			if(!inputForm.board_password.value){
				alert("비밀번호를 입력해주세요.");
				insertBoardForm.board_password.focus();
				return false;
			}
		}
		
		
		//제목 4000byte 글자수제한
		function sub_check_byte(frm) {
			var ari_max = 100; // limit 제한 글자수(100)
			var ls_str = frm.board_subject.value; // 내용 val
			var li_str_len = ls_str.length; // 전체길이 

			// 변수초기화 
			var li_max = ari_max; // 제한할 글자수 크기 
			var i = 0; // for문에 사용 
			var li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
			var li_len = 0; // substring하기 위해서 사용 
			var ls_one_char = ""; // 한글자씩 검사한다 
			var ls_str2 = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다. 

			for (i = 0; i < li_str_len; i++) {
				// 한글자추출 
				ls_one_char = ls_str.charAt(i);

				// 한글이면 2를 더한다. 
				if (escape(ls_one_char).length > 4) {
					li_byte += 2;
				} else {
					li_byte++;
				}
				// 전체 크기가 li_max를 넘지않으면 
				if (li_byte <= li_max) {
					li_len = i + 1;
				}
			}
			frm.subbyte.value = li_byte;

			// 전체길이를 초과하면 
			if (li_byte > li_max) {
				alert(ari_max + "Byte를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.board_subject.value = ls_str2;
				frm.subbyte.value = li_max;
			}
			frm.board_subject.focus();
		}//.글자수를 보여주고 제한하는 컨트롤 종료   

		
		//내용 4000byte 글자수제한
		function check_byte(frm) {
			var ari_max = 4000; // limit 제한 글자수(4000)
			var ls_str = frm.board_content.value; // 내용 val
			var li_str_len = ls_str.length; // 전체길이 

			// 변수초기화 
			var li_max = ari_max; // 제한할 글자수 크기 
			var i = 0; // for문에 사용 
			var li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
			var li_len = 0; // substring하기 위해서 사용 
			var ls_one_char = ""; // 한글자씩 검사한다 
			var ls_str2 = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다. 

			for (i = 0; i < li_str_len; i++) {
				// 한글자추출 
				ls_one_char = ls_str.charAt(i);

				// 한글이면 2를 더한다. 
				if (escape(ls_one_char).length > 4) {
					li_byte += 2;
				} else {
					li_byte++;
				}
				// 전체 크기가 li_max를 넘지않으면 
				if (li_byte <= li_max) {
					li_len = i + 1;
				}
			}
			frm.messagebyte.value = li_byte;

			// 전체길이를 초과하면 
			if (li_byte > li_max) {
				alert(ari_max + "Byte를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.board_content.value = ls_str2;
				frm.messagebyte.value = li_max;
			}
			frm.board_content.focus();
		}//.글자수를 보여주고 제한하는 컨트롤 종료
	</script>
</head>

<h1 align="center">답글 입력</h1>

<body onload="check_byte(document.insertRBoardForm); sub_check_byte(document.insertRBoardForm);">

<form name="insertRBoardForm" action="/btboard/insertRBoard.do" method="post" onSubmit="return checkIt()">
	<table border="1" align="center" width="800" bordercolor="#E7E7E7">
		
		<tr>
			<td width="250" height="8" align="center" bgcolor="#E7E7E7"><b>제목</b></td>
			<td width="550" height="8" colspan="3">
				<!-- 댓글에 필요한 hidden 값 정의 -->
				<input type="hidden" name="board_seq_num" value="${board_seq_num}" />
				<input type="hidden" name="board_group" value="${board_group}" />
	 			<input type="hidden" name="board_relevel" value="${board_relevel}" />
	 			<input type="hidden" name="board_restep" value="${board_restep}" />
	 			
				<input type="text" name="board_subject" id="board_subject" value="re)" size="70" maxlength="100" onKeyDown="sub_check_byte(this.form);" onkeyup="sub_check_byte(this.form);"/>
				<input type="text" name="subbyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" /> Byte / <font color="gray" size=2>100Byte</font>
			</td>
		</tr>
		
		<tr>
			<td width="150" height="8" align="center" bgcolor="#E7E7E7"><b>등록자</b></td>
			<td width="200" height="8">
				<input type="text" name="board_writer" id="board_writer" size="33" maxlength="10"/>
			</td>
			
			<td width="200" height="8" align="center" bgcolor="#E7E7E7">
				<b>비밀번호</b>
			</td>
			<td width="200" height="8">
				<input type="password" name="board_password" id="board_password" size="33" maxlength="8"/>
			</td>
		</tr>
		
		<tr>
			<td width="150" align="center" bgcolor="#E7E7E7">
				<b>내용</b>
			</td>
			<td width="550" colspan="3" align="center">
				 <pre><textarea cols="98" rows="10" name="board_content" id="board_content" class=textarea onKeyDown="check_byte(this.form);" onkeyup="check_byte(this.form);"></textarea></pre>
			</td>
		</tr>
		
		<tr>
			<td width="750" colspan="4" align="right">
				<input type="text" name="messagebyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" /> Byte / <font color="red" size=2>4000Byte</font>
			</td>
		</tr>
		
	 	<tr>
	 		<td width="750" colspan="4" align="right">
	 			<input name="submit" type="submit"  value="답글 쓰기"/>
				<input name="cancel" type="button"  value="등록 취소" onClick="javascript:location.href='/btboard/listBoard.do'" />
	 		</td>
	 	</tr>
	 	
	</table>
</form>


</body>
</html>