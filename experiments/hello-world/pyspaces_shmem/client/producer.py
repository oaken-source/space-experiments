
import pyspaces


def main():
    t = ('hello', 'world')
    print('producing tuple: %s' % str(t))
    with pyspaces.PySpaceShMem('HelloWorldPyspace') as space:
        space.put(t)


if __name__ == '__main__':
    print('this is producer')
    main()
