package imgrecognition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.opencv.core.Core;
import org.opencv.features2d.DescriptorExtractor;
import org.opencv.features2d.FeatureDetector;

public class ImageRecognizer {
	private final String featureDetectorName;
	private final String descriptorExtractorName;
	private final String optionFile;
	private final FeatureExtractor featureExtractor;
	private final DescriptorsVoter voter = new DescriptorsVoter();
	private final List<TrainData> trainData;
	private final static Map<String, Integer> featureDetectorNames = new HashMap<String, Integer>();
	private final static Map<String, Integer> descriptorExtractorNames = new HashMap<String, Integer>();

	static {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		LoadFeatureDetectorNames();
		LoadDescriptorExtractorNames();
	}

	public ImageRecognizer(Path trainImageRoot, Map<String, String> option)
			throws IOException, NoSuchAlgorithmException, ClassNotFoundException {
		featureDetectorName = option.get("featureDetector");
		descriptorExtractorName = option.get("descriptorExtractor");
		optionFile = (String) option.get("optionFile");

		FeatureDetector featureDetector = FeatureDetector.create(featureDetectorNames.get(featureDetectorName));
		DescriptorExtractor descriptorExtractor = DescriptorExtractor
				.create(descriptorExtractorNames.get(descriptorExtractorName));

		if (optionFile != null && optionFile != "") {
			String configPath = getClass().getResource(optionFile).getPath();
			featureDetector.read(configPath);
			descriptorExtractor.read(configPath);
		}

		featureExtractor = new FeatureExtractor(featureDetector, descriptorExtractor);
		trainData = loadTrainData(trainImageRoot);
	}

	public QueryResult recognize(Path queryImagePath) {
		Feature queryFeatures = featureExtractor.extract(queryImagePath);
		System.out.print("FD:" + featureDetectorName + "/");
		System.out.print("DE:" + descriptorExtractorName + "/");
		System.out.print("OptionFile:" + optionFile + "/");
		System.out.print("Count of keypoints for query image:");
		System.out.println(queryFeatures.countOfKeyPoints());
		List<Result> resultList = voter.vote(queryFeatures.descriptors, trainData);
		return new QueryResult(resultList, queryFeatures);
	}

	// 登録された訓練画像を読み込み、特徴量を抽出する
	private List<TrainData> loadTrainData(Path trainImageRoot) throws IOException, NoSuchAlgorithmException, ClassNotFoundException {
		List<TrainData> trainData = new ArrayList<TrainData>();
		for (Path idDir : Files.newDirectoryStream(trainImageRoot)) {
			if (!idDir.toFile().isDirectory()) {
				continue;
			}

			String id = idDir.getFileName().toString();
			for (Path imagePath : Files.newDirectoryStream(idDir)) {
				if (imagePath.getFileName().toString().startsWith(".")) {
					System.out.println(
							"This is invalid image file: " + imagePath.toString() + ". This File is ignored.");
					continue;
				}
				try {
					TrainData trainDatum = TrainDataCache.getCache(imagePath, featureDetectorName, descriptorExtractorName,
							optionFile);
					// 訓練データがキャッシュから取得できなければ新たに作成する
					if (trainDatum == null) {
						Feature features = featureExtractor.extract(imagePath);
						System.out.print("FD:" + featureDetectorName + "/");
						System.out.print("DE:" + descriptorExtractorName + "/");
						System.out.print("OptionFile:" + optionFile + "/");
						System.out.print("Count of keypoints for train image(" + imagePath.toString() + "):");
						System.out.println(features.countOfKeyPoints());
						trainDatum = new TrainData(id, features.descriptors);
						TrainDataCache.saveCache(trainDatum, imagePath, featureDetectorName, descriptorExtractorName,
								optionFile); // 訓練データをキャッシュに保存
					}
					trainData.add(trainDatum);
				} catch (org.opencv.core.CvException e) {
					String error = "FD:" + featureDetectorName + "/";
					error += "DE:" + descriptorExtractorName + "/";
					error += "OptionFile:" + optionFile + "/";
					error += 
							"Something wrong with " + imagePath.toString() + ". This File is ignored. Error :" + e;
					throw new RuntimeException(error);
				}
			}
		}
		return trainData;
	}

