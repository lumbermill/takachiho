package imgrecognition;

import org.opencv.core.Mat;

public class TrainData {
	public final String label;
	public final Mat descriptors;

	public TrainData(String label, Mat descriptors) {
		this.label = label;
		this.descriptors = descriptors;
	}
}
