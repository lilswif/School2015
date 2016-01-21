# Installation & Usage of JMeter on Windows

### Installation
Download Apache JMeter 2.13 from http://jmeter.apache.org/download_jmeter.cgi 

### GuiSession
1. Unzip the file and open the file by going into bin -> ApacheJMeter.
2. Open the template "build-web-test-plan".
3. Under the tab HTTP Request Defaults you set your server IP that you want to loadtest (port number).
4. At tab Home page you set the page you want to loadtest from your server <ip>/page.
5. Vagrant up your server that u want to set under siege.
6. Set at JMeter Users(thread group) the amount of users you want, and the amount of seconds.
7. Go to the tab Graph Results and press the start button or the shortcut CTRL + R.
8. Set at graph results the destination path for the results where it should be written to.
9. You should now be able to see some action and curves at the display.

### Make output file:

 - Visit_homepage.jmx
 
### Define wich sites/pages to besiege
In this example we besiege multiple pages of the Wordpress site from our stack.

1. Make a new HTTP request (under sampler -> http request).
2. Add all the IP-addresses:

- 192.168.56.77/wordpress/
- 192.168.56.77/wordpress/index.php/2015/09/21/demo-post-48/
- 192.168.56.77/wordpress/index.php/category/uncategorized/

### Configure test scenario 

### Start attack: Run test or CTRL + R !!!