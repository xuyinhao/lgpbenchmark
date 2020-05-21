val="1:mkdir 1-1"
aa=$(echo "$val"|awk -F :  '{print $1}')
echo $aa
