import sys
import os
import urllib.request
import urllib.error

host = os.environ["SYNC_HOST"]
port = os.environ["SYNC_PORT"]
url = f"http://{host}:{port}/sync/meta"

try:
    req = urllib.request.urlopen(url)
except urllib.error.HTTPError as e:
    # 405 Method Not Allowed means it's probably working
    if e.code == 405:
        sys.exit(0)
    sys.exit(1)
except urllib.error.URLError as e:
    sys.exit(1)
if req.getcode() != 200:
    sys.exit(1)
sys.exit(0)
