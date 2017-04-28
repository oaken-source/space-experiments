
# check whether we're on GNU+Linux or Darwin
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	SED=sed
elif [[ "$OSTYPE" == "darwin"* ]]; then
	if ! type -p gsed > /dev/null; then
	  echo "missing prerequesite: gsed" >&2; exit 2
	fi
    SED=gsed
else
	echo "unkown OS: $OSTYPE" >&2; exit 2
fi

# check for prerequerites
if ! type -p wget > /dev/null; then
  echo "missing prerequesite: wget" >&2; exit 2
fi
if ! type -p unzip > /dev/null; then
  echo "missing prerequesite: unzip" >&2; exit 2
fi
if ! type -p mvn > /dev/null; then
  echo "missing prerequesite: maven" >&2; exit 2
fi
if ! type -p javac > /dev/null; then
  echo "missing prerequesite: jdk" >&2; exit 2
fi
if ! type -p java > /dev/null; then
  echo "missing prerequesite: jre" >&2; exit 2
fi

# prepare environment
export APACHE_RIVER_HOME="$(pwd)/packages/apache-river-2.2.2"
export RIVER_EXAMPLES_HOME="$(pwd)/packages/river-examples-1.0"
export LIB=$RIVER_EXAMPLES_HOME/home/target/home-1.0-bin/lib

export JVM_ARGS="-Djava.security.manager -Djava.security.policy=$(pwd)/servers/javaspaces/server.policy -Djava.rmi.server.useCodebaseOnly=false"

# fetch apache river, if not present
if [ ! -d $APACHE_RIVER_HOME ]; then
  cd packages
  if [ ! -f apache-river-2.2.2-src.tar.gz ]; then
    wget http://archive.apache.org/dist/river/river-2.2.2/apache-river-2.2.2-src.tar.gz
  fi
  tar -xf apache-river-2.2.2-src.tar.gz
  cd ..
fi
# fetch river examples, if not present
if [ ! -d $RIVER_EXAMPLES_HOME ]; then
  cd packages
  if [ ! -f river-examples-1.0-source-release.zip ]; then
    wget http://apache.mirror.iphh.net/river/river-examples-1.0/river-examples-1.0-source-release.zip
  fi
  unzip river-examples-1.0-source-release.zip
  cd ..
fi

# enable javaspaces in river-examples. this requires steps a) and b) below:
#  a) add outrigger dependency to pom.xml in river-examples
if ! grep -q "<artifactId>outrigger</artifactId>" $RIVER_EXAMPLES_HOME/pom.xml; then
  $SED -i -e'/<dependencies>/a \            <dependency>\n                <groupId>org.apache.river<\/groupId>\n                <artifactId>outrigger<\/artifactId>\n                <version>${jsk.version}<\/version>\n            <\/dependency>' $RIVER_EXAMPLES_HOME/pom.xml
fi
if ! grep -q "<artifactId>outrigger</artifactId>" $RIVER_EXAMPLES_HOME/browser/pom.xml; then
  $SED -i -e'/<dependencies>/a \            <dependency>\n                <groupId>org.apache.river<\/groupId>\n                <artifactId>outrigger<\/artifactId>\n                <version>${jsk.version}<\/version>\n            <\/dependency>' $RIVER_EXAMPLES_HOME/browser/pom.xml
fi

#  b) build the examples (mvn install && mvn site)
if [ ! -f $LIB/outrigger.jar ]; then
  pushd $RIVER_EXAMPLES_HOME
  mvn install
  mvn site
  popd
fi
