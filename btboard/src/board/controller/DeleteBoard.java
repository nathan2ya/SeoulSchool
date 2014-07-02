package board.controller;


import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

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
public class DeleteBoard {
	//delete
	private int board_seq_num;
	private int currentPage;
	private int replay_seq_num;
	private BoardDTO paramClass = new BoardDTO(); //원글
	private ReplayDTO paramClass1 = new ReplayDTO(); //소댓글
	private List<BoardDTO> list = new ArrayList<BoardDTO>(); //원글에 소댓글이 있는 레코드 리스트
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//연결
	public DeleteBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//원글 삭제
	@RequestMapping("/deleteBoard.do")
	public String deleteBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		paramClass.setBoard_seq_num(board_seq_num);
		sqlMapper.delete("Board.deleteBoard", paramClass); //원글삭제
		
		//원글의 답글이 있는경우 -> 답글 제목 update하기.
		list = sqlMapper.queryForList("Board.selectReplay", board_seq_num);
		for(int i=0; i<list.size(); i++){
			paramClass.setBoard_seq_num(list.get(i).getBoard_seq_num());
			paramClass.setBoard_subject("[원글이 삭제된 답글]"+list.get(i).getBoard_subject());
			sqlMapper.update("Board.updateBoardSubject", paramClass); //삭제되는 원글의 답글제목들을 모두 변경함.
		}

		//소댓글 삭제시작
		paramClass1.setReplay_board_seq_num(board_seq_num);
		sqlMapper.delete("Replay.deleteBoard", paramClass1); //소댓글삭제
		
		return  "redirect:/listBoard.do"; // list로 redirect
	}
	
	//소댓글 삭제
	@RequestMapping("/deleteReplay.do")
	public String deleteRepaly(HttpServletRequest request, HttpServletResponse response) throws Exception{
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		replay_seq_num = Integer.parseInt(request.getParameter("replay_seq_num"));
		
		paramClass1.setReplay_seq_num(replay_seq_num);
		sqlMapper.delete("Replay.deleteReplay", paramClass1);
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage; // 호출한 readBoard로 redirect
	}
} //.end of class
