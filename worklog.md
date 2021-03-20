Worklog

### Upcoming
 - [ ] review semantic "layer cake": OWL, SPARQL, RDF, schema, KG
 - [ ] consider SPARQL category query...politicians, people above a certain fame, political organizations, financial orgs, countries?
      - [ ] are all subjects a [type of sport](https://www.wikidata.org/wiki/Q31629) or [geographic region](https://www.wikidata.org/wiki/Q82794)? (plus art/entertainment)
 - [ ] [Neo4j link prediction](https://neo4j.com/docs/graph-data-science/current/algorithms/ml-models/linkprediction/)
 - [ ] Neo4j and OWL / RDF
      - https://neo4j.com/docs/labs/nsmntx/current/importing-ontologies/
      - https://neo4j.com/blog/using-owl-with-neo4j/
      - https://lju-lazarevic.github.io/ImportingRDFSOWL.html
      - https://community.neo4j.com/t/import-owl-individuals-to-neo4j/11873
 - [ ] start using Python driver for Neo4j: https://neo4j.com/developer/python/
 - [ ] submit project proposal
 - [ ] figure out AWS hosted Neo4j: https://console.aws.amazon.com/marketplace/home/subscriptions#/subscriptions/42e71149-46df-4ee5-ae1b-34d134153fd6

### March
 - 20 March: **finished project proposal draft**, emailed Michael to schedule feedback discussion
 - 17 March:
    - major literature review of several news KG articles
    - started tex proposal -- need to continue with project problem, plan, software, etc. - SEE research-questions and applications-ontologies-use-cases
 - 15 March: found a few articles and briefly reviewed one
 - 14 March:
    - found a few new academic articles ([1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9216015), [2](https://ojs.aaai.org/index.php/AAAI/article/view/5681), [3](https://msnews.github.io/assets/doc/ACL2020_MIND.pdf))
    - still defining research question: KG + NLP + link prediction for...recommendations, fact extraction, information retrieval?
    - reviewed two MK Bergman KG articles: [1](https://github.com/heychrisek/msc-data-science-project/blob/main/article-notes/2021-03-14_https-www-mkbergman-com-2244-a-common-sense-view.md), [2](https://github.com/heychrisek/msc-data-science-project/blob/main/article-notes/2021-03-14_https-www-mkbergman-com-2267-combining.md)
 - 12 March:
    - add individual features/columns for each subject/genre (see notebook and output CSVs)
    - CSV with sample of ~200 news items: breakingviews.csv
    - Neo4j CREATE NewsItems for 216 Breakingviews news items, basic genres, and continent subjects
      - images: [1](https://drive.google.com/file/d/1LeIy60x17guQbfFBS0EhznmPR-d00SZ9/view?usp=sharing), [2](https://drive.google.com/file/d/1pKNjCCksnJ522UOInAD3iQtURSP7MTy5/view?usp=sharing), [3](https://drive.google.com/file/d/1gMdv4bqjJb77qelHnmUOz4FDfIor4h3C/view?usp=sharing), [4](https://drive.google.com/file/d/1z5UlOC5Y_JatiUtmWGN70grOArDzeapI/view?usp=sharing)
    - complete WikiData IDs in `subjects-with-wikidata.csv` 
    - TO BE CONTINUED: pick up where [these notes](https://github.com/heychrisek/msc-data-science-project/blob/main/notes-to-self/2021-03-12-project-title-and-diagram.txt) left off
 - 11 March: complete [Neo4j knowledge graph tutorial](https://neo4j.com/developer/graph-data-science/build-knowledge-graph-nlp-ontologies/)
 - Early March: Start data analysis and scripting (see [item_xml_docs_to_csv.py](https://github.com/heychrisek/msc-data-science-project/blob/main/scripts/item_xml_docs_to_csv.py), [data-dimensions.ipynb Python notebook](https://github.com/heychrisek/msc-data-science-project/blob/main/data-dimensions.ipynb) and output CSVs)


### Earlier
 - Source [data](https://aws.amazon.com/marketplace/pp/Reuters-News-Archive-30-Days/prodview-qwmkdffmmjesa), early drafts ([here](https://docs.google.com/document/d/1-Ltw4ZjXQVwPCVux86JSdNDtQngP33QWRi5KTal2QUg/edit?usp=sharing), [here](https://docs.google.com/document/d/1viAyGsHNJJKXqgL_oeUCmmGzPOB0lZLolx-1lRwc3ZE/edit?usp=sharing), [here](https://docs.google.com/document/d/1AIcdu5ZSYt-s7Xytc7WMUEsNNxGkWzT-t5vpIbpLxV4/edit?usp=sharing)) and [initial project proposal](https://drive.google.com/file/d/1sfsfyxlBT35WbQ6Vuz7Expz3fEhNqH-M/view?usp=sharing)