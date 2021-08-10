https://neo4j.com/developer/graph-data-science/build-knowledge-graph-nlp-ontologies/#entity-extraction
https://neo4j.com/developer/graph-data-science/nlp/entity-extraction/

// -----------
// 1 SEMANTICS
// -----------

CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;

CALL n10s.graphconfig.init({handleVocabUris: "MAP"});

CALL n10s.nsprefixes.add('neo','neo4j://voc#');
CALL n10s.mapping.add("neo4j://voc#subCatOf","SUB_CAT_OF");
CALL n10s.mapping.add("neo4j://voc#about","ABOUT");



// for each of the SPARQL urls in "SPARQL-endpoints.txt", to import:
//    - countries (Q6256), 4252 rows
//    - political parties (Q7278), sitelinks >= 20, 3532 rows
//    - public companies (Q891723), sitelinks >=30, 3346 rows
//    - cities (Q515), sitelinks >= 50, 22052 rows
//    - politicians (wdt:P106 wd:Q82955), sitelinks >= 75, 2629 rows
//    - athletes (?occupation wdt:P279 wd:Q2066131 .), sitelinks >= 55, 2899 rows
WITH "https://query.wikidata.org/sparql?query=prefix%20neo%3A%20%3Cneo4j%3A%2F%2Fvoc%23%3E%20%0A%0ACONSTRUCT%20%7B%0A%3Fitem%20a%20neo%3ACategory%20%3B%20neo%3AsubCatOf%20%3FparentItem%20.%20%20%0A%20%20%3Fitem%20neo%3Aname%20%3Flabel%20.%0A%20%20%3FparentItem%20a%20neo%3ACategory%3B%20neo%3Aname%20%3FparentLabel%20.%0A%20%20%3Farticle%20a%20neo%3AWikipediaPage%3B%20neo%3Aabout%20%3Fitem%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%0A%7D%0AWHERE%20%0A%7B%0A%20%20%3Fitem%20(wdt%3AP31%7Cwdt%3AP279)*%20wd%3AQ6256%20.%0A%20%20%3Fitem%20wdt%3AP31%7Cwdt%3AP279%20%3FparentItem%20.%0A%20%20%3Fitem%20rdfs%3Alabel%20%3Flabel%20.%0A%20%20filter(lang(%3Flabel)%20%3D%20%22en%22)%0A%20%20%3FparentItem%20rdfs%3Alabel%20%3FparentLabel%20.%0A%20%20filter(lang(%3FparentLabel)%20%3D%20%22en%22)%0A%20%20%0A%20%20OPTIONAL%20%7B%0A%20%20%20%20%20%20%3Farticle%20schema%3Aabout%20%3Fitem%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20schema%3AinLanguage%20%22en%22%20%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20schema%3AisPartOf%20%3Chttps%3A%2F%2Fen.wikipedia.org%2F%3E%20.%0A%20%20%20%20%7D%0A%20%20%0A%7D%0A" AS countriesUri
CALL n10s.rdf.import.fetch(countriesUri, 'Turtle' , { headerParams: { Accept: "application/x-turtle" } })
YIELD terminationStatus, triplesLoaded, triplesParsed, namespaces, callParams
RETURN terminationStatus, triplesLoaded, triplesParsed, namespaces, callParams;


// summary of nodes
CALL apoc.meta.stats()
YIELD labels, relTypes, relTypesCount
RETURN labels, relTypes, relTypesCount;

MATCH path = (c:Category {name: "republic"})<-[:SUB_CAT_OF*]-(child)
RETURN path
LIMIT 25;



// -----------
// 2 NLP / ENTITY EXTRACTION
// -----------

:params key => ("AIzaSyCIJz7J8WdS4y84ljjj1fa9wVvjzamW5Lk")

// example apoc.nlp.gcp.entities.stream to see return value from Google Cloud API
//    MATCH (n:NewsItem {guid: "tag:reuters.com,2019:newsml_A4N21U01K"})
//    CALL apoc.nlp.gcp.entities.stream(n, {nodeProperty:'body', key: $key})
//    YIELD node, value
//    RETURN node, value


// example apoc.nlp.gcp.entities.stream with a single news item
//    MATCH (n:NewsItem {guid: "tag:reuters.com,2019:newsml_A4N21U01K"})
//    CALL apoc.nlp.gcp.entities.stream(n, {nodeProperty:'body', key: $key})
//    YIELD node, value
//    SET node.gcpEntitiesProcessed = true
//    WITH node, value
//    UNWIND value.entities AS entity
//    
//    WITH entity, node
//    WHERE not(entity.metadata.wikipedia_url is null)
//    
//    MERGE (page:Resource {uri: entity.metadata.wikipedia_url, name:entity.name})
//    SET page:WikipediaPage
//    
//    MERGE (node)-[:HAS_ENTITY {salience:entity.salience}]->(page)
// 
// 
// example check of new entities and HAS_ENTITY relationships (with salience)
//    MATCH (n:NewsItem {guid: "tag:reuters.com,2019:newsml_A4N21U01K"})-[r:HAS_ENTITY]->(p)
//    RETURN n, r, p;

