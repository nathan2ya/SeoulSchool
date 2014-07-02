package board.controller;


import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import board.dto.BoardDTO;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

import common.PagingAction;


@Controller
public class ListBoard {
	//list
	private BoardDTO paramClass = new BoardDTO();
	private List<BoardDTO> list = new ArrayList<BoardDTO>();
	private List<BoardDTO> list1 = new ArrayList<BoardDTO>();
	private List<BoardDTO> cntList = new ArrayList<BoardDTO>();
	Calendar today = Calendar.getInstance();
	private int searchingNow; // 전체글, 검색글을 판단하여 버튼 출력여부를 결정하는 논리값.
	private String tempInput; // list에 노출 되는 검색어 값
	
	//page
	private int totalCount;// 총 게시물의 수
	private int blockCount;// 한 페이지의 게시물의 수
	private int blockPage;// 한 화면에 보여줄 페이지 수
	private String pagingHtml;// 페이징을 구현한 HTML
	private PagingAction page;// 페이징 클래스
	private String serviceName;// 호출페이지
	private int currentPage; //상품 현재페이지
	private int lastPage;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//연결
	public ListBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//리스트(전체 글)
	@RequestMapping("/listBoard.do")
	public String listBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		// 전체글, 검색글 판단값.
		searchingNow = 0; //0 == 전체글//1 == 검색글//
		
