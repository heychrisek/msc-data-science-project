// news items with no entities
MATCH (n:NewsItem)
WHERE NOT (n)-[:HAS_ENTITY]->()
RETURN COUNT(n);


// entities with no names
MATCH (w:WikipediaPage) WHERE not exists(w.name) RETURN w;


