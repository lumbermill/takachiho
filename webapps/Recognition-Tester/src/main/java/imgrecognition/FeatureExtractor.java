package imgrecognition;

import java.nio.file.Path;

import org.opencv.core.Mat;
import org.opencv.core.MatOfKeyPoint;
import org.opencv.features2d.DescriptorExtractor;
import org.opencv.features2d.FeatureDetector;
import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

public class FeatureExtractor {
	private final FeatureDetector featureDetector;
	private final DescriptorExtractor descriptorExtractor;

	public FeatureExtractor() {
		String configPath = getClass().getResource("sift_config").getPath();
		featureDetector = FeatureDetector.create(FeatureDetector.SIFT);
		featureDetector.read(configPath);
		descriptorExtractor = DescriptorExtractor.create(DescriptorExtractor.SIFT);
		descriptorExtractor.read(configPath);
	}

	public Mat extract(Path imagePath) {
		// 画像データの読み込み
		Mat image = Highgui.imread(imagePath.toString());

		// 白黒画像データの作成
		Mat grayImage = new Mat();
		Imgproc.cvtColor(image, grayImage, Imgproc.COLOR_BGRA2GRAY);

		// キーポイント検出
		MatOfKeyPoint keyPoints = new MatOfKeyPoint();
		featureDetector.detect(grayImage, keyPoints);

		// 特徴量記述
		Mat descriptors = new Mat();
		descriptorExtractor.compute(grayImage, keyPoints, descriptors);
		return descriptors;
	}
}
