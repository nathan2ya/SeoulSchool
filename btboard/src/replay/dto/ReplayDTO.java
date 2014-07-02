package replay.dto;

import java.util.Date;

public class ReplayDTO {
	private int replay_seq_num;
	private int replay_board_seq_num;
	private String replay_writer;
	private String replay_password;
	private String replay_content;
	private Date replay_reg_date;
	private int replay_isUpdating;
	
	
	public int getReplay_seq_num() {
		return replay_seq_num;
	}
	public void setReplay_seq_num(int replay_seq_num) {
		this.replay_seq_num = replay_seq_num;
	}
	public String getReplay_content() {
		return replay_content;
	}
	public void setReplay_content(String replay_content) {
		this.replay_content = replay_content;
	}
	public Date getReplay_reg_date() {
		return replay_reg_date;
	}
	public void setReplay_reg_date(Date replay_reg_date) {
		this.replay_reg_date = replay_reg_date;
	}
	public int getReplay_board_seq_num() {
		return replay_board_seq_num;
	}
	public void setReplay_board_seq_num(int replay_board_seq_num) {
		this.replay_board_seq_num = replay_board_seq_num;
	}
	public String getReplay_writer() {
		return replay_writer;
	}
	public void setReplay_writer(String replay_writer) {
		this.replay_writer = replay_writer;
	}
	public String getReplay_password() {
		return replay_password;
	}
	public void setReplay_password(String replay_password) {
		this.replay_password = replay_password;
	}
	public int getReplay_isUpdating() {
		return replay_isUpdating;
	}
	public void setReplay_isUpdating(int replay_isUpdating) {
		this.replay_isUpdating = replay_isUpdating;
	}
}
