
import sys
from timeit import default_timer as timer
from math import floor
import string
import random
import pyspaces

warmup_iterations = 10000
tuples = 10000
fill_level = 1000000


def randint():
    return random.randint(0, 0xfffffff)

def randstring(length):
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))

def randdoublearray(length):
    return [ random.random() for _ in range(length) ]


def experiment_put(tg, level):
    print("connecting to space")
    space = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')

    if level == "filled":
        print("generating fill level");
        for i in range(fill_level):
            space.put(next(tg))

    print("generating benchmark tuples");
    entries = [ next(tg) for _ in range(tuples) ]

    print("performing benchmark");
    for i in range(tuples):
        t1 = timer()
        space.put(entries[i])
        t2 = timer()
        print('time: %sns' % floor((t2 - t1) * 10**9))


def experiment_take(tg, level):
    print("connecting to space")
    space = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')

    if level == "filled":
        print("generating fill level");
        for i in range(fill_level):
            space.put(next(tg))

    print("performing benchmark");
    for i in range(tuples):
        space.put(next(tg))
        t1 = timer()
        space.take((None, None))
        t2 = timer()
        print('time: %sns' % floor((t2 - t1) * 10**9))


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
    else:
        raise Exception("unsupported tupletype %s", tupletype)


    if operation == "put":
        experiment_put(tg, level)
    elif operation == "take":
        experiment_take(tg, level)
    else:
        raise Exception("unsupported operation %s", operation)

if __name__ == '__main__':
    main(sys.argv)
