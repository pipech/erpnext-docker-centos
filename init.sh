
if [ -d "/home/frappe/frappe-bench/apps-temp" ]; then

	sudo mv /home/frappe/frappe-bench/sites-temp/* /home/frappe/frappe-bench/sites
	rm -rf /home/frappe/frappe-bench/sites-temp
	echo "Moved sites Folder"

	sudo mv /home/frappe/frappe-bench/apps-temp/* /home/frappe/frappe-bench/apps
	rm -rf /home/frappe/frappe-bench/apps-temp
	echo "Moved apps Folder"
	
	sudo mysql --user="root" --password="12345" --execute="
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION; 
	CREATE USER 'root'@'%' IDENTIFIED BY '12345';
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
	"
	echo "mySQL Create User, Done"
	
fi
