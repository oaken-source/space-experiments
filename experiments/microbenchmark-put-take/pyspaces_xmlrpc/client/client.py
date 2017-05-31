
import sys
from timeit import default_timer as timer
from math import floor
import string
import random
import pyspaces

tuples = 100
warmup_iterations = 100
iterations = 100
fill_level = 10000


def randint():
    return random.randint(0, 0xfffffff)

def randstring(length):
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))

def randdoublearray(length):
    return [ random.random() for _ in range(length) ]


def experiment_put(space, tg, level):
    if level == "filled":
        print("generating fill level");
        for i in range(fill_level):
            space.put(next(tg))

    print("generating benchmark tuples");
    entries = [ next(tg) for _ in range(tuples) ]

    def task():
        for i in range(tuples):
            space.put(entries[i])

    def cleanup():
        for i in range(tuples):
            space.take((None, None))

    print("warmup space");
    for i in range(warmup_iterations):
        task()
        cleanup()

    print("performing benchmark");
    times = []
    for i in range(iterations):
        t1 = timer()
        task()
        t2 = timer()
        times.append(floor((t2 - t1) * 10**9))
        cleanup()

    for i in range(iterations):
        print('time: %ins' % times[i])


def experiment_take(space, tg, level):
    if level == "filled":
        print("generating fill level");
        for i in range(fill_level):
            space.put(next(tg))

    def prepare():
        for i in range(tuples):
            space.put(next(tg))

    def task():
        for i in range(tuples):
            space.take((None, None))

    print("warmup space");
    for i in range(warmup_iterations):
        prepare()
        task()

    print("performing benchmark");
    times = []
    for i in range(iterations):
        prepare()
        t1 = timer()
        task()
        t2 = timer()
        times.append(floor((t2 - t1) * 10**9))

    for i in range(iterations):
        print('time: %ins' % times[i])


def main(args):
    operation=args[1]
    tupletype=args[2]
    level=args[3]

    print('operation: %s' % operation)
    print('tupletype: %s' % tupletype)
    print('level:     %s' % level)

    tg = None
    if tupletype == "null":
        def _tg():
            while True:
                yield (None, None)
        tg = _tg()
    elif tupletype == "int":
        def _tg():
            while True:
                yield (randint(), randint())
        tg = _tg()
    elif tupletype == "string":
        def _tg():
            while True:
                yield (randstring(32), randstring(32))
        tg = _tg()
    elif tupletype == "doublearray":
        def _tg():
            while True:
                yield (randdoublearray(32), randdoublearray(32))
        tg = _tg()
    elif tupletype == "doublearrayxl":
        def _tg():
            while True:
                yield (randdoublearray(256), randdoublearray(256))
        tg = _tg()
    elif tupletype == "doublearrayxxl":
        def _tg():
            while True:
                yield (randdoublearray(2048), randdoublearray(2048))
        tg = _tg()
    else:
        raise Exception("unsupported tupletype %s", tupletype)

    print("connecting to space")
    space = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')

    if operation == "put":
        experiment_put(space, tg, level)
    elif operation == "take":
        experiment_take(space, tg, level)
    else:
        raise Exception("unsupported operation %s", operation)

if __name__ == '__main__':
    main(sys.argv)
