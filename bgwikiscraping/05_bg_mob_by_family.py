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
Get Mob Family Bestiary Info
#############################
'''

def build_info_table(info):
  # get bestiary information from the mob family page
  # crystal and resistances


  # list to hold information from the Bestiary table
  info_list = list()

  # iterate through the rows 
  for row in info:
    # set header and cell information
    head = row.find_all("th")
    cell = row.find_all("td")

    # determine if the table has headers
    if len(head) > 0:
      # list to hold header information
      row_list = list() 
      # iterate through header information
      for h in head:
        # set span and image tags
        span    = h.find("span")
        image   = h.find("img")

        # determine if a span tag exists
        if span != None:
          # append the span title to the row list
          row_list.append(span["title"])
        # determine if there is no image and the header has content
        elif image == None and h.contents != None:
          # append the header content to the row list
          info_list.append([str(h.contents[0]).strip()])
      # if the row list has element append to the information list
      if len(row_list) > 0:
        info_list.append(row_list)

    # determine if the table has cells
    if len(cell) > 0:
      # list to hold cell information
      row_list = list() 
      # iterate through cell information
      for h in cell:
        # set span tag
        span = h.find("span")
        # determine if the span exists 
        if span != None:
          check_span = len(span("title"))
          if check_span == 0:
            row_list.append(span.get_text())
          else:
            row_list.append(span["title"])
        else:
          row_list.append(h.get_text().strip())
      if len(row_list)> 0:
        info_list.append(row_list)

  # list to hold resistance information
  # count set to 0
  short_list  = list()
  count       = 0

  # iterate through the information list
  for item in info_list:
    # determine if the current item is Crystal
    # append item index 1 to short list
    if "Crystal" ==  item[0]:
      short_list.append(item[1])
    # determine if the current item is Resistances
    # increment the count 
    if "Resistances" in item[0]:
      count = count + 1
    # determine if the count is in range 0 to 5
    elif count > 0 and count < 5:
      # determine if the item is not empty
      if item != "":
        # concatenate the resistance items and append to the short list
        string = ",".join(item)
        short_list.append(string.replace("%",""))
      else:
        # append an empty string to the short list
        short_list.append("")
      # increment the counter
      count = count + 1

  # determine if the crystal value is not empty 
  if short_list[0] != "":
    # split the crystal value
    short_list[0] = short_list[0].split(" ")
  else:
    # append empty list for the crystal value
    short_list[0] = [""]
    pass  

  # determine if the resistances are not numeric and set to empty string
  if short_list[2][0].isnumeric() == False:
    short_list[2] = ""
  if short_list[4][0].isnumeric() == False:
    short_list[4] = ""

  # debug output
  print("Insert {} {} {}".format(short_list[0][0],short_list[2],short_list[4]))

  # update the mob family information for crystal and resistances
  cur.execute('''UPDATE family SET crystal=?,resist_phy=?,resist_mag=? WHERE name=?''', 
    (short_list[0][0],short_list[2],short_list[4],current))
  conn.commit()

'''
#############################
Get Mob Family Event Info
#############################
'''

def family_event_information(event_table):
  # get event mob information from the mob family pages

  # iterate through the tables for the current family event mobs
  for event in event_table:
    # set the rows for the current table
    event_rows = event.find_all("tr")

    # iterate through the rows 
    for row in event_rows:
      # set the cells for the current row
      event_td = row.find_all("td")
      # determine if cells exists 
      if event_td:

        # build the name for the current event mob
        # removes brackets, separates adjacent names and sets a list
        name = event_td[0].get_text().replace("[","").replace("]","").strip()
        name = re.sub(r'(?<=[a-z\)])(?=[A-Z])','|', name)
        names = name.split("|")

        # determine if the current name contains Event.Mob and skip 
        if "Event.Mob" in name or name == "":
          continue
        
        # set the appreace value to empty and content to a tag
        appearance = ""
        content = event_td[1].find("a")
        # determine if content exists
        if content:
          # set appearance to the content text
          appearance = content.get_text()

        # set the zones to all a tags
        zones = event_td[2].find_all("a")

        # iterate through each of the zones
        for zone in zones:
          # set the current zone name
          zone_name = zone.get_text().strip()

          # find zone information for the current zone name
          cur.execute('''SELECT * FROM zones WHERE name =? ORDER BY name''', (zone_name,))
          res_zones = cur.fetchall()

          # determine if the current zone name is not a zone
          if len(res_zones) == 0:

            # find battlefield information for the current zone name
            cur.execute('''SELECT * FROM battlefields WHERE name =? ORDER BY name''', (zone_name,))
            res_battles = cur.fetchall()

            # determine if the zone name is a battle field
            if len(res_battles) > 0:
              #print("Zone Name : {} {}".format(len(res_battles),zone_name))

              # set the appearance and zone name for the battle field
              appearance = res_battles[0][2]
              zone_name = res_battles[0][1]

            else:
              # find zone information for the current appearance value
              cur.execute('''SELECT * FROM zones WHERE name =? ORDER BY name''', (appearance,))
              res_battles = cur.fetchall()
              # determine the zone exists in battle fields and set zone name and location
              if len(res_battles) > 0:
                #print(len(res_battles),res_battles[0])
                zone_name, location = location, zone_name

          # remove # from Riverne Areas when it exists
          # add the current zone name to the name list
          zone_name = zone_name.replace("#","")
          name_list.append(name)

          # iterate through each name in names list
          for name in names:

            # attempt to insert mob information into the Mob DB
            try:
              # Debug Information
              print("Insert ENM : {} {} {} {} {}".format(name,zone_name,current,2,appearance))
              cur.execute('''INSERT INTO mob (name,zone,family,nm,appearance) VALUES (?,?,?,?,?)''', 
                (name,zone_name,current,2,appearance))
              conn.commit()
            except:
              ("Exists")

'''
#############################
Get Mob Family NM Info
#############################
'''    

def family_nm_information(nm_table):
  
  # build list of table information
  nm_listing = list()
  # iterate through table rows
  for nm in nm_table:
    # set cell information and list for cell information
    nm_rows = nm.find_all("td")
    nm_list = list()
    # iterate through cell information
    for row in nm_rows:

      # append current cell information to the row list
      nm_list.append(row.get_text().strip())
    # append the row list to the table list
    nm_listing.append(nm_list)

  # iterate through NM information
  for this_nm in nm_listing:
    # determine if information exists
    if len(this_nm)>0:
      # set the drops for the current nm
      drops = (this_nm[3].replace("\n",","))
      
      # set the levels for the current nm
      # set the default to  0,0 
      levels = [0,0]
      # determine if the level is not a number 
      if this_nm[0].isalpha():
        levels = [0,0]
      # determine if the number value is a range and split
      elif "-" in this_nm[0]:
        levels = this_nm[0].split("-")
      # determine if the value is empty and set to 0,0
      elif this_nm[0] == "":
        levels = [0,0]
      # set the both values to the same value
      else:
        levels = [this_nm[0],this_nm[0]]

      # correction for level out of range
      if int(levels[0]) > 300:
        levels[0] = 0   
      if int(levels[1]) > 300:
        levels[1] = 0   

      # split the name and additional information values
      name = this_nm[1].split("\xa0\xa0")
      # determine if the name is empty and skip
      if name[0] == "":
        continue

      # determine if the name len is 1
      if len(name) == 1:
        # append empty string for information values
        name.append("")

      # determine if the name is a list of names
      if "[" in name[0]:
        # split the names, strip brackets and split into a list, set the name list
        temp = re.sub(r'(?<=[a-z\)])(?=[A-Z])','|', name[0]).strip("[]").split("|")
        name[0] = temp
      else:
        # set the single name to a list entry
        name[0] = [name[0]]

      # Determine if the area value is empty/Varies
      if this_nm[2] == "" or this_nm[2] == "Varies":
        # set the area namme to Unspecified
        this_nm[2] = "Unspecified"
      
      # get the count of the zones for the current name and set exception to 0
      try:
        cur.execute('''SELECT COUNT(name) FROM zones WHERE name=?''',(this_nm[2],))
        check = cur.fetchone()
      except:
        check = [0]

      # set the default value for appearance
      appearance = ""

      # determine if the zone was not found in the DB
      if (check[0]) == 0:
        # set the current zone name
        zone_name = this_nm[2]

        # determine the the current zone is a list of zones
        if "[" in zone_name:
          # separate the zone information into a list of names
          temp = re.sub(r'(?<=[a-z\)])(?=[A-Z])','|', zone_name).strip("[]").split("|")
          this_nm[2] = temp
        # determine if the list is separated by *
        elif "*" in zone_name:
          # separate the zone information into a list of names
          temp = zone_name.split("*")
          this_nm[2] = temp
        else: 
          # check battlefields for the current zone names
          cur.execute('''SELECT * FROM battlefields WHERE name =? ORDER BY name''', (zone_name,))
          res_battles = cur.fetchall()
          # update the current zone name and appearance
          appearance = this_nm[2]
          this_nm[2] = [res_battles[0][1]]
      else:
        # set the zone name to a list 
        this_nm[2] = [this_nm[2]]

      # iterate through the current name list
      for names in name[0]:
        # set the inital value for the name check
        zone_check = ""

        # iterate through the zone for the current nm
        for zone in this_nm[2]:
          # sdetermine if the zone is empty and skip
          if zone == "":
            continue
          # determine if the current zone is Varies
          elif zone == "Varies":
            # set the current zone to Uspecified
            zone = "Unspecified"

          # debug information
          print("Insert NM : {} {} {} {} {} {} ".format(names,levels,zone,name[1],1,drops))

          # determine if the current name has been processed and the zone check is the current zone
          # determine if the name is empty and skip on either condition
          if (name in name_list and zone_check == zone) or name == "":
            continue

          # set the zone check value and add the name to the name list
          zone_check = zone
          name_list.append(name)

          # attempt to insert mo information into the DB
          try:
            pass
            cur.execute('''INSERT INTO mob (name,level_min,level_max,zone,conditions,nm,family,drops,appearance) VALUES (?,?,?,?,?,?,?,?,?)''', 
              (names,levels[0],levels[1],zone,name[1],1,current,drops,appearance))
            conn.commit()
          except:
            ("Exists")

'''
#############################
Get Mob Family Normal Info
#############################
'''

def family_adversary_information(ad_table):

  # build list of table information
  ad_listing = list()
  # iterate through table rows
  for ad in ad_table:
    # set cell information and list for cell information
    ad_rows = ad.find_all("td")
    ad_list = list()
    # iterate through cell information
    for td in ad_rows:
      # append current cell information to the row list
      ad_list.append(td.get_text().strip())
    # append the row list to the table list
    ad_listing.append(ad_list)

  # iterate through the mob inforamtion
  for this_ad in ad_listing:
    # determine if mob information exists
    if len(this_ad) > 0:
      
      # set the levels for the current nm
      # set the default to  0,0 
      levels = [0,0]
      # determine if the level is not a number 
      if this_ad[0].isalpha():
        levels = [0,0]
      # determine if the number value is a range and split
      elif "-" in this_ad[0]:
        levels = this_ad[0].split("-")
      # determine if the value is empty and set to 0,0
      elif this_ad[0] == "":
        levels = [0,0]
      # set the both values to the same value
      else:
        levels = [this_ad[0],this_ad[0]]

      # build the name for the current event mob
      # removes brackets, separates adjacent names and sets a list
      if "[" in this_ad[1]:
        name = this_ad[1].replace("[","").replace("]","").strip()
        name = re.sub(r'(?<=[a-z\)])(?=[A-Z])','|', name)
        names = name.split("|")
      else :
        # set the name to a list
        names = [this_ad[1]]

      # determine if the zone name is empty and set to Unspecified
      if this_ad[2] == "":
        this_ad[2] = "Unspecified"


      # get the count of the zones for the current name and set exception to 0
      try:
        cur.execute('''SELECT COUNT(name) FROM zones WHERE name=?''',(this_ad[2],))
        check = cur.fetchone()
      except:
        check = [0]

      # determine if the zone exists in the zones DB
      if (check[0]) == 0:
        # split the name, strip brackets and set to a list
        zone_name = this_ad[2]
        temp = re.sub(r'(?<=[a-z\)])(?=[A-Z])','-', zone_name).strip("[]").split("-")
        this_ad[2] = temp
      else:
        # set the current zone name to a list
        this_ad[2] = [this_ad[2]]

      # iterate through current zones
      for item in this_ad[2]:

        # set the current zone name
        zone_name = item

        # find zone information for the current zone name
        cur.execute('''SELECT * FROM zones WHERE name =? ORDER BY name''', (zone_name,))
        res_zones = cur.fetchall()

        # determine if the current zone name is not a zone
        if len(res_zones) == 0:

          # find battlefield information for the current zone name
          cur.execute('''SELECT * FROM battlefields WHERE name =? ORDER BY name''', (zone_name,))
          res_battles = cur.fetchall()

          # determine if the zone name is a battle field
          if len(res_battles) > 0:
            # set the appearance and zone name for the battle field
            item = res_battles[0][1]

        # iterate through the names
        for name in names:
          # corrrection for empty names or name has been processed
          if len(name) < 2 or  name in name_list:
            continue

          # debug information
          print("Insert Mob: {} {} {} {} {} ".format(name,levels[0],levels[1],item,0))

          # attempt to insert mob information into the DB
          try:
            cur.execute('''INSERT INTO mob (name,level_min,level_max,zone,nm,family) VALUES (?,?,?,?,?,?)''', 
              (name,levels[0],levels[1],item,0,current))
            conn.commit()
          except:
            ("Exists")


'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
# get name information from the family DB
conn      = sqlite3.connect('xdatabase.db')
cur       = conn.cursor()
cur.execute('''SELECT name FROM family ORDER BY name''')
results   = cur.fetchall()

# set session, sookies, and headers for the page request
# set URL for Category
my_session    = requests.session()
for_cookies   = my_session.get("https://www.bg-wiki.com")
cookies       = for_cookies.cookies
headers       = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url           = "https://www.bg-wiki.com/ffxi/Category:"
name_list     = list()

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

# iterate through the family names
for index in range(0,len(results),1):

  # set the current family name 
  current = results[index][0]
  # Debug output
  print("Category : {}".format(current))

  # get the information for the current mob fmaily
  response = my_session.get(url + current, headers=headers, cookies=cookies)

  # set the soup and body for the current page
  soup = BeautifulSoup(response.content,'html.parser')
  body = soup.find('div', {"id":"bodyContentOuter"})
  
  # set table and row information for the current family 
  # call the build info table function for the table inforamtion
  try:
    tables  = body.find_all('table', {"class":"Standard R1-White"})
    info    = tables[-1].find_all("tr")
    build_info_table(info)
  except:
    print("No Family Information")
  
  # set the event mob information and call event function
  try:
    ev_table = body.find("span", {"id":"Event_Appearances"}).find_parent().find_next_sibling().find_all("tr")
    family_event_information(ev_table)
  except:
    print("NO EVE")
    pass

  # set the nm mob inforamtion and dual values
  try:
    nm_span   = body.find("span", {"id":"Notorious_Monster"})
    nms_span  = body.find("span", {"id":"Notorious_Monsters"})

    # determine which nm section exists on the current page
    # call the nm mob information function
    if nm_span:
      nm_table = body.find("span", {"id":"Notorious_Monster"}).find_parent().find_next_sibling().find_all("tr")
    elif nms_span:
      nm_table = body.find("span", {"id":"Notorious_Monsters"}).find_parent().find_next_sibling().find_all("tr")
    family_nm_information(nm_table)
  except:
    print("NO NM")
  
  # set the normal mob information and call the family information function
  try:
    ad_table = body.find("span", {"id":"Adversaries"}).find_parent().find_next_sibling().find_all("tr")
    family_adversary_information(ad_table)
  except:
    print("NO ADV")
    pass
