
JAVAC = javac
JAVAFLAGS = -classpath .:$(LIB)/start.jar:$(LIB)/jsk-lib.jar:$(LIB)/outrigger.jar

CLASSES = Connect.class NullEntry.class

.PHONY: all
all: $(CLASSES)

.PHONY: clean
clean:
	$(RM) $(CLASSES)

%.class: %.java
	$(JAVAC) $< $(JAVAFLAGS)