	private static void LoadFeatureDetectorNames() {
		featureDetectorNames.put("FAST", new Integer(FeatureDetector.FAST));
		featureDetectorNames.put("STAR", new Integer(FeatureDetector.STAR));
//		featureDetectorNames.put("SIFT", new Integer(FeatureDetector.SIFT));
//		featureDetectorNames.put("SURF", new Integer(FeatureDetector.SURF));
		featureDetectorNames.put("ORB", new Integer(FeatureDetector.ORB));
		featureDetectorNames.put("MSER", new Integer(FeatureDetector.MSER));
		featureDetectorNames.put("GFTT", new Integer(FeatureDetector.GFTT));
		featureDetectorNames.put("HARRIS", new Integer(FeatureDetector.HARRIS));
		featureDetectorNames.put("SIMPLEBLOB", new Integer(FeatureDetector.SIMPLEBLOB));
		featureDetectorNames.put("DENSE", new Integer(FeatureDetector.DENSE));
		featureDetectorNames.put("BRISK", new Integer(FeatureDetector.BRISK));
		featureDetectorNames.put("AKAZE", new Integer(FeatureDetector.AKAZE));
		featureDetectorNames.put("GRID_FAST", new Integer(FeatureDetector.GRID_FAST));
		featureDetectorNames.put("GRID_STAR", new Integer(FeatureDetector.GRID_STAR));
//		featureDetectorNames.put("GRID_SIFT", new Integer(FeatureDetector.GRID_SIFT));
//		featureDetectorNames.put("GRID_SURF", new Integer(FeatureDetector.GRID_SURF));
		featureDetectorNames.put("GRID_ORB", new Integer(FeatureDetector.GRID_ORB));
		featureDetectorNames.put("GRID_MSER", new Integer(FeatureDetector.GRID_MSER));
		featureDetectorNames.put("GRID_GFTT", new Integer(FeatureDetector.GRID_GFTT));
		featureDetectorNames.put("GRID_HARRIS", new Integer(FeatureDetector.GRID_HARRIS));
		featureDetectorNames.put("GRID_SIMPLEBLOB", new Integer(FeatureDetector.GRID_SIMPLEBLOB));
		featureDetectorNames.put("GRID_DENSE", new Integer(FeatureDetector.GRID_DENSE));
		featureDetectorNames.put("GRID_BRISK", new Integer(FeatureDetector.GRID_BRISK));
		featureDetectorNames.put("GRID_AKAZE", new Integer(FeatureDetector.GRID_AKAZE));
		featureDetectorNames.put("PYRAMID_FAST", new Integer(FeatureDetector.PYRAMID_FAST));
		featureDetectorNames.put("PYRAMID_STAR", new Integer(FeatureDetector.PYRAMID_STAR));
//		featureDetectorNames.put("PYRAMID_SIFT", new Integer(FeatureDetector.PYRAMID_SIFT));
//		featureDetectorNames.put("PYRAMID_SURF", new Integer(FeatureDetector.PYRAMID_SURF));
		featureDetectorNames.put("PYRAMID_ORB", new Integer(FeatureDetector.PYRAMID_ORB));
		featureDetectorNames.put("PYRAMID_MSER", new Integer(FeatureDetector.PYRAMID_MSER));
		featureDetectorNames.put("PYRAMID_GFTT", new Integer(FeatureDetector.PYRAMID_GFTT));
		featureDetectorNames.put("PYRAMID_HARRIS", new Integer(FeatureDetector.PYRAMID_HARRIS));
		featureDetectorNames.put("PYRAMID_SIMPLEBLOB", new Integer(FeatureDetector.PYRAMID_SIMPLEBLOB));
		featureDetectorNames.put("PYRAMID_DENSE", new Integer(FeatureDetector.PYRAMID_DENSE));
		featureDetectorNames.put("PYRAMID_BRISK", new Integer(FeatureDetector.PYRAMID_BRISK));
		featureDetectorNames.put("PYRAMID_AKAZE", new Integer(FeatureDetector.PYRAMID_AKAZE));
		featureDetectorNames.put("DYNAMIC_FAST", new Integer(FeatureDetector.DYNAMIC_FAST));
		featureDetectorNames.put("DYNAMIC_STAR", new Integer(FeatureDetector.DYNAMIC_STAR));
//		featureDetectorNames.put("DYNAMIC_SIFT", new Integer(FeatureDetector.DYNAMIC_SIFT));
//		featureDetectorNames.put("DYNAMIC_SURF", new Integer(FeatureDetector.DYNAMIC_SURF));
		featureDetectorNames.put("DYNAMIC_ORB", new Integer(FeatureDetector.DYNAMIC_ORB));
		featureDetectorNames.put("DYNAMIC_MSER", new Integer(FeatureDetector.DYNAMIC_MSER));
		featureDetectorNames.put("DYNAMIC_GFTT", new Integer(FeatureDetector.DYNAMIC_GFTT));
		featureDetectorNames.put("DYNAMIC_HARRIS", new Integer(FeatureDetector.DYNAMIC_HARRIS));
		featureDetectorNames.put("DYNAMIC_SIMPLEBLOB", new Integer(FeatureDetector.DYNAMIC_SIMPLEBLOB));
		featureDetectorNames.put("DYNAMIC_DENSE", new Integer(FeatureDetector.DYNAMIC_DENSE));
		featureDetectorNames.put("DYNAMIC_BRISK", new Integer(FeatureDetector.DYNAMIC_BRISK));
		featureDetectorNames.put("DYNAMIC_AKAZE", new Integer(FeatureDetector.DYNAMIC_AKAZE));

	}

