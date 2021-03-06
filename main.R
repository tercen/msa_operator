library(tercen)
library(dplyr)
library(msa)
library(Biostrings)
library(tidyr)
library(DECIPHER)

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
if(length(set) > 10000) stop("Cannot align more than 10000 sequences.")
names(set) <- df[,1]

if(method != "DECIPHER") {
  AAset <- BStringSet(set)
  aln <- msa(AAset, method = method, type = sequence_type)  # default clustal algo
  aln <- msaConvert(aln, type="seqinr::alignment")
  
} else {
  if(sequence_type == "protein") AAset <- AAStringSet(set)
  if(sequence_type == "dna") AAset <- DNAStringSet(set)
  if(sequence_type == "rna") AAset <- RNAStringSet(set)
  aln <- DECIPHER::AlignSeqs(AAset)
  aln <- msaConvert(Biostrings::AAMultipleAlignment(aln), type="seqinr::alignment")
}

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

