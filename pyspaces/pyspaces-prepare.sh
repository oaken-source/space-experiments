
# check for prerequisites
if ! type -p virtualenv > /dev/null; then
  echo "missing prerequesite: virtualenv" >&2; exit 2
fi
if ! type -p python3 > /dev/null; then
  echo "missing prerequesite: python3" >&2; exit 2
fi
if ! type -p git > /dev/null; then
  echo "missing prerequesite: git" >&2; exit 2
fi

# create new virtualenv if reqired
if [ ! -d .venv ]; then
  virtualenv -p python3 .venv
fi

# activate the virtualenv
PS1="" source .venv/bin/activate

if [ ! -f pyspaces/setup.py ]; then
  git submodule update --init
fi

# install pyspaces server to virtualenv
if ! python -c 'from pyspaces import PySpace' &> /dev/null; then
  cd pyspaces
  python setup.py develop
  cd ..
fi
