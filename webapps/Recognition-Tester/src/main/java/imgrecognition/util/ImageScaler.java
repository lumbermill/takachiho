package imgrecognition.util;

import java.nio.file.Path;

import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.highgui.Highgui;
import org.opencv.imgproc.Imgproc;

public class ImageScaler {

	private ImageScaler() {}

	public static void adjustWidth(Path sourceImagePath, double width) {
		Mat sourceImage = Highgui.imread(sourceImagePath.toString());
		double scale = width / sourceImage.width();
		Size size = new Size(width, sourceImage.height() * scale);
		Imgproc.resize(sourceImage, sourceImage, size);
		Highgui.imwrite(sourceImagePath.toString(), sourceImage);
	}
}
