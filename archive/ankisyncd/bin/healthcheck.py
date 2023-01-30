import sys
import os
import urllib.request
import urllib.error

host = os.environ["ANKISYNCD_HOST"]
port = os.environ["ANKISYNCD_PORT"]
url = f"http://{host}:{port}/"

try:
    req = urllib.request.urlopen(url)
except urllib.error.HTTPError as e:
    sys.exit(1)
except urllib.error.URLError as e:
    sys.exit(1)
if req.getcode() != 200:
    sys.exit(1)
sys.exit(0)
