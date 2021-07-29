# news items with 1 subject
MATCH (n:NewsItem)-[:HAS_SUBJECT]->(s:Subject)
WITH n, count(s) as rels, collect(s) as subjects
WHERE rels = 1
RETURN n, subjects, rels;


# news items with 1 genre relationship
MATCH (n:NewsItem)-[:HAS_GENRE]->(g:Genre)
WITH n, count(g) as rels, collect(g) as genres
WHERE rels = 1
RETURN n, genres, rels;


# news items with more than 5 genre relationships
MATCH (n:NewsItem)-[:HAS_GENRE]->(g:Genre)
WITH n, count(g) as rels, collect(g) as genres
WHERE rels > 5
RETURN n, genres, rels;


# 11433 news items with more than 10 subjects, max of 91 subjects
# (91-subject news items are mostly/all "DIARY-POLITICAL/ (DIARY):DIARY-Political and General News Events from #{DATE}")
MATCH (n:NewsItem)-[:HAS_SUBJECT]->(s:Subject)
WITH n, count(s) as numberOfSubjects, collect(s) as subjects
ORDER BY numberOfSubjects DESC
WHERE numberOfSubjects > 10
RETURN n.guid, numberOfSubjects;


# longest news items
MATCH (n:NewsItem)
WITH n, toInteger(n.bodyLengthChars) as chars
ORDER BY chars DESC
RETURN n, chars
LIMIT 10;


# shortest news items
MATCH (n:NewsItem)
WITH n, toInteger(n.bodyLengthChars) as chars
ORDER BY chars
RETURN n, chars
LIMIT 10;


# subjects sorted by degree (number of news items with that subject)
MATCH (s:Subject)
RETURN s.subject, SIZE(()-[:HAS_SUBJECT]->(s)) AS degree
ORDER BY degree DESC;


# genres sorted by degree (number of news items with that genre)
MATCH (g:Genre)
RETURN g.genre, SIZE(()-[:HAS_GENRE]->(g)) AS degree
ORDER BY degree DESC;