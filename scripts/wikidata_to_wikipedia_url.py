# Given some wikidata URLs, return the wikipedia URLs

# [ ] TODO: error handling if no English wikipedia URL found


from selenium import webdriver 
from selenium.webdriver.chrome.options import Options 
import pdb

options = Options() 
options.headless = True 
driver = webdriver.Chrome()

# replace wikidata urls here
wikidata_urls = ['https://www.wikidata.org/wiki/Q11635']
wikipedia_urls = []
for url in wikidata_urls:
  driver.get(url) 
  href =  driver.find_elements_by_class_name('wikibase-sitelinkview-enwiki')[0].find_element_by_tag_name('a').get_attribute('href')
  # wikipedia_urls.append(href)
  print(href)

driver.quit()

# print(wikipedia_urls)