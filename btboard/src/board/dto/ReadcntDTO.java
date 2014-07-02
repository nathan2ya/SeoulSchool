package board.dto;

public class ReadcntDTO {
	private int readCnt_seq_num; // 레코드 시퀀스넘버
	private String readCnt_log; // 조회정보
	
	public int getReadCnt_seq_num() {
		return readCnt_seq_num;
	}
	public void setReadCnt_seq_num(int readCnt_seq_num) {
		this.readCnt_seq_num = readCnt_seq_num;
	}
	public String getReadCnt_log() {
		return readCnt_log;
	}
	public void setReadCnt_log(String readCnt_log) {
		this.readCnt_log = readCnt_log;
	}
}
