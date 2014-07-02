<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>게시판</title>
	
	<style>
	    #align {  
	        width:100%;  
	        height:100px;
	        text-align:center;  
	    }
	    
	    A:link    {color:blue;text-decoration:none;} /* 아직 방문하지 않은경우 */
		A:visited {color:blue; text-decoration:none; }/* 한번 이상 방문한 링크 처리 */
		A:active  {color:blue; text-decoration:none; }/* 마우스로 클릭하는 순간 */
		A:hover  {color:blue; text-decoration:none; } /* 마우스 링크 위 올려 놓았을때 */
    </style>
	
	<script language="javascript">
		
		//원글 삭제(소댓글이 없는 경우)
		function deletes(){
			if(confirm("삭제 하시겠습니까?")){
				location.href='/btboard/pwCheckFrom.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&requestType=1';
			}
		}
		
		//원글 삭제(소댓글이 있는 경우)
		function deletes1(){
			if(confirm("현재 소댓글이 있습니다. '예'를 클릭하시면 원글과 함께 삭제됩니다.")){
				location.href='/btboard/pwCheckFrom.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&requestType=1';
			}
		}
		
		//소댓글 입력 250byte 글자수제한
		function sub_check_byte(frm) {
			var ari_max = 250; // limit 제한 글자수
			var ls_str = frm.replay_content.value; // 내용 val
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
				frm.replay_content.value = ls_str2;
				frm.subbyte.value = li_max;
			}
			frm.replay_content.focus();
		}//.글자수를 보여주고 제한하는 컨트롤 종료 
		
		
		
		//소댓글수정 250byte 글자수제한
		function sub_check_byte1(frm) {
			var ari_max = 250; // limit 제한 글자수
			var ls_str = frm.replay_list_content1.value; // 내용 val
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
			frm.subbyte1.value = li_byte;

			// 전체길이를 초과하면 
			if (li_byte > li_max) {
				alert(ari_max + "Byte를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.replay_list_content1.value = ls_str2;
				frm.subbyte1.value = li_max;
			}
			frm.replay_list_content1.focus();
		}//.글자수를 보여주고 제한하는 컨트롤 종료
		
		
		
		//소댓글 입력
		function insertReplay(form) {
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_writer = document.getElementById("replay_writer").value; 
			var replay_content = document.getElementById("replay_content").value;
			var replay_password = document.getElementById("replay_password").value;
			var searchingNow = ${searchingNow};
			
			inputForm=eval("document.readBoardForm");
			
			if(!replay_password){
				alert("비밀번호를 입력해주세요.");
				readBoardForm.replay_password.focus();
				return false;
			}
			
			if(!replay_writer){
				alert("작성자를 입력해주세요.");
				readBoardForm.replay_writer.focus();
				return false;
			}
	
			var url = "/btboard/insertReplay.do?replay_writer="+replay_writer+"&replay_password="+replay_password+"&replay_content="+replay_content+"&board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&requestType=1"+"&searchingNow="+searchingNow;
			location.href=url;
		}
		
		
		
		//소댓글 수정 요청
		function updateRequesting(form, re_seq){
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_seq_num = re_seq;
			var searchingNow = ${searchingNow};
			
			
			if(confirm("수정 하시겠습니까?")){
				location.href="/btboard/updateReplayFrom.do?replay_seq_num="+replay_seq_num+"&board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&searchingNow="+searchingNow;
			}
		}
		
		
		//소댓글 수정 하기
		function updateReplay(form) {
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			
			var replay_seq_num = document.getElementById("replay_seq").value;
			var replay_content = document.getElementById("replay_list_content1").value;
			var replay_pw = document.getElementById("replay_pw").value;
			var replay_password = document.getElementById("check_replay_password").value;
			var searchingNow = ${searchingNow};
			
			inputForm=eval("document.readBoardForm");
			
			if(!replay_password){
				alert("비밀번호를 입력해주세요.");
				readBoardForm.check_replay_password.focus();
				return false;
			}
			if(replay_password != replay_pw){
				alert("비밀번호를 다시 확인해주세요");
				readBoardForm.check_replay_password.focus();
				return false;
			}
			if(replay_password == replay_pw){ //비밀번호가 맞으면
				var url = "/btboard/updateReplay.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&replay_seq_num="+replay_seq_num+"&replay_content="+replay_content+"&searchingNow="+searchingNow;
				location.href=url;
			}
		}
		
		
		//소댓글 수정 취소하기
		function cancelUpdateReplay(form) {
			if(confirm("수정을 취소 하시겠습니까?")){
				history.go(-1);
			}
		}
		
		
		//소댓글 삭제
		function deleteReplay(form, re_seq){
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_seq_num = re_seq;
			
			if(confirm("삭제 하시겠습니까?")){
				location.href="/btboard/pwCheckFrom.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&replay_seq_num="+replay_seq_num+"&requestType=2";
			}
		}
		
	</script>
</head>

<h1 align="center">글 읽기</h1>

<body>
	
	<form name="readBoardForm" action="/btboard/updateBoardForm.do" method="post">
		<table border="1" align="center" width="700" bordercolor="#E7E7E7">
			<tr>
				<td width="100" height="8" bgcolor="#E7E7E7"><b>제목</b></td>
				<td width="600" height="8" colspan="5">${resultClass.board_subject}</td>
			</tr>
			
			<tr>
				<!-- submit 필요값 hidden처리 -->
	 			<input type="hidden" name="board_seq_num" id="board_seq_num" value="${board_seq_num}" />
	 			<input type="hidden" name="currentPage" id="currentPage" value="${currentPage}" />
	 			
				<td width="70" height="8" bgcolor="#E7E7E7"><b>글번호</b></td>
				<td width="70" height="8">${resultClass.board_seq_num}</td>

				<td width="70" height="8" bgcolor="#E7E7E7"><b>등록자</b></td>
				<td width="70" height="8">${resultClass.board_writer}</td>
				
				<td width="70" height="8" bgcolor="#E7E7E7"><b>조회수</b></td>
				<td width="70" height="8">${resultClass.board_readcnt} <br/>
				</td>
			</tr>
			
			<tr>
				<td width="70" height="300" bgcolor="#E7E7E7"><b>내용</b></td>
				<td colspan="5" width="450">
					<pre><textarea cols="90" rows="20" name="board_content" maxlength="300" readonly="readonly" style="border:0px">${resultClass.board_content}</textarea></pre> 
				</td>
			</tr>
			
			<tr>
		 		<td colspan="6" align="right">
		 			<input name="submit" type="submit"  value="수정" />
		 			<!-- 소댓글이 없는 경우 -->
		 			<c:if test="${total == 0}">
			 			<input  type="button" name="delete"  value="삭제" onClick="deletes();" />
			 		</c:if>
			 		<!-- 소댓글이 있는 경우 -->
			 		<c:if test="${total != 0}">
			 			<input  type="button" name="delete"  value="삭제" onClick="deletes1();" />
			 		</c:if>
			 		
			 		<input  type="button" name="boardR"  value="답글 쓰기" onClick="javascript:location.href='/btboard/insertRBoardForm.do?board_seq_num=${resultClass.board_seq_num}&board_group=${resultClass.board_group}&board_relevel=${resultClass.board_relevel}&board_restep=${resultClass.board_restep}'" />
					
					
					
					<!-- 전체글에서 read.jsp 진입시에 --> 
					<c:if test="${searchingNow == 0}">
						<input  type="button" name="list"  value="목록 보기" onClick="javascript:location.href='/btboard/listBoard.do?currentPage=${currentPage}'" />
					</c:if>
					<!-- 검색중 read.jsp 진입시에 --> 
					<c:if test="${searchingNow == 1}">
						<input  type="button" name="list"  value="목록 보기" onClick="javascript:location.href='/btboard/listSearchBoard.do?searchType=${searchType}&userinput=${userinput}&currentPage=${currentPage}'" />
					</c:if>
		 		</td>
		 	</tr>
		 	
		 	
		 	<!-- 소댓글입력 -->
		 	<tr>
		 		<td colspan="6" align="left" bgcolor="#E7E7E7">
		 			<b>댓글입력</b>
		 		</td>
		 	</tr>
		 	<tr>
		 		<td colspan="6" align="right">
		 			<textarea cols="100" rows="3" name="replay_content" id="replay_content" class=textarea onKeyDown="sub_check_byte(this.form);" onkeyup="sub_check_byte(this.form);"></textarea>
		 			<br/>
		 			작성자 : <input type="text" name="replay_writer" id="replay_writer" /> 
		 			비밀번호 : <input type="text" name="replay_password" id="replay_password" />
		 			
					<input  type="button" name="replay"  value="댓글입력" onclick="insertReplay(this.form)"/>
					
					<!-- 바이트수 체크 숨김 -->
					<input type="hidden" name="subbyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" />
		 		</td>
		 	</tr>
		 	<!-- .소댓글입력 종료 -->
		 	
		 	
		 	
		 	<!-- 소댓글 리스트 -->
		 	<tr>
		 		<td colspan="6" align="left" bgcolor="#E7E7E7">
		 			<b>댓글목록</b>
		 		</td>
		 	</tr>
		 	
		 	<c:forEach var="list" items="${list}">
		 	<tr>
		 		<td colspan="2" align="left">
		 			<b>작성자</b> </br> ${list.replay_writer}
		 			<input type="hidden" name="replay_seq_num" id="replay_seq_num" value="${list.replay_seq_num}" />
		 		</td>
		 		
		 		<!-- 소댓글 일반 리스트 -->
		 		<c:if test="${updating  == 0}">
			 		<td colspan="2" align="left">
			 			<b>내용</b> </br> 
		 				<textarea cols="60" rows="2" name="replay_list_content" id="replay_list_content" readonly="readonly" style="border:0px">${list.replay_content}</textarea>
			 		</td>
			 		<td colspan="1" align="center">
			 			<input  type="button" name="updateR"  value="수정" onclick="updateRequesting(this.form, '${list.replay_seq_num}')"/></br>
			 			<input  type="button" name="deleteR"  value="삭제" onClick="deleteReplay(this.form, '${list.replay_seq_num}');" />
			 		</td>
		 		</c:if>
		 		<!--. 소댓글 일반 리스트 종료 -->
		 		
		 		
		 		<!-- 소댓글 수정 요청시 변환된 리스트 -->
		 		<c:if test="${updating  == 1}">
		 			
					<!-- 수정요청된 레코드 -->
		 			<c:if test="${list.replay_isUpdating==1}">
				 		<td colspan="2" align="left">
				 			<b>내용</b> </br> 
			 				<textarea cols="60" rows="2" name="replay_list_content1" id="replay_list_content1" class=textarea onKeyDown="sub_check_byte1(this.form);" onkeyup="sub_check_byte1(this.form);">${list.replay_content}</textarea> <br/>
			 				
			 				<!-- 바이트수 체크 숨김 -->
							<input type="hidden" name="subbyte1" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" />
			 				작성자 : ${list.replay_writer} &nbsp;
			 				비밀번호 : 
			 				<!-- 사용자 비밀번호 확인용 input값 -->
			 				<input type="text" name="check_replay_password" id="check_replay_password"/>
			 				
			 				<!-- 시퀀스 및 기존비밀번호 -->
			 				<input type="hidden" name="replay_seq" id="replay_seq" value="${list.replay_seq_num}" />
			 				<input type="hidden" name="replay_pw" id="replay_pw" value="${list.replay_password}" />
				 		</td>
				 		<td colspan="1" align="center">
				 			<%-- 
				 			<input type="hidden" name="replay_seq_num" id="replay_seq_num" value="${list.replay_seq_num}" />
				 			 --%>
				 			<input type="hidden" name="searchingNow" id="searchingNow" value="${searchingNow}" />
				 			
				 			<input  type="button" name="updateRnow"  value="완료" onclick="updateReplay(this.form)"/></br>
				 			<input  type="button" name="cancelU"  value="취소" onClick="cancelUpdateReplay(this.form);" />
				 		</td>
				 		
			 		</c:if>
			 		
			 		<!-- 수정요청이 들어오지 않은 레코드 -->
			 		<c:if test="${list.replay_isUpdating==0}">
			 			<td colspan="2" align="left">
				 			<b>내용</b> </br> 
			 				<textarea cols="60" rows="2" name="replay_list_content" id="replay_list_content" readonly="readonly" style="border:0px">${list.replay_content}</textarea>
				 		</td>
				 		<td colspan="1" align="center">
				 			<input  type="button" name="updateR"  value="수정" onclick="updateRequesting(this.form, '${list.replay_seq_num}')"/></br>
				 			<input  type="button" name="deleteR"  value="삭제" onClick="deleteReplay(this.form, '${list.replay_seq_num}');" />
				 		</td>
			 		</c:if>
			 		
		 		</c:if>
		 		<!--. 소댓글 수정 리스트 종료 -->
		 		
		 		
		 		<td colspan="1" align="left">
		 			<b>작성일</b> </br> 
		 			<fmt:formatDate value="${list.replay_reg_date}" pattern="yyyy.MM.dd HH:mm:ss"/>
		 		</td>
		 	</tr>
		 	</c:forEach>
		 	
		 	
		 	<c:if test="${total == 0}">
			<tr>
				<td colspan="6" align="center">
					<pre>등록된 게시물이 없습니다.</pre>
				</td>
			</tr>
			</c:if>
		 	<!-- .리플리스트 종료 -->
		 	
		 	<tr>
		 		<td colspan="6" width="700" height="8" align="center">
		 			<!-- 댓글페이징 -->
					<div id="align">
						<br/>${pagingHtml}
					</div>
					<!-- .댓글페이징 종료 -->
		 		</td>
		 	</tr>
		 	
		</table>
	</form>
</body>
</html>