package sample;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
//import org.opencv.highgui.Highgui;
import org.opencv.objdetect.CascadeClassifier;

//OpenCV3から追加されたパッケージ
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

public class FaceDetection {
	public static void main(String[] args) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

		CascadeClassifier faceDetector = new CascadeClassifier(
			resourcePath("haarcascade_frontalface_default.xml"));

		Mat image = Imgcodecs.imread(resourcePath("lena.png"));

		MatOfRect faceDetections = new MatOfRect();
		faceDetector.detectMultiScale(image, faceDetections);

		for (Rect rect : faceDetections.toArray()) {
			Imgproc.rectangle(image, new Point(rect.x, rect.y),
				new Point(rect.x + rect.width, rect.y + rect.height),
				new Scalar(0, 255, 0));
		}

		Imgcodecs.imwrite("face_detection.png", image);
		System.out.println("face detection successfully finished!");
	}

	private static String resourcePath(String name) {
		return FaceDetection.class.getResource(name).getPath();
	}
}
