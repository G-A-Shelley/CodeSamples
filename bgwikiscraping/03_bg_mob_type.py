'''
#########################################################################################
Import Libraries
#########################################################################################
'''

# import requests, sqlite
import requests, sqlite3
# import beautiful soup
from bs4 import BeautifulSoup

'''
#########################################################################################
Functions 
#########################################################################################
'''

'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
conn  = sqlite3.connect('xdatabase.db')
cur   = conn.cursor()

# set session, sookies, and headers for the page request
# set URLs for Bestiary
my_session  = requests.session()
for_cookies = my_session.get("https://www.bg-wiki.com")
cookies     = for_cookies.cookies
headers     = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url         = "https://www.bg-wiki.com/ffxi/Category:Bestiary"

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

# page request respoonse information
# set the initial soup contnet from the page response
# find body content by id
# find all the title span elements for the class
# total limits the tables to just mob type/family
response  = my_session.get(url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
tags      = soup.find_all('span', {"class":"mw-headline"})
total     = 10
print(response.status_code) 

# iterate through the tables containing type and family names
for index in range(1,total,1):
  # set the next parent element from the current span
  check = tags[index].find_parent().find_next_sibling()
  # determine if the current element is a table and set the table element
  if check.name == "table":
    tables = tags[index].find_parent().find_next_sibling().find_all("table")
  else:
    tables = tags[index].find_parent().find_next_sibling().find_next_sibling().find_all("table")
  # iterate through each table in the current ecosystem   
  for table in tables:
    # set the title element
    # set the td elements
    # set the title name
    title   = table.find("th")        
    info    = (table.find_all("td"))
    current = title.get_text().strip()

    # determine if the current section is for the playable characters and skip
    if current == "Blessed Races of Altana":
      continue
    # attempt to insert the current mob type into the DB
    try:
      print("\n######### Type : {}".format(current)) # debug information
      cur.execute('''INSERT INTO type (name) VALUES (?)''', (title.get_text().strip(),))
      conn.commit()
    except:
      pass
    # attempt to insert the current mob family into the DB
    for content in info:
      print("Family : {} {}".format(content.get_text().strip(),title.get_text().strip())) # debug information
      try:
        cur.execute('''INSERT INTO family (name,type) VALUES (?,?)''', (content.get_text().strip(),title.get_text().strip()))
        conn.commit()
      except:
        pass