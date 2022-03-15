#!/usr/bin/perl

# Ensembl Genome (Plants, Metazoa, Protists, Fungi, Bacteria) の TSV から ID 抽出
# ensembl_xxx_gene (source) to other dataset (target)

my $dir = $ARGV[0];      # e.g. ${TOGOID_ROOT}/ensembl_genomes/plants

### dataset list
# ensembl_transcript
# ensembl_protein
# ncbigene
# renfeq_rna
# refseq_protein
# uniprot
my $dataset = $ARGV[1];

my $source = "gene_stable_id";
my $db = "db_name";
my $target;
my $file_postfix;
my $db_name;
my $source_col;
my $target_col;
my $db_col;
my $rm_target_version = 0;

# check dataset
if ($dataset eq "ensembl_transcript") {
  $file_postfix = "ena";
  $target = "transcript_stable_id";
} elsif ($dataset eq "ensembl_protein") {
  $file_postfix = "ena";
  $target = "protein_stable_id";
} elsif ($dataset eq "ncbigene") {
  $file_postfix = "entrez";
  $target = "xref";
  $db_name = "EntrezGene";
} elsif ($dataset eq "refseq_rna") {
  $file_postfix = "refseq";
  $target = "xref";
  $db_name = "RefSeq_dna";
  $rm_target_version = 1;
} elsif ($dataset eq "refseq_protein") {
  $file_postfix = "refseq";
  $target = "xref";
  $db_name = "RefSeq_peptide";
  $rm_target_version = 1;
} elsif ($dataset eq "uniprot") {
  $file_postfix = "uniprot";
  $target = "xref";
  $db_name = "Uniprot";
}

# get file list
my @files = `ls ${dir}/*.${file_postfix}.tsv.gz`;

# check column from a file
chomp($files[0]);
my @header = split(/\t/, `gzip -dc ${files[0]} | head -n 1`);
for (my $i = 0; $i <= $#header; $i++) {
  if ($header[$i] eq $source) {
    $source_col = $i + 1;
  }
  if ($header[$i] eq $target) {
    $target_col = $i + 1;
  }
  if ($header[$i] eq $db) {
    $db_col = $i + 1;
  }
}

# output
for (my $i = 0; $i <= $#files; $i++) {
  chomp($files[$i]);
  
  # エスケープがややこしいので、場合分けで書き下し
  if ($db_name) {
    if ($rm_target_version) {
      # check DB name & remove version number
      print `gzip -dc ${files[$i]} | sed 1d | awk '{ if (\$${target_col} && \$${db_col} ~ "${db_name}") { printf "\%s\t\%s\\n", \$${source_col}, \$${target_col} } }' | sed -r 's/\\.[0-9]+\$//g' | sort | uniq`;
    } else {
      # check DB name
      print `gzip -dc ${files[$i]} | sed 1d | awk '{ if (\$${target_col} && \$${db_col} ~ "${db_name}") { printf "\%s\t\%s\\n", \$${source_col}, \$${target_col} } }'                             | sort | uniq`;
    }
  } else {
    if ($rm_target_version) {
      # remove version number
      print `gzip -dc ${files[$i]} | sed 1d | awk '{ if (\$${target_col})                               { printf "\%s\t\%s\\n", \$${source_col}, \$${target_col} } }' | sed -r 's/\\.[0-9]+\$//g' | sort | uniq`;
    } else {
      # normal
      print `gzip -dc ${files[$i]} | sed 1d | awk '{ if (\$${target_col})                               { printf "\%s\t\%s\\n", \$${source_col}, \$${target_col} } }'                             | sort | uniq`;
    }  
  }
}