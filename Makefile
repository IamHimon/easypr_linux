OPENCV=1

EXEC=myeasypr
VPATH=./src/
OBJDIR=./obj/

CC=gcc
GCC=g++ -std=c++11 #兼容 c++11，不过在～/.bashrc中添加过了(但是不行)
LDFLAGS= -lm -pthread  -lstdc++ 
COMMON= 
CFLAGS=-Wall -Wfatal-errors 

COMMON+= -DOPENCV
CFLAGS+= -DOPENCV
LDFLAGS+= `pkg-config --libs opencv` 
COMMON+= `pkg-config --cflags opencv` 

OBJ = plate_locate.o main.o core_func.o plate.o util.o feature.o chars_segment.o chars_identify.o chars_recognise.o kv.o plate_judge.o plate_detect.o plate_recognize.o


OBJS = $(addprefix $(OBJDIR), $(OBJ))
DEPS = $(wildcard include/*.h) Makefile

all: obj results $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(COMMON) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(OBJDIR)%.o: %.cpp $(DEPS)
	$(GCC) $(COMMON) $(CFLAGS) -c $< -o $@

$(OBJDIR)%.o: %.cu $(DEPS)
	$(NVCC) $(ARCH) $(COMMON) --compiler-options "$(CFLAGS)" -c $< -o $@

obj:
	mkdir -p obj
results:
	mkdir -p results

.PHONY: clean

clean:
	rm -rf $(OBJS) $(EXEC)



