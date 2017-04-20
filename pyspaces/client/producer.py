
import pyspaces


def main():
    p = pyspaces.PySpace('http://localhost:10000')
    t = ('hello', 'world')
    print('producing %s tuple' % str(t))
    p.put(t)


if __name__ == '__main__':
    print('this is producer')
    main()
