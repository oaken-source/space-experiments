
import pyspaces


def main():
    p = pyspaces.PySpace('http://localhost:10000')
    print('consuming %s tuple' % p.take(('hello', None)))


if __name__ == '__main__':
    print('this is consumer')
    main()
