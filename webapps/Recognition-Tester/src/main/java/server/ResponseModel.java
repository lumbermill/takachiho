package server;

import imgrecognition.Result;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ResponseModel {
	public final long time;
	public final List<ResultModel> results;

	public ResponseModel(long time, List<Result> results, Map<String, Map<String, String>> itemInfo) {
		this.time = time;
		this.results = new ArrayList<ResultModel>();
		for (Result result : results) {
			this.results.add(new ResultModel(result.id, result.score, itemInfo));
		}
	}

	public static class ResultModel {
		private static final String SRC_FORMAT = "/label-image/%s.jpg";
		public final String labelImgSrc;
		public final String id;
		public final String jan;
		public final String label;
		public final int score;

		public ResultModel(String id, int score, Map<String, Map<String, String>> itemInfo) {
			this.labelImgSrc = String.format(SRC_FORMAT, id);
			this.id = id;
			this.score = score;
			Map<String, String> info = itemInfo.get(id);
			this.label = info.get("label");
			this.jan   = info.get("jan");
		}		
	}
}
