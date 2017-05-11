
import net.jini.core.entry.Entry;

public class StringEntry implements Entry {

    public String _s;
    public String _t;

    public StringEntry(String s, String t) {
        this._s = s;
        this._t = t;
    }

    public StringEntry() {
        this(null, null);
    }

    public String toString() {
        return "('" + this._s + "', '" + this._t + "')";
    }
}
