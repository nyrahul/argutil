# argutil
Simpler argument parsing for bash. Simpler bash API layer on top of getopt.

# Example

The steps are as follows:
1. add as many `argopt` as needed
2. run `argrun "$@"` once all argopts are added

```bash
. argutil.sh #source argutil

nodes_handler()
{
	echo "setting show nodes"
	show_nodes=1
}

spec_handler()
{
	echo "handling spec_handler arg=[$1]"
}

myinit()
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

myinit --spec "xyz" --nodes
```

# argopt specification

* --sopt: short hand option character
* --lopt: long hand option string
* --needval: use if the option requires a value
* --desc: help description for the option
* --handler: shell function handler if the option is seen. Optional argument is passed to the handler.

