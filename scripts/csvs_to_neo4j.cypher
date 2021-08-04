// after outputting breakingviews.csv, put it in Neo4j /import directory
// also put genres.csv, reuters.csv, and subjects-with-wikidata.csv in /import

// create 216 NewsItem nodes, one for each breakingviews item
CALL apoc.load.csv('/breakingviews.csv') yield map as row
CREATE (n:NewsItem) SET n = row;

// create 59k NewsItem nodes, one for each reuters item
// CALL apoc.load.csv('/reuters.csv') yield map as row
// CREATE (n:NewsItem) SET n = row;

CALL apoc.load.csv('/genres.csv') yield map
CREATE (g:Genre {genre: map.genre});

// MATCH (g:Genre) RETURN g LIMIT 10;

MATCH (g:Genre)
WITH g.genre AS genres
UNWIND genres AS genre
MATCH (n:NewsItem),(g:Genre) WHERE n.genres CONTAINS genre AND g.genre = genre
CREATE (n)-[r:HAS_GENRE]->(g);

MATCH (n:NewsItem)-[r:HAS_GENRE]->(g:Genre)
RETURN n, r, g LIMIT 20;

CALL apoc.load.csv('subjects-with-wikidata.csv') YIELD map
CREATE (s:Subject) SET s = map;

// MATCH (s:Subject) RETURN s, s.subject LIMIT 10;
// MATCH (s:Subject {category: "US state"}) RETURN s LIMIT 10;
// MATCH (s:Subject {category: "continent"}) RETURN s LIMIT 10;
// MATCH (s:Subject {category: "region"}) RETURN s LIMIT 10;
// MATCH (s:Subject {category: "art and culture"}) RETURN s LIMIT 10;

MATCH (s:Subject)
WITH s.subject AS subjects
UNWIND subjects AS subject
MATCH (n:NewsItem),(s:Subject) WHERE n.subjects CONTAINS subject AND s.subject = subject
CREATE (n)-[r:HAS_SUBJECT]->(s);

MATCH (n:NewsItem)-[r:HAS_SUBJECT]->(s:Subject)
RETURN n, r, s LIMIT 20;


// NewsItem with subject South America AND Europe
// MATCH (s1 {subject:'Europe'})<-[r1:HAS_SUBJECT]-(n:NewsItem)-[r2:HAS_SUBJECT]->(s2:Subject {subject:'South America'})
// RETURN s1, r1, n, s2, r2 LIMIT 200;


// Create new :RELATED_TO relationship for these three items that share South America and Europe
// MATCH (n1:NewsItem), (n2:NewsItem), (s:Subject{category:"continent"})
// WHERE (n1)-[:HAS_SUBJECT]->(s)
// AND (n2)-[:HAS_SUBJECT]->(s)
// AND NOT n1.guid = n2.guid
// CREATE (n1)-[:RELATED_TO{reason:"shared continent subjects"}]->(n2);


// MATCH (n1:NewsItem)-[r:RELATED_TO]-(n2:NewsItem) RETURN n1, r, n2 LIMIT 3;


// TBD Introduce entities, simply using South America subject for now
// CREATE (e:Entity{name:"South America"})

// CREATE CONSTRAINT ON (e:Entity) ASSERT e.name IS UNIQUE

// MATCH (n)-[:HAS_SUBJECT]->(s{subject:"South America"}), (e:Entity{name:"South America"})
CREATE (n)-[:HAS_ENTITY]->(e)

// MATCH (n)-[:HAS_ENTITY]->(e) RETURN n, e




// 00001-10000   14:10-14:34 (24 minutes)
// 10001-20000   14:34-14:40 (6 minutes)
// 20001-30000   14:41-14:48 (7 minutes)
// 30001-40000   14:49-14:57 (8 minutes)
// 40001-50000   14:57-15:03 (6 minutes)
// 50001-59542   15:03-15:08 (5 minutes)
//                           (56 minutes)
CALL apoc.load.csv('/guid_to_text_body.csv') yield map as row
MATCH (n:NewsItem {guid:row.guid})
SET n.body = row.body
RETURN n.guid, n.body;