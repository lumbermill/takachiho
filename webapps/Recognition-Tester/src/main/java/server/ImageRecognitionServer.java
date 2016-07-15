package server;

import imgrecognition.ImageRecognizer;
import imgrecognition.QueryResult;
import imgrecognition.util.ImageScaler;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.concurrent.CompletableFuture;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import net.arnx.jsonic.JSON;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

@SuppressWarnings("serial")
public class ImageRecognitionServer extends HttpServlet {
	private final ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
	private final Path queryImageDir;
	private final Map<String[], ImageRecognizer> recognizers = new HashMap<String[], ImageRecognizer>();
	private final Path resultJsonDir;
	private final String[][] recognizerPair = { // 認識アルゴリズムの組み合わせ＋設定ファイル名 
			{ "ORB",         "ORB", "" }, // optionは後で検討
//			{ "GRID_ORB",    "ORB", "" },
//			{ "PYRAMID_ORB", "ORB", "" },
//			{ "DYNAMIC_ORB", "ORB", "" },
//			{ "ORB",         "OPPONENT_ORB", "" },
//			{ "GRID_ORB",    "OPPONENT_ORB", "" },
//			{ "PYRAMID_ORB", "OPPONENT_ORB", "" },
//			{ "DYNAMIC_ORB", "OPPONENT_ORB", "" },
//			{ "BRISK",       "BRISK", "" },
			{ "AKAZE",       "AKAZE", "" }, };
	private final Map<String, Map<String, String>> itemInfo; // 訓練画像のラベル情報

	public ImageRecognitionServer() throws IOException {
		Iterator<String[]> iter_recognizer = Arrays.asList(recognizerPair).iterator();
		while (iter_recognizer.hasNext()) {
			String[] recognizer_set = iter_recognizer.next();
			recognizers.put(recognizer_set, createRecognizer(recognizer_set));
		}
		queryImageDir = Paths.get("./data/query-image/");
		itemInfo = loadItemInfo(Paths.get("./data/train-image/item_list.txt")); // リストのパスにする
		resultJsonDir = Paths.get("./data/result-json");
		Files.createDirectories(queryImageDir);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("application/json;charset=UTF-8");
		String queryImageHash = extractQuery(req);
		Path queryImagePath = queryImageDir.resolve(queryImageHash + ".jpg");
		// 質問画像のサイズを調整
		ImageScaler.adjustWidth(queryImagePath, 480);

		// すべての判定器を使って判定する
		Iterator<String[]> iter_recognizer = Arrays.asList(recognizerPair).iterator();
		List<ResponseModel> response = new ArrayList<ResponseModel>();
		while (iter_recognizer.hasNext()) {
			// 認識処理にかかる時間を測定
			long startTime = System.currentTimeMillis();
			String[] recognizer_set = iter_recognizer.next();
			QueryResult q_result = recognizers.get(recognizer_set).recognize(queryImagePath);
			long time = System.currentTimeMillis() - startTime;
			response.add(new ResponseModel(time, q_result, itemInfo, recognizer_set));
		}
		Map<String, Object> response_set = new HashMap<String, Object>();
		response_set.put("query_img_path", queryImagePath.toString());
		response_set.put("responses", response);

		// 結果をJSON形式で保存・送信
		String resultJSON = JSON.encode(response_set);
		this.saveResultJSON(resultJSON, queryImageHash);
		res.getWriter().print(resultJSON);
	}

	private ImageRecognizer createRecognizer(String[] recognizerPair) throws IOException {
		Map<String, String> option = new HashMap<String, String>();
		option.put("featureDetector", recognizerPair[0]);
		option.put("descriptorExtractor", recognizerPair[1]);
		option.put("optionFile", recognizerPair[2]);
		return new ImageRecognizer(Paths.get("./data/train-image/"), option);
	}

	private String extractQuery(HttpServletRequest req) {
		try {
			FileItem item = (FileItem) upload.parseRequest(req).get(0);
			String fileHash = getFileHash(item);
			Path dataPath = queryImageDir.resolve(fileHash + ".jpg");
			item.write(dataPath.toFile());
			return fileHash;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	private String getFileHash(FileItem file) throws NoSuchAlgorithmException, IOException {
		MessageDigest md = MessageDigest.getInstance("MD5");
		DigestInputStream input = new DigestInputStream(file.getInputStream(), md);
		while (input.read() != -1) {
		}
		byte[] digest = md.digest();
		input.close();
		// 16進数文字列に変換
		return DatatypeConverter.printHexBinary(digest);
	}

	// ID,JANコード,商品名をテキストファイルから読み込む
	private Map<String, Map<String, String>> loadItemInfo(Path item_list_path) throws IOException {
		Map<String, Map<String, String>> map = new HashMap<String, Map<String, String>>();
		FileReader fr = new FileReader(item_list_path.toFile());
		BufferedReader br = new BufferedReader(fr);
		String line;
		StringTokenizer token;
		while ((line = br.readLine()) != null) {
			Map<String, String> submap = new HashMap<String, String>();
			token = new StringTokenizer(line, ",");
			String id = token.nextToken();
			String jan = token.nextToken();
			String label = token.nextToken();
			submap.put("jan", jan);
			submap.put("label", label);
			map.put(id, submap);
		}
		br.close();
		return map;
	}

	private void saveResultJSON(String resultJSON, String queryImageHash) throws IOException {
		// 非同期で保存
		CompletableFuture.runAsync(() -> {
			try {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
				String now = sdf.format(new Date());
				String filename = queryImageHash + "-" + now + ".json";
				Path savePath = resultJsonDir.resolve(filename);
				File file = savePath.toFile();
				FileWriter filewriter = new FileWriter(file);
				filewriter.write(resultJSON);
				filewriter.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		});
	}

	public static void main(String[] args) throws Exception {
		Server server = new Server(8080);
		WebAppContext context = new WebAppContext("./webapp", "/");
		server.setHandler(context);
		server.start();
		server.join();
	}
}