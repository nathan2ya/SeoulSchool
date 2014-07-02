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
	private BoardDTO paramClass = new BoardDTO(); //����
	private ReplayDTO paramClass1 = new ReplayDTO(); //�Ҵ��
	private List<BoardDTO> list = new ArrayList<BoardDTO>(); //���ۿ� �Ҵ���� �ִ� ���ڵ� ����Ʈ
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//����
	public DeleteBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//���� ����
	@RequestMapping("/deleteBoard.do")
	public String deleteBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		paramClass.setBoard_seq_num(board_seq_num);
		sqlMapper.delete("Board.deleteBoard", paramClass); //���ۻ���
		
		//������ ����� �ִ°�� -> ��� ���� update�ϱ�.
		list = sqlMapper.queryForList("Board.selectReplay", board_seq_num);
		for(int i=0; i<list.size(); i++){
			paramClass.setBoard_seq_num(list.get(i).getBoard_seq_num());
			paramClass.setBoard_subject("[������ ������ ���]"+list.get(i).getBoard_subject());
			sqlMapper.update("Board.updateBoardSubject", paramClass); //�����Ǵ� ������ ���������� ��� ������.
		}

		//�Ҵ�� ��������
		paramClass1.setReplay_board_seq_num(board_seq_num);
		sqlMapper.delete("Replay.deleteBoard", paramClass1); //�Ҵ�ۻ���
		
		return  "redirect:/listBoard.do"; // list�� redirect
	}
	
	//�Ҵ�� ����
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
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage; // ȣ���� readBoard�� redirect
	}
} //.end of class
