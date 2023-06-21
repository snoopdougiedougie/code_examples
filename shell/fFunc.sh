func="function"
found="false"

cat $1 |
while read line
do
    # Look for first function
    if [ "$found" == "false" ]
    then
        if echo "$line" | grep -q "${func}"
        then
            echo "Found first function"
            found="true"
            echo "}"
            echo ""
        fi
    fi

    echo "$line"
done

echo "Done"
