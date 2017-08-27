
# Win probability projections based on Elo Rating
# 6/27/2017
# Derek

library(rvest)
library(XML)
library(dplyr)

# Define functions

# Pull games for today
gamestoday <- function(season, date) {
  
  dfdate <- get_results(season)
  dfdatesub <- subset(dfdate,
                      Date == date
  )
  
  dfdatesub$Notes <- NULL
  return(dfdatesub)
  
}

# example function inputs
# gamestoday(2017, "2016-10-12")


# import ratings to use for win probability
importratings <- function(gamesdate) {
  list.files(setwd("/Users/derekpeterson/Documents/R/Elo/2018"))
  gamesdate <- as.Date(gamesdate)
  filen <- paste("/Users/derekpeterson/Documents/R/Elo/2018/",gamesdate,"start.csv", sep = "")
  ratings <- read.csv(file = filen)  
  return(ratings)
}


# Construct initial objects
ratings_today <- importratings("2017-10-04")

games_today <- gamestoday(2018, "2017-10-04")
games_today

# Populate data frame with calculations
# Elo calculations - in home team perspective
games_today$elov <- ratings_today[which(ratings_today$Team %in% games_today$Visitor), 2]
games_today$eloh <- ratings_today[which(ratings_today$Team %in% games_today$Home), 2]
games_today$eh <- round(1/(1 + 10^-((games_today$eloh-games_today$elov + home)/400)),2) * 100
games_today$ev <- 100-games_today$eh




games <- data.frame(Date = games_today$Date,
                    Away = games_today$Visitor,
                    eV = paste(round(games_today$ev,2),"%", sep = ""),
                    Home = games_today$Home,
                    eH = paste(round(games_today$eh,2),"%", sep = ""),
                    Tweet = paste(games$Date, games$Away, "at", games$Home, ":", games$Away, games$eV, "chance to win /", games$Home, games$eH, "chance to win")
)
games

gamedate <- "2017-10-04twitter.csv"
write.csv(games, file = paste("/Users/derekpeterson/Documents/R/Elo/Twitter/", gamedate, sep = ""))

