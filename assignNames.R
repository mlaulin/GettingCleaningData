## myString <- c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", "tBodyAcc-std()-Y","tBodyAccJerk-std()-X","fBodyAcc-mean()-Z","fBodyBodyAccJerkMag-mean()","subject","activitylabels")
## print(myString)
## print(class(myString))
## strLength <- length(myString)
## print(strLength)

assignNames <- function(columnNames){

  i <- 1L
  myString <- columnNames
  print(myString)
  strLength <- length(myString)
  ## print(strLength)
  myNewString <- c()
  
  while(i <= strLength-2){
    
    x <- myString[i]
    ## print(x)
    
    xs <- strsplit(x,"-")
    ## print(str(xs))
    
    if(xs[[1]][[1]] %like% "t")
    {
      ## print("time")
      ## print(xs[[1]][[1]])
      xs[[1]][[1]] <- sub("t","time",xs[[1]][[1]])
    }
    else if(xs[[1]][[1]] %like% "f")
    {
      ## print("frequency")
      ## print(xs[[1]][[1]])
      xs[[1]][[1]] <- sub("f","frequency",xs[[1]][[1]])
    }
    
    if(xs[[1]][[2]] == "mean()")
    {
      ## print("Mean")
      ## print(xs[[1]][[2]])
      xs[[1]][[2]] <- "Mean"
    }
    else if(xs[[1]][[2]] == "std()")
    {
      ## print("Standard Deviation")
      ## print(xs[[1]][[2]])  
      xs[[1]][[2]] <- "STDV"
    }
    
    ## print(length(xs[[1]]))
    
    if((length(xs[[1]])) == 3)
    {
      ## print(xs[[1]][[3]])
      y <- paste(xs[[1]][[1]],"-",xs[[1]][[2]],"-",xs[[1]][[3]],sep = "")  
    }
    else if((length(xs[[1]])) == 2)
    {
      ## print(xs[[1]][[2]])
      y <- paste(xs[[1]][[1]],"-",xs[[1]][[2]],sep = "")
    }
    else
    {
      y <- xs
    }
        
    ## print(y)
    myNewString[i] <- y
    
    i <- i+1
  }
  
  myNewString[i] <- "subject"
  myNewString[i+1] <- "activitylabels"
  
  return(myNewString)
}
