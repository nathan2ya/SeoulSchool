<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>�Խ���</title>
	
	<style>
	    #align {  
	        width:100%;  
	        height:100px;
	        text-align:center;  
	    }
	    
	    A:link    {color:blue;text-decoration:none;} /* ���� �湮���� ������� */
		A:visited {color:blue; text-decoration:none; }/* �ѹ� �̻� �湮�� ��ũ ó�� */
		A:active  {color:blue; text-decoration:none; }/* ���콺�� Ŭ���ϴ� ���� */
		A:hover  {color:blue; text-decoration:none; } /* ���콺 ��ũ �� �÷� �������� */
    </style>
	
	<script language="javascript">
		
		//���� ����(�Ҵ���� ���� ���)
		function deletes(){
			if(confirm("���� �Ͻðڽ��ϱ�?")){
				location.href='/btboard/pwCheckFrom.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&requestType=1';
			}
		}
		
		//���� ����(�Ҵ���� �ִ� ���)
		function deletes1(){
			if(confirm("���� �Ҵ���� �ֽ��ϴ�. '��'�� Ŭ���Ͻø� ���۰� �Բ� �����˴ϴ�.")){
				location.href='/btboard/pwCheckFrom.do?board_seq_num=${board_seq_num}&currentPage=${currentPage}&requestType=1';
			}
		}
		
		//�Ҵ�� �Է� 250byte ���ڼ�����
		function sub_check_byte(frm) {
			var ari_max = 250; // limit ���� ���ڼ�
			var ls_str = frm.replay_content.value; // ���� val
			var li_str_len = ls_str.length; // ��ü���� 

			// �����ʱ�ȭ 
			var li_max = ari_max; // ������ ���ڼ� ũ�� 
			var i = 0; // for���� ��� 
			var li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
			var li_len = 0; // substring�ϱ� ���ؼ� ��� 
			var ls_one_char = ""; // �ѱ��ھ� �˻��Ѵ� 
			var ls_str2 = ""; // ���ڼ��� �ʰ��ϸ� �����Ҽ� ������������ �����ش�. 

			for (i = 0; i < li_str_len; i++) {
				// �ѱ������� 
				ls_one_char = ls_str.charAt(i);

				// �ѱ��̸� 2�� ���Ѵ�. 
				if (escape(ls_one_char).length > 4) {
					li_byte += 2;
				} else {
					li_byte++;
				}
				// ��ü ũ�Ⱑ li_max�� ���������� 
				if (li_byte <= li_max) {
					li_len = i + 1;
				}
			}
			frm.subbyte.value = li_byte;

			// ��ü���̸� �ʰ��ϸ� 
			if (li_byte > li_max) {
				alert(ari_max + "Byte�� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.replay_content.value = ls_str2;
				frm.subbyte.value = li_max;
			}
			frm.replay_content.focus();
		}//.���ڼ��� �����ְ� �����ϴ� ��Ʈ�� ���� 
		
		
		
		//�Ҵ�ۼ��� 250byte ���ڼ�����
		function sub_check_byte1(frm) {
			var ari_max = 250; // limit ���� ���ڼ�
			var ls_str = frm.replay_list_content1.value; // ���� val
			var li_str_len = ls_str.length; // ��ü���� 

			// �����ʱ�ȭ 
			var li_max = ari_max; // ������ ���ڼ� ũ�� 
			var i = 0; // for���� ��� 
			var li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
			var li_len = 0; // substring�ϱ� ���ؼ� ��� 
			var ls_one_char = ""; // �ѱ��ھ� �˻��Ѵ� 
			var ls_str2 = ""; // ���ڼ��� �ʰ��ϸ� �����Ҽ� ������������ �����ش�. 

			for (i = 0; i < li_str_len; i++) {
				// �ѱ������� 
				ls_one_char = ls_str.charAt(i);

				// �ѱ��̸� 2�� ���Ѵ�. 
				if (escape(ls_one_char).length > 4) {
					li_byte += 2;
				} else {
					li_byte++;
				}
				// ��ü ũ�Ⱑ li_max�� ���������� 
				if (li_byte <= li_max) {
					li_len = i + 1;
				}
			}
			frm.subbyte1.value = li_byte;

			// ��ü���̸� �ʰ��ϸ� 
			if (li_byte > li_max) {
				alert(ari_max + "Byte�� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.replay_list_content1.value = ls_str2;
				frm.subbyte1.value = li_max;
			}
			frm.replay_list_content1.focus();
		}//.���ڼ��� �����ְ� �����ϴ� ��Ʈ�� ����
		
		
		
		//�Ҵ�� �Է�
		function insertReplay(form) {
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_writer = document.getElementById("replay_writer").value; 
			var replay_content = document.getElementById("replay_content").value;
			var replay_password = document.getElementById("replay_password").value;
			var searchingNow = ${searchingNow};
			
			inputForm=eval("document.readBoardForm");
			
			if(!replay_password){
				alert("��й�ȣ�� �Է����ּ���.");
				readBoardForm.replay_password.focus();
				return false;
			}
			
			if(!replay_writer){
				alert("�ۼ��ڸ� �Է����ּ���.");
				readBoardForm.replay_writer.focus();
				return false;
			}
	
			var url = "/btboard/insertReplay.do?replay_writer="+replay_writer+"&replay_password="+replay_password+"&replay_content="+replay_content+"&board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&requestType=1"+"&searchingNow="+searchingNow;
			location.href=url;
		}
		
		
		
		//�Ҵ�� ���� ��û
		function updateRequesting(form, re_seq){
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_seq_num = re_seq;
			var searchingNow = ${searchingNow};
			
			
			if(confirm("���� �Ͻðڽ��ϱ�?")){
				location.href="/btboard/updateReplayFrom.do?replay_seq_num="+replay_seq_num+"&board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&searchingNow="+searchingNow;
			}
		}
		
		
		//�Ҵ�� ���� �ϱ�
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
				alert("��й�ȣ�� �Է����ּ���.");
				readBoardForm.check_replay_password.focus();
				return false;
			}
			if(replay_password != replay_pw){
				alert("��й�ȣ�� �ٽ� Ȯ�����ּ���");
				readBoardForm.check_replay_password.focus();
				return false;
			}
			if(replay_password == replay_pw){ //��й�ȣ�� ������
				var url = "/btboard/updateReplay.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&replay_seq_num="+replay_seq_num+"&replay_content="+replay_content+"&searchingNow="+searchingNow;
				location.href=url;
			}
		}
		
		
		//�Ҵ�� ���� ����ϱ�
		function cancelUpdateReplay(form) {
			if(confirm("������ ��� �Ͻðڽ��ϱ�?")){
				history.go(-1);
			}
		}
		
		
		//�Ҵ�� ����
		function deleteReplay(form, re_seq){
			var board_seq_num = document.getElementById("board_seq_num").value;
			var currentPage = document.getElementById("currentPage").value;
			var replay_seq_num = re_seq;
			
			if(confirm("���� �Ͻðڽ��ϱ�?")){
				location.href="/btboard/pwCheckFrom.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&replay_seq_num="+replay_seq_num+"&requestType=2";
			}
		}
		
	</script>
