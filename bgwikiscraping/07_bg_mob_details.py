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
get mob name information
#############################
'''

def get_name_information(info):
  # build list of mob name inforamtion and update DB

  # list to hold mob information
  info_list = list()
  
  # iterate through the table rows
  for row in info:

    # set the cell for the current row
    cell = row.find_all("td")

    # determine if cells exist in the current row
    if len(cell) > 0:
      # list to hold row information
      row_list = list() 

      # iterate through the row cells
      for h in cell:
        # set span and link tags
        span = h.find_all("span")
        link = h.find_all("a")
        # set empty list to test against
        test = list()

        # determine if span is not empty
        if span != test:
          # iterate through the span elements
          for sp in span:
            # attempy to append the span title or append empty string
            try:
              row_list.append(sp["title"].strip())
            except:
              row_list.append("")
        # determine if the kink list is not empty
        elif link != test:
          # attempt to append the link text or append empty string
          try:
            row_list.append(link[0].get_text())
          except:
            row_list.append(link[1].get_text())
        else:
          row_list.append(h.get_text().strip())
      # determine if the row list has content and append to the info list
      if len(row_list)> 0:
        info_list.append(row_list)

  # debug information
  for info in info_list:
    print(info)

  # update the job information for the current mob name  
  cur.execute('''UPDATE mob SET job=? WHERE name=?''', 
    (info_list[2][1],current))
  conn.commit()

  # Iterate through the player detection values
  for detection in info_list[5]:
    # remove text and print debug output
    detect = detection.replace("Detects by ","")
    print(detect)

    # determine detection type and update database
    if detect == "Sight":
      pass
      cur.execute('''UPDATE mob SET sight=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "Sound":
      pass
      cur.execute('''UPDATE mob SET sound=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "Magic":
      pass
      cur.execute('''UPDATE mob SET magic=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "Low HP":
      pass
      cur.execute('''UPDATE mob SET hp=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "Healing":
      pass
      cur.execute('''UPDATE mob SET healing=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "True Sight":
      pass
      cur.execute('''UPDATE mob SET truesight=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "True Sound":
      pass
      cur.execute('''UPDATE mob SET truesound=? WHERE name=?''', 
        (1,current))
      conn.commit()
    elif detect == "Job Ability":
      pass
      cur.execute('''UPDATE mob SET ability=? WHERE name=?''', 
        (1,current))
      conn.commit()


'''
#############################
confirm cell checkmarks
#############################
'''

def confirm_cell_checkmarks(cells,cell_list):
  # confirms cell content checkmarks and converts to 1 or 0

  # iterate through individual cells
  for cell in cells:
    # set the lniks for the current cell
    links = cell.find_all("a")
    # set empty list for testing
    test = list()

    # determine if a link exists
    if links != test:
      # set a list for link information
      link_list = list()
      # iterate through each link
      for link in links:
        try:
          # set the titel from the link title
          title = link["title"]
          # determine if the titel is question or check
          # set to 1 or 0
          if title == "Question":
            title = "0"  
          elif title == "Check":
            title = "1"
          # append the updated title inforamtion to the link list
          link_list.append(title)
        except:
          pass
      # append the link list to the passed cell list
      cell_list.append(link_list)
    # no links exist
    else:
      # set the text for the current cell text
      text = (cell.get_text().strip())
      # determine if the text is check and append 1 or append text
      if text == "Сheck":
        cell_list.append(1)
      else:
        cell_list.append(text)
  # return the updated cell list 
  return cell_list

'''
#############################
mob location information
#############################
'''

def get_mob_location_information(listing_table):
  # get zone specific location for the current mob name

  # iterate through the mob table infomation
  for index in range(1,len(listing_table),7):

    # set a list for mob information
    mob_info = list()

    # determine if the list is empty and break
    if index > len(listing_table):
      break
    
    # get the cell information for the selected rowa
    first = listing_table[index+2].find_all("td")
    second = listing_table[index+4].find_all("td")
    third = listing_table[index+6].find_all("td")

    # updted info mob inforamtion for the selected rows
    mob_info = (confirm_cell_checkmarks(first,mob_info))
    mob_info = (confirm_cell_checkmarks(second,mob_info))
    mob_info = (confirm_cell_checkmarks(third,mob_info))

    # set the zone name and drops for the current mob name 
    zone  = mob_info[0][0]
    drops = ",".join(mob_info[1])
    
    # set the default levels to 0
    levels = [0,0]
    
    # determine if the levels contain a split characters
    if "-" in mob_info[4]:
      # split levels on the -
      levels = mob_info[4].split("-")
    # determine if the level is empty
    elif mob_info[4] == "":
      # set to zero levels
      levels = [0,0]
    # determine if the levels are a list
    elif type(mob_info[4]) == list:
      # set the levels from the list index vales
      levels = [mob_info[4][0].strip(),mob_info[4][0].strip()]
    else:
      # set the levels to match when only one is given
      levels = [mob_info[4],mob_info[4]]

    # set default agro value to 0
    # determine if the given is check and set agro to 1
    agro = 0
    if mob_info[5] == "Check":
      agro = 1

    # set the default link value to 0
    # determine if the given is check and set link to 1
    link = 0
    if  mob_info[6] == "Check":
      link = 1

    #  set spawn and condition values
    spawns      = mob_info[7]
    conditions  = ""

    # determine if the spawn value is not a number
    if spawns.isalpha():
      # set condition to spawn and spawn to mepty string
      conditions  = spawns
      spawns      = ""

    # determine if the mob resistance value is empty and set to 0 list
    if mob_info[14] == "":
      mob_info[14] = ['0']
    # set the resistance value
    resist = mob_info[14][0]

    # determine if the mob immune value is empty and set to 0 list
    if mob_info[18] == "":
      mob_info[18] = ['0']
    # stet the immune value
    immune = mob_info[18][0]
    
    # find zone information for the current zone name
    cur.execute('''SELECT * FROM zones WHERE name =? ORDER BY name''', (zone,))
    res_zones = cur.fetchall()

    # determine if the current zone name is not a zone
    if len(res_zones) == 0:

      # find battlefield information for the current zone name
      cur.execute('''SELECT * FROM battlefields WHERE name =? ORDER BY name''', (zone,))
      res_battles = cur.fetchall()

      # determine if the zone name is a battle field
      if len(res_battles) > 0:

        # set the zone name for the current area
        zone = res_battles[0][1]

    # debug information
    print("-----------------------------------------------")
    print("Name {} Zone {} Level {}-{} ".format(current,zone,levels[0],levels[1]))
    print("Agro {} Link {} Spawns {} Resists {} Immune {}".format(agro,link,spawns, resist, immune))
    print("Conditions".format(conditions))
    print("Drops : {}".format(drops))
    print("-----------------------------------------------")

    # attempt to insert the mob information for name and zone
    try:
      print("Insert {} {} {} {} {} ".format(name,levels[0],levels[1],item,0))
      cur.execute('''INSERT INTO mob (name,zone) VALUES (?,?)''', 
        (current,zone))
      conn.commit()
    except:
      ("Exists")

    # attempt tp update the mob additional information
    try:
      cur.execute('''UPDATE mob SET level_min=?,level_max=?,aggressive=?,links=?,spawns=?,resist=?,immune=?,drops=?,conditions=? WHERE (name = ? AND zone=?)''',
        (levels[0],levels[1],agro,link,spawns,resist,immune,drops,conditions,current,zone))
      conn.commit()
    except:
      print("Update Error")

'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
# get name information from the family DB
conn    = sqlite3.connect('xdatabase.db')
cur     = conn.cursor()
cur.execute('''SELECT * FROM mob GROUP by name ORDER by name ASC''')
results = cur.fetchall()


# set session, sookies, and headers for the page request
# set URL for mob information
my_session    = requests.session()
for_cookies   = my_session.get("https://www.bg-wiki.com")
cookies       = for_cookies.cookies
headers       = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url           = "https://www.bg-wiki.com/ffxi/"

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

# mob name where formatting is not standard
skip_list =  ["","Aiatar","Antares","Archaic Mirror (Monster)","Asphyxiating Cyhiraeth","Bayawak",
    "Blanched Mandragora","Brash Gramk-Droog","Cactuar","Cactuar Cantautor","Cerberus","Colibri", "Craklaw",
    "Dark Ixion","Drachenlizard","Dune Widow","Evil Weapon","Feuerunke","Gloomanita","Glowering Ladybug",
    "Habetrot","Herbage Hunter","Hydra","Ignoble Skeleton","Intulo","Ironclad","Jormungand","Krabkatoa","Luckybug",
    "Mischievous Micholas","Naphula","Orobon","Peirithoos","Pixie","Poroggo","Seaboard Vulture","Slobbering Ruszor",
    "Snapping Craklaw","Tenodera","Tumult Curator","Unrelenting Dullahan","Unrepentant Byrgen","Valkurm Emperor",
    "Velkk Abyssal","Velkk Junglemancer","Velkk Mindmelter","Velkk Tearlicker","Vespo","Wivre","Yacumama",
    "Blind Moby","Bozzetto Pilferer","Fleetstalker","Goblin Golem","Gu'Dha Effigy","Hanbi","Mboze","Morseiu",
    "Nepionic Soulflayer","Odin (Notorious Monster)","Omega","Ophiotaurus","Overlord's Tombstone","Palila",
    "Quiebitiel","Tzee Xicu Idol","Ultima","Wyrm"]

# iterate through the slected mob names
for index in range(0,len(results),1):

  # debug information
  print(index,results[index][0],results[index][1])

  # determine if the current mob is to be skipped
  if results[index][0] in skip_list or "Apex" in results[index][0] or "Bozzetto" in results[index][0]:
    continue

  # set the name for the current mob and the page name 
  current   = results[index][0].strip()
  page      = '_'.join((results[index][0].strip()).split())
  # debug information 
  print(page, current)

  # get the information for the current mob name
  response = my_session.get(url + page, headers=headers, cookies=cookies)

  # set the soup and body for the current page
  # set the table for the current body
  soup  = BeautifulSoup(response.content,'html.parser')
  body  = soup.find('div', {"id":"bodyContentOuter"})
  chart = body.find_all('table', {"class":"Standard R1-White"})
  
  # determine if the chart does not exist and skip
  if len(chart) == 0:
    continue

  # set the table rows for the current mob and call name information function
  info = chart[0].find_all("tr")
  get_name_information(info)

  # set the table rows for the mob information tables and call mob location information function
  listing_table = body.find("span", {"id":"Listings"}).find_parent().find_next_sibling().find_all("tr")
  get_mob_location_information(listing_table)