	private static void LoadDescriptorExtractorNames() {
//		descriptorExtractorNames.put("SIFT", new Integer(DescriptorExtractor.SIFT));
//		descriptorExtractorNames.put("SURF", new Integer(DescriptorExtractor.SURF));
		descriptorExtractorNames.put("ORB", new Integer(DescriptorExtractor.ORB));
		descriptorExtractorNames.put("BRIEF", new Integer(DescriptorExtractor.BRIEF));
		descriptorExtractorNames.put("BRISK", new Integer(DescriptorExtractor.BRISK));
		descriptorExtractorNames.put("FREAK", new Integer(DescriptorExtractor.FREAK));
		descriptorExtractorNames.put("AKAZE", new Integer(DescriptorExtractor.AKAZE));
//		descriptorExtractorNames.put("OPPONENT_SIFT", new Integer(DescriptorExtractor.OPPONENT_SIFT));
//		descriptorExtractorNames.put("OPPONENT_SURF", new Integer(DescriptorExtractor.OPPONENT_SURF));
		descriptorExtractorNames.put("OPPONENT_ORB", new Integer(DescriptorExtractor.OPPONENT_ORB));
		descriptorExtractorNames.put("OPPONENT_BRIEF", new Integer(DescriptorExtractor.OPPONENT_BRIEF));
		descriptorExtractorNames.put("OPPONENT_BRISK", new Integer(DescriptorExtractor.OPPONENT_BRISK));
		descriptorExtractorNames.put("OPPONENT_FREAK", new Integer(DescriptorExtractor.OPPONENT_FREAK));
		descriptorExtractorNames.put("OPPONENT_AKAZE", new Integer(DescriptorExtractor.OPPONENT_AKAZE));
	}
	
	// すべてのアルゴリズムの組み合わせを返す
	public static String[][] allRecognizerPair() {
		List<String[]> result = new ArrayList<String[]>();
		for (String fd : ImageRecognizer.featureDetectorNames.keySet()) {
			for (String de : ImageRecognizer.descriptorExtractorNames.keySet()) {
				String[] recognizerPair = {fd,de,""}; 
				result.add(recognizerPair);
			}
		}
		return result.toArray(new String[0][0]);
	}

