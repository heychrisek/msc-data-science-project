research questions

  topic / title
  A Domain-Specific Knowledge Graph for News Recommendations

  high-level
  build a domain-specific knowledge graph of news items
  use the knowledge graph for prototype recommender system (item to item, entity to entity, entity to item)
  use the knowledge graph to run experiments, to improve recommendations and information retrieval:
    - apply semantic technologies (ontologies, vocabulary, RDF)
    - apply NLP (NER, clustering, topic/keyword extraction)
    - apply ML (clustering/similarity/[link prediction](https://neo4j.com/docs/graph-data-science/current/algorithms/ml-models/linkprediction/))
  evaluate experiments' improvements over the prototype
  
  can we build a NewsML to KG pipeline?
    NewsML -> named entity recognition -> wikidata links -> Neo4j Knowledge Graph

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

  enrichment:
    - can we enhance the data / knowledge graph with semantic technologies (ontology, vocabulary, RDF)?
    - can we enhance data / knowledge graph with NER? can we measure the improvement?
    - does a knowledge graph improve the quality of recommended news items?
    - does a knowledge graph improve information retrieval?
    - how to evaluate improvements in quality or information retrieval? (precision/recall)
    - can we generate new links between news items?
    - can we generate new links between entities? (e.g., [2.2 of this article](http://ceur-ws.org/Vol-2601/kars2019_paper_01.pdf) -- Trump and Lebron same news)
    - can we identify meaningful clusters of news items?
    - can we extract implicit/latent topics or keywords from news items?
        - **Category classification task**
    - which news item relations are relevant (for news)? can we remove irrelevant relations?
    - can we expose the knowledge graph as a user-facing application? (Neo4j, UI, API?)
    - what is a meaningful level of connection between news items? (for example, one-hop, paths of length N, shared entity with salience above some weight/cutoff)
    - can we learn Knowledge Graph Embeddings (KGEs)?
        - more detail: [1](https://towardsdatascience.com/introduction-to-knowledge-graph-embedding-with-dgl-ke-77ace6fb60ef), [2](https://github.com/awslabs/dgl-ke), [3](https://ieeexplore.ieee.org/document/8047276)
    - are knowledge graph recommendations explainable? (model explainability)

