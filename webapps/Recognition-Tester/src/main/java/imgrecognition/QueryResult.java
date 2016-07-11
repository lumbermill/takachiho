package imgrecognition;

import java.util.List;

public class QueryResult {
		public final List<Result> resultList;
		public final Feature queryImageFeature;

		public QueryResult(List<Result> resultList, Feature queryImageFeature) {
			this.resultList = resultList;
			this.queryImageFeature = queryImageFeature;
		}
}
