tests: list_tests run_tests
tests_clean:
	rm -f testlist *.out

clean: tests_clean
list_tests:
	./list-tests > testlist

run_tests:
	./run-tests -v
