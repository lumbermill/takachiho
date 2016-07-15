package sample;

import imgrecognition.ImageRecognizer;
import imgrecognition.Result;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import java.util.HashMap;

public class ImageRecognizerTest {
	public static void main(String[] args) throws IOException, NoSuchAlgorithmException, ClassNotFoundException {
		// 画像の認識結果を取得
		Path queryPath = Paths.get("./data/query-image/sample.jpg");

		// ImageRecognizerの初期化
		Path trainDir = Paths.get("./data/train-image/");
		
		Map<String, String> option = new HashMap<String, String>();
		option.put("featureDetector", "ORB");
		option.put("descriptorExtractor", "ORB");
		option.put("optionFile", ""); // optionは後で検討
		ImageRecognizer recognizer = new ImageRecognizer(trainDir,option);

		// 認識結果を表示
		for (Result result : recognizer.recognize(queryPath).resultList) {
			System.out.println("l: " + result.id + ", s: " + result.score);
		}
	}
}
