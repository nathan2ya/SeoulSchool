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
	private int totalCount;// �� �Խù��� ��
	private int blockCount;// �� �������� �Խù��� ��
	private int blockPage;// �� ȭ�鿡 ������ ������ ��
	private String pagingHtml;// ����¡�� ������ HTML
	private PagingAction page;// ����¡ Ŭ����
	private String serviceName;// ȣ��������
	
	private int currentPage;
	private int r_currentPage;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	
	//����
	public GetBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//�� ����
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
		
		
		//�ش�۹�ȣ�� ���ڵ� get(readBoard.jsp)
		resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
		
		
		/*
		//���뿡�� ����� ���� replaceó�� - ���� �����ϱ� ���ؼ� �ּ�ó����.
		board_content = board_content.replaceAll("<br/>", "\r\n");  //����
		board_content = board_content.replaceAll("&nbsp;", "\u0020");  // �����̽���
		*/
		
		
		//�� ��ȸ�� +1
		String ip_address = InetAddress.getLocalHost().getHostAddress(); // ������ ip
		String seq_num = Integer.toString(resultClass.getBoard_seq_num()); // ���� �۹�ȣ
		Calendar date = Calendar.getInstance();
		SimpleDateFormat sformat = new SimpleDateFormat("yyyy-MM-dd");
		String today = sformat.format(date.getTime()); //���ó�¥//�Ϸ簡 ������ ���� ����ڰ� ��ȸ���� ���� ��ų �� �ֱ�����.
		//���� DB Insert parameter
		String parameter = ip_address+seq_num+today; //ip�ּ�+�۹�ȣ+���ó�¥
		
		//���� �ִ��� ������ count
		Integer count = (Integer) sqlMapper.queryForObject("Board.selectCountForReadCnt", parameter);
		
		if(count==0){ //���ڵ尡 �������� ���� ���
			//insert // readcnt_table�� ���� ���� ���
			sqlMapper.insert("Board.insertReadCnt", parameter);
			//update ��ȸ�� +1 // btboard�� ��ȸ��+=1
			paramClass.setBoard_seq_num(board_seq_num);
			sqlMapper.update("Board.updateBoardReadcnt", paramClass);
		}
		//.�� ��ȸ�� +1 ����
		
		
		
		
		//�ش�۹�ȣ�� ���ڵ� get(readBoard.jsp)
		resultClass = (BoardDTO)sqlMapper.queryForObject("Board.selectBoardOne", board_seq_num);
		
		
		
		//�Ҵ�� ����Ʈ
		list = sqlMapper.queryForList("Replay.selectAll", board_seq_num);
		
		
		
		//�Ҵ���� ������
		blockCount = 10;// �� �������� �Խù��� ��
		blockPage = 5;// �� ȭ�鿡 ������ ������ ��
		serviceName = "readBoard";// ȣ�� URI ����
		totalCount = list.size(); // ��ü �� ����
		
		//r_currentPage �Ҵ�� ���������� �ʱ�ȭ
		if(null == request.getParameter("r_currentPage")){
			r_currentPage = 1;
		}else{
			r_currentPage = Integer.parseInt(request.getParameter("r_currentPage"));
		}
		
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage, board_seq_num, r_currentPage); // pagingAction ��ü ����.
		pagingHtml = page.getPagingHtml().toString(); // ������ HTML ����.

		int lastCount = totalCount; //��ü���� ����
		
		// ���� �������� ������ ���� ��ȣ�� ��ü�� ������ �� ��ȣ���� ������ lastCount�� +1 ��ȣ�� ����.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		// ��ü ����Ʈ���� ���� ��������ŭ�� ����Ʈ�� �����´�.
		list = list.subList(page.getStartCount(), lastCount);
		
		//.�Ҵ���� ������ ����
		
		
		//��� ����
		if(request.getParameter("updating")==null){
			request.setAttribute("updating", 0); 
		}else{
			request.setAttribute("updating", 1); 
		}
		
		
		//set
		request.setAttribute("resultClass", resultClass); // �ش� ���� ���ڵ� �÷� ����
        request.setAttribute("board_seq_num", board_seq_num); //���� ���
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("list", list); // �Ҵ�� ����Ʈ
        request.setAttribute("total", list.size()); // �Ҵ�� ���ڵ� ����
        request.setAttribute("pagingHtml", pagingHtml); //�Ҵ�� ������
        
		return  "/view/board/readBoard.jsp";
	}
} //.end of class
