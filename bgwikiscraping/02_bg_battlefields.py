'''
#########################################################################################
Import Libraries
#########################################################################################
'''

# import requests, sqlite, regular expressions
import requests, sqlite3, re
# import beautiful soup
from bs4 import BeautifulSoup

'''
#########################################################################################
Functions 
#########################################################################################
'''

'''
#############################
Build List from Table Info
#############################
'''

def build_info_table(info,title,current):
  info_list = list()  # list of information to be returned
  
  # iterate through all of the rows in info
  for row in info:
    cell      = row.find_all("td")  # td cell information
    row_list  = list()              # list of information for each row

    # determine if the current row is content
    if len(cell) > 0:
      row_list.append(title)    # append the title to the row list
      row_list.append(current)  # append the current area to the row list
      # iterate through the td information
      for h in cell:
        span = h.find_all("span") # find all span elements 
        link = h.find_all("a")    # find all a elements
        test = list()             # default empty list for comparisson
        # determine if the span list is not empty  
        if span != test:
          # iterate through span content
          for sp in span:
            # attempt to append the span title to the row list or empty
            try:
              row_list.append(sp["title"].strip())
            except:
              row_list.append("")
        # determine if the link list is not empty
        elif link != test:
          # attempt to append the first element of the link list to the row list or the second 
          try:
            row_list.append(link[0].get_text())
          except:
            row_list.append(link[1].get_text())
        # not a span od link list found
        else:
          # append the text to the row list
          row_list.append(h.get_text().strip())
      # determine if the row list has content
      if len(row_list)> 0:
        # append the row list to the info_list
        info_list.append(row_list)
  
  # return the finished info_list
  return(info_list)

def insert_battlefield(name, zone, category, entry):
  print("Insert {} {} {} {}".format(name, zone, category, entry)) # debug print info
  # attempt to insert the current information into the battlefield DB
  try:
    pass
    cur.execute('''INSERT INTO battlefields (name, zone, category, entry) VALUES (?,?,?,?)''', 
      (name, zone, category, entry))
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
# set URLs for Area information
# battlefield and assault information lists
my_session    = requests.session()
for_cookies   = my_session.get("https://www.bg-wiki.com")
cookies       = for_cookies.cookies
headers       = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
battle_url    = "https://www.bg-wiki.com/ffxi/Category:Battlefields"
assault_url   = "https://www.bg-wiki.com/ffxi/Category:Assault"
annm_url      = "https://www.bg-wiki.com/ffxi/Category:Allied_Notes_NM_System"
walks_url     = "https://www.bg-wiki.com/ffxi/Walk_of_Echoes"
battlefields  = list()
assaults      = list()
allied        = list()
walks         = list()

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

'''
#############################
Battlefields Information
#############################
'''

