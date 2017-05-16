
import com.sun.jini.start.LifeCycle;
import java.util.Scanner;
import net.jini.core.entry.Entry;
import net.jini.core.lease.Lease;
import net.jini.space.JavaSpace;

public class Client {

    private static final int tuples = 100;
    private static final int warmup_iterations = 100;
    private static final int iterations = 100;
    private static final int fill_level = 10000;

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
          case "doublearrayxl":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new DoubleArrayEntry(Utils.randDoubleArray(256), Utils.randDoubleArray(256));
                }
                public Entry makeEmpty() {
                    return new DoubleArrayEntry();
                }
            };
            break;
          case "doublearrayxxl":
            tg = new TupleGenerator() {
                public Entry make() {
                    return new DoubleArrayEntry(Utils.randDoubleArray(2048), Utils.randDoubleArray(2048));
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

    public static void experiment_put(final TupleGenerator tg, String level) throws Exception {
        System.out.println("connecting to space");
        final JavaSpace space = SpaceHelper.connect();

        if (level.equals("filled")) {
            System.out.println("generating fill level");
            for (int i = 0; i < fill_level; ++i)
              space.write(tg.make(), null, Lease.FOREVER);
        }

        System.out.println("generating benchmark tuples");
        final Entry[] entries = new Entry[tuples];
        for (int i = 0; i < tuples; ++i)
          entries[i] = tg.make();

        Runnable task = new Runnable() { public void run() {
            try {
                for (int i = 0; i < tuples; ++i)
                  space.write(entries[i], null, Lease.FOREVER);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        } };

        Runnable cleanup = new Runnable() { public void run() {
            try {
                for (int i = 0; i < tuples; ++i)
                  space.take(tg.makeEmpty(), null, Long.MAX_VALUE);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        } };

        System.out.println("warmup space");
        for (int i = 0; i < warmup_iterations; ++i) {
          task.run();
          cleanup.run();
        }

        System.out.println("performing benchmark");
        long times[] = new long[iterations];
        for (int i = 0; i < iterations; ++i)
          {
            long t1 = System.nanoTime();
            task.run();
            long t2 = System.nanoTime();
            times[i] = t2 - t1;
            cleanup.run();
          }

        for (int i = 0; i < iterations; ++i)
          System.out.println("time: " + times[i] + "ns");
    }

    public static void experiment_take(final TupleGenerator tg, String level) throws Exception {
        System.out.println("connecting to space");
        final JavaSpace space = SpaceHelper.connect();

        if (level.equals("filled")) {
            System.out.println("generating fill level");
            for (int i = 0; i < fill_level; ++i)
              space.write(tg.make(), null, Lease.FOREVER);
        }

        Runnable prepare = new Runnable() { public void run() {
            try {
                for (int i = 0; i < tuples; ++i)
                  space.write(tg.make(), null, Lease.FOREVER);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        } };

        Runnable task = new Runnable() { public void run() {
            try {
                for (int i = 0; i < tuples; ++i)
                  space.take(tg.makeEmpty(), null, Long.MAX_VALUE);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        } };

        System.out.println("warmup space");
        for (int i = 0; i < warmup_iterations; ++i) {
            prepare.run();
            task.run();
        }

        System.out.println("performing benchmark");
        long times[] = new long[iterations];
        for (int i = 0; i < iterations; ++i)
          {
            prepare.run();
            long t1 = System.nanoTime();
            task.run();
            long t2 = System.nanoTime();
            times[i] = t2 - t1;
          }

        for (int i = 0; i < iterations; ++i)
          System.out.println("time: " + times[i] + "ns");
    }
}
