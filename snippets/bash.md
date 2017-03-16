# Bash


```
^[ + b - previous word
^[ + f - next word

^[ + . - insert previous return value



PORT=${1:-52}

for I in $(seq -w 1 31)
do
  echo $I
done

date +%y%m%d_%H%M%S
```

## at

1分後に処理を実行
```
echo 'foo.sh -t bar -e' | at now + 1minute
```
