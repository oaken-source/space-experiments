
import pyspaces


def main():
    p = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')
    t = ('hello', 'world')
    print('producing tuple: %s' % str(t))
    p.put(t)


if __name__ == '__main__':
    print('this is producer')
    main()
