# TODO
# [ ] remove debugging tools: pprint, pdb
# [ ] add command line argument for output .csv filename
# [ ] optimize script's performance

import csv
import os
import sys
import xml.etree.ElementTree as ET

# REMOVE WHEN DONE
import pprint
import pdb


def save_to_csv(newsitems, filename):
  fields = ['guid', 'slugline', 'headline', 'description', 'genres', 'subjects', 'bodyLengthChars', 'bodyLengthWords', 'body']

  with open(filename, 'w') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fields)
    writer.writeheader()
    writer.writerows(newsitems)

def parse_xml(filename):
  NSMAP = {'iptc': 'http://iptc.org/std/nar/2006-10-01/',
           'xhtml': 'http://www.w3.org/1999/xhtml'}
  root = ET.parse(filename).getroot()

  guid = root.find('./iptc:itemSet/iptc:newsItem', namespaces=NSMAP).get('guid')
  
  subjectNodes = root.findall('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:subject/iptc:name', namespaces=NSMAP)
  subjects = set()
  if len(subjectNodes) == 0:
    subjects = None
  else:
    for s in subjectNodes:
      subjects.add(s.text)

  genreNodes = root.findall('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:genre/iptc:name', namespaces=NSMAP)
  if len(genreNodes) == 0:
    genres = None
  else:
    genres = set()
    for g in genreNodes:
      genres.add(g.text)

  slugline = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:slugline', namespaces=NSMAP).text
  headline = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:headline', namespaces=NSMAP).text
  description = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:description', namespaces=NSMAP).text
  body = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentSet/iptc:inlineXML/xhtml:html/xhtml:body', namespaces=NSMAP)#.text
  body = str(ET.tostring(body))

  return {"body": body,
          'description': description,
          'genres': genres,
          'guid': guid,
          'headline': headline,
          'slugline': slugline,
          'subjects': subjects,
          'bodyLengthChars': len(body),
          'bodyLengthWords': len(body.split(" "))}

def parse_n_files(path='./', max_files=100000):
  counter = 0
  newsItems = []

  files = os.listdir(path)
  length = min(len(files), max_files)
  print("Parsing " + str(length) + " files...")
  for i, filename in enumerate(files):
    if i%500 == 0: print("Parsing file " + str(i) + " out of " + str(length))
    
    newsItem = parse_xml(path + '/' + filename)
    newsItems.append(newsItem)

    # pprint.pprint(newsItems)
    save_to_csv(newsItems, 'output.csv')

    counter += 1
    if counter >= max_files:
      break


# command line API
#   call with no params (from directory with XML files):           python item_xml_docs_to_csv.py
#   call with first arg as `path` param:                           python item_xml_docs_to_csv.py ./text_en_201909
#   call with first arg `path` and second arg `max_files` param:   python item_xml_docs_to_csv.py ./text_en_201909 20
if __name__ == "__main__":
  if len(sys.argv) == 1:
    parse_n_files()
  elif len(sys.argv) == 2:
    parse_n_files(sys.argv[1])
  else:
    parse_n_files(sys.argv[1], int(sys.argv[2]))