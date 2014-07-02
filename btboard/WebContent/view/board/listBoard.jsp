<%@ page language="java" contentType="text/html; charset=euc-kr"
	pageEncoding="euc-kr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>BT게시판</title>
	<style>
    #align {  
        width:100%;  
        height:100px;
        text-align:center;  
    }
    
    A:link    {color:blue;text-decoration:none;} /* 아직 방문하지 않은경우 */
	A:visited {color:blue; text-decoration:none; } /* 한번 이상 방문한 링크 처리 */
	A:active  {color:blue; text-decoration:none; }/* 마우스로 클릭하는 순간 */
	A:hover  {color:blue; text-decoration:none; } /* 마우스 링크 위 올려 놓았을때 */
	
    </style>

    
    <script language="javascript">
		//검색어 null 유효성 검사	
		function checkIt(){
			inputForm=eval("document.searchForm");
			
			if(!searchForm.userinput.value){
				alert("검색어를 기입해주세요.");
				inputForm.userinput.focus();
				return false;
			}
		}
		
		//검색어제한 글자수 제한 스크립트
		function CheckStrLen(maxChars, theField) {
			var temp; //들어오는 문자값.
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
						alert("내용은 영문 " + (maxChars * 2) + "자 한글 " + maxChars
								+ "자 까지 입력가능합니다. (공백 및 개행 포함)");
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

<h1 align="center">BT게시판</h1>

<body>
	
	<!-- 게시판 리스트 -->
	
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="5" width="700" align="right">
				<c:if test="${searchingNow == 0}">
					현재 <font color="red"><b>전체 글(${total})</b></font>을 보고 계십니다. <br/>
				</c:if>
				<c:if test="${searchingNow == 1}">
					<input name="stopSearching" type="button"  value="전체 글 보기" onClick="javascript:location.href='/btboard/listBoard.do'" /> <br/>
					현재 "<font size="4" color="green">${tempInput}</font>" 의 <font color="red"><b>검색 글(${totalCount})</b></font>을 보고 계십니다. 
				</c:if>
			</td>
		</tr>
	</table>
	
	<table border="2" align="center" cellpadding="0" cellspacing="0" bordercolor="#B2EBF4">
		<tr>
			<td width="70" align="center" bgcolor="#E7E7E7"><font size="4"><b>글 번호</b></font></td>
			<td width="320" align="center" bgcolor="#E7E7E7"><font size="4"><b>제목</b></font></td>
			<td width="120" align="center" bgcolor="#E7E7E7"><font size="4"><b>작성자</b></font></td>
			<td width="120" align="center" bgcolor="#E7E7E7"><font size="4"><b>작성날짜</b></font></td>
			<td width="70" align="center" bgcolor="#E7E7E7"><font size="4"><b>조회수</b></font></td>
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
						<!-- 들여쓰기 -->
						<c:forEach var="a" begin="0" end="${list.board_relevel}" step="1"> 
						    &nbsp;&nbsp;
						</c:forEach> 
						
						<font color="#0054FF">${list.board_subject}</font>
					</a>
				</td>
				<td align="center">${list.board_writer}</td>
				<td align="center"><fmt:formatDate value="${list.board_reg_date}" pattern="yyyy년MM월dd일 HH:mm:ss"/></td>
				<td align="center">${list.board_readcnt}</td>
			</tr>
		</c:forEach>
		
		<c:if test="${total == 0}">
		<tr>
			<td colspan="5" align="center">
				<pre>등록된 게시물이 없습니다.</pre>
			</td>
		</tr>
		</c:if>
	</table>
	
	<form name="searchForm" action="/btboard/listSearchBoard.do" method="post">
	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr align="right">
			<td width="700" colspan="5" align="right">
				<br/>
				<!-- 검색 입력 필드 -->
				<select name = "searchType"> 
                   <option value = "subject"> 제목</option> 
                   <option value = "content"> 내용</option> 
                   <option value = "writer"> 작성자</option> 
               </select> 
				<input type="text" name="userinput" id="userinput"  onKeyUp="CheckStrLen('200',this);" />
				<input name="submit" type="submit"  value="검색" onClick="return checkIt()" /> 
				<!-- .검색 입력 필드 종료 -->
				
				<input name="insert" type="button"  value="글 쓰기" onClick="javascript:location.href='/btboard/insertBoardForm.do'" /> <br/>
				<font color = "gray" size="2">검색어 글자수 제한은 최대 200자 입니다.</font> <br/>
			</td>
		</tr>
	</table>
	</form>
	<!-- .게시판 리스트 종료 -->
	
	
	<!-- 페이징 -->
	<div id="align">
		<br/>${pagingHtml}
	</div>
	<!-- .페이징종료 -->
	
</body>
</html>
