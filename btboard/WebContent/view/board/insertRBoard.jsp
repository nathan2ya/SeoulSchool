<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>

<html>
<head>
	<title>��� �Է�</title>
	
	<SCRIPT type="text/javascript">
		//null ��ȿ���˻�
		function checkIt(){
			inputForm=eval("document.insertBoardForm");
		 
			if(!inputForm.board_subject.value){
				alert("������ �Է����ּ���.");
				insertBoardForm.board_subject.focus();
				return false;
			}
			if(!inputForm.board_writer.value){
				alert("�ۼ��ڸ� �Է����ּ���.");
				insertBoardForm.board_writer.focus();
				return false;
			}
			if(!inputForm.board_password.value){
				alert("��й�ȣ�� �Է����ּ���.");
				insertBoardForm.board_password.focus();
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

		
		//���� 4000byte ���ڼ�����
		function check_byte(frm) {
			var ari_max = 4000; // limit ���� ���ڼ�(4000)
			var ls_str = frm.board_content.value; // ���� val
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

<h1 align="center">��� �Է�</h1>

<body onload="check_byte(document.insertRBoardForm); sub_check_byte(document.insertRBoardForm);">

<form name="insertRBoardForm" action="/btboard/insertRBoard.do" method="post" onSubmit="return checkIt()">
	<table border="1" align="center" width="800" bordercolor="#E7E7E7">
		
		<tr>
			<td width="250" height="8" align="center" bgcolor="#E7E7E7"><b>����</b></td>
			<td width="550" height="8" colspan="3">
				<!-- ��ۿ� �ʿ��� hidden �� ���� -->
				<input type="hidden" name="board_seq_num" value="${board_seq_num}" />
				<input type="hidden" name="board_group" value="${board_group}" />
	 			<input type="hidden" name="board_relevel" value="${board_relevel}" />
	 			<input type="hidden" name="board_restep" value="${board_restep}" />
	 			
				<input type="text" name="board_subject" id="board_subject" value="re)" size="70" maxlength="100" onKeyDown="sub_check_byte(this.form);" onkeyup="sub_check_byte(this.form);"/>
				<input type="text" name="subbyte" STYLE="border:0; text-align:right" size="4" readonly="readonly" value="0" /> Byte / <font color="gray" size=2>100Byte</font>
			</td>
		</tr>
		
		<tr>
			<td width="150" height="8" align="center" bgcolor="#E7E7E7"><b>�����</b></td>
			<td width="200" height="8">
				<input type="text" name="board_writer" id="board_writer" size="33" maxlength="10"/>
			</td>
			
			<td width="200" height="8" align="center" bgcolor="#E7E7E7">
				<b>��й�ȣ</b>
			</td>
			<td width="200" height="8">
				<input type="password" name="board_password" id="board_password" size="33" maxlength="8"/>
			</td>
		</tr>
		
		<tr>
			<td width="150" align="center" bgcolor="#E7E7E7">
				<b>����</b>
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
	 			<input name="submit" type="submit"  value="��� ����"/>
				<input name="cancel" type="button"  value="��� ���" onClick="javascript:location.href='/btboard/listBoard.do'" />
	 		</td>
	 	</tr>
	 	
	</table>
</form>


</body>
</html>