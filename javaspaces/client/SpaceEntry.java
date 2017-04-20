
import net.jini.core.entry.Entry;

public class SpaceEntry implements Entry {

    public String a;
    public String b;

    public SpaceEntry(String a, String b) {
        this.a = a;
        this.b = b;
    }

    public SpaceEntry() {
        this(null, null);
    }

    public String toString() {
        return "('" + a + "', '" + b + "')";
    }
}
