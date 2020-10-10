library(tercen)
library(dplyr)
library(msa)
library(Biostrings)
library(tidyr)

options("tercen.workflowId" = "a77770c3923fad0ca99b77fa8905471d")
options("tercen.stepId"     = "bb25a84f-6304-4e9d-bfaf-85cb5d088ce5")

ctx <- tercenCtx()

method <- "ClustalW"
if(!is.null(ctx$op.value('method'))) {
  method <- ctx$op.value('method')
} 
sequence_type <- "protein"
if(!is.null(ctx$op.value('sequence_type'))) {
  sequence_type <- ctx$op.value('sequence_type')
} 

df <- ctx %>% select(.ri, .ci) %>%
  mutate(letter = ctx$select(ctx$colors[[1]])[[1]]) %>%
  spread(.ci, letter)

set <- apply(df[,-1], 1, function(x) paste0(x[!is.na(x)], collapse = ""))
if(length(set) > 500) stop("Cannot align more than 500 sequences.")
names(set) <- df[,1]

AAset <- BStringSet(set)

aln <- msa(AAset, method = method, type = sequence_type)  # default clustal algo
aln <- msaConvert(aln, type="seqinr::alignment")

position_aligned <- sapply(aln$seq, function(x) c(gregexpr(pattern = "[a-zA-Z]", x)[[1]]))
names(position_aligned) <- 1:length(position_aligned) - 1

.ci <- lapply(lengths(position_aligned), function(x) 1:x - 1)

df_out <- data.frame(
  .ri = as.numeric(rep(names(position_aligned), times = lengths(position_aligned))),
  .ci = unlist(.ci),
  position_aligned = unlist(position_aligned)
) %>%
  ctx$addNamespace() %>%
  ctx$save()
