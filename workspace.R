library(tercen)
library(dplyr)
library(msa)
library(Biostrings)

options("tercen.workflowId" = "a77770c3923fad0ca99b77fa8905471d")
options("tercen.stepId"     = "3a192551-2fea-4836-8079-ef1a9df8cc59")

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
