package server;

import imgrecognition.Result;

import java.util.ArrayList;
import java.util.List;

public class ResponseModel {
	public final long time;
	public final List<ResultModel> results;

	public ResponseModel(long time, List<Result> results) {
		this.time = time;
		this.results = new ArrayList<ResultModel>();
		for (Result result : results) {
			this.results.add(new ResultModel(result.label, result.score));
		}
	}

	public static class ResultModel {
		private static final String SRC_FORMAT = "/label-image/%s.jpg";
		public final String labelImgSrc;
		public final String label;
		public final int score;

		public ResultModel(String label, int score) {
			this.labelImgSrc = String.format(SRC_FORMAT, label);
			this.label = label;
			this.score = score;
		}
	}
}
