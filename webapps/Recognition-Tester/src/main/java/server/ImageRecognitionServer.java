package server;

import imgrecognition.ImageRecognizer;
import imgrecognition.Result;
import imgrecognition.util.ImageScaler;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.arnx.jsonic.JSON;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

@SuppressWarnings("serial")
public class ImageRecognitionServer extends HttpServlet {
	private final ServletFileUpload upload =
		new ServletFileUpload(new DiskFileItemFactory());
	private final ImageRecognizer recognizer;
	private final Path queryImageDir;

	public ImageRecognitionServer() throws IOException {
		recognizer = new ImageRecognizer(Paths.get("./data/train-image/"));
		queryImageDir = Paths.get("./data/query-image/");
		Files.createDirectories(queryImageDir);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		res.setContentType("application/json;charset=UTF-8");
		Path queryImagePath = extractQuery(req);
		// 質問画像のサイズを調整
		ImageScaler.adjustWidth(queryImagePath, 480);
		// 認識処理にかかる時間を測定
		long startTime = System.currentTimeMillis();
		List<Result> results = recognizer.recognize(queryImagePath);
		long time = System.currentTimeMillis() - startTime;
		// 結果をJSON形式で送信
		res.getWriter().print(JSON.encode(new ResponseModel(time, results)));
	}

	private Path extractQuery(HttpServletRequest req) {
		try {
			FileItem item = (FileItem) upload.parseRequest(req).get(0);
			Path dataPath = queryImageDir.resolve(item.getName());
			item.write(dataPath.toFile());
			return dataPath;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public static void main(String[] args) throws Exception {
		Server server = new Server(8080);
		WebAppContext context = new WebAppContext("./webapp", "/");
		server.setHandler(context);
		server.start();
		server.join();
	}
}