package server;

import imgrecognition.Feature;
import imgrecognition.QueryResult;
import imgrecognition.Result;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ResponseModel {
	public final long time;
	public final List<ResultModel> results;
	public final String featureDetectorName;
	public final String descriptorExtractorName;
	public final String optionFileName;

	public ResponseModel(long time, QueryResult q_result, Map<String, Map<String, String>> itemInfo, String[] recognizer_set) {
		this.time = time;
		this.featureDetectorName = recognizer_set[0];
		this.descriptorExtractorName = recognizer_set[1];
		this.optionFileName      = recognizer_set[2];
		this.results = new ArrayList<ResultModel>();
		for (Result result : q_result.resultList) {
			this.results.add(new ResultModel(result.id, result.score, itemInfo, q_result.queryImageFeature));
		}
	}

	public static class ResultModel {
		private static final String SRC_FORMAT = "/label-image/%s.jpg";
		public final String labelImgSrc;
		public final String id;
		public final String jan;
		public final String label;
		public final int score;
		public final double similarytyRatio;

		public ResultModel(String id, int score, Map<String, Map<String, String>> itemInfo, Feature queryFeature) {
			this.labelImgSrc = String.format(SRC_FORMAT, id);
			this.id = id;
			this.score = score;
			Map<String, String> info = itemInfo.get(id);
			this.label = info.get("label");
			this.jan   = info.get("jan");
			this.similarytyRatio = (double)score / queryFeature.countOfKeyPoints(); // マッチした訓練画像特徴点の数 ÷ 質問画像の特徴点の総数
		}		
	}
}
