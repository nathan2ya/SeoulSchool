package board.dto;

import java.util.Date;

public class BoardDTO {
	private int board_seq_num; // 레코드 시퀀스넘버
	private String board_subject; // 제목
	private String board_content; // 내용
	private String board_writer; //작성자
	private Date board_reg_date; //날짜
	private int board_readcnt; //조회수
	private int board_group; //글의 그룹
	private int board_relevel; //그룹 내 글의 종류 // 0 == 새글 // 1== 새글의 답글 // 2==답글의 답글
	private int board_restep; // 그룹 내 작성 순서 // 0 == 최초작성 // 이하 순차 증가 n+1
	private String board_password; // 비밀번호
	private int rownum;
	
	
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public String getBoard_password() {
		return board_password;
	}
	public void setBoard_password(String board_password) {
		this.board_password = board_password;
	}
	public int getBoard_seq_num() {
		return board_seq_num;
	}
	public void setBoard_seq_num(int board_seq_num) {
		this.board_seq_num = board_seq_num;
	}
	public String getBoard_subject() {
		return board_subject;
	}
	public void setBoard_subject(String board_subject) {
		this.board_subject = board_subject;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public String getBoard_writer() {
		return board_writer;
	}
	public void setBoard_writer(String board_writer) {
		this.board_writer = board_writer;
	}
	public Date getBoard_reg_date() {
		return board_reg_date;
	}
	public void setBoard_reg_date(Date board_reg_date) {
		this.board_reg_date = board_reg_date;
	}
	public int getBoard_readcnt() {
		return board_readcnt;
	}
	public void setBoard_readcnt(int board_readcnt) {
		this.board_readcnt = board_readcnt;
	}
	public int getBoard_group() {
		return board_group;
	}
	public void setBoard_group(int board_group) {
		this.board_group = board_group;
	}
	public int getBoard_relevel() {
		return board_relevel;
	}
	public void setBoard_relevel(int board_relevel) {
		this.board_relevel = board_relevel;
	}
	public int getBoard_restep() {
		return board_restep;
	}
	public void setBoard_restep(int board_restep) {
		this.board_restep = board_restep;
	}
}
