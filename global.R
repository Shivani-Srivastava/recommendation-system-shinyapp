
## setting input defaults
require(text2vec)
#focal.user = "Ox" # say. This comes from USER INPUT
#n0 = 10 # top n0 unrated items user might like. again, USER INPUT

dtm2CF <- function(dtm, focal.user, n0){
  
  ## Finding similarities of all the item pairs.
  a3 = sim2(as.matrix(t(dtm)), method = "cosine", norm="l2") # item-item simil matrix
  a4 = sim2(as.matrix(dtm), method = "cosine", norm="l2") # user-user simil matrix
  
  ## IBCF: Generating the missing ratings in the table
  a5 = a4 %*% as.matrix(dtm) %*% a3 # 0.01s  single, simple step using matrix multiplication
  a5a = apply(a5, 1, function(x) {x/max(x)}) # 0 s!
  a5a = t(a5a)
  
  ## Find unrated items focal.user i0 might most like.
  i0 = which(rownames(a5a) == focal.user) # doc index num of focal.user
  a6 = a5a[i0, (dtm[i0,] == 0)] # retain only brands focal.user hasn't yet rated
  a7 = sort(a6, decreasing=TRUE, index.return=TRUE) # sort by predicted ratings
  output0_ibcf = data.frame(IBCF.Recommended.brands = names(a6[a7$ix]), 
                            Pref.Prob = as.matrix(round(a6[a7$ix], 3)))
  
  rownames(output0_ibcf) = NULL
  output0_ibcf
  
  ## same for UBCF
  a8 = a4 %*% as.matrix(dtm)
  a9 = a4 %*% rep(1, nrow(a4))
  a10 = matrix(rep(as.vector(a9)), nrow(a4), ncol(a8))
  a11 = a8 / a10
  a12 = a11[i0, (dtm[i0,] == 0)] 
  a13 = sort(a12, decreasing=TRUE, index.return=TRUE) # 
  output0_ubcf = data.frame(UBCF.Recommended.brands = names(a12[a13$ix]), 
                            Pref.Prob = as.matrix(round(a12[a13$ix], 3)))
  
  rownames(output0_ubcf) = NULL
  output0_ubcf  
  
  return(list(output0_ibcf, output0_ubcf)) 
  
} # func ends