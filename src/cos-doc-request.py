import requests
import xml.etree.cElementTree as ET

url="https://s3.us-south.cloud-object-storage.appdomain.cloud/cloud-object-storage-eda-folders"

r = requests.get(url)
print(r.status_code)
print(r.text)
root = ET.fromstring(r.text)
contents= root.get('Contents')
print(contents)