<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>

<html>
<head>
	<title>�� ����</title>
	
	<SCRIPT type="text/javascript">
		//null ��ȿ���˻�
		function checkIt(){
			inputForm=eval("document.updateBoardForm");
			var password = ${resultClass.board_password}
		 
			if(!inputForm.board_subject.value){
				alert("������ �Է����ּ���.");
				updateBoardForm.board_subject.focus();
				return false;
			}
			if(!inputForm.board_password.value){
				alert("��й�ȣ�� �Է����ּ���.");
				updateBoardForm.board_password.focus();
				return false;
			}
			if(inputForm.board_password.value != password){
				alert("��й�ȣ�� Ȯ�����ּ���");
				updateBoardForm.board_password.focus();
				return false;
			}
		}
		
		
		//���� 4000byte ���ڼ�����
		function sub_check_byte(frm) {
			var ari_max = 100; // limit ���� ���ڼ�(100)
			var ls_str = frm.board_subject.value; // ���� val
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
				frm.board_subject.value = ls_str2;
				frm.subbyte.value = li_max;
			}
			frm.board_subject.focus();
		}//.���ڼ��� �����ְ� �����ϴ� ��Ʈ�� ����   
		
		
		
		//���ڼ�����(����)
		function check_byte(frm) {
			var ari_max = 4000; // limit ���� ���ڼ�(4000)
			var ls_str = frm.board_content.value; // �̺�Ʈ�� �Ͼ ��Ʈ���� value �� 
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
			frm.messagebyte.value = li_byte;

			// ��ü���̸� �ʰ��ϸ� 
			if (li_byte > li_max) {
				alert(ari_max + "Byte�� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. ");
				ls_str2 = ls_str.substr(0, li_len);
				frm.board_content.value = ls_str2;
				frm.messagebyte.value = li_max;
			}
			frm.board_content.focus();
		}//.���ڼ��� �����ְ� �����ϴ� ��Ʈ�� ����
	</script>
</head>

<h1 align="center">�� �Է�</h1>

<body onload="check_byte(document.updateBoardForm); sub_check_byte(document.updateBoardForm);">

<form name="updateBoardForm" action="/btboard/updateBoard.do" method="post" onSubmit="return checkIt()">
	<table border="1" align="center" width="700">
		<tr>
			<td width="100" height="8" align="center" bgcolor="#E7E7E7"><b>����</b></td>
			<td width="600" height="8" colspan="5">
				<!-- submit �ʿ䰪 hiddenó�� -->
	 			<input type="hidden" name="board_seq_num" value="${board_seq_num}" />
	 			<input type="hidden" name="currentPage" value="${currentPage}" />
	 			<!-- .hidden�� ó�� ���� -->
	 			
				<input type="text" name="board_subject" id="board_subject" value="${resultClass.board_subject}" size="60" maxlength="100" onKeyDown="sub_check_byte(this.form);" onkeyup="sub_check_byte(this.form);"/>
				<input type="text" name="subbyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" /> Byte / <font color="gray" size=2>100Byte</font>
			</td>
		</tr>
		
		<tr>
			<td width="100" height="8" align="center" bgcolor="#E7E7E7"><b>�����</b></td>
			<td width="600" height="8" colspan="5">
				${resultClass.board_writer}
			</td>
		</tr>
		
		<tr>
			<td colspan="6" align="left">
				<b>����</b> <br/>
				<font size="2" align="center" color="gray"> ������ �ִ� 4000 byte(�ѱ� 2000��, ���� 4000��) ���� �ۼ����� �մϴ�.</font> <BR/>
			</td>
		</tr>
		
		<tr>
			<td colspan="6" align="center">
				<pre><textarea cols="105" rows="10" name="board_content" class=textarea onKeyDown="check_byte(this.form);" onkeyup="check_byte(this.form);">${board_content}</textarea></pre>
			</td>
		</tr>
		
		<tr>
			<td align="right" colspan="6">
				<input type="text" name="messagebyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" /> Byte / <font color="red" size=2>4000Byte</font>
			</td>
		</tr>
		
		<tr>
			<td colspan="6">
				<b>��й�ȣ</b> <input type="password" name="board_password" maxlength="8"/>
			</td>
		</tr>
		
	 	<tr>
	 		<td colspan="2" align="right">
	 			<input name="submit" type="submit"  value="�� ����"/>
				<input name="cancel" type="button"  value="��� ���" onClick="javascript:location.href='/btboard/listBoard.do'" />
	 		</td>
	 	</tr>
	 	
	</table>
</form>


</body>
</html>