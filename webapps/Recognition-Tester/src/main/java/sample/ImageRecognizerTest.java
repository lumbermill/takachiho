package sample;

import imgrecognition.ImageRecognizer;
import imgrecognition.Result;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ImageRecognizerTest {
	public static void main(String[] args) throws IOException {
		// 画像の認識結果を取得
		Path queryPath = Paths.get("./data/query-image/sample.jpg");

		// ImageRecognizerの初期化
		Path trainDir = Paths.get("./data/train-image/");
		ImageRecognizer recognizer = new ImageRecognizer(trainDir);

		// 認識結果を表示
		for (Result result : recognizer.recognize(queryPath)) {
			System.out.println("l: " + result.id + ", s: " + result.score);
		}
	}
}
