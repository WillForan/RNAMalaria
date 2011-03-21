CREATE TABLE  features(
	ID			CHAR NOT NULL,  --should be uniq?
	chrom			INT NOT NULL,
	start			INT NOT NULL,
	end			INT NOT NULL,
	feature			CHAR NOT NULL,
	strand			CHAR,
	frame			INT,
	score			INT,
	source			CHAR,
	timelastmodified,
	blastp_file,
	blastx_file,
	isObsolete,
	Parent,
	feature_id,
	colour,
	Dbxref,
	product,
	Derives_from,
	previous_systematic_id,
	orthologous_to,
	literature,
	translation,
	comment,
	gO,
	polypeptide_domain,
	fasta_file,
	transmembrane_polypeptide_region,
	non_cytoplasmic_polypeptide_region,
	membrane_structure,
	cytoplasmic_polypeptide_region,
	blastpgo_file,
	Name,
	gPI_anchor_cleavage_site,
	eC_number,
	synonym,
	signal_peptide,
	paralogous_to,
	curation,
	product_synonym,
	controlled_curation,
	clustalx_file,
	stop_codon_redefined_as_selenocysteine BOOLEAN,
	tblastx_file, --included for one read :(
	Note
);

/*
	seqname -- The name of the sequence. Must be a chromosome or scaffold.
	source -- The program that generated this feature.
	feature -- The name of this type of feature. Some examples of standard feature types are "CDS", "start_codon", "stop_codon", and "exon".
	start -- The starting position of the feature in the sequence. The first base is numbered 1.
	end -- The ending position of the feature (inclusive).
	score -- A score between 0 and 1000. If the track line useScore attribute is set to 1 for this annotation data set, the score value will determine the level of gray in which this feature is displayed (higher numbers = darker gray). If there is no score value, enter ".".
	strand -- Valid entries include '+', '-', or '.' (for don't know/don't care).
	frame -- If the feature is a coding exon, frame should be a number between 0-2 that represents the reading frame of the first base. If the feature is not a coding exon, the value should be '.'.
	group -- All lines with the same group are linked together into a single item.
*/

/*
./parse.pl 2011-03-20/01.gff |sort |uniq -c |sort -nr #where print join("\n",keys(%extra)),"\n";
1031 timelastmodified
1031 ID
1023 isObsolete
634 Parent
587 feature_id
552 colour
154 Dbxref
149 product
149 Derives_from
146 previous_systematic_id
143 orthologous_to
141 literature
137 translation
121 comment
108 gO
96 polypeptide_domain
81 fasta_file
72 transmembrane_polypeptide_region
72 non_cytoplasmic_polypeptide_region
72 membrane_structure
72 cytoplasmic_polypeptide_region
72 blastp%2Bgo_file
45 Name
43 gPI_anchor_cleavage_site
23 eC_number
19 synonym
16 signal_peptide
8 isObsolete
8 Parent  
6 paralogous_to
6 curation
1 product_synonym
1 Note
*/
