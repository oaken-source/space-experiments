
import pyspaces


def main():
    p = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')
    print('consuming tuple: %s' % str(p.take(('hello', None))))


if __name__ == '__main__':
    print('this is consumer')
    main()
