#! /bin/bash
if [ $# != 1 ] || [ $1 != "validate" -a $1 != "full" ]; then
    echo "Please pass 'validate' or 'full' parameter."
    exit 1
fi

run_command()
{
    echo "Running: $1"
    $1
    if [ $? != 0 ]; then
        echo "Failed: $1"
        exit 1
    else
        echo "Passed: $1"
    fi
}

COMMANDS=()

if [ $1 == "validate" ] || [ $1 == "full" ]
then
    COMMANDS+=("terraform fmt -check=true")
    COMMANDS+=("terraform init -backend=false")
    COMMANDS+=("terraform validate")
    COMMANDS+=("dep ensure")
fi

if [ $1 == "full" ]; then
    COMMANDS+=("go test -v ./test/ -timeout 20m")
fi

for command in "${COMMANDS[@]}"
do
    run_command "$command"
done