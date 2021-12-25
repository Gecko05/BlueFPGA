CC = g++
CPPFLAGS = -Wall -g -std=c++11
OBJS = main.o Instructions.o
DEPS = Instructions.h
OUTEXEC = blue

all: main

main: $(OBJS) $(DEPS)
	$(CC) $(CPPFLAGS) -o $(OUTEXEC) $(OBJS)

%.o: %.cpp $(DEPS)
	$(CC) $(CPPFLAGS) -c -o $@ $<

clean:
	rm $(OUTEXEC) *.o