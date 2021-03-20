// after outputting breakingviews.csv, put it in Neo4j /import directory

// create 216 NewsItem nodes, one for each breakingviews item
CALL apoc.load.csv('/breakingviews.csv') yield map as row
CREATE (n:NewsItem) SET n = row

CALL apoc.load.csv('/genres.csv') yield map
CREATE (g:Genre {genre: map.genre})

MATCH (g:Genre) RETURN g LIMIT 10



// all breakingviews nodes have genres Columns, Reports, Reuters Breakingviews
// only some have Reuters Breakingviews Full, Dealtalk, Enterprise reporting, Media type Graphics, so add for those

// 1 relationship
MATCH (n:NewsItem),(g:Genre)
WHERE n.genres CONTAINS "Dealtalk" AND g.genre = "Dealtalk"
CREATE (n)-[r:HAS_GENRE]->(g)
RETURN r;

// 1 relationship
MATCH (n:NewsItem),(g:Genre)
WHERE n.genres CONTAINS "Enterprise reporting" AND g.genre = "Enterprise reporting"
CREATE (n)-[r:HAS_GENRE]->(g)
RETURN n, r, g;

// 3 relationships
MATCH (n:NewsItem),(g:Genre)
WHERE n.genres CONTAINS "Media type Graphics" AND g.genre = "Media type Graphics"
CREATE (n)-[r:HAS_GENRE]->(g)
RETURN n, r, g;

// 114 relationships
MATCH (n:NewsItem),(g:Genre)
WHERE n.genres CONTAINS "Reuters Breakingviews Full" AND g.genre = "Reuters Breakingviews Full"
RETURN r;
CREATE (n)-[r:HAS_GENRE]->(g)


MATCH (n:NewsItem)-[r:HAS_GENRE]->(g:Genre)
RETURN n, r, g


CREATE (s:Subject {subject:'Antarctica'});
CREATE (s:Subject {subject:'Africa'});
CREATE (s:Subject {subject:'Asia'});
CREATE (s:Subject {subject:'Australia'});
CREATE (s:Subject {subject:'Europe'});
CREATE (s:Subject {subject:'North America'});
CREATE (s:Subject {subject:'South America'});

MATCH (s:Subject) SET s.type='Continent'

MATCH (s:Subject) RETURN s;



// there's probably a better way to iterate / FOREACH, but for now manually run for each of seven (7) breakingviews subjects (for continents):

// 0 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "Antarctica" AND s.subject = "Antarctica"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 8 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "Africa" AND s.subject = "Africa"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 103 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "Asia" AND s.subject = "Asia"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 10 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "Australia" AND s.subject = "Australia"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 116 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "Europe" AND s.subject = "Europe"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 122 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "North America" AND s.subject = "North America"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;

// 5 relationships
MATCH (n:NewsItem),(s:Subject)
WHERE n.subjects CONTAINS "South America" AND s.subject = "South America"
CREATE (n)-[r:HAS_SUBJECT]->(s)
RETURN n, r, s;


MATCH (n:NewsItem)-[r:HAS_SUBJECT]->(s:Subject)
RETURN n, r, s;


// NewsItem with subject South America AND Europe
MATCH (s1 {subject:'Europe'})<-[r1:HAS_SUBJECT]-(n:NewsItem)-[r2:HAS_SUBJECT]->(s2:Subject {subject:'South America'})
RETURN s1, r1, n, s2, r2


// Create new :RELATED_TO relationship for these three items that share South America and Europ
MATCH (n1:NewsItem), (n2:NewsItem), (s1:Subject{subject:"South America"}), (s2:Subject{subject:"Europe"})
WHERE (n1)-[:HAS_SUBJECT]->(s1)
AND (n1)-[:HAS_SUBJECT]->(s2)
AND (n2)-[:HAS_SUBJECT]->(s1)
AND (n2)-[:HAS_SUBJECT]->(s2)
AND NOT n1.guid = n2.guid
CREATE (n1)-[:RELATED_TO{reason:"shared continent subjects"}]->(n2)

MATCH (n1)-[r:RELATED_TO]-(n2)
RETURN n1, r, n2


// Introduce entities, simply using South America subject for now
CREATE (e:Entity{name:"South America"})

CREATE CONSTRAINT ON (e:Entity) ASSERT e.name IS UNIQUE

MATCH (n)-[:HAS_SUBJECT]->(s{subject:"South America"}), (e:Entity{name:"South America"})
CREATE (n)-[:HAS_ENTITY]->(e)

MATCH (n)-[:HAS_ENTITY]->(e) RETURN n, e


