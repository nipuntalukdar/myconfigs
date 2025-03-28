rm -f tmp.txt
touch tmp.txt
for i in `cat dirs.txt`
do
  if [  -d $i ] ; then
    echo $i >> tmp.txt 
  fi
done
mv tmp.txt dirs.txt

