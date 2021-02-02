# Thread limit of SPARQL query
our $THREAD_LIMIT = 10;

# Endpoint
our $EP = "https://integbio.jp/rdf/mirror/uniprot/sparql";
our $EP_MIRROR = "https://sparql.uniprot.org/sparql";

# SPARQL query for get-taxonomy-list
our $QUERY_TAX = "PREFIX up: <http://purl.uniprot.org/core/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX db: <http://purl.uniprot.org/database/>
SELECT DISTINCT ?org
WHERE {
  ?org ^up:organism [ 
    a up:Protein ;
    rdfs:seeAlso [ 
      up:database db:HGNC
    ] ] .
}";

# SPARQL query for get-ID-list
our $QUERY = "PREFIX up: <http://purl.uniprot.org/core/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX db: <http://purl.uniprot.org/database/>
PREFIX tax: <http://purl.uniprot.org/taxonomy/>
SELECT DISTINCT ?source ?target
WHERE {
  ?source a up:Protein ;
           up:organism __TAXON__ ;
           rdfs:seeAlso ?target .
  ?target up:database db:HGNC .
}";

# regex : req. double escape backslash (e.g. '\d' -> '\\d')
our $SOURCE_REGEX = "http://purl.uniprot.org/uniprot/(.+)";
our $TARGET_REGEX = "http://purl.uniprot.org/hgnc/(.+)";
