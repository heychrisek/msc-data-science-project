# TODO
# [ ] remove debugging tools: pprint, pdb
# [ ] add command line argument for output .csv filename
# [ ] optimize script's performance

import csv
import os
import re
import sys
import xml.etree.ElementTree as ET

# REMOVE WHEN DONE
import datetime
import pprint
import pdb

NSMAP = {'iptc': 'http://iptc.org/std/nar/2006-10-01/',
           'xhtml': 'http://www.w3.org/1999/xhtml'}
CSV_ROW_LIMIT = 10000
VERBOSE = False

# temporary solution for encoded emojis in files like:
#   tag:reuters.com,2019:newsml_CqtdcPk1a:607651010.XML
#   tag:reuters.com,2019:newsml_CqtHM2P1a:938288348.XML
# for example: &#55358;&#56603;&#55357;&#56397;&#55356;&#56826;&#55356;&#56824;
# should become something like:
#   &#55358;&#56603; -> 55368 56603 -> https://www.iemoji.com/view/emoji/2277/smileys-people/left-facing-fist
#   &#55357;&#56397;
#   &#55356;&#56826;
#   &#55356;&#56824; -> 55356 56824 -> https://www.iemoji.com/view/emoji/1674/flags/south-sudan
# if only Trump's tweets weren't suspended :)
# solution could include:
#   https://github.com/KermMartian/smsxml2html/issues/1#issuecomment-414967015
#   https://stackoverflow.com/questions/13165408/decode-55357-to-real-character#answer-13165544
INVALID_CHAR_REGEX = '&#\d\d\d\d\d;'

def save_to_csv(news_items, filename):
  fields = ['filename',
            'datetime',
            'guid',
            'slugline',
            'headline',
            'description',
            'genres',
            'subjects',
            'bodyLengthChars',
            'bodyLengthWords',
            # 'body'
            ]

  with open(filename, 'w') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fields)
    writer.writeheader()
    writer.writerows(news_items)

def make_news_item_dict(filename, body='', datetime='EXCEPTION', description='EXCEPTION',
                        genres='EXCEPTION', guid='EXCEPTION', headline='EXCEPTION',
                        slugline='EXCEPTION', subjects='EXCEPTION'):
  """
  Return dictionary of news_item. For empty case (in exceptions), default arguments
  will be 'EXCEPTION' and 0 length for bodyLengthChards and bodyLengthWords.
  """
  return {#'body': body,
          'datetime': datetime,
          'description': description,
          'filename': filename,
          'genres': genres,
          'guid': guid,
          'headline': headline,
          'slugline': slugline,
          'subjects': subjects,
          'bodyLengthChars': len(body),
          'bodyLengthWords': len(body.split(' '))}

def parse_xml(path, filename):
  file = path + '/' + filename
  try:
    root = ET.parse(file).getroot()
  except Exception as e:
    raise(e)
    with open(file, 'r') as file:
      data = file.read()
      data = re.sub(INVALID_CHAR_REGEX, '�', data)
      root = ET.fromstring(data)

  guid = root.find('./iptc:itemSet/iptc:newsItem', namespaces=NSMAP).get('guid')

  subject_nodes = root.findall('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:subject/iptc:name', namespaces=NSMAP)
  subjects = set()
  if len(subject_nodes) == 0:
    subjects = None
  else:
    for s in subject_nodes:
      subjects.add(s.text)

  genre_nodes = root.findall('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:genre/iptc:name', namespaces=NSMAP)
  if len(genre_nodes) == 0:
    genres = None
  else:
    genres = set()
    for g in genre_nodes:
      genres.add(g.text)

  datetime = root.find('./iptc:itemSet/iptc:newsItem/iptc:itemMeta/iptc:firstCreated', namespaces=NSMAP).text
  slugline = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:slugline', namespaces=NSMAP).text
  headline = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:headline', namespaces=NSMAP).text
  description = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentMeta/iptc:description', namespaces=NSMAP).text
  body = root.find('./iptc:itemSet/iptc:newsItem/iptc:contentSet/iptc:inlineXML/xhtml:html/xhtml:body', namespaces=NSMAP)#.text
  body = str(ET.tostring(body))

  # make_news_item_dict(filename, body, datetime, description, genres, guid, headline, slugline, subjects)
  return {#'body': body,
          'datetime': datetime,
          'description': description,
          'filename': filename,
          'genres': genres,
          'guid': guid,
          'headline': headline,
          'slugline': slugline,
          'subjects': subjects,
          'bodyLengthChars': len(body),
          'bodyLengthWords': len(body.split(' '))}

def parse_xml_and_write_csv(path, files, output_filename):
  counter = 0
  news_items = []
  n_files = len(files)
  check_length = n_files // 10 + 1
  for i, filename in enumerate(files):
    if VERBOSE:
      if i%check_length == 0:
        print(str(int(i/n_files*100)) + '% of this segment complete - Parsing file ' + str(i) + ' out of ' + str(n_files) + ' - ', datetime.datetime.now())

    try:
      news_item = parse_xml(path, filename)
    except Exception as e:
      print('EXCEPTION: ', e, 'on file ', filename)
      news_item = make_news_item_dict(filename)
    news_items.append(news_item)

  if VERBOSE:
    print('Parsed next ' + str(n_files) + ' files')
    print('Saving to ' + output_filename + '...')

  save_to_csv(news_items, output_filename)

  if VERBOSE: print('Saved to ' + output_filename)

def parse_n_files(path='./', max_files=100000):
  files = os.listdir(path)
  files.sort()
  n_files = min(len(files), max_files)
  n_remaining_files = n_files

  if 'start_file_index' not in locals():
    start_file_index = 0
    end_file_index = start_file_index + CSV_ROW_LIMIT

  if VERBOSE:
    print('Parsing all ' + str(n_files) + 'XML files in directory')
    print()

  while end_file_index < n_files:
    end_file_index = start_file_index + CSV_ROW_LIMIT
    n_rows_in_csv = min(n_remaining_files, CSV_ROW_LIMIT)
    output_filename = 'output_' + str(start_file_index+1) + '_' + str(start_file_index + n_rows_in_csv) + '.csv'
    if VERBOSE: print('Parsing ' + str(n_rows_in_csv) + ' files into CSV rows in: ' + output_filename)
    parse_xml_and_write_csv(path, files[start_file_index:end_file_index], output_filename)
    n_remaining_files = n_remaining_files - n_rows_in_csv
    if VERBOSE:
      print('Completed parsing and saving of ' + str(n_files - n_remaining_files) + '/' + str(n_files) + ' files (' + str((n_files - n_remaining_files) / n_files * 100) + '%)')
      print()
    start_file_index += CSV_ROW_LIMIT


# command line API
#   call with no params (from directory with XML files):           python item_xml_docs_to_csv.py
#   call with first arg as `path` param:                           python item_xml_docs_to_csv.py ./text_en_201909
#   call with first arg `path` and second arg `max_files` param:   python item_xml_docs_to_csv.py ./text_en_201909 20
if __name__ == '__main__':
  if VERBOSE: print(datetime.datetime.now())
  if len(sys.argv) == 1:
    parse_n_files()
  elif len(sys.argv) == 2:
    parse_n_files(sys.argv[1])
  else:
    parse_n_files(sys.argv[1], int(sys.argv[2]))
  if VERBOSE: print(datetime.datetime.now())
