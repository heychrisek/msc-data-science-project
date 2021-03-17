https://arxiv.org/pdf/1904.05557.pdf

"Searching News Articles Using an Event Knowledge Graph Leveraged by Wikidata"

  related (IPTC, rNews): https://www.researchgate.net/publication/221467264_Bringing_the_IPTC_News_Architecture_into_the_Semantic_Web


"In this paper, we present a system for aggregating unstructured news articles and structured data describing events leveraging on the Wikidata knowledge base. This approach makes use of several Information Retrieval and Information Extraction tasks. In the context of Information Extraction,the knowledge associated with news articles can typically be used for training event extractors in a distant supervision mode. From the Information Retrieval perspective, the approach makes it possible to retrieve news articles describing events using either keyword-based queries or filters that typically make use of properties available in knowledge bases. It also allows to query Wikidata and then to read an entire annotated article describing the corresponding event. We implemented a system which is available at http://asrael.eurecom.fr/ and covers the last two tasks" (1)

**Figure 1: System overview for annotating news articles and enabling structured search.**


Data: AFP articles
      Wikidata occurences (https://www.wikidata.org/wiki/Q1190554)
        for example: https://www.wikidata.org/wiki/Q3107014
      IPTC Media Topics

Approach:
  - map articles to Wikidata occurences
      - **precision/recall -- see scoring function and ["golden standard" mapping](https://github.com/crudnik/asrael)**

  - Schema Clustering
  - Automatic Semantic Annotation of News Articles
  - Search Engine
  