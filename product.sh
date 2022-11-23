# Unix product inventory project
#!/bin/bash
menu_choice=""
record_file="productrec.ldb"
temp_file=/tmp/ldb.$$
touch $temp_file; chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT


get_return()
{
	printf '\tClick Enter\n'
	read x
	return 0
}

get_confirm()
{
	printf '\tAre you sure?\n'
	while true
	do
	  read x
	  case "$x" in
	y|yes|Y|Yes|YES)
	      return 0;;
	n|no|N|No|NO)
	printf '\ncancelled\n'
		  return 1;;
	      *) printf 'Please enter yes or no';;
	esac
	done
}

set_menu_choice()
{
	clear
	printf '\nMenu:-'
	printf '\n'
	printf '\ta) Add new product records\n'
	printf '\tb) Find product\n'
	printf '\tc) Edit product\n'
	printf '\td) Remove product\n'
	printf '\te) View products\n'
	printf '\tf) Quit\n'
	printf 'Please enter your choice and then press enter\n'
	read menu_choice
	return
}

insert_record()
{
	echo $* >>$record_file
	return
}

add_products()
{

	printf 'Enter product category:-'
	read tmp
	Cat=${tmp%%,*}

	printf 'Enter product name:-'
	read tmp
	Name=${tmp%%,*}

	printf 'Enter MRP:-'
	read tmp
	MRP=${tmp%%,*}

	printf 'Enter Quantity:-'
	read tmp
	QTY=${tmp%%,*}

	#Check that the user wants to add info
	printf 'About to add new entry\n'
	printf "$Cat\t$Name\t$MRP\t$QTY\n"

	#If confirmed,append it to the record file
	if get_confirm; then
	insert_record $Cat:$Name-Rs. $MRP [ Qty=$QTY ]
	fi

	return
}

find_products()
{
	  echo "Enter product name to find:"
	  read product2find
	  grep $product2find $record_file> $temp_file

	  linesfound=`cat $temp_file|wc -l`

	  case `echo $linesfound` in
	  0)    echo "Sorry, nothing found"
	get_return
		return 0
		;;
	  *)    echo "Found the following"
		cat $temp_file
	get_return
		return 0
	esac
	return
}

remove_products() 
{

	linesfound=`cat $record_file|wc -l`

	   case `echo $linesfound` in
	   0)    echo "Sorry, nothing found\n"
	get_return
		 return 0
		 ;;
	   *)    echo "Found the following\n"
		 cat $record_file ;;
	esac
	printf "Type the product name you want to delete\n"
	 read searchstr

	  if [ "$searchstr" = "" ]; then
	      return 0
	   fi
	 grep -v "$searchstr" $record_file> $temp_file
	 mv $temp_file $record_file
	printf "Product has been removed\n"
	get_return
	return
}

view_products()
{
	printf "List of products are:\n"
	cat $record_file
	get_return
	return
}



edit_products()
{
	printf "List of products are:\n"
	cat $record_file
	printf "Type the name of the product you want to edit\n"
	read searchstr
	  if [ "$searchstr" = "" ]; then
	     return 0
	  fi
	  grep -v "$searchstr" $record_file> $temp_file
	  mv $temp_file $record_file
	printf "Enter the new record\n"
	add_products
}

rm -f $temp_file
if [!-f $record_file];then
touch $record_file #creates empty file
fi

clear
printf '\n\n\n'
printf '***Product Management***'
sleep 1

quit="n"
while [ "$quit" != "y" ];
do

set_menu_choice
case "$menu_choice" in
a) add_products;;
b) find_products;;
c) edit_products;;
d) remove_products;;
e) view_products;;
f) quit=y;;
*) printf "Sorry, invalid choice.";;
esac
done
#end
rm -f $temp_file
echo "Finished"

exit 0