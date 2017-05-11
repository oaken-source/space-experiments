
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
import net.jini.core.discovery.LookupLocator;

public class SpaceHelper {

    public static JavaSpace connect() throws Exception {
        LookupLocator ll = new LookupLocator("jini://localhost:4160");
        ServiceRegistrar sr = ll.getRegistrar();

        ServiceTemplate template = new ServiceTemplate(null,
                                                       new Class[] { JavaSpace.class },
                                                       new Entry[0]);

        ServiceMatches sms = sr.lookup(template, 10);

        if (0 == sms.items.length) {
            throw new RuntimeException("No JavaSpace found.");
        }
        return (JavaSpace) sms.items[0].service;
    }

}
