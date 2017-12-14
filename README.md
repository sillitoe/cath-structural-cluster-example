
# Structural Clusters

This project contains a set of example files relating to:

 * CATH Functional Families (`ff`)
 * CATH Structural Clusters (`ff_ssg5`)

 ```
 $ ls -1 example_data/
 1.10.510.10-ff-77378.faa
 1.10.510.10-ff-77378.reduced.filter.log
 1.10.510.10-ff-77378.reduced.sto
 1.10.510.10-ff_ssg5-21.aln_reps.cora
 1.10.510.10-ff_ssg5-21.aln_reps.cora.fa
 1.10.510.10-ff_ssg5-21.reps
 1.10.510.10-ff_ssg5-21.reps.fa
 1.10.510.10-ff_ssg5-21.scorecons
 ```

More info on each of these files below.

## Overview

Basic idea of generating superfamilies of protein domains in CATH-Gene3D:

 1. Identify structural domains within PDB
 1. Group structural structures where there is clear evidence of common evolutionary ancestor
 1. Use HMM to identify where these structural domains lie on all known sequences

Within a CATH-Gene3D superfamily, we generate families of functionally related sequences (FunFams).
We then use structural alignments to try and stick these potentially remote FunFams back together
while maintaining structurally conserved regions.

## Functional Families (FunFams)

Within a particular CATH superfamily (e.g. `1.10.510.10`):

_Cluster_ protein domain sequences from PDB (CATH) and UniProtKB (Gene3D) into functionally related groups (FunFams)

  1.10.510.10-ff-77378.faa

_Output_ Funfam files:
 * add annotations (`EC`, `GO`, `UNIPROT`, `CSA`, etc)
 * filter FunFam sequences (see below)
 * run `scorecons` to calculate conservation within alignment positions (and overall sequence diversity - `DOPS`)
 * use `MAFFT` to align the reduced set of sequences
 * output this information in `STOCKHOLM` format

  1.10.510.10-ff-77378.reduced.sto

### Filtering FunFams:

Some FunFams are huge (>10,000 sequences). In a large number of cases, this makes visual analysis difficult and produces poor quality alignments. To try and deal with this, _reduce_ the full set of sequences involved in the FunFam taking care to try and keep as many "interesting" sequences as possible.

Filtering criteria:

 * _unique_cath_s35_ - one sequence for every sequence family in CATH
 * _unique_ec_ - one sequence for every EC combination
 * _all_model_organism_ - all sequences from 10 model genomes in Genome3D - eg. human, mouse, fly
 * _unique_cath_s100_ - all non-identical structural domains
 * _all_ec_with_swissprot_ - all sequences in swissprot that have EC annotations
 * _all_pan_compara_ - all sequences in the PAN COMPARA dataset of genomes

Essentially we keep adding sequences into the cluster up to a hard maximum of 1000. More information on this filter process can be found in the log file:

  1.10.510.10-ff-77378.reduced.filter.log

Note: we've spent a fair bit of time trying to come up with a set of criteria that works for all clusters - very happy to have feedback on this.

## Generate Structural Clusters

 1. For every FunFam that contains at least one structure - identify a structural representative
 1. Perform all-against-all structure comparison with all these representative structures (`SSAP`)
 1. Use the comparison scores to cluster representative domains (ie FunFams) according to < 5A (`ff_ssg5`) and < 9A (`ff_ssg9`) SIMAX (ie normalised RMSD)

Each structural cluster has a list of CATH domains - each domain represents one FunFam.

  1.10.510.10-ff_ssg5-21.reps

Also available in FASTA format (note these sequences are based on the residues observed in the PDB structure)

  1.10.510.10-ff_ssg5-21.reps.fa

### Structural Cluster files:

Once we have identified the most closely related FunFams (ie where structural representatives are all within 5A SIMAX) we perform a multiple structural alignment (using `CORA`).

  1.10.510.10-ff_ssg5-21.aln_reps.cora

In FASTA format:

  1.10.510.10-ff_ssg5-21.aln_reps.cora.fa

### Expand structural clusters

We now _expand_ the information available for each of the positions in this structural alignment, by adding back in the sequence information from the FunFams.

These expanded alignments are available in STOCKHOLM and FASTA format:

  1.10.510.10-ff_ssg5-21.expanded.sto
  1.10.510.10-ff_ssg5-21.expanded.fa

It's important to note that, in these expanded structural alignments, we can only include residues that can be directly aligned to positions observed in the multiple structural alignment. So, the representative structures will contain all their expected residues, but all the other sequences will be missing residues that do not correspond to a position in the structural alignment sticking everything together.

The full domain sequences will be present in the individual FunFam alignments.
