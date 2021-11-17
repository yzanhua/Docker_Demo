EXECS=hello_world_exec
MPICC?=mpicc

all: ${EXECS}

hello_world_exec: hello_world.c
	${MPICC} -o hello_world_exec hello_world.c
run:
	mpiexec -n 4 ./hello_world_exec
clean:
	rm -f ${EXECS}