# page request respoonse information
# set the initial soup contnet from the page response
# find body content by id
# find all the title span elements for the class
response  = my_session.get(battle_url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
body      = soup.find('div', {"id":"bodyContentOuter"})
tags      = body.find_all('span', {"class":"mw-headline"})
title     = tags[0].get_text()
print(response.status_code)

# iterate through tags list
for index in range(0,len(tags),1):

  current   = (tags[index].get_text())  # set current tag name
  parent    = tags[index].find_parent() # find the parent of the current tag
  section   = (parent.name).strip()     # set the current section name

  # Determine if the current Tag is for Adventurer 
  # Skip over Monthly Adventurer Campaign in Battlefields page
  if "Adventurer" in current:
    continue
  # determine if the current tag is the type of battlefield and set the title
  elif section == "h2":
    title = current
  # setermine if the current tag is the group of the current type
  elif section == "h3":
    # set the sibling name for the current element
    sibling = parent.find_next_sibling().name
    # if the current element name is not a table
    if sibling != "table":
      # set the sibling name and table rows for the current parent element
      sibling   = parent.find_next_sibling().find_next_sibling().name
      table     = parent.find_next_sibling().find_next_sibling().find_all("tr")
    # the current element is a table
    else:
      # set the current table rows
      table     = parent.find_next_sibling().find_all("tr")
    # append the information from the build talbe info function
    battlefields.append(build_info_table(table,title, current))

'''
#############################
Assault Information
#############################
'''

# page request respoonse information
# set the initial soup contnet from the page response
# find body content by id
# find all the title span elements for the class
# clear the title current and table values
response  = my_session.get(assault_url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
body      = soup.find('div', {"id":"bodyContentOuter"})
tags      = body.find_all('span', {"class":"mw-headline"})
e_assault = "Imperial Army I.D. Tags"
title     = ""
current   = ""
table     = ""

# iterate through index values 6 to 13 to eliminate not assault information tables
for index in range(6,13,1):

  current   = (tags[index].get_text())  # set current tag name
  parent    = tags[index].find_parent() # find the parent of the current tag
  section   = (parent.name).strip()     # set the current section name

  # determine if the current tag is the type of battlefield and set the title
  if section == "h2":
    title = current
  # setermine if the current tag is the group of the current type
  elif section == "h3":
    # set the sibling name for the current element
    sibling = parent.find_next_sibling().name
    # if the current element name is not a table
    if sibling != "table":
      # set the sibling name and table rows for the current parent element
      sibling   = parent.find_next_sibling().find_next_sibling().name
      table     = parent.find_next_sibling().find_next_sibling().find_all("tr")
    # the current element is a table
    else:
      # set the current table rows
      table     = parent.find_next_sibling().find_all("tr")
    # append the information from the build talbe info function
    assaults.append(build_info_table(table,title, current))

'''
#############################
ANNM Information
#############################
'''

# Add Allied Notes Notorious Monster Information from pages
# page request respoonse information
# set the initial soup contnet from the page response
# find body content by id
# find all the title span elements for the class
# clear the current and table values
response  = my_session.get(annm_url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
body      = soup.find('div', {"id":"bodyContentOuter"})
tags      = body.find_all('span', {"class":"mw-headline"})
current   = ""
table     = ""

# iterate through index values 6 to 13 to eliminate not assault information tables
for index in range(0,len(tags),1):

  current   = (tags[index].get_text())  # set current tag name
  parent    = tags[index].find_parent() # find the parent of the current tag
  section   = (parent.name).strip()     # set the current section name

  if "Zones" in current:
    # set the entry item for current bettlefield
    entry = re.sub(r'(.*)\(','', current).strip(")")

    # set the sibling name for the current element
    sibling = parent.find_next_sibling().name
    # if the current element name is not a table
    if sibling != "table":
      # set the sibling name and table rows for the current parent element
      sibling   = parent.find_next_sibling().find_next_sibling().name
      table     = parent.find_next_sibling().find_next_sibling().find_all("tr")
    # the current element is a table
    else:
      # set the current table rows
      table     = parent.find_next_sibling().find_all("tr")
    # append the information from the build talbe info function
    allied.append(build_info_table(table,entry, current))

'''
#############################
Walk of Echoes Information
#############################
'''

# Add Allied Notes Notorious Monster Information from pages
# page request respoonse information
# set the initial soup contnet from the page response
# find body content by id
# find all the title span elements for the class
# clear the current and table values
response  = my_session.get(walks_url, headers=headers, cookies=cookies)
soup      = BeautifulSoup(response.content,'html.parser')
body      = soup.find('div', {"id":"bodyContentOuter"})
tags      = body.find_all('span', {"class":"mw-headline"})
current   = ""
table     = ""

# iterate through index values 6 to 13 to eliminate not assault information tables
for index in range(0,len(tags),1):

  current   = (tags[index].get_text())  # set current tag name
  parent    = tags[index].find_parent() # find the parent of the current tag
  section   = (parent.name).strip()     # set the current section name

  print(current)

  if "Battlefields" in current:
    # set the entry item for current bettlefield
    entry = "Kupofried's medallion"

    # set the sibling name for the current element
    sibling = parent.find_next_sibling().name
    # if the current element name is not a table
    if sibling != "table":
      # set the sibling name and table rows for the current parent element
      sibling   = parent.find_next_sibling().find_next_sibling().name
      table     = parent.find_next_sibling().find_next_sibling().find_all("tr")
    # the current element is a table
    else:
      # set the current table rows
      table     = parent.find_next_sibling().find_all("tr")
    # append the information from the build talbe info function
    walks.append(build_info_table(table,entry, current))

'''
#############################
Manual Add Information
#############################
'''

# Maunally Added information for Einherjar
zone        = "Hazhalm Testing Grounds"
category    = "Einherjar"
entry       = "Smoldering Lamp"
battle_area = ["Grimgerde's Chamber", "Rossweisse's Chamber", "Siegrune's Chamber", "Helmwige's Chamber", 
  "Schwertleite's Chamber", "Waltraute's Chamber", "Brunhilde's Chamber", "Gerhilde's Chamber", "Ortlinde's Chamber",
  "Odin's Chamber",  "Odin's Chamber II"]

# iterate through the additional information and call the inser function
for battle in battle_area:
  pass
  insert_battlefield(battle,zone,category,entry)
    
# Maunally Added information for Limbus
zone        = "Temenos"
category    = "Limbus"
entry       = ["","","",
                
                "",
                "Emerald Chip,","Scarlet Chip","Ivory Chip",
                "Orchid Chip,Cerulean Chip,Silver Chip","Metal Chip","Metal Chip",
                "Metal Chip","Niveous Chip"]
battle_area = ["Western Temenos","Eastern Temenos","Northern Temenos",
                "Temenos Northern Tower",
                "Central Temenos - 1st Floor","Central Temenos - 2nd Floor","Central Temenos - 3rd Floor",
                "Central Temenos - 4th Floor","Central Temenos - Basement","Central Temenos - Basement 1",
                "Central Temenos - Basement II","Central Temenos - 4th Floor II"]

# iterate through the additional information and call the inser function
for index in range(len(battle_area)):
  pass
  insert_battlefield(battle_area[index],zone,category,entry[index])

# Maunally Added information for Limbus
zone        = "Apollyon"
category    = "Limbus"
entry       = ["","","","",
                "Smoky Chip,Smalt Chip,Magenta Chip,Charcoal Chip","Metal Chip",
                "Metal Chip","Crepuscular Chip"]
battle_area = ["North East Apollyon","South East Apollyon","North West Apollyon","South West Apollyon",
                "Central Apollyon","CS Apollyon",
                "CS Apollyon II","Central Apollyon II"]

# iterate through the additional information and call the inser function
for index in range(len(battle_area)):
  pass
  insert_battlefield(battle_area[index],zone,category,entry[index])

# Maunally Added information for Incursion
zone        = "Cirdas Caverns (U)"
category    = "Incursion"
entry       = ["Velkk fetish"]
battle_area = ["Incursion"]

# iterate through the additional information and call the inser function
for index in range(len(battle_area)):
  pass
  insert_battlefield(battle_area[index],zone,category,entry[index])

'''
#############################
DB Update from Lists
#############################
'''

# iterate through the battlefield list and call the insert function
for battle in battlefields:
  for field in battle:
    pass
    insert_battlefield(field[3],field[2],field[0],field[1])

# iterate through the assault list and call the insert function
for assault in assaults:
  for field in assault:
    pass
    #print(field[2],field[1],"Assault",e_assault)
    insert_battlefield(field[2],field[1],"Assault",e_assault)

for allies in allied:
  for ally in allies:
    pass
    insert_battlefield(ally[4],ally[2],"ANNM",ally[0])

for walk in walks:
  for fight in walk:
    pass
    if fight[2] == "Type":
      continue
    #print(fight)
    # name, zone, category, entry
    insert_battlefield(fight[3],"Walk of Echoes",fight[2],fight[0])