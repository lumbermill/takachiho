package imgrecognition;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.xml.bind.DatatypeConverter;

import org.opencv.core.Mat;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class TrainDataCache {

	private static String cacheDir = "./data/train-cache/";
	
	public static void saveCache(TrainData trainDatum, Path imagePath, String featureDetectorName,
			String descriptorExtractorName,String optionFile) throws NoSuchAlgorithmException, IOException {
		String cacheFileName = cacheFileName(imagePath, featureDetectorName, descriptorExtractorName, optionFile);
		ObjectOutputStream objectOutputStream = new ObjectOutputStream( new FileOutputStream(cacheDir + cacheFileName));
		objectOutputStream.writeObject(trainDatum.id);
		objectOutputStream.writeObject(matToJson(trainDatum.descriptors));
		objectOutputStream.close();
	}

	public static TrainData getCache(Path imagePath, String featureDetectorName, String descriptorExtractorName,
			String optionFile) throws NoSuchAlgorithmException, ClassNotFoundException {
		try {
			String cacheFileName = cacheFileName(imagePath, featureDetectorName, descriptorExtractorName, optionFile);
			ObjectInputStream objInStream = new ObjectInputStream(new FileInputStream(cacheDir + cacheFileName));
			String id = (String) objInStream.readObject();
			String descriptorsJSON = (String) objInStream.readObject();
			Mat descriptors = matFromJson(descriptorsJSON);
			objInStream.close();
			return new TrainData(id, descriptors);
		} catch (IOException e) {
			return null;
		}
	}
	
	private static String cacheFileName(Path trainImageRoot, String featureDetectorName,
			String descriptorExtractorName,String optionFile) throws NoSuchAlgorithmException, IOException {
		return getStringHash( trainImageRoot.toString() +  featureDetectorName
				+ descriptorExtractorName + optionFile);
	}

	private static String getStringHash(String strKey) throws NoSuchAlgorithmException, IOException {
		MessageDigest md = MessageDigest.getInstance("MD5");
		md.update(strKey.getBytes());
		byte[] digest = md.digest();
		// 16進数文字列に変換
		return DatatypeConverter.printHexBinary(digest);
	}
	
	public static String matToJson(Mat mat){        
	    JsonObject obj = new JsonObject();

	    if(mat.isContinuous()){
	        int cols = mat.cols();
	        int rows = mat.rows();
	        int elemSize = (int) mat.elemSize();    

	        byte[] data = new byte[cols * rows * elemSize];

	        mat.get(0, 0, data);

	        obj.addProperty("rows", mat.rows()); 
	        obj.addProperty("cols", mat.cols()); 
	        obj.addProperty("type", mat.type());

	        // We cannot set binary data to a json object, so:
	        // Encoding data byte array to Base64.
	        String dataString = new String(Base64.getEncoder().encodeToString(data));

	        obj.addProperty("data", dataString);            

	        Gson gson = new Gson();
	        String json = gson.toJson(obj);

	        return json;
	    } else {
	        System.out.println("Mat not continuous.");
	    }
	    return "{}";
	}

	public static Mat matFromJson(String json){
	    JsonParser parser = new JsonParser();
	    JsonObject JsonObject = parser.parse(json).getAsJsonObject();

	    int rows = JsonObject.get("rows").getAsInt();
	    int cols = JsonObject.get("cols").getAsInt();
	    int type = JsonObject.get("type").getAsInt();

	    String dataString = JsonObject.get("data").getAsString();       
	    byte[] data = Base64.getDecoder().decode(dataString.getBytes()); 

	    Mat mat = new Mat(rows, cols, type);
	    mat.put(0, 0, data);

	    return mat;
	}
}