	// すべての利用可能なアルゴリズムの組み合わせ(128通り)を返す
	public static String[][] allAvailableRecognizerPair() {
		String[][] pair = { 
				{ "GRID_SIMPLEBLOB", "OPPONENT_BRISK", "" },
				{ "GRID_SIMPLEBLOB", "BRISK", "" },
				{ "GRID_MSER", "OPPONENT_ORB", "" },
				{ "GRID_MSER", "OPPONENT_BRISK", "" },
				{ "GRID_MSER", "BRISK", "" },
				{ "GRID_MSER", "ORB", "" },
				{ "GRID_FAST", "OPPONENT_ORB", "" },
				{ "GRID_FAST", "OPPONENT_BRISK", "" },
				{ "GRID_FAST", "BRISK", "" },
				{ "GRID_FAST", "ORB", "" },
				{ "PYRAMID_AKAZE", "AKAZE", "" },
				{ "PYRAMID_AKAZE", "OPPONENT_ORB", "" },
				{ "PYRAMID_AKAZE", "OPPONENT_BRISK", "" },
				{ "PYRAMID_AKAZE", "OPPONENT_AKAZE", "" },
				{ "PYRAMID_AKAZE", "BRISK", "" },
				{ "PYRAMID_AKAZE", "ORB", "" },
				{ "SIMPLEBLOB", "OPPONENT_BRISK", "" },
				{ "SIMPLEBLOB", "BRISK", "" },
				{ "GRID_BRISK", "OPPONENT_ORB", "" },
				{ "GRID_BRISK", "OPPONENT_BRISK", "" },
				{ "GRID_BRISK", "BRISK", "" },
				{ "GRID_BRISK", "ORB", "" },
				{ "PYRAMID_HARRIS", "OPPONENT_ORB", "" },
				{ "PYRAMID_HARRIS", "OPPONENT_BRISK", "" },
				{ "PYRAMID_HARRIS", "BRISK", "" },
				{ "PYRAMID_HARRIS", "ORB", "" },
				{ "BRISK", "OPPONENT_ORB", "" },
				{ "BRISK", "OPPONENT_BRISK", "" },
				{ "BRISK", "BRISK", "" },
				{ "BRISK", "ORB", "" }, 
				{ "GRID_GFTT", "OPPONENT_ORB", "" },
				{ "GRID_GFTT", "OPPONENT_BRISK", "" },
				{ "GRID_GFTT", "BRISK", "" },
				{ "GRID_GFTT", "ORB", "" },
				{ "DYNAMIC_ORB", "OPPONENT_ORB", "" },
				{ "DYNAMIC_ORB", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_ORB", "BRISK", "" }, 
				{ "DYNAMIC_ORB", "ORB", "" },
				{ "PYRAMID_ORB", "OPPONENT_ORB", "" },
				{ "PYRAMID_ORB", "OPPONENT_BRISK", "" },
				{ "PYRAMID_ORB", "BRISK", "" },
				{ "PYRAMID_ORB", "ORB", "" },
				{ "DYNAMIC_BRISK", "OPPONENT_ORB", "" },
				{ "DYNAMIC_BRISK", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_BRISK", "BRISK", "" }, 
				{ "DYNAMIC_BRISK", "ORB", "" }, 
				{ "DYNAMIC_AKAZE", "AKAZE", "" },
				{ "DYNAMIC_AKAZE", "OPPONENT_ORB", "" },
				{ "DYNAMIC_AKAZE", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_AKAZE", "OPPONENT_AKAZE", "" },
				{ "DYNAMIC_AKAZE", "BRISK", "" },
				{ "DYNAMIC_AKAZE", "ORB", "" },
				{ "GRID_ORB", "OPPONENT_ORB", "" },
				{ "GRID_ORB", "OPPONENT_BRISK", "" },
				{ "GRID_ORB", "BRISK", "" },
				{ "GRID_ORB", "ORB", "" },
				{ "PYRAMID_SIMPLEBLOB", "OPPONENT_BRISK", "" },
				{ "PYRAMID_SIMPLEBLOB", "BRISK", "" },
				{ "DYNAMIC_SIMPLEBLOB", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_SIMPLEBLOB", "BRISK", "" },
				{ "PYRAMID_BRISK", "OPPONENT_ORB", "" },
				{ "PYRAMID_BRISK", "OPPONENT_BRISK", "" },
				{ "PYRAMID_BRISK", "BRISK", "" },
				{ "PYRAMID_BRISK", "ORB", "" },
				{ "GRID_HARRIS", "OPPONENT_ORB", "" },
				{ "GRID_HARRIS", "OPPONENT_BRISK", "" },
				{ "GRID_HARRIS", "BRISK", "" },
				{ "GRID_HARRIS", "ORB", "" },
				{ "GRID_AKAZE", "AKAZE", "" },
				{ "GRID_AKAZE", "OPPONENT_ORB", "" },
				{ "GRID_AKAZE", "OPPONENT_BRISK", "" },
				{ "GRID_AKAZE", "OPPONENT_AKAZE", "" },
				{ "GRID_AKAZE", "BRISK", "" },
				{ "GRID_AKAZE", "ORB", "" },
				{ "HARRIS", "OPPONENT_ORB", "" },
				{ "HARRIS", "OPPONENT_BRISK", "" },
				{ "HARRIS", "BRISK", "" },
				{ "HARRIS", "ORB", "" },
				{ "PYRAMID_MSER", "OPPONENT_ORB", "" },
				{ "PYRAMID_MSER", "OPPONENT_BRISK", "" },
				{ "PYRAMID_MSER", "BRISK", "" },
				{ "PYRAMID_MSER", "ORB", "" },
				{ "DYNAMIC_MSER", "OPPONENT_ORB", "" },
				{ "DYNAMIC_MSER", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_MSER", "BRISK", "" },
				{ "DYNAMIC_MSER", "ORB", "" },
				{ "AKAZE", "AKAZE", "" },
				{ "AKAZE", "OPPONENT_ORB", "" },
				{ "AKAZE", "OPPONENT_BRISK", "" },
				{ "AKAZE", "OPPONENT_AKAZE", "" },
				{ "AKAZE", "BRISK", "" },
				{ "AKAZE", "ORB", "" },
				{ "MSER", "OPPONENT_ORB", "" },
				{ "MSER", "OPPONENT_BRISK", "" },
				{ "MSER", "BRISK", "" },
				{ "MSER", "ORB", "" },
				{ "DYNAMIC_FAST", "OPPONENT_ORB", "" },
				{ "DYNAMIC_FAST", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_FAST", "BRISK", "" },
				{ "DYNAMIC_FAST", "ORB", "" },
				{ "PYRAMID_FAST", "OPPONENT_ORB", "" },
				{ "PYRAMID_FAST", "OPPONENT_BRISK", "" },
				{ "PYRAMID_FAST", "BRISK", "" },
				{ "PYRAMID_FAST", "ORB", "" },
				{ "DYNAMIC_HARRIS", "OPPONENT_ORB", "" },
				{ "DYNAMIC_HARRIS", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_HARRIS", "BRISK", "" },
				{ "DYNAMIC_HARRIS", "ORB", "" },
				{ "DYNAMIC_GFTT", "OPPONENT_ORB", "" },
				{ "DYNAMIC_GFTT", "OPPONENT_BRISK", "" },
				{ "DYNAMIC_GFTT", "BRISK", "" },
				{ "DYNAMIC_GFTT", "ORB", "" },
				{ "FAST", "OPPONENT_ORB", "" },
				{ "FAST", "OPPONENT_BRISK", "" },
				{ "FAST", "BRISK", "" },
				{ "FAST", "ORB", "" },
				{ "PYRAMID_GFTT", "OPPONENT_ORB", "" },
				{ "PYRAMID_GFTT", "OPPONENT_BRISK", "" },
				{ "PYRAMID_GFTT", "BRISK", "" },
				{ "PYRAMID_GFTT", "ORB", "" },
				{ "ORB", "OPPONENT_ORB", "" },
				{ "ORB", "OPPONENT_BRISK", "" },
				{ "ORB", "BRISK", "" },
				{ "ORB", "ORB", "" },
				{ "GFTT", "OPPONENT_ORB", "" },
				{ "GFTT", "OPPONENT_BRISK", "" },
				{ "GFTT", "BRISK", "" },
				{ "GFTT", "ORB", "" } 
			};
		return pair;
	}
}
