
import net.jini.core.entry.Entry;

public class DoubleArrayEntry implements Entry {

    public double[] _a;
    public double[] _b;

    public DoubleArrayEntry(double[] a, double[] b) {
        this._a = a;
        this._b = b;
    }

    public DoubleArrayEntry() {
        this(null, null);
    }

    public String toString() {
        return "([" + Double.toString(_a[0]) + ", ...], [" + Double.toString(_b[0]) + ", ...])";
    }
}
