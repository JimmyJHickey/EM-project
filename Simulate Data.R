#ST793 Final Project
#EM algorithm for CT Data
#Eric Yanchenko (Alvin Sheng and Jimmy Hickey) [Copyright]
#November 4, 2020

#Function which generates the observed data for a single theta vector
data_gen <- function(theta, d){
  #Theta is the given theta vector used to compute attenutation probs.
  #d is mean of initial Poisson distribution
  
  p = length(theta)
  
  if(p<=0){#If empty theta vector is given, return # of emitted photons
    return(d)
  }
  
  X1 = rpois(1, lambda = d) #Initial number of counts from Poisson dist.
  
  X = c(X1, rep(0, p)) #Vector to hold the number of counts after each interaction
  
  for(j in 1:p){
    X[j+1] <- rbinom(1, size = X[j], prob = exp(-theta[j]))
    #Generate the number of photons from Binom(X_i, exp(theta_i))
  }
  
  Y = X[p+1] #Actually observed data (number of counts)
  
  return(Y)
}

#Function which generates the obersrved data for entire theta matrix and arbitrary projections
data_gen_df <- function(THETA, d, ROW, COL, reps=1){
  #THETA: inputed theta matrix used to compute probs.
  #d: Poisson mean for initial Poisson generation
  #ROW: rows which we project on (vector) Enter negative row number to get opposite direction
  #COL: columns which we project on (vector) Enter negative col number to get opposite direction
  #reps: number of times to run the function
  
  r = dim(THETA)[1] #Number of rows in THETA
  c = dim(THETA)[2] #Number of cols in THETA
  
  #Check that ROW and COL projection indices are valid
  if(max(abs(ROW))> r || max(abs(COL)) > c){
    return(simpleError("Row and/or column indices out of range."))
  }
  
  #Return length(ROW)+length(COL) list
  #with d, indices (in order) beam went through, counts
  proj.list <- vector("list", (length(ROW) + length(COL)) * reps)
  
  pl_idx <- 1
  
  for(a in 1:reps){
    
    #Run over ROWS first
    for(rr in ROW){
      if(rr > 0){
        y <- data_gen(THETA[rr,THETA[rr,]>=0], d)
        #Matrix indices that this beam goes through
        idx = seq(rr, rr+(c-1)*r, r)
        idx = idx[which(THETA[rr,]>=0, arr.ind=TRUE)] #Drop indices with negative thetas
      }else{ #switch order of theta if row number is negative
        y <- data_gen(rev(THETA[-(rr),THETA[-(rr),]>=0]), d)
        #Matrix indices that this beam goes through
        idx = seq(-rr, -rr+(c-1)*r, r)
        idx = rev(idx[which(THETA[-rr,]>=0, arr.ind=TRUE)])
      }
      add.list <- list(d = d, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
  
    #Run over COLS second
    for(cc in COL){
      if(cc >0){
        y<- data_gen(THETA[THETA[,cc]>=0,cc], d)
        idx = seq((cc-1)*r+1, cc*r, 1)
        idx = idx[which(THETA[,cc]>=0, arr.ind = TRUE)] # Drop indices with negative thetas
      }else{
        y <- data_gen(rev(THETA[THETA[,-(cc)]>=0,-(cc)]), d)
        idx = seq((-cc-1)*r+1, -cc*r, 1)
        idx = rev(idx[which(THETA[,-cc]>=0, arr.ind=TRUE)])
      }
      add.list <- list(d = d, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
  }
  
  #Return list with d, idx, y for each 
  return(proj.list)
}

