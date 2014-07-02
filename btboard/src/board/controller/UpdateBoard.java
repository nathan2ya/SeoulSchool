package board.controller;


import java.io.IOException;
import java.io.Reader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import replay.dto.ReplayDTO;
import board.dto.BoardDTO;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;


@Controller
public class UpdateBoard {
	//update
	private int board_seq_num;
	private int currentPage;
	private int replay_seq_num;
	private String replay_content;
	private int searchingNow;
	private BoardDTO paramClass = new BoardDTO();
	private BoardDTO resultClass = new BoardDTO();
	
	private ReplayDTO paramClass1 = new ReplayDTO();
	private ReplayDTO resultClass1 = new ReplayDTO();
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//연결
	public UpdateBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//글 수정 폼
	@RequestMapping("/updateBoardForm.do")
	public String updateBoardForm(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		//수정에 뿌려줄 레코드1개 select
		resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
	
		
		//textarea 의 개행과 띄어쓰기 처리
		String board_content = resultClass.getBoard_content();
		
		request.setAttribute("board_seq_num", board_seq_num);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("resultClass", resultClass);
		request.setAttribute("board_content", board_content);
		
		return  "/view/board/updateBoard.jsp";
	}
	
	//글 수정
	@RequestMapping("/updateBoard.do")
	public String updateBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		String board_subject = request.getParameter("board_subject");
		String board_content = request.getParameter("board_content");
		
		//업데이트 항목 DTO에 set
		paramClass.setBoard_seq_num(board_seq_num);
		paramClass.setBoard_subject(board_subject);
		paramClass.setBoard_content(board_content);
		
		//항목 update
		sqlMapper.update("Board.updateBoardOne", paramClass);
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage;
	}
	
	
	//소댓글 수정 요청
	@RequestMapping("/updateReplayFrom.do")
	public String updateReplayFrom(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		replay_seq_num = Integer.parseInt(request.getParameter("replay_seq_num"));
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		searchingNow = Integer.parseInt(request.getParameter("searchingNow"));
		
		//수정에 뿌려줄 레코드1개 select
		paramClass1.setReplay_seq_num(replay_seq_num);
		paramClass1.setReplay_board_seq_num(board_seq_num);
		resultClass1 = (ReplayDTO)sqlMapper.queryForObject("Replay.selectReplayOneforUpdate", paramClass1);
		
		//1로 업데이트시키기만 하면됨. //isupdating DTO 만들어야됨.
		sqlMapper.update("Replay.updateIsupdating", replay_seq_num);
		
		request.setAttribute("resultClass1", resultClass1);
		request.setAttribute("searchingNow", searchingNow);
		
		return  "redirect:/readBoard.do?updating=1&board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&resultClass1="+resultClass1+"&searchingNow="+searchingNow;
	}
	
	
	
	//소댓글 수정 요청
	@RequestMapping("/updateReplay.do")
	public String updateReplay(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		replay_seq_num = Integer.parseInt(request.getParameter("replay_seq_num"));
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		replay_content = request.getParameter("replay_content"); //수정될 값
		
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		searchingNow = Integer.parseInt(request.getParameter("searchingNow"));
		
		
		paramClass1.setReplay_seq_num(replay_seq_num);
		paramClass1.setReplay_content(replay_content);
		
		//해당 레코드 업데이트 // isUpdating 항목 다시 0으로 초기화.
		sqlMapper.update("Replay.updateReplayChoosen", paramClass1);
		
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&searchingNow="+searchingNow;
	}
	
	
	
} //.end of class
