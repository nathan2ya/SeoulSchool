package board.controller;


import java.io.IOException;
import java.io.Reader;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import replay.dto.ReplayDTO;
import board.dto.BoardDTO;
import board.dto.ReadcntDTO;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

import common.PagingAction;


@Controller
public class GetBoard {
	//insert
	private BoardDTO paramClass = new BoardDTO();
	private BoardDTO resultClass = new BoardDTO();
	private ReadcntDTO readcntClass = new ReadcntDTO();
	private List<ReplayDTO> list = new ArrayList<ReplayDTO>();
	private int board_seq_num;
	private String searchType;
	private String userinput;
	private int searchingNow;
	
	//page
	private int totalCount;// 총 게시물의 수
	private int blockCount;// 한 페이지의 게시물의 수
	private int blockPage;// 한 화면에 보여줄 페이지 수
	private String pagingHtml;// 페이징을 구현한 HTML
	private PagingAction page;// 페이징 클래스
	private String serviceName;// 호출페이지
	
	private int currentPage;
	private int r_currentPage;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	
	//연결
	public GetBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//글 보기
	@RequestMapping("/readBoard.do")
	public String readBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		
		if(null != request.getParameter("searchType") && null != request.getParameter("userinput")){
			searchType = request.getParameter("searchType");
			userinput = request.getParameter("userinput");
			request.setAttribute("searchType", searchType);
			request.setAttribute("userinput", userinput);
			request.setAttribute("searchingNow", 1);
		}else{
			request.setAttribute("searchType", 0);
			request.setAttribute("userinput", 0);
			request.setAttribute("searchingNow", 0);
		}
		
		
		//해당글번호의 레코드 get(readBoard.jsp)
		resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
		
		
		/*
		//내용에서 개행과 공백 replace처리 - 추후 적용하기 위해서 주석처리함.
		board_content = board_content.replaceAll("<br/>", "\r\n");  //개행
		board_content = board_content.replaceAll("&nbsp;", "\u0020");  // 스페이스바
		*/
		
		
		//글 조회수 +1
		String ip_address = InetAddress.getLocalHost().getHostAddress(); // 접속자 ip
		String seq_num = Integer.toString(resultClass.getBoard_seq_num()); // 접속 글번호
		Calendar date = Calendar.getInstance();
		SimpleDateFormat sformat = new SimpleDateFormat("yyyy-MM-dd");
		String today = sformat.format(date.getTime()); //오늘날짜//하루가 지나면 같은 사용자가 조회수를 증가 시킬 수 있기위함.
		//최종 DB Insert parameter
		String parameter = ip_address+seq_num+today; //ip주소+글번호+오늘날짜
		
		//글이 있는지 없는지 count
		Integer count = (Integer) sqlMapper.queryForObject("Board.selectCountForReadCnt", parameter);
		
		if(count==0){ //레코드가 존재하지 않을 경우
			//insert // readcnt_table에 접속 정보 기록
			sqlMapper.insert("Board.insertReadCnt", parameter);
			//update 조회수 +1 // btboard에 조회수+=1
			paramClass.setBoard_seq_num(board_seq_num);
			sqlMapper.update("Board.updateBoardReadcnt", paramClass);
		}
		//.글 조회수 +1 종료
		
		
		
		
		//해당글번호의 레코드 get(readBoard.jsp)
		resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
		
		
		
		//소댓글 리스트
		list = sqlMapper.queryForList("Replay.selectAll", board_seq_num);
		
		
		
		//소댓글의 페이지
		blockCount = 10;// 한 페이지의 게시물의 수
		blockPage = 5;// 한 화면에 보여줄 페이지 수
		serviceName = "readBoard";// 호출 URI 정의
		totalCount = list.size(); // 전체 글 갯수
		
		//r_currentPage 소댓글 현재페이지 초기화
		if(null == request.getParameter("r_currentPage")){
			r_currentPage = 1;
		}else{
			r_currentPage = Integer.parseInt(request.getParameter("r_currentPage"));
		}
		
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage, board_seq_num, r_currentPage); // pagingAction 객체 생성.
		pagingHtml = page.getPagingHtml().toString(); // 페이지 HTML 생성.

		int lastCount = totalCount; //전체글의 갯수
		
		// 현재 페이지의 마지막 글의 번호가 전체의 마지막 글 번호보다 작으면 lastCount를 +1 번호로 설정.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		// 전체 리스트에서 현재 페이지만큼의 리스트만 가져온다.
		list = list.subList(page.getStartCount(), lastCount);
		
		//.소댓글의 페이지 종료
		
		
		//댓글 수정
		if(request.getParameter("updating")==null){
			request.setAttribute("updating", 0); 
		}else{
			request.setAttribute("updating", 1); 
		}
		
		
		//set
		request.setAttribute("resultClass", resultClass); // 해당 글의 레코드 컬럼 접근
        request.setAttribute("board_seq_num", board_seq_num); //이하 답글
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("list", list); // 소댓글 리스트
        request.setAttribute("total", list.size()); // 소댓글 레코드 개수
        request.setAttribute("pagingHtml", pagingHtml); //소댓글 페이지
        
		return  "/view/board/readBoard.jsp";
	}
} //.end of class
