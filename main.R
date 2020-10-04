library(tercen)
library(dplyr)
library(msa)
library(Biostrings)

ctx <- tercenCtx()
set <- ctx$rselect(ctx$rnames[[grep("sequence", ctx$rnames)]])[[1]]
if(length(set[[1]]) > 500) stop("Cannot align more than 500 sequences.")
names(set) <- ctx$rselect(ctx$rnames[[grep("name", ctx$rnames)]])[[1]]

AAset <- AAStringSet(set)

aln <- msa(AAset)  # default clustal algo
aln <- msaConvert(aln, type="seqinr::alignment")

df_out <- data.frame(
  .ri = 1:length(aln$seq) - 1,
  aligned_sequence = aln$seq,
  name = aln$nam
) %>%
  ctx$addNamespace() %>%
  ctx$save()
