package imgrecognition;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.opencv.core.Mat;
import org.opencv.core.MatOfDMatch;
//import org.opencv.features2d.DMatch;
import org.opencv.features2d.DescriptorMatcher;

//OpenCV3
import org.opencv.core.DMatch;

public class DescriptorsVoter {
	// FLANNアルゴリズムはSIFT以外で上手く動作しなかったので別のアルゴリズムでマッチングする
	private final DescriptorMatcher matcher = DescriptorMatcher.create(DescriptorMatcher.BRUTEFORCE_HAMMING);

	// Resultを得点の高いものから降順にソートするためのComparator
	private final Comparator<Result> comparator = new Comparator<Result>() {
		@Override
		public int compare(Result left, Result right) {
			return -Integer.compare(left.score, right.score);
		}
	};

	public List<Result> vote(Mat queryDescriptors, List<TrainData> trainData) {
		// 質問画像の各キーポイントのインデックスに対してMatchを格納したMapを用意
		Map<Integer, Match> matches = new HashMap<Integer, Match>();
		// 質問画像の各特徴量に対して距離の一番小さい訓練画像の特徴量を決める
		for (TrainData data : trainData) {
			for (Match match : match(queryDescriptors, data)) {
				updateMatches(matches, match);
			}
		}

		// 各ラベルに得票数を対応させるMapを用意
		Map<String, Integer> scores = new HashMap<String, Integer>();
		// 各ラベルで距離が一番小さいとされた回数をカウント
		for (Match match : matches.values()) {
			int oldScore = scores.containsKey(match.id) ? scores.get(match.id) : 0;
			scores.put(match.id, oldScore + 1);
		}

		// scoresをList<Result>へ変換
		List<Result> results = new ArrayList<Result>();
		for (Entry<String, Integer> e : scores.entrySet()) {
			results.add(new Result(e.getKey(), e.getValue()));
		}

		// 得点の高いものから降順に並び替える
		Collections.sort(results, comparator);
		return results;
	}

	// 質問画像の特徴量と訓練画像の特徴量のマッチング処理
	private List<Match> match(Mat queryDescriptors, TrainData trainData) {
		MatOfDMatch dMatches = new MatOfDMatch();
		matcher.match(queryDescriptors, trainData.descriptors, dMatches);
		List<Match> result = new ArrayList<Match>();
		for (DMatch dMatch : dMatches.toArray()) {
			result.add(new Match(trainData.id, dMatch));
		}
		return result;
	}

	// 与えられたマッチング結果の距離が対応するインデックスのマッチング結果の距離よりも小さいとき、その結果を書き換える
	private void updateMatches(Map<Integer, Match> matches, Match match) {
		int queryIndex = match.queryIndex;
		if (!matches.containsKey(queryIndex) || match.distance < matches.get(queryIndex).distance) {
			matches.put(queryIndex, match);
		}
	}

	// 質問画像の特徴量とマッチングした訓練画像（ラベル）の特徴量の距離を格納するためのクラス
	private static class Match {
		public final String id;
		public final int queryIndex;
		public final double distance;

		public Match(String id, DMatch match) {
			this.id = id;
			queryIndex = match.queryIdx;
			distance = match.distance;
		}
	}
}
