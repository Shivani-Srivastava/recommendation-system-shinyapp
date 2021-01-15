dtm <- read.csv("c://Users/31202/Downloads/B2C brands pgp21 _bigram_corpus (3) _dtm.csv",header = TRUE)

dtm <- read.csv("data/dtm_to_network_an.csv",header = TRUE)

## basic pre-proc
rownames(dtm) = dtm[,1]
dtm = dtm[,2:ncol(dtm)]

## descriptive summary of DTM
a0 = colSums(dtm)
a1 = sort(a0, decreasing=TRUE, index.return=TRUE)
a2 = as.matrix(a0[a1$ix])
token_freqs = data.frame(freq = a2)
t <- as.data.frame(head(token_freqs, 10)) # 2nd output. Sorted freqs
t$word <- rownames(t)


system.time({ CF.list = dtm2CF(dtm, "Bubbles", 12) })  # 0.06 s


ibcf.brands = CF.list[[1]]; print(ibcf.brands)


dtm <- dataset()
rownames(dtm) = dtm[,1]
dtm = dtm[,2:ncol(dtm)]

a0 = colSums(dtm)
a1 = sort(a0, decreasing=TRUE, index.return=TRUE)
a2 = as.matrix(a0[a1$ix])
token_freqs = data.frame(freq = a2)
token_freqs$word = rownames(token_freqs)
# reorder by column name
token_freqs <- token_freqs[c("word", "freq")]  #return(as.data.frame(head(token_freqs, 10))) # 2nd output. Sorted freqs
head(token_freqs,10)
