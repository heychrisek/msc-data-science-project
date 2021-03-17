useful applications  
  Wikification (document annotation)
  Part-of-speech tagging
  Cosine similarity measure
  Neighbourhood subgraph
  Concept information 
    http://wikifier.org/
    http://wikifier.ijs.si/info.html

  news aggregator API
    https://newsapi.org/

  news aggregator UI/API
    https://eventregistry.org/
    https://github.com/EventRegistry/event-registry-python

  cross-lingual similarity
    http://aidemo.ijs.si/xling/wikipedia.html

  global events
    https://www.gdeltproject.org/

  news knowledge graph generator (**most similar to my use case?**)
    http://asrael.eurecom.fr/

  event knowledge graph
    http://eventkg.l3s.uni-hannover.de/

ontologies/vocabularies
  BBC
    https://www.bbc.co.uk/ontologies
  
  IPTC newscodes
    https://iptc.org/standards/newscodes/
    http://cv.iptc.org/newscodes/
    http://cv.iptc.org/newscodes/mediatopic
    http://show.newscodes.org/index.html?newscodes=medtop

use cases
  discover news events
    aggregate news events
    harvest/store news events
  link news events
  enhance/enrich news events (additional detail metadata, link to Wikidata/DBpedia)
  retrieve news events (improve information retrieval)
  recommend news events

my project
  NewsML -> NER -> wikidata links -> Neo4j Knowledge Graph

  question: how to aggregate text news data and enhance link prediction and information retrieval using semantic technologies, NLP, and ML
  goals:
    - pipeline: documents -> enrichment -> graph DB
        - enrichment
            - NER (named entities)
            - Wikidata links
            - topic extraction (keywords)
            - ontology
            - linked items (linked to each other, linked to an event?)
            - clustering
        - knowledge graph representation in Neo4j
    - practical applications
        - information retrieval (evaluate precision/recall)
        - linked item recommendations