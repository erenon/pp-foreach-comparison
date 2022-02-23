.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.PHONY: clean

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# binlog
binlog.hpp : binlog.py
	python $< > $@

binlog_%.cpp : call_foreach.py
	echo '#include "binlog.hpp"' > $@
	python $< $* >> $@

gcc_binlog_%.ii : binlog_%.cpp binlog.hpp
	g++ -E $< > $@

clang_binlog_%.ii : binlog_%.cpp binlog.hpp
	clang++ -E $< > $@

gcc_binlog_%.time : binlog_%.cpp binlog.hpp
	/usr/bin/time -f "$* %U" g++ -E $< > /dev/null 2> $@

clang_binlog_%.time : binlog_%.cpp binlog.hpp
	/usr/bin/time -f "$* %U" clang++ -E $< > /dev/null 2> $@

# swansontec, max: 364
swansontec_%.cpp : call_foreach.py
	echo '#include "swansontec.hpp"' > $@
	python $< $* >> $@

gcc_swansontec_%.ii : swansontec_%.cpp swansontec.hpp
	g++ -E $< > $@

clang_swansontec_%.ii : swansontec_%.cpp swansontec.hpp
	clang++ -E $< > $@

gcc_swansontec_%.time : swansontec_%.cpp swansontec.hpp
	/usr/bin/time -f "$* %U" g++ -E $< > /dev/null 2> $@

clang_swansontec_%.time : swansontec_%.cpp swansontec.hpp
	/usr/bin/time -f "$* %U" clang++ -E $< > /dev/null 2> $@

# hobbes, max: 513
hobbes_%.cpp : call_foreach.py
	echo '#include "hobbes.hpp"' > $@
	python $< $* >> $@

gcc_hobbes_%.ii : hobbes_%.cpp hobbes.hpp
	g++ -E $< > $@

clang_hobbes_%.ii : hobbes_%.cpp hobbes.hpp
	clang++ -E $< > $@

gcc_hobbes_%.time : hobbes_%.cpp hobbes.hpp
	/usr/bin/time -f "$* %U" g++ -E $< > /dev/null 2> $@

clang_hobbes_%.time : hobbes_%.cpp hobbes.hpp
	/usr/bin/time -f "$* %U" clang++ -E $< > /dev/null 2> $@

TIMES := X_1.time X_2.time X_4.time X_8.time X_16.time X_32.time X_64.time X_128.time X_256.time X_364.time

%.times : $(subst X,%,${TIMES})
	cat $^ > $@

%.svg : %_binlog.times %_swansontec.times %_hobbes.times
	gnuplot \
		-e 'set terminal svg' \
		-e 'set output "$@"' \
		-e 'set key left top' \
		-e 'set title "$* preprocessing times"' \
		-e 'set xlabel "Number of FOREACH arguments"' \
		-e 'set ylabel "Time spent in userspace preprocessing (seconds)"' \
		-e 'set xrange [1 : 364]' \
		-e 'plot "$*_binlog.times" with lines title "binlog" linecolor "blue", "$*_swansontec.times" with lines title "swansontec" linecolor "black", "$*_hobbes.times" with lines title "hobbes" linecolor "red"'

clean :
	rm -f *.time *.times *.svg binlog.hpp *.ii *.cpp
