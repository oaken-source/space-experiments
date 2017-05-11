
import com.sun.jini.start.LifeCycle;
import java.util.Scanner;
import net.jini.core.entry.Entry;
import net.jini.core.lease.Lease;
import net.jini.space.JavaSpace;

public class Client {

    private static final int warmup_iterations = 10000;
    private static final int tuples = 10000;
    private static final int fill_level = 1000000;

    abstract static class TupleGenerator {
        abstract Entry make();
        abstract Entry makeEmpty();
    };

    public Client(final String[] args, LifeCycle lc) throws Exception {
        main(args);
    }

    public static synchronized void main(String[] args) throws Exception {
        String operation = System.getenv("operation");
        String tupletype = System.getenv("tupletype");
        String level = System.getenv("level");

        System.out.println("operation: " + operation);
        System.out.println("tupletype: " + tupletype);
        System.out.println("level:     " + level);

        TupleGenerator tg;
        switch (tupletype) {
          case "null":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new NullEntry();
                }
                public Entry makeEmpty() {
                    return new NullEntry();
                }
            };
            break;
          case "int":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new IntEntry(Utils.randInt(), Utils.randInt());
                }
                public Entry makeEmpty() {
                    return new IntEntry();
                }
            };
            break;
          case "string":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new StringEntry(Utils.randString(32), Utils.randString(32));
                }
                public Entry makeEmpty() {
                    return new StringEntry();
                }
            };
            break;
          case "doublearray":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new DoubleArrayEntry(Utils.randDoubleArray(32), Utils.randDoubleArray(32));
                }
                public Entry makeEmpty() {
                    return new DoubleArrayEntry();
                }
            };
            break;
          default:
            throw new RuntimeException("unknown tupletype: " + tupletype);
        }

        switch(operation) {
          case "put":
            experiment_put(tg, level);
            break;
          case "take":
            experiment_take(tg, level);
            break;
          default:
            throw new RuntimeException("invalid operation: " + operation);
        }
    }

    public static void experiment_put(TupleGenerator tg, String level) throws Exception {
        System.out.println("connecting to space");
        final JavaSpace space = SpaceHelper.connect();

        System.out.println("warmup space");
        for (int i = 0; i < warmup_iterations; ++i)
          space.write(tg.make(), null, Lease.FOREVER);
        for (int i = 0; i < warmup_iterations; ++i)
          space.take(tg.makeEmpty(), null, Long.MAX_VALUE);

        if (level.equals("filled")) {
            System.out.println("generating fill level");
            for (int i = 0; i < fill_level; ++i)
              space.write(tg.make(), null, Lease.FOREVER);
        }

        System.out.println("generating benchmark tuples");
        final Entry[] entries = new Entry[tuples];
        for (int i = 0; i < tuples; ++i)
          entries[i] = tg.make();

        class PutTask implements Runnable {
            private int i = 0;
            public void run() {
                try {
                    space.write(entries[i++], null, Lease.FOREVER);
                }
                catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        };
        PutTask task = new PutTask();

        System.out.println("performing benchmark");
        for (int i = 0; i < tuples; ++i)
          {
            long t1 = System.nanoTime();
            task.run();
            long t2 = System.nanoTime();
            System.out.println("time: " + (t2 - t1) + "ns");
          }
    }

    public static void experiment_take(final TupleGenerator tg, String level) throws Exception {
        System.out.println("connecting to space");
        final JavaSpace space = SpaceHelper.connect();

        System.out.println("warmup space");
        for (int i = 0; i < warmup_iterations; ++i)
          space.write(tg.make(), null, Lease.FOREVER);
        for (int i = 0; i < warmup_iterations; ++i)
          space.take(tg.makeEmpty(), null, Long.MAX_VALUE);

        if (level.equals("filled")) {
            System.out.println("generating fill level");
            for (int i = 0; i < fill_level; ++i)
              space.write(tg.make(), null, Lease.FOREVER);
        }

        Runnable task = new Runnable() { public void run() {
            try {
                space.take(tg.makeEmpty(), null, Long.MAX_VALUE);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        } };

        System.out.println("performing benchmark");
        for (int i = 0; i < tuples; ++i)
          {
            space.write(tg.make(), null, Lease.FOREVER);
            long t1 = System.nanoTime();
            task.run();
            long t2 = System.nanoTime();
            System.out.println("time: " + (t2 - t1) + "ns");
          }
    }
}
