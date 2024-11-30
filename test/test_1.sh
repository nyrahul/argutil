#!/bin/bash

TMPDIR=/tmp/argutil-test-$$

. ../argutil.sh

nodes_handler()
{
	echo "setting show nodes"
	show_nodes=1
}

spec_handler()
{
	echo "handling spec_handler"
}

cluster_list_cmd()
{
	argopt 	--sopt "s" \
			--lopt "spec" \
			--needval \
			--desc "search filter for cluster names (regex based)" \
	    	--handler "spec_handler"
	argopt 	--sopt "n" \
			--lopt "nodes" \
			--desc "lists nodes from the clusters" \
			--handler "nodes_handler"
	argrun "$@"
}

mkdir -p $TMPDIR
cluster_list_cmd --help > $TMPDIR/out.txt
diff $TMPDIR/out.txt exp_help.txt

rm -rf $TMPDIR