		//list
		//list = sqlMapper.queryForList("Board.selectAll"); //전체글
		list = sqlMapper.queryForList("Board.selectAllrownum"); //정렬된 리스트

		
		//페이지처리
		blockCount = 10;// 한 페이지의 게시물의 수
		blockPage = 5;// 한 화면에 보여줄 페이지 수
		serviceName = "listBoard";// 호출 URI 정의
		totalCount = list.size(); // 전체 글 갯수
		//currentPage 초기화
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage); // pagingAction 객체 생성.
		pagingHtml = page.getPagingHtml().toString(); // 페이지 HTML 생성.

		int lastCount = totalCount; //전체글의 갯수
		
		// 현재 페이지의 마지막 글의 번호가 전체의 마지막 글 번호보다 작으면 lastCount를 +1 번호로 설정.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		
		// 전체 리스트에서 현재 페이지만큼의 리스트만 가져온다.
		list = list.subList(page.getStartCount(), lastCount);
		
		//.페이지처리 종료
		
		
		//제목 15글자 단위로 개행
		String first;
		String second;
		String resultSubject;
		
		for(int i=0; i<list.size(); i++){
			if(list.get(i).getBoard_subject().length() > 18){ //제목이 18글자 이상이면
				//0~19 잘라내기//18로 수정함
				first = list.get(i).getBoard_subject().substring(0, 18);
				
				resultSubject = first + "..."; //"<br/>" + second;
				list.get(i).setBoard_subject(resultSubject);
			}
			
		}
		//.제목 15글자 단위로 개행 종료
		
		
		//마지막 페이지 산출
		lastPage = (int) Math.ceil((double) totalCount / blockCount);
		//리스트size() / 한페이지에 보여줄 게시글 수 = 페이지수(반올림)
		if (lastPage == 0) {
			lastPage = 1;
		}
		// 현재 페이지가 전체 페이지 수보다 크면 전체 페이지 수로 설정
		if (currentPage > lastPage) {
			currentPage = lastPage;
		}
		//.마지막 페이지 산출 종료
		
		
		//새글만 가져옴
		cntList = sqlMapper.queryForList("Board.newList");
		int numberCount = cntList.size(); // 새글의 레코드 총 개수
		
		int number; // 가변 시작 글 넘버
		int cnt=0; // 댓글 카운터변수
		
		if(page.getCurrentPage()==1){ // 시작페이지 일 경우
			number=numberCount-(page.getCurrentPage()-1)*blockCount;
		}else if(page.getCurrentPage()==page.getTotalPage()){ // 마지막페이지 일 경우
			number=numberCount-(page.getCurrentPage()-1)*blockCount+blockCount+1;
		}else{ // 중간페이지 일 경우 //현재페이지 미만의 답글 수를 구함.
			
			int temp = page.getCurrentPage();
			
			for(int i=temp-1; i>0; i--){ // 현재페이지 이전 답글을 체크하기 위해 -1함
				int temp1 = i*blockCount-blockCount; //지금페이지에서 시작 인덱스 값
				int temp2 = i*blockCount; //지금페이지에서 마지막 인덱스 값
				
				list1 = sqlMapper.queryForList("Board.selectAllrownum"); //정렬된 리스트
				list1 = list1.subList(temp1, temp2); // 지금페이지를 시작,마지막 값으로 자름
				
				for(int j=0; j<list1.size(); j++){
					//답글인것만
					if(list1.get(j).getBoard_relevel()>0){
						cnt++;//지금페이지의 답글 개수를 누적시킴
					}
				}
			}
			//기존 계산식에서 -> 최종적으로 현재페이지 이전의 모든페이지의 답글을 더함
			number=(numberCount-(page.getCurrentPage()-1)*blockCount)+cnt;
		}
		
		
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pagingHtml", pagingHtml);
		request.setAttribute("list", list);
		request.setAttribute("number", number); //글넘버 - 가변으로 선정되는 게시글의 숫자
		request.setAttribute("total", totalCount); //모든 게시글 수
		request.setAttribute("lastPage", lastPage); // 마지막 페이지
		request.setAttribute("searchingNow", searchingNow);
		
		return  "/view/board/listBoard.jsp";
	}
	
	
	
	//리스트(검색된 글)
	@RequestMapping("/listSearchBoard.do")
	public String listSearchBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		// 전체글, 검색글 판단값.
		searchingNow = 1; //0 == 전체글//1 == 검색글//
		
		request.setCharacterEncoding("euc-kr");
		
		//사용자가 입력한 값
		String searchType = request.getParameter("searchType"); //검색 종류 // 제목,내용,작성자
		String userinput = request.getParameter("userinput"); //검색어
		
		//검색종류&검색어를 만족하는 레코드 검색
		if(searchType.equals("subject")){
			//제목 검색
			list = sqlMapper.queryForList("Board.selectWithSubject", userinput);
		}else if(searchType.equals("content")){
			//내용 검색
			list = sqlMapper.queryForList("Board.selectWithContent", userinput);
		}else{
			//작성자 검색
			list = sqlMapper.queryForList("Board.selectWithWriter", userinput);
		}
			
		//페이지처리
		blockCount = 10;// 한 페이지의 게시물의 수
		blockPage = 5;// 한 화면에 보여줄 페이지 수
		serviceName = "listSearchBoard";// 호출 URI 정의
		totalCount = list.size(); // 전체 글 갯수
		
		//currentPage 초기화
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage, searchType, userinput); // pagingAction 객체 생성.
		pagingHtml = page.getPagingHtml().toString(); // 페이지 HTML 생성.

		int lastCount = totalCount; // 마지막 레코드 = 개수
		
		
		// 현재 페이지의 마지막 글의 번호가 전체의 마지막 글 번호보다 작으면 lastCount를 +1 번호로 설정.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		
		// 전체 리스트에서 현재 페이지만큼의 리스트만 가져온다.
		list = list.subList(page.getStartCount(), lastCount);
		//.페이지처리 종료
		
		
		//검색어 노출
		if(userinput.length()>8){ // 사용자 입력값이 8자 이상일 경우
			tempInput = userinput.substring(0, 8) + "..."; // 8까지 + ... 추가
		}else{ // 이하일경우
			tempInput = userinput;
		}
		
		//리스트 글번호 가변 계산
		int number=totalCount-(page.getCurrentPage()-1)*blockCount;
				
		request.setAttribute("number", number);	
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pagingHtml", pagingHtml);
		request.setAttribute("list", list);
		request.setAttribute("searchingNow", searchingNow);
		
		request.setAttribute("searchType", searchType);
		request.setAttribute("userinput", userinput);
		
		request.setAttribute("tempInput", tempInput);
		request.setAttribute("totalCount", totalCount);
		
		return  "/view/board/listBoard.jsp";
	}
	
}
