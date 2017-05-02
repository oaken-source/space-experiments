
import com.sun.jini.start.LifeCycle;
import java.util.Scanner;
import net.jini.config.Configuration;
import net.jini.config.ConfigurationProvider;
import net.jini.core.entry.Entry;
import net.jini.core.lookup.ServiceItem;
import net.jini.core.lookup.ServiceTemplate;
import net.jini.lookup.ServiceDiscoveryManager;
import net.jini.security.ProxyPreparer;
import net.jini.space.JavaSpace;
import net.jini.core.lookup.ServiceRegistrar;
import net.jini.core.lookup.ServiceMatches;
import net.jini.core.lease.Lease;
import net.jini.core.discovery.LookupLocator;

public class Connect {

    private static final String MODULE="org.apache.river.examples.hello.client";

    public Connect(final String[] args, LifeCycle lc) {
        main(args);
    }

    public static synchronized void main(String[] args) {
        try {
            LookupLocator ll = new LookupLocator("jini://localhost:4160");
            ServiceRegistrar sr = ll.getRegistrar();

            ServiceTemplate template = new ServiceTemplate(
                    null,
                    new Class[] { JavaSpace.class },
                    new Entry[0]);

            ServiceMatches sms = sr.lookup(template, 10);
            if (0 == sms.items.length) {
                System.out.println("No JavaSpace found.");
                return;
            }

            JavaSpace space = (JavaSpace) sms.items[0].service;

            NullEntry entry = new NullEntry();
            space.write(entry, null, Lease.FOREVER);

        } catch (Exception ex) {
            ex.printStackTrace();
	    System.exit(1);
        }
    }
}
