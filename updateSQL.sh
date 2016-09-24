#IFS=$"\n"
#for i in $(<~/Downloads/bankfile.txt)
#do
#	echo "insert "+$i+" end;"
#done 
#IFS=$oldifs

while read line
do
	echo "use luna_dev;insert into luna_bank_branch values ($line );" | /Applications/MySQLWorkbench.app/Contents/MacOS/mysql -h115.159.67.120 -uvbdev -pvb2015
	echo "insert $line end;"
#	t = 
#	/Applications/MySQLWorkbench.app/Contents/MacOS/mysql -h115.159.67.120 -uvbdev -pvb2015 -e
done < ~/Downloads/bankfile.txt
