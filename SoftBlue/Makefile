CC = g++
CPPFLAGS = -Wall -g
OBJS = main.o Instructions.o
DEPS = Instructions.h

all: main

main: $(OBJS) $(DEPS)
	$(CC) $(CPPFLAGS) -o main $(OBJS)

%.o: %.cpp $(DEPS)
	$(CC) $(CPPFLAGS) -c -o $@ $<

clean:
	rm main *.o