SOURCEDIR := src
SOURCES = $(shell find -name *.d)

OBJECTS := $(SOURCES:%.d=%.o)
BINARY := application
dmd_opts := 
dmd_base := dmd -betterC -g $(dmd_opts)

all: $(BINARY)

$(BINARY): $(OBJECTS)
	$(dmd_base) -of=$(BINARY) $(OBJECTS)

%.o: %.d
	$(dmd_base) -Isrc -c $< -of=$@

clean:
	rm $(BINARY) $(OBJECTS)

run: $(BINARY)
	./$(BINARY)
