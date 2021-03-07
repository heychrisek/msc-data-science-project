# msc-data-science-project

See [TODO.md](https://github.com/heychrisek/msc-data-science-project/blob/main/TODO.md) for a todo list of reading.

This README documents some of the actual code / processing / data science that's been completed or planned. Skip ahead to [section 2c](https://github.com/heychrisek/msc-data-science-project/#2c-csv-and-dimensions) for some interactive code.

### 1. Source and analyze the data

#### 1a. Data source

This project will use this dataset provided by Reuters: [Reuters News Archive (30 Days)](https://aws.amazon.com/marketplace/pp/Reuters-News-Archive-30-Days/prodview-qwmkdffmmjesa#offers). It is briefly described as:

> Reuters’ Text Archive provides the full corpus of English articles that have been published. This will include breaking news in the financial and general news space as well as global coverage in politics, sports, entertainment, and technology. This comprehensive corpus of content makes this dataset ideal for any natural language processing (NLP) algorithms or ML applications.

#### 2a. Corpus size

There are 59,542 documents in this corpuse. 

```
$ find ./ -type f | wc -l
59542
```

#### 2b. XML

Each file is an XML document in the [IPTC NewsML-G2](https://iptc.org/standards/newsml-g2/) format.

[ ] **TODO**: review NewsML-G2
[ ] **TODO**: document this XML structure
[ ] **TODO**: map XML structure to human-meaningful description
[ ] **TODO**: ontology? review XML [limitations](https://www.cambridgesemantics.com/blog/semantic-university/learn-rdf/rdf-vs-xml/) and consider how to expand the semantics of this dataset

#### 2c. CSV and dimensions

The [`item_xml_docs_to_csv.py` script](https://github.com/heychrisek/msc-data-science-project/blob/main/item_xml_docs_to_csv.py) coupled with the [Jupyter notebook](https://github.com/heychrisek/msc-data-science-project/blob/main/data-dimensions.ipynb) some early insights into the data and its dimensions:

```
import pandas as pd

df = pd.read_csv('../output.csv')
df.head()

df.describe()
# rough estimates about the text body:
#  - text body tends to be about 595 words long, but with extreme outliers (46297!)
#  - text body tends to be about 2904 chars long, but with extreme outliers (203K!)
#  - average word length is 4-5 chars long (bodyLengthChars / bodyLengthWords, for mean and max)

df.info()
# rough observations:
#  - genres are missing for the majority of items (could disregard genre, or this could be an
#    interesting problem: predict genre items where it's missing)
#  - subjects are missing for a small number of items, about 6.5%

```
### 2. Ingest the documents into Neo4j
[ ] Proof of concept: follow [Neo4j tutorial](https://neo4j.com/developer/graph-data-science/build-knowledge-graph-nlp-ontologies/)
[ ] Sample Cypher queries

### 3. Text processing

Consider:
[ ] evaluating and improving information retrieval (search)
[ ] text classification
      [ ] Neo4j: items have phrases, phrases have topics, same topics are same class?
      [ ] similarity/clustering

### 4. [optional] Deploy data / pipeline / API?
[ ] Neo4j cloud hosting
[ ] Expose Cypher query interface
[ ] Expose information retrieval search API
[ ] Chatbot

### 5. Finalize written report
[ ] finalize code/pipeline -- identify key code snippets
[ ] diagram of data flow: XML docs -> CSV/Neo4j -> NLP pipeline
[ ] **define the problem**: improve information retrieval with Neo4j? apply Neo4j to improve NLP applications? use Neo4j to improve *semantic value* of text data? compare Neo4j to non-graph DBs for information retrieval or NLP applications?

#### 5x. Challenges
Notes about challenges faced (and solved):
[ ] emojis in tweets (&#55358;&#56603; -> left-facing fist emoji) for tag:reuters.com,2019:newsml_CqtHM2P1a. solutions: (1) handle exceptions, (2) sub &#\d\d\d\d\d; with �, (3) TBD correct solution
[ ] scale of data -- script takes ~2 hours (?) to run
[ ] how to store / process text files (not in CSV!)
[ ] loading into Neo4j
[ ] how to split words -- 1 or more spaces so that tag:reuters.com,2019:newsml_L3N2602HC:991614233.XML doesn't have 76783 words (still has 294233 chars)
    - [ ] weird document (table, lots of whitepace): tag/reuters.com,2019/newsml_L3N2602HC/991614233.XML
    - [ ] weird document (full transcript of a committee hearing): tag/reuters.com,2019/newsml_CqtYP8GSa/1548902168.XML
    - [ ] how to compute average word length