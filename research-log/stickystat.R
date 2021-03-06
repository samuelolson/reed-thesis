# preliminary code
filenames <- list.files()
library(jsonlite)
pages <- list()
for(i in seq_along(filenames)) {
  mydata <- fromJSON(filenames[i], simplifyDataFrame = TRUE)
  pages[[i]] <- mydata
}

turn_lengths <- rep(0, length(pages))
for(i in seq_along(pages)) {
  turn_lengths[i] <- pages[[i]]$turns
}
# revised code to check if a move is used
stickyreturn <- function(battlelog) { 
  if(any(grep("(Sticky Web[|]p1a) | (Sticky Web[|]p2a)", battlelog)) == FALSE) {
    stickyuse <- NA
  }
  if(any(grep("(Sticky Web[|]p1a) && (Sticky Web[|]p2a)", battlelog)) == TRUE) {
    stickyuse <- "both"
    } 
  if(any(grep("[|]Sticky Web[|]p1a", battlelog)) == TRUE) {
    stickyuse <- "p1"
    } 
  if(any(grep("[|]Sticky Web[|]p2a", battlelog)) == TRUE) {
    stickyuse <- "p2"
  } 
  stickyuse
}

stickyreturn(pages[[i]]$log) 
stickyverdict <- rep(NA, length(pages))
for(i in 1:length(pages)) { stickyverdict[i] <- stickyreturn(pages[[i]]$log)} 
# code to check who won the battle 
# code first checks if the battle was a draw
# then the code checks if p1 won
# if p1 did not win and it was not a draw, then p2 won 
playerout <- function(battlelog) {
  if((battlelog$endType) == "draw") {
    playout <- NA} 
  if((battlelog$p1rating$elo > battlelog$p1rating$oldelo) == TRUE) {
    playout <- "p1"}
  else {
    playout <- "p2"}
  playout
}

playerout(pages[[i]])
winlose <- rep(NA, length(pages)) 
for(i in 1:length(pages)) {winlose[i] <- playerout(pages[[i]])} 
# code to cross compare who won with who used the move 
# code has two matchings that are not important to collect statistics on:
# 1. the move was not used or 2. both players used the move 
# then the code checks if the winning player used the move and returns a 1 if they did
# otherwise the function outputs a 0 if the player who used the move lost and their opponent did not use the move
stickystat <- function(playerout, stickyreturn, battlelog) {
  if((winlose=="p1") && (stickyverdict=="p1")) {
    stickywin <-1
  }
  if((winlose=="p2") && (stickyverdict)=="p2") {
    stickywin <-1
  }
  if((winlose=="p1") && (stickyverdict=="p2")) {
    stickywin <-0
  }
  if((winlose=="p2") && (stickyverdict=="p1")) {
    stickywin <-0
  }
  if(is.na(stickyverdict)) {
    stickywin <- NA
  }
  if(is.na(winlose)) {
    stickywin <- NA
  }
  stickywin 
}


# current attempt
stickystats <- rep(NA, length(pages))
for(j in 1:length(pages)) {stickystats[j] <- stiicky[j]}
  
  
stiicky <- function(battlelog)  {if((winlose[i]=="p1") && (stickyverdict[i]=="p1")) {
  stiicky <-1
}
if((winlose[i]=="p2") && (stickyverdict[i])=="p2") {
  stiicky <-1
}
if((winlose[i]=="p1") && (stickyverdict[i]=="p2")) {
  stiicky <-0
}
if((winlose[i]=="p2") && (stickyverdict[i]=="p1")) {
  stiicky <-0
}
else {
  stiicky <- NA
}
}
# unused atm
## which stickystat to use? 
stickystat(stickyverdict[[i]], winlose[[i]])  
stickystat(pages[[i]]) 
## stickyout, function of stickystat
stickyout <- rep(NA, length(pages))
for(i in 1:length(pages)) {stickyout[i] <- stickystat(playerout(pages[i]), winlose(pages[i]))} 
# whenever I use this code it just returns an "unexpected '}' in "}" error 
