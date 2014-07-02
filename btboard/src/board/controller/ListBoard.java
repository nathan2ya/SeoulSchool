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
	private int searchingNow; // ��ü��, �˻����� �Ǵ��Ͽ� ��ư ��¿��θ� �����ϴ� ����.
	private String tempInput; // list�� ���� �Ǵ� �˻��� ��
	
	//page
	private int totalCount;// �� �Խù��� ��
	private int blockCount;// �� �������� �Խù��� ��
	private int blockPage;// �� ȭ�鿡 ������ ������ ��
	private String pagingHtml;// ����¡�� ������ HTML
	private PagingAction page;// ����¡ Ŭ����
	private String serviceName;// ȣ��������
	private int currentPage; //��ǰ ����������
	private int lastPage;
	
	//iBatis
	SqlMapClientTemplate ibatis = null;
	public static Reader reader;
	public static SqlMapClient sqlMapper;
	
	//����
	public ListBoard() throws IOException{
		reader = Resources.getResourceAsReader("sqlMapConfig.xml");
		sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		reader.close();
	}

	//����Ʈ(��ü ��)
	@RequestMapping("/listBoard.do")
	public String listBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("euc-kr");
		
		// ��ü��, �˻��� �Ǵܰ�.
		searchingNow = 0; //0 == ��ü��//1 == �˻���//
		
		//list
		//list = sqlMapper.queryForList("Board.selectAll"); //��ü��
		list = sqlMapper.queryForList("Board.selectAllrownum"); //���ĵ� ����Ʈ

		
		//������ó��
		blockCount = 10;// �� �������� �Խù��� ��
		blockPage = 5;// �� ȭ�鿡 ������ ������ ��
		serviceName = "listBoard";// ȣ�� URI ����
		totalCount = list.size(); // ��ü �� ����
		//currentPage �ʱ�ȭ
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage); // pagingAction ��ü ����.
		pagingHtml = page.getPagingHtml().toString(); // ������ HTML ����.

		int lastCount = totalCount; //��ü���� ����
		
		// ���� �������� ������ ���� ��ȣ�� ��ü�� ������ �� ��ȣ���� ������ lastCount�� +1 ��ȣ�� ����.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		
		// ��ü ����Ʈ���� ���� ��������ŭ�� ����Ʈ�� �����´�.
		list = list.subList(page.getStartCount(), lastCount);
		
		//.������ó�� ����
		
		
		//���� 15���� ������ ����
		String first;
		String second;
		String resultSubject;
		
		for(int i=0; i<list.size(); i++){
			if(list.get(i).getBoard_subject().length() > 18){ //������ 18���� �̻��̸�
				//0~19 �߶󳻱�//18�� ������
				first = list.get(i).getBoard_subject().substring(0, 18);
				
				resultSubject = first + "..."; //"<br/>" + second;
				list.get(i).setBoard_subject(resultSubject);
			}
			
		}
		//.���� 15���� ������ ���� ����
		
		
		//������ ������ ����
		lastPage = (int) Math.ceil((double) totalCount / blockCount);
		//����Ʈsize() / ���������� ������ �Խñ� �� = ��������(�ݿø�)
		if (lastPage == 0) {
			lastPage = 1;
		}
		// ���� �������� ��ü ������ ������ ũ�� ��ü ������ ���� ����
		if (currentPage > lastPage) {
			currentPage = lastPage;
		}
		//.������ ������ ���� ����
		
		
		//���۸� ������
		cntList = sqlMapper.queryForList("Board.newList");
		int numberCount = cntList.size(); // ������ ���ڵ� �� ����
		
		int number; // ���� ���� �� �ѹ�
		int cnt=0; // ��� ī���ͺ���
		
		if(page.getCurrentPage()==1){ // ���������� �� ���
			number=numberCount-(page.getCurrentPage()-1)*blockCount;
		}else if(page.getCurrentPage()==page.getTotalPage()){ // ������������ �� ���
			number=numberCount-(page.getCurrentPage()-1)*blockCount+blockCount+1;
		}else{ // �߰������� �� ��� //���������� �̸��� ��� ���� ����.
			
			int temp = page.getCurrentPage();
			
			for(int i=temp-1; i>0; i--){ // ���������� ���� ����� üũ�ϱ� ���� -1��
				int temp1 = i*blockCount-blockCount; //�������������� ���� �ε��� ��
				int temp2 = i*blockCount; //�������������� ������ �ε��� ��
				
				list1 = sqlMapper.queryForList("Board.selectAllrownum"); //���ĵ� ����Ʈ
				list1 = list1.subList(temp1, temp2); // ������������ ����,������ ������ �ڸ�
				
				for(int j=0; j<list1.size(); j++){
					//����ΰ͸�
					if(list1.get(j).getBoard_relevel()>0){
						cnt++;//������������ ��� ������ ������Ŵ
					}
				}
			}
			//���� ���Ŀ��� -> ���������� ���������� ������ ����������� ����� ����
			number=(numberCount-(page.getCurrentPage()-1)*blockCount)+cnt;
		}
		
		
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("pagingHtml", pagingHtml);
		request.setAttribute("list", list);
		request.setAttribute("number", number); //�۳ѹ� - �������� �����Ǵ� �Խñ��� ����
		request.setAttribute("total", totalCount); //��� �Խñ� ��
		request.setAttribute("lastPage", lastPage); // ������ ������
		request.setAttribute("searchingNow", searchingNow);
		
		return  "/view/board/listBoard.jsp";
	}
	
	
	
	//����Ʈ(�˻��� ��)
	@RequestMapping("/listSearchBoard.do")
	public String listSearchBoard(HttpServletRequest request, HttpServletResponse response) throws Exception{
		// ��ü��, �˻��� �Ǵܰ�.
		searchingNow = 1; //0 == ��ü��//1 == �˻���//
		
		request.setCharacterEncoding("euc-kr");
		
		//����ڰ� �Է��� ��
		String searchType = request.getParameter("searchType"); //�˻� ���� // ����,����,�ۼ���
		String userinput = request.getParameter("userinput"); //�˻���
		
		//�˻�����&�˻�� �����ϴ� ���ڵ� �˻�
		if(searchType.equals("subject")){
			//���� �˻�
			list = sqlMapper.queryForList("Board.selectWithSubject", userinput);
		}else if(searchType.equals("content")){
			//���� �˻�
			list = sqlMapper.queryForList("Board.selectWithContent", userinput);
		}else{
			//�ۼ��� �˻�
			list = sqlMapper.queryForList("Board.selectWithWriter", userinput);
		}
			
		//������ó��
		blockCount = 10;// �� �������� �Խù��� ��
		blockPage = 5;// �� ȭ�鿡 ������ ������ ��
		serviceName = "listSearchBoard";// ȣ�� URI ����
		totalCount = list.size(); // ��ü �� ����
		
		//currentPage �ʱ�ȭ
		if(null == request.getParameter("currentPage")){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		page = new PagingAction(serviceName, currentPage, totalCount, blockCount, blockPage, searchType, userinput); // pagingAction ��ü ����.
		pagingHtml = page.getPagingHtml().toString(); // ������ HTML ����.

		int lastCount = totalCount; // ������ ���ڵ� = ����
		
		
		// ���� �������� ������ ���� ��ȣ�� ��ü�� ������ �� ��ȣ���� ������ lastCount�� +1 ��ȣ�� ����.
		if (page.getEndCount() < totalCount)
			lastCount = page.getEndCount() + 1;
		
		
		// ��ü ����Ʈ���� ���� ��������ŭ�� ����Ʈ�� �����´�.
		list = list.subList(page.getStartCount(), lastCount);
		//.������ó�� ����
		
		
		//�˻��� ����
		if(userinput.length()>8){ // ����� �Է°��� 8�� �̻��� ���
			tempInput = userinput.substring(0, 8) + "..."; // 8���� + ... �߰�
		}else{ // �����ϰ��
			tempInput = userinput;
		}
		
		//����Ʈ �۹�ȣ ���� ���
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
