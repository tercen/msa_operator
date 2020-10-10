# Multiple Sequence Alignment operator

##### Description

`msa` operator performs Multiple Sequence Alignment.

##### Usage

Input projection|.
---|---
`row`        |  factor, sequence names/IDs
`col`        |  numeric, position
`y-axis`        |  numeric, value corresponding to amino or nucleic acid
`color`        |  factor, optional, letter

Properties|.
---|---
`sequence_type` | whether it is `dna`, `rna`, or `protein` sequences
`method`        | alignment method, can be `ClustalW`, `Muscle`, `DECIPHER`, or `ClustalOmega`

Output relations|.
---|---
`aligned_position`        | numeric, position in the alignment

##### Details

The operator uses the Clustal algorithm with default parameters.

##### See Also

https://github.com/tercen/readfasta_operator

