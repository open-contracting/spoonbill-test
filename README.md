# spoonbill-test
Integration tests of converting JSON to Excel/CSV

How to run tests:
1. Clone project ```git@github.com:open-contracting/spoonbill-test.git```
2. Need create virtualenv: ```virtualenv -p python3 venv```
3. Activate "venv" source ```./venv/bin/activate```
4. Execute command ```pip install -r requirements.txt```
5. Download 'chromedriver' - version should be the same as Chrome browser on system
https://chromedriver.chromium.org/downloads
6. Unpack 'chromedriver' to {your project}/venv/bin
7. Run tests ```SITE_URL={site url} python -m robot tests```
