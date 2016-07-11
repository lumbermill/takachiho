package imgrecognition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import org.opencv.core.Core;

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

	public QueryResult recognize(Path queryImagePath) {
		Feature queryFeatures = featureExtractor.extract(queryImagePath);
		System.out.print("Count of keypoints for query image:");
		System.out.println(queryFeatures.countOfKeyPoints());
		 List<Result> resultList = voter.vote(queryFeatures.descriptors, trainData);
		 return new QueryResult(resultList,queryFeatures);
	}

	// 登録された訓練画像を読み込み、特徴量を抽出する
	private List<TrainData> loadTrainData(Path trainImageRoot) throws IOException {
		List<TrainData> trainData = new ArrayList<TrainData>();
		for (Path idDir : Files.newDirectoryStream(trainImageRoot)) {
			if (!idDir.toFile().isDirectory()) {
				continue;
			}
			String id = idDir.getFileName().toString();
			for (Path imagePath : Files.newDirectoryStream(idDir)) {
				try {
					Feature features = featureExtractor.extract(imagePath);
					System.out.print("Count of keypoints for train image(" + imagePath.toString() + "):");
					System.out.println(features.countOfKeyPoints());
					trainData.add(new TrainData(id, features.descriptors));
				} catch(org.opencv.core.CvException e) {
					System.out.println("Something wrong with " + imagePath.toString() + ". This File is ignored. Error :" + e);
					continue;
				}
			}
		}
		return trainData;
	}
}
