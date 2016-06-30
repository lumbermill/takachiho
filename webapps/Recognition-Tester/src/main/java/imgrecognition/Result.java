package imgrecognition;

public class Result {
	public final String label;
	public final int score;

	public Result(String label, int score) {
		this.label = label;
		this.score = score;
	}
}
