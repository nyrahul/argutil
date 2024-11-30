#!/bin/bash

. cmd.sh

testfail=0
testcnt=0

print_status()
{
	echo "Tests total : $testcnt"
	echo "Tests failed: $testfail"
}

status_fail()
{
	echo "TEST FAIL: $1"
}

test_help()
{
	# help check
	out=$(cluster_list_cmd --help)
	[[ $? -ne 2 ]] && status_fail "help did not return the right return value" && return 1
	[[ "$(cat exp_help.txt)" != "$out" ]] && \
		status_fail "help did not return the right output" && return 1
	return 0
}

test_spec()
{
	# spec check
	out=$(cluster_list_cmd --spec xyz)
	[[ $? -ne 0 ]] && status_fail "spec did not return the right return value" && return 1
	[[ "handling spec_handler option=[xyz]" != "$out" ]] && \
		status_fail "spec did not return the right output" && return 1
	return 0
}

test_nodes()
{
	out=$(cluster_list_cmd --nodes)
	[[ $? -ne 0 ]] && status_fail "nodes did not return the right return value" && return 1
	[[ "setting show nodes" != "$out" ]] && \
		status_fail "nodes did not return the right output" && return 1

	return 0
}

run_tests()
{
	for t in $(declare -F | grep "declare -f test_" | awk '{print $3}'); do
		echo "executing [$t] ..."
		((testcnt++))
		$t
		[[ $? -ne 0 ]] && ((testfail++))
	done
}

run_tests
print_status
