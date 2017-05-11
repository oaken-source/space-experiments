
import pyspaces


def main():
    with pyspaces.PySpaceShMem('ConnectMicroBenchPyspace') as space:
        space.put((None,))


if __name__ == '__main__':
    main()
