# model="base2309"
model=$1
start=$2
end=$3

while read -r pgid; do
    kill -- -"$pgid"
done < "$model-stream.txt"

rm "$model-stream.txt"