// batch of 10 completes every ~6 seconds
// 60,000 items / batch of 10 = 6,000 batches
// 6,000 batches x 6 seconds = 36,000 seconds = 600 minutes = 10 hours...
CALL apoc.periodic.iterate(
  "MATCH (n:NewsItem)
   WHERE not(exists(n.gcpEntitiesProcessed))
   RETURN n",
  "CALL apoc.nlp.gcp.entities.stream([item in $_batch | item.n], {
     nodeProperty: 'body',
     key: $key
   })
   YIELD node, value
   SET node.gcpEntitiesProcessed = true
   WITH node, value
   UNWIND value.entities AS entity
   WITH entity, node
   WHERE not(entity.metadata.wikipedia_url is null)
   MERGE (page:Resource {uri: entity.metadata.wikipedia_url})
   SET page:WikipediaPage
   MERGE (node)-[:HAS_ENTITY {salience:entity.salience}]->(page)",
  {batchMode: "BATCH_SINGLE", batchSize: 1000, params: {key: $key}})
YIELD batches, total, timeTaken, committedOperations
RETURN batches, total, timeTaken, committedOperations;

// see count of news items with entity extraction completed
MATCH (n:NewsItem {gcpEntitiesProcessed: true})
RETURN COUNT(n)

// see graph of news items -> entities
MATCH (n:NewsItem {gcpEntitiesProcessed: true})-[r:HAS_ENTITY]-(p)
RETURN n, r, p

// 
MATCH (p:WikipediaPage)
RETURN p.name, SIZE(()-[:HAS_ENTITY]->(p)) AS degree
ORDER BY degree DESC
LIMIT 10;


// -----------
// 3 QUERY KNOWLEDGE GRAPH
// https://neo4j.com/developer/graph-data-science/build-knowledge-graph-nlp-ontologies/#querying-the-knowledge-graph
// https://neo4j.com/developer/graph-data-science/build-knowledge-graph-nlp-ontologies/#querying-the-knowledge-graph
// -----------
MATCH (n:NewsItem)
WHERE NOT(n)-[:HAS_ENTITY]->()
RETURN COUNT(n);

    // -----------
    // 3a CLEANUP
    // some Category nodes are missing 'name' property -- see wikidata_urls_to_names.py script
    // after Python script runs, copy names into CSV of URIs, then run the following:
    // -----------
    CALL apoc.load.csv('wikidata_uris_and_names.csv') YIELD map as row
    MATCH (c:Category {uri: row.uri})
    SET c.name = row.name
    RETURN c


// news items matching Croatia as an explicit topic
MATCH (c:Category {name: "Croatia"})
CALL n10s.inference.nodesInCategory(c, {
  inCatRel: "ABOUT",
  subCatRel: "SUB_CAT_OF"
})
YIELD node
MATCH (node)<-[e:HAS_ENTITY]-(n:NewsItem)
RETURN n.headline AS headline, n.description AS description, n.datetime AS date,
       collect(n10s.rdf.getIRILocalName(node.uri)) as explicitTopics, e.salience AS entitySalience
ORDER BY entitySalience DESC
LIMIT 5;


// news items matching explicit topics like US and Egypt (countries), based on subcategory relationship to "state"
MATCH (c:Category {name: "state"})
CALL n10s.inference.nodesInCategory(c, {
  inCatRel: "ABOUT",
  subCatRel: "SUB_CAT_OF"
})
YIELD node
MATCH (node)<-[e:HAS_ENTITY]-(n:NewsItem)
RETURN n.headline AS headline, n.description AS description, n.datetime AS date,
       collect(n10s.rdf.getIRILocalName(node.uri)) as explicitTopics, e.salience AS entitySalience
ORDER BY entitySalience DESC
LIMIT 500;


// news items matching explicit topics like Norway and Thailand, based on subcategory relationship to "constitutional monarchy"
MATCH (c:Category {name: "constitutional monarchy"})-[r]-(n)
RETURN c, r, n

MATCH (c:Category {name: "constitutional monarchy"})
CALL n10s.inference.nodesInCategory(c, {
  inCatRel: "ABOUT",
  subCatRel: "SUB_CAT_OF"
})
YIELD node
MATCH (node)<-[e:HAS_ENTITY]-(n:NewsItem)
RETURN n.headline AS headline, n.description AS description, n.datetime AS date,
       collect(n10s.rdf.getIRILocalName(node.uri)) as explicitTopics, e.salience AS entitySalience
ORDER BY entitySalience DESC
LIMIT 500;



MATCH (n:NewsItem {guid: "tag:reuters.com,2019:newsml_A4N21U01Y"}),
      path = (a)-[:HAS_ENTITY]->(wiki)-[:ABOUT]->(cat),
      otherPath = (wiki)<-[:HAS_ENTITY]-(other)
return path, otherPath;


// :ABOUT relationship between wikipedia page and category for Obamas
MATCH (w:WikipediaPage)-[a:ABOUT]-(c:Category)
WHERE w.uri CONTAINS "Obama"
RETURN w, a, c;


// Category and WikipediaPage for US Democratic Party
MATCH (c:Category)<-[r:ABOUT]-(w:WikipediaPage)
WHERE c.uri="http://www.wikidata.org/entity/Q29552"
RETURN c, r, w;


// categories that are subcategories of something else
MATCH (c1)-[:SUB_CAT_OF]-(c2)
RETURN c1, c2 LIMIT 10;


// categories that are parents of IBM
MATCH p=(c1 {name:"IBM"})-[:SUB_CAT_OF]-(c2)
WITH *, relationships(p) AS r
RETURN c1, c2, r LIMIT 100