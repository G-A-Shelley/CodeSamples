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
get zone information
#############################
'''

def get_zone_information(info):
  # get zone specific information

  # set list for zone information  
  info_list = list()
  
  # iterate through the rows
  for row in info:
    # set the cells for the current row
    cell = row.find_all("td")

    # determine if the row has cell content
    if len(cell) > 0:
      # set list for current row information
      row_list = list() 

      # iterate through the cella
      for h in cell:
        # set the span and a tags
        span = h.find_all("span")
        link = h.find_all("a")
        # set empty list for checka
        test = list()

        # determine if the span is not empty
        if span != test:
          # iterate through spans
          for sp in span:
            # attempt to set span title or empty string
            try:
              row_list.append(sp["title"].strip())
            except:
              row_list.append("")
        # determine if the link is not empty
        elif link != test:
          try:
            row_list.append(link[0].get_text())
          except:
            row_list.append(link[1].get_text())
        # not span or link
        else:
          # append the cell text to the row list
          row_list.append(h.get_text().strip())

      # determine if the row list is not empty 
      # append the row list to the info list
      if len(row_list)> 0:
        info_list.append(row_list)
  
  # set the continent, region and zone to empty strings
  continent = ""
  region    = ""
  zone_type = ""

  # iterate through the info list
  for info in info_list:
    # determine and set continet, region and zone values
    if info[0] == "Continent":
      continent = info[1]
    if info[0] == "Region":
      region = info[1]
    if info[0] == "Zone Type":
      zone_type = info[1]

  # debug information
  print("Zone {} | Continent {} | Region {} | Type {}".format(current,continent,region,zone_type))
  
  # update the zones DB
  cur.execute('''UPDATE zones SET continent=?,region=?,type=? WHERE (name = ?)''',
    (continent,region,zone_type,current))
  conn.commit()

'''
#############################
get zone npc information
#############################
'''

def get_npc_information(info):
  # get npc information for a zone

  # set list for npc information
  info_list = list()
  
  # iterate through info rows
  for row in info:
    # set cell information from the row
    cell = row.find_all("td")

    # determine if the row contains td elements
    if len(cell) > 0:
      # set a list to hold row information
      row_list = list() 

      # iterate through cell
      for h in cell:
        # set span and a tag lists
        span = h.find_all("span")
        link = h.find_all("a")
        # set empty list for checks
        test = list()

        # determine if the span is not empty
        if span != test:
          # iterate through spans
          for sp in span:
            # attempt to set span title or empty string
            try:
              row_list.append(sp["title"].strip())
            except:
              row_list.append("")
        # determine if the link is not empty
        elif link != test:
          # attempt to set link text to index 0 or 1
          try:
            row_list.append(link[0].get_text())
          except:
            row_list.append(link[1].get_text())
        # not span or link
        else:
          # append the cell text to the row list
          row_list.append(h.get_text().strip())
      
      # determine if the row list is not empty 
      # append the row list to the info list
      if len(row_list)> 0:
        info_list.append(row_list)
  
  # iterate through the info list
  for info in info_list:
    # determine if the text mathces Flavor Text and set to empty
    if info[3] == "Flavor Text":
      info[3] = ""
    # determine if the name is empty
    if info[0] != "":
      # attempt to insert npc information into npc DB
      try:
        pass
        cur.execute('''INSERT INTO npc (name,zone,pos,info) VALUES (?,?,?,?)''', 
          (info[0],current,info[2],info[3]))
        conn.commit()
      except:
        pass

'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
# get name information from the zones DB
conn    = sqlite3.connect('xdatabase.db')
cur     = conn.cursor()
cur.execute('''SELECT name FROM zones ORDER BY name ASC''')
results = cur.fetchall()

# set session, sookies, and headers for the page request
# set URL for mob information
my_session  = requests.session()
for_cookies = my_session.get("https://www.bg-wiki.com")
cookies     = for_cookies.cookies
headers     = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url         = "https://www.bg-wiki.com/ffxi/"

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

#for index in range(36,41,1):
for index in range(0,len(results),1):
  
  # set the current zone name, page url, section 
  current   = results[index][0].strip()
  page      = '_'.join((results[index][0].strip()).split()) 
  section   = ""
  # debug information
  print(current,url+page)

  # get the information for the current zone
  response  = my_session.get(url + page, headers=headers, cookies=cookies)
  
  # set the soup and body for the current page
  # set the table for the current body
  # set the chart for zone  information
  soup  = BeautifulSoup(response.content,'html.parser')
  body  = soup.find('div', {"id":"bodyContentOuter"})
  chart = body.find_all('table', {"class":"Standard R1-White C1-Bold"})

  # determine if there is body content
  if body != 0:

    # set the values for npc and npcs
    npc   = body.find("span", {"id":"NPC"})
    npcs  = body.find("span", {"id":"NPCs"})
    
    # determine which npc table exists on the page
    # set the section to the corresponding npc table
    if npc != None:
      print("NPC none")
      section = npc
    elif npcs != None:
      print("NPCs none")
      section = npcs

    # determine if the section has content
    if section != "":
      # set the table and tag name
      next_tag    = section.find_parent().find_next_sibling()
      check_name  = next_tag.name

      # determine if the next tag is a table
      if check_name == "table":
        # set the nap information table and call npc information function
        npc_table = next_tag.find("table").find_all("tr")
        get_npc_information(npc_table)
      # determine if the next tag is a div
      elif check_name == "div":
        # set the divisions for the current element
        npc_div = next_tag.find_all("div")
        # iterate through the div elements
        for div in npc_div:
          # set the nap information table and call npc information function
          npc_table = div.find("table").find_all("tr")
          get_npc_information(npc_table)

    # determine if the zone information table exists
    if len(chart) > 0:    
      # set the table for zone information and call the zone information function
      box = chart[0].find_all("tr")
      get_zone_information(box)
