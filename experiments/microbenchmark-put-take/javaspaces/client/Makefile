
JAVAC = javac
JAVAFLAGS = -classpath .:$(LIB)/start.jar:$(LIB)/jsk-lib.jar:$(LIB)/outrigger.jar

CLASSES = \
	Client.class \
	Utils.class \
	SpaceHelper.class \
	NullEntry.class \
	IntEntry.class \
	StringEntry.class \
	DoubleArrayEntry.class

.PHONY: all
all: $(CLASSES)

.PHONY: clean
clean:
	$(RM) $(CLASSES)

%.class: %.java
	$(JAVAC) $< $(JAVAFLAGS)
