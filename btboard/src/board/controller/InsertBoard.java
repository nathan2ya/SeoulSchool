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
	
	//�Խ��� ��� �� �Ҵ��
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
	
	//����
	public InsertBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	
	//���� ���� ��
	@RequestMapping("/insertBoardForm.do")
	public String insertBoardForm(HttpServletRequest request) throws Exception{
		
		return "/view/board/insertBoard.jsp";
	}
	
	
	//��� ���� ��
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
	
	
	
	
	//���� ���
	@RequestMapping("/insertBoard.do")
	public String insertBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//����ڰ� �Է��� values
		String board_subject = request.getParameter("board_subject");
		String board_content = request.getParameter("board_content");
		String board_writer = request.getParameter("board_writer");
		String board_password = request.getParameter("board_password");

		//���� ��Ͻ�
		board_relevel = 0;
		board_restep = 0;
		
		//����ڰ� �Է��� ���� DTO�� set
		paramClass.setBoard_subject(board_subject);
		paramClass.setBoard_content(board_content);
		paramClass.setBoard_writer(board_writer);
		paramClass.setBoard_reg_date(today.getTime());
		paramClass.setBoard_relevel(board_relevel);
		paramClass.setBoard_restep(board_restep);
		paramClass.setBoard_password(board_password);
		
		//insert
		sqlMapper.insert("Board.insertBoard", paramClass);
		
		return  "redirect:/listBoard.do"; // list�� redirect
	}
	
	//��� ���
	@RequestMapping("/insertRBoard.do")
	public String insertRBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//����ڰ� �Է��� values
		String board_subject = request.getParameter("board_subject");
		String board_content = request.getParameter("board_content");
		String board_writer = request.getParameter("board_writer");
		String board_password = request.getParameter("board_password");

		//��� ��Ͻ� // ȣ���� �������� ���簪
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		board_group = Integer.parseInt(request.getParameter("board_group"));   //ȣ���������� �׷��� �״�� �ִ´�.
		board_relevel = Integer.parseInt(request.getParameter("board_relevel"));
		board_restep = Integer.parseInt(request.getParameter("board_restep"));
		
		
		//����ڰ� �Է��� ���� DTO�� set
		paramClass.setBoard_subject(board_subject);
		paramClass.setBoard_content(board_content);
		paramClass.setBoard_writer(board_writer);
		paramClass.setBoard_reg_date(today.getTime());
		paramClass.setBoard_group(board_group); // ȣ���������� �׷��� �״�� ����
		paramClass.setBoard_relevel(board_relevel+1); //ȣ�������� relevel �� +1 ��  // 0 ����/ 1 ������ ��� //
		paramClass.setBoard_restep(board_restep+1); //ȣ�������� restep �� +1 ��
		paramClass.setBoard_password(board_password);
		
		//update // insert �ϱ� ���� ���� insert�� ���ڵ带 ���� 
		sqlMapper.update("Board.updateBoardRestep", paramClass); // +1�� restep�� ���� �ֱ�����, ���� �׷쳻�� ���ݵ� �� �̻�Ǵ°͵��� ��� +1 ���߽�Ų��.
		
		//insert // ���� insert�Ѵ�.
		sqlMapper.insert("Board.insertRBoard", paramClass);
		
		return  "redirect:/listBoard.do"; // list�� redirect
	}
	
	//�Ҵ�� ���
	@RequestMapping("/insertReplay.do")
	public String insertReplay(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		Calendar today = Calendar.getInstance();
		
		//����ڰ� �Է��� values
		String replay_writer = request.getParameter("replay_writer");
		String replay_password = request.getParameter("replay_password");
		String replay_content = request.getParameter("replay_content");
		searchingNow = Integer.parseInt(request.getParameter("searchingNow"));
		
		
		//insert �Ϸ�� ȣ�� �������� ���ư��� ���� ��
		board_seq_num = Integer.parseInt(request.getParameter("board_seq_num"));
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
		//����ڰ� �Է��� ���� DTO�� set
		paramClass1.setReplay_board_seq_num(board_seq_num);
		paramClass1.setReplay_writer(replay_writer);
		paramClass1.setReplay_password(replay_password);
		paramClass1.setReplay_content(replay_content);
		paramClass1.setReplay_reg_date(today.getTime());
		
		//insert // ���� insert�Ѵ�.
		sqlMapper.insert("Replay.insertReplay", paramClass1);
		
		return  "redirect:/readBoard.do?board_seq_num="+board_seq_num+"&currentPage="+currentPage+"&searchingNow="+searchingNow; // ȣ���� readBoard�� redirect
	}
	
	
	
} //.end of class
