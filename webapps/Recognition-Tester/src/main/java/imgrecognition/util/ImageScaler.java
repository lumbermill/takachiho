package imgrecognition.util;

import java.nio.file.Path;

import org.opencv.core.Mat;
import org.opencv.core.Size;
//import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

//openCV3
import org.opencv.imgcodecs.Imgcodecs;

public class ImageScaler {

	private ImageScaler() {}

	public static void adjustWidth(Path sourceImagePath, double width) {
		Mat sourceImage = Imgcodecs.imread(sourceImagePath.toString());
		double scale = width / sourceImage.width();
		Size size = new Size(width, sourceImage.height() * scale);
		Imgproc.resize(sourceImage, sourceImage, size);
		Imgcodecs.imwrite(sourceImagePath.toString(), sourceImage);
	}
}
