CFLAGS := -Wall -g
OBJS := memtool.o mx6dl_modules.o mx6q_modules.o mx6sl_modules.o \
		mx6sx_modules.o mx6ul_modules.o mx7d_modules.o mx6ull_modules.o \
		mx7ulp_modules.o mx8mq_modules.o

memtool_nxp: $(OBJS)
	$(CC) -o memtool_nxp $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) memtool_nxp

tags: FORCE
	ctags -R
	find ./ -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" > cscope.files
	cscope -bkq -i cscope.files
PHONY += FORCE
FORCE:
