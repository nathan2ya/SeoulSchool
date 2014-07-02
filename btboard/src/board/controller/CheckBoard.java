package board.controller;


import java.io.IOException;
import java.io.Reader;

import javax.servlet.http.HttpServletRequest;

import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import replay.dto.ReplayDTO;
import board.dto.BoardDTO;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;


@Controller
public class CheckBoard { 
	private int board_seq_num;
	private int currentPage;
	private String userInput;
	private BoardDTO resultClass = new BoardDTO();
	private ReplayDTO resultClass1 = new ReplayDTO();
	private String path;
	private int requestType;
	private int replay_seq_num;
	
	//��й�ȣ
	private String pw;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//����
	public CheckBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//���� ��й�ȣ üũ ��
	@RequestMapping("/pwCheckFrom.do")
	public String pwCheckFrom(HttpServletRequest request) throws Exception{
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		requestType = Integer.parseInt(request.getParameter("requestType")); //���� ������û = 1 // �Ҵ�� ������û = 2
		
		
		if(requestType==1){ // ���� ���� ��û �� ���
			//�ش� �� ���ڵ��� ��й�ȣ �����͸� ������.
			resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
			pw = resultClass.getBoard_password();
		}else{ // �Ҵ�� ���� ��û �� ���
			replay_seq_num = Integer.parseInt(request.getParameter("replay_seq_num")); //�Ҵ���� �������ѹ�
			resultClass1 = (ReplayDTO)sqlMapper.queryForObject("Replay.selectReplayOne", replay_seq_num);
			pw = resultClass1.getReplay_password();
		}
		
		
		request.setAttribute("pw", pw); //�̱��� ��й�ȣ�� checkPassword.jsp �� �ѱ�
		request.setAttribute("board_seq_num", board_seq_num);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("replay_seq_num", replay_seq_num);
		request.setAttribute("requestType", requestType); 
		
		return  "/view/board/checkPassword.jsp";
	}
	
	
} //.end of class
