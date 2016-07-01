package imgrecognition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import org.opencv.core.Core;
import org.opencv.core.Mat;

public class ImageRecognizer {
	private final FeatureExtractor featureExtractor = new FeatureExtractor();
	private final DescriptorsVoter voter = new DescriptorsVoter();
	private final List<TrainData> trainData;

	static {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
	}

	public ImageRecognizer(Path trainImageRoot) throws IOException {
		trainData = loadTrainData(trainImageRoot);
	}

	public List<Result> recognize(Path queryImagePath) {
		Mat queryFeatures = featureExtractor.extract(queryImagePath);
		return voter.vote(queryFeatures, trainData);
	}

	// 登録された訓練画像を読み込み、特徴量を抽出する
	private List<TrainData> loadTrainData(Path trainImageRoot) throws IOException {
		List<TrainData> trainData = new ArrayList<TrainData>();
		for (Path labelDir : Files.newDirectoryStream(trainImageRoot)) {
			if (!labelDir.toFile().isDirectory()) {
				continue;
			}
			String label = labelDir.getFileName().toString();
			for (Path imagePath : Files.newDirectoryStream(labelDir)) {
				try {
					Mat features = featureExtractor.extract(imagePath);
					trainData.add(new TrainData(label, features));
				} catch(org.opencv.core.CvException e) {
					System.out.println(e);
					continue;
				}
			}
		}
		return trainData;
	}
}
