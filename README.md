# Applipedia Parser
Palo Alto Networks provides an free overview about theire application classification at https://applipedia.paloaltonetworks.com.
This can be used by Palo Alto Customers to check what an specific app is categorised by Palo Alto Firewalls.

Sadly this information is not available in a machine usable format.

So this quick and dirty Ruby Script is scarping the data and generating a big CSV with all Details.

I tested a full download, which takes about 15 minutes - mostly because every detail page of the ~ 3000 apps have to be opend with a POST Request.

Please feel free to contribute improvements, e.g.

- do some CLI improvements
- prallel requests
- error handling
- only request missing / changed app details
- code quality ;)

# Useage
The App generates two kind of CSV, one big overview List, and one Detail List with all the app details.
You have to modify main.rb (uncomment methods)
#Gernate the App List (applipedia_list.csv)
#get_list
#Generate the Full Detail CSV (applipedia_detail_list.csv)
#I recommend to test the functionality with a "short list" - applipedia_short_list
#get_details

# Other todos
- Thor CLI
- method to parse only the delta - identify new / changed apps utilizing https://github.com/PaloAltoNetworks/SplunkforPaloAltoNetworks/blob/develop/bin/retrieveNewApps.py which points to: https://ww2.paloaltonetworks.com/iphone/NewApps.aspx (seems to be currently unavailable!)
