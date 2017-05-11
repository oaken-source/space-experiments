
import net.jini.core.entry.Entry;

public class IntEntry implements Entry {

    public Integer _i;
    public Integer _j;

    public IntEntry(Integer i, Integer j) {
        this._i = i;
        this._j = j;
    }

    public IntEntry() {
        this(null, null);
    }

    public String toString() {
        return "(" + Integer.toString(this._i) + ", " + Integer.toString(this._j) + ")";
    }
}
