package board.controller;


import java.io.IOException;
import java.io.Reader;
import java.net.InetAddress;
import java.util.Calendar;

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
public class InsertBoard {
	//insert
	private BoardDTO paramClass = new BoardDTO();
	private ReplayDTO paramClass1 = new ReplayDTO();
	
	//게시판 댓글 및 소댓글
	private int board_seq_num;
	private int board_group;
	private int board_relevel;
	private int board_restep;
	private int currentPage;
	private int searchingNow;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//연결
	public InsertBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	
	//새글 쓰기 폼
	@RequestMapping("/insertBoardForm.do")
	public String insertBoardForm(HttpServletRequest request) throws Exception{
		
		return "/view/board/insertBoard.jsp";
	}
	
	
	//댓글 쓰기 폼
	@RequestMapping("/insertRBoardForm.do")
	public String insertRBoardForm(HttpServletRequest request) throws Exception{
		
		int board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		int board_group = Integer.parseInt(request.getParameter("board_group"));
		int board_relevel = Integer.parseInt(request.getParameter("board_relevel"));
		int board_restep = Integer.parseInt(request.getParameter("board_restep"));
		
		request.setAttribute("board_seq_num", board_seq_num);
		request.setAttribute("board_group", board_group);
		request.setAttribute("board_relevel", board_relevel);
		request.setAttribute("board_restep", board_restep);
		
		return "/view/board/insertRBoard.jsp";
	}
	
	
	
	
	//새글 등록
	@RequestMapping("/insertBoard.do")
	public String insertBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//사용자가 입력한 values
		String board_subject = request.getParameter("board_subject");
		String board_content = request.getParameter("board_content");
		String board_writer = request.getParameter("board_writer");
		String board_password = request.getParameter("board_password");

		//새글 등록시
		board_relevel = 0;
		board_restep = 0;
		
		//사용자가 입력한 값을 DTO에 set
		paramClass.setBoard_subject(board_subject);
		paramClass.setBoard_content(board_content);
		paramClass.setBoard_writer(board_writer);
		paramClass.setBoard_reg_date(today.getTime());
		paramClass.setBoard_relevel(board_relevel);
		paramClass.setBoard_restep(board_restep);
		paramClass.setBoard_password(board_password);
		
		//insert
		sqlMapper.insert("Board.insertBoard", paramClass);
		
		return  "redirect:/listBoard.do"; // list로 redirect
	}
	
	//답글 등록
	@RequestMapping("/insertRBoard.do")
	public String insertRBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//사용자가 입력한 values
		String board_subject = request.getParameter("board_subject");
		String board_content = request.getParameter("board_content");
		String board_writer = request.getParameter("board_writer");
		String board_password = request.getParameter("board_password");

		//답글 등록시 // 호출한 페이지의 히든값
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		board_group = Integer.parseInt(request.getParameter("board_group"));   //호출페이지의 그룹을 그대로 넣는다.
		board_relevel = Integer.parseInt(request.getParameter("board_relevel"));
		board_restep = Integer.parseInt(request.getParameter("board_restep"));
		
		
		//사용자가 입력한 값을 DTO에 set
		paramClass.setBoard_subject(board_subject);
		paramClass.setBoard_content(board_content);
		paramClass.setBoard_writer(board_writer);
		paramClass.setBoard_reg_date(today.getTime());
		paramClass.setBoard_group(board_group); // 호출페이지의 그룹을 그대로 넣음
		paramClass.setBoard_relevel(board_relevel+1); //호출페이지 relevel 의 +1 값  // 0 새글/ 1 새글의 답글 //
		paramClass.setBoard_restep(board_restep+1); //호출페이지 restep 의 +1 값
		paramClass.setBoard_password(board_password);
		
		//update // insert 하기 전에 지금 insert될 레코드를 위해 
		sqlMapper.update("Board.updateBoardRestep", paramClass); // +1된 restep의 값을 넣기전에, 같은 그룹내에 지금들어갈 값 이상되는것들은 모두 +1 가중시킨다.
		
		//insert // 이제 insert한다.
		sqlMapper.insert("Board.insertRBoard", paramClass);
		
		return  "redirect:/listBoard.do"; // list로 redirect
	}
	
	//소댓글 등록
	@RequestMapping("/insertReplay.do")
	public String insertReplay(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//사용자가 입력한 values
		String replay_writer = request.getParameter("replay_writer");
		String replay_password = request.getParameter("replay_password");
		String replay_content = request.getParameter("replay_content");
		searchingNow = Integer.parseInt(request.getParameter("searchingNow"));
		
		
		//insert 완료시 호출 페이지로 돌아가기 위한 값
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
		//사용자가 입력한 값을 DTO에 set
		paramClass1.setReplay_board_seq_num(board_seq_num);
		paramClass1.setReplay_writer(replay_writer);
		paramClass1.setReplay_password(replay_password);
		paramClass1.setReplay_content(replay_content);
		paramClass1.setReplay_reg_date(today.getTime());
		
		//insert // 이제 insert한다.
		sqlMapper.insert("Replay.insertReplay", paramClass1);
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&searchingNow="+searchingNow; // 호출한 readBoard로 redirect
	}
	
	
	
} //.end of class
