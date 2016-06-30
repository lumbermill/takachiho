package sample;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfKeyPoint;
import org.opencv.core.Scalar;
import org.opencv.features2d.FeatureDetector;
import org.opencv.features2d.Features2d;
import org.opencv.features2d.KeyPoint;
import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

public class KeyPointsDetection {
	public static void main(String[] args) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

		// 画像データの読み込み
		Mat sourceImage = Highgui.imread(resourcePath("tortoise.png"));

		// 白黒画像データの作成
		Mat grayImage = new Mat();
		Imgproc.cvtColor(sourceImage, grayImage, Imgproc.COLOR_BGRA2GRAY);

		// 白黒画像データの描画
		Highgui.imwrite("gray_tortoise.png", grayImage);

		// キーポイント検出器の初期化
		FeatureDetector featureDetector = FeatureDetector.create(FeatureDetector.SIFT);

		// キーポイント検出
		MatOfKeyPoint keyPoints = new MatOfKeyPoint();
		featureDetector.detect(grayImage, keyPoints);

		// キーポイントの表示
		KeyPoint[] keyPointArray = keyPoints.toArray();
		System.out.println("KeyPoints count: " + keyPointArray.length);
		for (int i = 0; i < Math.min(keyPointArray.length, 20); i++) {
			System.out.println(keyPointArray[i]);
		}

		// キーポイントの描画
		Mat output = new Mat();
		Features2d.drawKeypoints(sourceImage, keyPoints, output,
			new Scalar(0.0, 0.0, 255.0), 4);
		Highgui.imwrite("keypoints.png", output);
	}

	private static String resourcePath(String name) {
		return KeyPointsDetection.class.getResource(name).getPath();
	}
}
