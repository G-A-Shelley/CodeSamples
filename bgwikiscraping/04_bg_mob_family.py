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
Update Mob Family Info
#############################
'''

def update_family_information(boxes,page):
  # iterate through information boxes
  for box in boxes:
    # empty list to hold content
    # find all the links for the current box
    information   = list()
    links         = box.find_all("a")
    # add the value at the second index to information
    information.append((links[1].get_text()))

    # set the div for the current box 
    # set the big/span of the first box element
    divs = box.find_all("div")
    span = divs[0].find("big").find("span")

    print(information[0]) # debug information

    # determine if a span does not exist and append 0
    if span == None:
      #print("Empty") # debug information
      information.append(0)
    # determine if the current style is green and append 2
    elif "green" in span["style"]:
      #print("Charmable") # debug information
      information.append(2)
    # determine if the current style is green and append 1
    elif "red" in span["style"]:
      information.append(1)
      #print("Not") # debug information
    # default append 0
    else:
      information.append(0)
      #print("None") # debug information
    # attempt to update familly charm information
    try:
      cur.execute('''UPDATE family SET charm=? WHERE name = ?''',(information[1],information[0]))
      conn.commit()
    except:
      pass

'''
#############################
Update Mob Type Info
#############################
'''

def update_type_information(type_of, items):
  # determine if items is not none
  if items != None:
    # iterate through the items
    for item in items:
      # split item to get the last value for the DB
      values = item.get_text().split()
      # determine if the first index value matches and try to insert the second index value
      if values[0] == "Intimidate":
        try:
          cur.execute('''UPDATE type SET intimidate_to=? WHERE name = ?''',(values[-1],type_of))
          conn.commit()
        except:
          pass
      # determine if the first index value matches and try to insert the second index value
      elif values[0] == "Intimidated":
        try:
          cur.execute('''UPDATE type SET intimidate_by=? WHERE name = ?''',(values[-1],type_of))
          conn.commit()
        except:
          pass

'''
#########################################################################################
Set Locals
#########################################################################################
'''

# setup database connection
# get name information from the type DB
conn    = sqlite3.connect('xdatabase.db')
cur     = conn.cursor()
cur.execute('''SELECT name FROM type ORDER BY name''')
results = cur.fetchall()

# set session, sookies, and headers for the page request
# set URL for Category
my_session  = requests.session()
for_cookies = my_session.get("https://www.bg-wiki.com")
cookies     = for_cookies.cookies
headers     = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
url         = "https://www.bg-wiki.com/ffxi/Category:"

'''
#########################################################################################
Process Content from the Selected BG-Wiki Site
#########################################################################################
'''

# iterate through the DB select results
for result in results:
  # build the page names to be used in the URL
  # set the additional list to new empty list
  page        = result[0].strip() 
  names       = page.split()
  page        = '_'.join(names)
  additional  = []
  
  # determine if the current name is a plural exception and make plural
  if names[0]  in ["Archaic","Demon","Dragon","Luminion"]:
    page = page + "s"
  
  print("########", page, names) # debug information

  # page request respoonse information
  # set the initial soup contnet from the page response
  # find all the title span elements for the class
  response  = my_session.get(url + page, headers=headers, cookies=cookies)
  soup      = BeautifulSoup(response.content,'html.parser')
  tags      = soup.find_all('span', {"class":"mw-headline"})
  print(response.status_code)

  # set the elements for the table and list elements
  table = tags[0].find_parent().find_next_sibling()
  lists = tags[1].find_parent().find_next_sibling().find_next_sibling()

  # set the elements from tables and lists for the td and li elements
  boxes = table.find_all("td")
  items = lists.find_all("li")

  # update the family and type information function
  update_family_information(boxes,page)
  update_type_information(page,items)

  # set the check to the next sibling element to the current table
  check = table.find_next_sibling()
  # determine if the type of the element is a table
  if check.name == "table":
    # set the additional information td and update family information
    additional = table.find_next_sibling().find_all("td")
    update_family_information(additional,page)
