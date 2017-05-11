
import java.util.Random;

public class Utils {

    public static String join(String[] arr, String sep) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.length; ++i) {
            if (i > 0)
              sb.append(sep);
            sb.append(arr[i]);
        }
        return sb.toString();
    }

    private static Random r = new Random();

    public static int randInt() {
        return r.nextInt();
    }

    private static final char[] charset = "0123456789abcdefghijklmnopqrstuvwxyz".toCharArray();

    public static String randString(int length) {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; ++i)
          sb.append(charset[r.nextInt(charset.length)]);

        return sb.toString();
    }

    public static double[] randDoubleArray(int length) {
        double[] res = new double[length];

        for (int i = 0; i < length; ++i)
          res[i] = r.nextDouble();

        return res;
    }

}
