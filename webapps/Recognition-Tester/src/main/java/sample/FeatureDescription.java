package sample;

import java.util.Arrays;
import java.util.Comparator;

import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfDMatch;
import org.opencv.core.MatOfKeyPoint;
//import org.opencv.features2d.DMatch;
import org.opencv.features2d.DescriptorExtractor;
import org.opencv.features2d.DescriptorMatcher;
import org.opencv.features2d.FeatureDetector;
import org.opencv.features2d.Features2d;
//import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

//OpenCV3
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.core.DMatch;


public class FeatureDescription {
	public static void main(String[] args) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

		// 特徴量抽出インスタンスとキーポイント検出インスタンスを生成
		FeatureDetector featureDetector = FeatureDetector.create(FeatureDetector.ORB);
		DescriptorExtractor descriptorExtractor = DescriptorExtractor.create(DescriptorExtractor.ORB);

		// 画像データ1の読み込み
		Mat sourceImage1 = Imgcodecs.imread(resourcePath("tortoise.png"));


		// 画像データ1の白黒画像データの作成
		Mat grayImage1 = new Mat();
		Imgproc.cvtColor(sourceImage1, grayImage1, Imgproc.COLOR_BGRA2GRAY);

		// 画像データ1のキーポイント検出
		MatOfKeyPoint keyPoints1 = new MatOfKeyPoint();
		featureDetector.detect(grayImage1, keyPoints1);

		// 画像データ1の特徴量記述
		Mat descriptors1 = new Mat();
		descriptorExtractor.compute(grayImage1, keyPoints1, descriptors1);

		// 特徴量の表示
		int type = descriptors1.type();
		descriptors1.convertTo(descriptors1, CvType.CV_8UC1);
		System.out.println("KeyPoints count: " + keyPoints1.toArray().length);
		System.out.println("Descriptors count: " + descriptors1.rows());
		for (int r = 0; r < Math.min(descriptors1.rows(), 20); r++) {
			byte[] vector = new byte[128];
			descriptors1.get(r, 0, vector);
			System.out.println(Arrays.toString(vector));
		}
		descriptors1.convertTo(descriptors1, type);

		// 以下、画像2の特徴量抽出処理
		Mat sourceImage2 = Imgcodecs.imread(resourcePath("tortoise_rot.png"));

		Mat grayImage2 = new Mat();
		Imgproc.cvtColor(sourceImage2, grayImage2, Imgproc.COLOR_BGRA2GRAY);

		MatOfKeyPoint keyPoints2 = new MatOfKeyPoint();
		featureDetector.detect(grayImage2, keyPoints2);

		Mat descriptors2 = new Mat();
		descriptorExtractor.compute(grayImage2, keyPoints2, descriptors2);

		// 特徴量のマッチング
//		DescriptorMatcher matcher = DescriptorMatcher.create(DescriptorMatcher.FLANNBASED);
		DescriptorMatcher matcher = DescriptorMatcher.create(DescriptorMatcher.BRUTEFORCE_HAMMING);
		MatOfDMatch matches = new MatOfDMatch();
		matcher.match(descriptors1, descriptors2, matches);

		// マッチング結果の表示
		DMatch[] matchArray = matches.toArray();
		for (int i = 0; i < Math.min(matchArray.length, 60); i++) {
			System.out.println(matchArray[i]);
		}

		// マッチング結果を距離が近い順に並び変える
		Arrays.sort(matchArray, new Comparator<DMatch>() {
			@Override
			public int compare(DMatch left, DMatch right) {
				return Double.compare(left.distance, right.distance);
			}
		});

		// 距離の小さいいくつかのマッチング結果を抽出する
		DMatch[] smallDistanceMatches = new DMatch[10];
		for (int i = 0; i < Math.min(matchArray.length, 10); i++) {
			smallDistanceMatches[i] = matchArray[i];
		}
		matches.fromArray(smallDistanceMatches);

		// マッチング結果の描画
		Mat output = new Mat();
		Features2d.drawMatches(sourceImage1, keyPoints1, sourceImage2, keyPoints2, matches, output);
		Imgcodecs.imwrite("descriptors_match.png", output);
	}

	private static String resourcePath(String name) {
		return FeatureDescription.class.getResource(name).getPath();
	}
}
