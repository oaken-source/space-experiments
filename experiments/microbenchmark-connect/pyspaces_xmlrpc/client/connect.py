
import pyspaces


def main():
    p = pyspaces.PySpaceXMLRPCClient('http://localhost:10000')
    p.put((None,))


if __name__ == '__main__':
    main()
