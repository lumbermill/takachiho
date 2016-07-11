package imgrecognition;
import org.opencv.core.Mat;
import org.opencv.core.MatOfKeyPoint;

public class Feature {
	public final Mat srcImage;
	public final Mat grayImage;
	public final Mat descriptors;
	MatOfKeyPoint keyPoints = new MatOfKeyPoint();

	public Feature(Mat srcImage, Mat grayImage, MatOfKeyPoint keyPoints, Mat descriptors) {
		this.srcImage = srcImage;
		this.grayImage = grayImage;
		this.keyPoints = keyPoints;
		this.descriptors = descriptors;
	}
	
	public int countOfKeyPoints() {
		return this.keyPoints.toArray().length;
	}	
}
