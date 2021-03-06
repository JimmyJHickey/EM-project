
calc_index = function(nrow, x, y){
  return(nrow * (y-1) + x)
}



# detecting if any projections have length sqrt(2) (or not 1), indicating non-90 degree angles

d_sqrt2 <- function(proj_list) {
  
  has_sqrt2 <- FALSE   
  
  for (proj in proj_list) {
    
    if (proj$l != 1) {
      has_sqrt2 <- TRUE
    }
    
  }
  
  return(has_sqrt2)
  
}

# looks like no 45 degree angles are making it



neg_idx <- function(proj_list) {
  
  has_neg <- FALSE   
  
  for (proj in proj_list) {
    
    if (length(which(proj$idx <= 0)) >= 1) {
      has_neg <- TRUE
    }
    
  }
  
  return(has_neg)
  
}

# I was worried there might be negative indices, but it's all good





# Really simple circle to test things with

set.seed(627)

radius = 1

in_circ = in_circle(radius)
plot_matrix(in_circ)

circle_theta  = circle_pattern(in_circ, 2, 10, 10)
plot_matrix(circle_theta)

bounds <- 2:(nrow(circle_theta) - 1)



THETA <- circle_theta

ROW = c(bounds, -bounds)

COL = c(bounds, -bounds)



##### Understanding how the for-loop iterates through the matrix indices

# starting on rows and going down seems to work. However, going backwards is the issue

# the conditional statement putting new projections into proj_list is in the wrong place

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
  proj.list <- vector("list", 1)
  
  pl_idx <- 1
  
  # 1. Projections with slope (rise/run), starting from left wall
  for(rr in ROW){
    if(rr > 0){
      
      curr_row = rr
      curr_col = 1
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row+1
        curr_col = curr_col+1
        
      }
    }
    else{ # switch order of idx and theta if row number is negative
      curr_row = -rr
      curr_col = 1
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row+1
        curr_col = curr_col+1
        
      }
      
      idx <- rev(idx)
      hit_thetas <- rev(hit_thetas)
      
    }
    
    y <- data_gen(hit_thetas, d, l = l)
    idx = idx[which(hit_thetas >= 0)] #Drop indices with negative thetas
    
    if(length(idx) != 0 && ! is.na(y)){
      add.list <- list(d = d, l = l, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
    
  }
  
  # 2. Projections with slope (-run/rise), starting from left wall
  for(rr in ROW){
    if(rr > 0){
      
      curr_row = rr
      curr_col = 1
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])    
        curr_row = curr_row - 1
        curr_col = curr_col + 1
        
      }
    }
    else{ # switch order of idx and theta if row number is negative
      
      curr_row = -rr
      curr_col = 1
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])    
        curr_row = curr_row - 1
        curr_col = curr_col + 1
        
      }
      
      idx <- rev(idx)
      hit_thetas <- rev(hit_thetas)
      
    }
    
    y <- data_gen(hit_thetas, d, l = l)
    idx = idx[which(hit_thetas >= 0)] #Drop indices with negative thetas
    
    if(length(idx) != 0 && ! is.na(y)){
      add.list <- list(d = d, l = l, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
    
  }
  
  # 3. Projections with slope (rise/run), starting from bottom wall
  for(cc in COL){
    if(cc > 0){
      
      curr_row = 1
      curr_col = cc
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row + 1
        curr_col = curr_col - 1
        
      }
    }
    else{ # switch order of idx and theta if col number is negative
      
      curr_row = 1
      curr_col = -cc
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row + 1
        curr_col = curr_col - 1
        
      }
      
      idx <- rev(idx)
      hit_thetas <- rev(hit_thetas)
      
    }
    
    y <- data_gen(hit_thetas, d, l = l)
    idx = idx[which(hit_thetas >= 0)] #Drop indices with negative thetas
    
    if(length(idx) != 0 && ! is.na(y)){
      add.list <- list(d = d, l = l, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
    
  }
  
  # 4. Projections with slope (-run/rise), starting from top wall
  for(cc in COL){
    if(cc > 0){
      
      curr_row = 1
      curr_col = cc
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row + 1
        curr_col = curr_col + 1
        
      }
    }
    else{ # switch order of idx and theta if col number is negative
      
      curr_row = 1
      curr_col = -cc
      
      #Matrix indices that this beam goes through
      idx = c()
      
      # thetas intersected
      hit_thetas = c()
      
      # while still in bounds of the scan
      while((1 <= curr_row && curr_row <= r) && 
            (1 <= curr_col && curr_col <= c)){
        
        idx = c(idx, calc_index(r, curr_row, curr_col))
        hit_thetas = c(hit_thetas, THETA[curr_row, curr_col])
        curr_row = curr_row + 1
        curr_col = curr_col + 1
        
      }
      
      idx <- rev(idx)
      hit_thetas <- rev(hit_thetas)
      
    }
    
    y <- data_gen(hit_thetas, d, l = l)
    idx = idx[which(hit_thetas >= 0)] #Drop indices with negative thetas
    
    if(length(idx) != 0 && ! is.na(y)){
      add.list <- list(d = d, l = l, idx = idx, y = y)
      proj.list[[pl_idx]] <- add.list
      pl_idx <- pl_idx + 1
    }
    
  }
  

  
  
}






