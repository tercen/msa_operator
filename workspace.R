library(tercen)
library(dplyr)
library(msa)
library(Biostrings)

options("tercen.workflowId" = "a77770c3923fad0ca99b77fa8905471d")
options("tercen.stepId"     = "dbd6c2d2-3a0f-4b1f-bcc1-016a5ee2c562")

ctx <- tercenCtx()
set <- ctx$rselect(ctx$rnames[[1]])
if(length(set[[1]]) > 500) stop("Cannot align more than 500 sequences.")

AAset <- AAStringSet(set[[1]])

aln <- msa(AAset)  # default clustal algo
aln <- msaConvert(aln, type="seqinr::alignment")

df_out <- data.frame(
  .ri = 1:length(aln$seq) - 1,
  aligned_sequence = aln$seq
) %>%
  ctx$addNamespace() %>%
  ctx$save()