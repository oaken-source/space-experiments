
import pyspaces


def main():
    with pyspaces.PySpaceShMem('HelloWorldPyspace') as space:
        print('consuming tuple: %s' % str(space.take(('hello', None))))


if __name__ == '__main__':
    print('this is consumer')
    main()
