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
#############################
Get information from tables
#############################
'''

def get_table_information(table):
  for content in table:
    page_name = content.get_text().strip() # set the current page name
    # determine if the page name is not in the list of names and the length if less than 30
    # 30 helps correct getting information for a nested table in the final area table
    if page_name not in name_list and len(page_name) < 30:
      name_list.append(page_name) # add the name to the list
      # attempt to inser tdatabase information
      insert_area(page_name)

'''
#############################
Insert Area Information
#############################
'''

def insert_area(name):
  name_list.append(name) # add the name to the list
  print(name,"|",len(name_list)) # debug information
  try:
    pass
    # update database and commit changes
    cur.execute('''INSERT INTO zones (name) VALUES (?)''', (name.replace("#",""),)) # Replace # for Riverne Name corrections
    conn.commit()
  except:
    pass

'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
conn  = sqlite3.connect('xdatabase.db')
cur   = conn.cursor()

# set session, sookies, and headers for the page request
# set URL for Area information
# list of area names to be inserted
my_session  = requests.session()
for_cookies = my_session.get("https://www.bg-wiki.com")
cookies     = for_cookies.cookies
headers     = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url         = "https://www.bg-wiki.com/ffxi/Category:Areas"
name_list   = list()

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

# page request respoonse information
# set the initial soup contnet from the page response
# find all the title span elements
response  = my_session.get(url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
tags      = soup.find_all('span', {"class":"mw-headline"})
print(response.status_code)

'''
#############################
Area Information
#############################
'''

# iterate through the title tags
for tag in tags:
  # find all of the tables after the current title tag
  tables = tag.find_parent().find_next_sibling().find_all("table")
  # iterate through all of the current title tables
  for table in tables:
    info = (table.find_all("td")) # find all of the td elements for the current table
    # iterate through all of the current td elements
    get_table_information(info)

  # determine if the next element after the current table exists
  if tag.find_parent().find_next_sibling().find_next_sibling():
    # find all of the next tables after the current table
    next_tag = tag.find_parent().find_next_sibling().find_next_sibling().find_all("table")
    #iterate through the current tables    
    for table in next_tag:
      info = (table.find_all("td")) # find all of the td elements for the current table
      # iterate through the td lements
      get_table_information(info)
 
'''
#############################
Manual Add Information
#############################
'''

# Manual Entry of Areas not on Area Category Page
missing_areas = ["Dynamis - San d'Oria (D)","Dynamis - Bastok (D)","Dynamis - Windurst (D)","Dynamis - Jeuno (D)",
  "Arrapago Remnants II","Bhaflau Remnants II","Silver Sea Remnants II","Zhayolm Remnants II","Unspecified"]

# iterate through additional areas and insert into the DB
for area in missing_areas:
  insert_area(area)