</head>

<h1 align="center">�� �б�</h1>

<body>
	
	<form name="readBoardForm" action="/btboard/updateBoardForm.do" method="post">
		<table border="1" align="center" width="700" bordercolor="#E7E7E7">
			<tr>
				<td width="100" height="8" bgcolor="#E7E7E7"><b>����</b></td>
				<td width="600" height="8" colspan="5">${resultClass.board_subject}</td>
			</tr>
			
			<tr>
				<!-- submit �ʿ䰪 hiddenó�� -->
	 			<input type="hidden" name="board_seq_num" id="board_seq_num" value="${board_seq_num}" />
	 			<input type="hidden" name="currentPage" id="currentPage" value="${currentPage}" />
	 			
				<td width="70" height="8" bgcolor="#E7E7E7"><b>�۹�ȣ</b></td>
				<td width="70" height="8">${resultClass.board_seq_num}</td>

				<td width="70" height="8" bgcolor="#E7E7E7"><b>�����</b></td>
				<td width="70" height="8">${resultClass.board_writer}</td>
				
				<td width="70" height="8" bgcolor="#E7E7E7"><b>��ȸ��</b></td>
				<td width="70" height="8">${resultClass.board_readcnt} <br/>
				</td>
			</tr>
			
			<tr>
				<td width="70" height="300" bgcolor="#E7E7E7"><b>����</b></td>
				<td colspan="5" width="450">
					<pre><textarea cols="90" rows="20" name="board_content" maxlength="300" readonly="readonly" style="border:0px">${resultClass.board_content}</textarea></pre> 
				</td>
			</tr>
			
			<tr>
		 		<td colspan="6" align="right">
		 			<input name="submit" type="submit"  value="����" />
		 			<!-- �Ҵ���� ���� ��� -->
		 			<c:if test="${total == 0}">
			 			<input  type="button" name="delete"  value="����" onClick="deletes();" />
			 		</c:if>
			 		<!-- �Ҵ���� �ִ� ��� -->
			 		<c:if test="${total != 0}">
			 			<input  type="button" name="delete"  value="����" onClick="deletes1();" />
			 		</c:if>
			 		
			 		<input  type="button" name="boardR"  value="��� ����" onClick="javascript:location.href='/btboard/insertRBoardForm.do?board_seq_num=${resultClass.board_seq_num}&board_group=${resultClass.board_group}&board_relevel=${resultClass.board_relevel}&board_restep=${resultClass.board_restep}'" />
					
					
					
					<!-- ��ü�ۿ��� read.jsp ���Խÿ� --> 
					<c:if test="${searchingNow == 0}">
						<input  type="button" name="list"  value="��� ����" onClick="javascript:location.href='/btboard/listBoard.do?currentPage=${currentPage}'" />
					</c:if>
					<!-- �˻��� read.jsp ���Խÿ� --> 
					<c:if test="${searchingNow == 1}">
						<input  type="button" name="list"  value="��� ����" onClick="javascript:location.href='/btboard/listSearchBoard.do?searchType=${searchType}&userinput=${userinput}&currentPage=${currentPage}'" />
					</c:if>
		 		</td>
		 	</tr>
		 	
		 	
		 	<!-- �Ҵ���Է� -->
		 	<tr>
		 		<td colspan="6" align="left" bgcolor="#E7E7E7">
		 			<b>����Է�</b>
		 		</td>
		 	</tr>
		 	<tr>
		 		<td colspan="6" align="right">
		 			<textarea cols="100" rows="3" name="replay_content" id="replay_content" class=textarea onKeyDown="sub_check_byte(this.form);" onkeyup="sub_check_byte(this.form);"></textarea>
		 			<br/>
		 			�ۼ��� : <input type="text" name="replay_writer" id="replay_writer" /> 
		 			��й�ȣ : <input type="text" name="replay_password" id="replay_password" />
		 			
					<input  type="button" name="replay"  value="����Է�" onclick="insertReplay(this.form)"/>
					
					<!-- ����Ʈ�� üũ ���� -->
					<input type="hidden" name="subbyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" />
		 		</td>
		 	</tr>
		 	<!-- .�Ҵ���Է� ���� -->
		 	
		 	
		 	
		 	<!-- �Ҵ�� ����Ʈ -->
		 	<tr>
		 		<td colspan="6" align="left" bgcolor="#E7E7E7">
		 			<b>��۸��</b>
		 		</td>
		 	</tr>
		 	
		 	<c:forEach var="list" items="${list}">
		 	<tr>
		 		<td colspan="2" align="left">
		 			<b>�ۼ���</b> </br> ${list.replay_writer}
		 			<input type="hidden" name="replay_seq_num" id="replay_seq_num" value="${list.replay_seq_num}" />
		 		</td>
		 		
		 		<!-- �Ҵ�� �Ϲ� ����Ʈ -->
		 		<c:if test="${updating  == 0}">
			 		<td colspan="2" align="left">
			 			<b>����</b> </br> 
		 				<textarea cols="60" rows="2" name="replay_list_content" id="replay_list_content" readonly="readonly" style="border:0px">${list.replay_content}</textarea>
			 		</td>
			 		<td colspan="1" align="center">
			 			<input  type="button" name="updateR"  value="����" onclick="updateRequesting(this.form, '${list.replay_seq_num}')"/></br>
			 			<input  type="button" name="deleteR"  value="����" onClick="deleteReplay(this.form, '${list.replay_seq_num}');" />
			 		</td>
		 		</c:if>
		 		<!--. �Ҵ�� �Ϲ� ����Ʈ ���� -->
		 		
		 		
		 		<!-- �Ҵ�� ���� ��û�� ��ȯ�� ����Ʈ -->
		 		<c:if test="${updating  == 1}">
		 			
					<!-- ������û�� ���ڵ� -->
		 			<c:if test="${list.replay_isUpdating==1}">
				 		<td colspan="2" align="left">
				 			<b>����</b> </br> 
			 				<textarea cols="60" rows="2" name="replay_list_content1" id="replay_list_content1" class=textarea onKeyDown="sub_check_byte1(this.form);" onkeyup="sub_check_byte1(this.form);">${list.replay_content}</textarea> <br/>
			 				
			 				<!-- ����Ʈ�� üũ ���� -->
							<input type="hidden" name="subbyte1" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" />
			 				�ۼ��� : ${list.replay_writer} &nbsp;
			 				��й�ȣ : 
			 				<!-- ����� ��й�ȣ Ȯ�ο� input�� -->
			 				<input type="text" name="check_replay_password" id="check_replay_password"/>
			 				
			 				<!-- ������ �� ������й�ȣ -->
			 				<input type="hidden" name="replay_seq" id="replay_seq" value="${list.replay_seq_num}" />
			 				<input type="hidden" name="replay_pw" id="replay_pw" value="${list.replay_password}" />
				 		</td>
				 		<td colspan="1" align="center">
				 			<%-- 
				 			<input type="hidden" name="replay_seq_num" id="replay_seq_num" value="${list.replay_seq_num}" />
				 			 --%>
				 			<input type="hidden" name="searchingNow" id="searchingNow" value="${searchingNow}" />
				 			
				 			<input  type="button" name="updateRnow"  value="�Ϸ�" onclick="updateReplay(this.form)"/></br>
				 			<input  type="button" name="cancelU"  value="���" onClick="cancelUpdateReplay(this.form);" />
				 		</td>
				 		
			 		</c:if>
			 		
			 		<!-- ������û�� ������ ���� ���ڵ� -->
			 		<c:if test="${list.replay_isUpdating==0}">
			 			<td colspan="2" align="left">
				 			<b>����</b> </br> 
			 				<textarea cols="60" rows="2" name="replay_list_content" id="replay_list_content" readonly="readonly" style="border:0px">${list.replay_content}</textarea>
				 		</td>
				 		<td colspan="1" align="center">
				 			<input  type="button" name="updateR"  value="����" onclick="updateRequesting(this.form, '${list.replay_seq_num}')"/></br>
				 			<input  type="button" name="deleteR"  value="����" onClick="deleteReplay(this.form, '${list.replay_seq_num}');" />
				 		</td>
			 		</c:if>
			 		
		 		</c:if>
		 		<!--. �Ҵ�� ���� ����Ʈ ���� -->
		 		
		 		
		 		<td colspan="1" align="left">
		 			<b>�ۼ���</b> </br> 
		 			<fmt:formatDate value="${list.replay_reg_date}" pattern="yyyy.MM.dd HH:mm:ss"/>
		 		</td>
		 	</tr>
		 	</c:forEach>
		 	
		 	
		 	<c:if test="${total == 0}">
			<tr>
				<td colspan="6" align="center">
					<pre>��ϵ� �Խù��� �����ϴ�.</pre>
				</td>
			</tr>
			</c:if>
		 	<!-- .���ø���Ʈ ���� -->
		 	
		 	<tr>
		 		<td colspan="6" width="700" height="8" align="center">
		 			<!-- �������¡ -->
					<div id="align">
						<br/>${pagingHtml}
					</div>
					<!-- .�������¡ ���� -->
		 		</td>
		 	</tr>
		 	
		</table>
	</form>
</body>
</html>