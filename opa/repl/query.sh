

cat <<EOF > v1-data-input.json
{
    "input": $(cat json_data/$1)
}
EOF