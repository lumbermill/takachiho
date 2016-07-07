package imgrecognition;

import org.opencv.core.Mat;

public class TrainData {
	public final String id;
	public final Mat descriptors;
	public TrainData(String id, Mat descriptors) {
		this.id = id;
		this.descriptors = descriptors;
	}
}
