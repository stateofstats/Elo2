

##### NHL ELO RATIINGS #####

# TO DO:

# 1 - import team rankings
# 2 - pull league scores for day
# 3 - calculate new ratings based on that day's results
# 4 - export csv of ratings for that day


## Assumptions ##

# All naming conventions assume end of that game day (after all games are completed)
# ex- 2017-10-25 = elo ratings after all games on the october 25th, 2017 have concluded


library(rvest)
library(xml2)
library(dplyr)

# DATE FOR GAMES 

todaysgamedate <- as.Date("2017-10-04")

# Set variables

home = 35        # Adjustment for home advantage
kvar = 8         # k = velocity of change = 8
imp = 1          # importance of game( 1 for regular season, 1.5 for playoffs)

# Define functions


library(XML)
library(dplyr)

season2018_start_ratings <- read.csv(file = "~/R/Elo/elo_2018_start.csv")

df2017 <- get_results(2017)

daysubset <- subset(df2017, 
                    Date == "2016-10-15"
)
daysubset


gamestoday <- function(season, date) {
  
  dfdate <- get_results(season)
  dfdatesub <- subset(dfdate,
                      Date == date)
  dfdatesub$Notes <- NULL
  return(dfdatesub)
  
}

gamestoday(2018, todaysgamedate)




importratings <- function(gamesdate) {
  list.files(setwd("/Users/derekpeterson/Documents/R/Elo/2018"))
  gamesdate <- as.Date(gamesdate)
  filen <- paste("/Users/derekpeterson/Documents/R/Elo/2018/",gamesdate,"start.csv", sep = "")
  ratings <- read.csv(file = filen)  
  return(ratings)
}


# Construct initial objects

ratings_today <- importratings(todaysgamedate)

games_today <- gamestoday(2017, todaysgamedate)


# Populate data frame with calculations
# Elo calculations - in home team perspective
games_today$elov <- ratings_today[which(ratings_today$Team %in% games_today$Visitor), 2]
games_today$eloh <- ratings_today[which(ratings_today$Team %in% games_today$Home), 2]
games_today$eh <- round(1/(1 + 10^-((games_today$eloh-games_today$elov + home)/400)),2)
games_today$ev <- 1-games_today$eh
games_today$GD <- games_today$HG - games_today$VG
games_today$result <- ifelse(games_today$Type == "SO", 0.5,ifelse(games_today$HG>games_today$VG,1,0))
games_today$p1 <- (games_today$eloh - games_today$elov + home) / 100
games_today$multi <- abs((games_today$GD - (0.85*games_today$p1))) + exp(1) - 1
games_today$logM <- ifelse(log(games_today$multi) < 1, 1,log(games_today$multi))
games_today$change <- kvar * imp * games_today$logM * (games_today$result - games_today$eh)
games_today$nelov <- round(ifelse(games_today$change < 0, games_today$elov + abs(games_today$change), games_today$elov-abs(games_today$change)), 1)
games_today$neloh <- round(ifelse(games_today$change < 0, games_today$eloh - abs(games_today$change), games_today$eloh + abs(games_today$change)), 1)

games_today
# Build list of teams and their respective new ratings
team_list_away <- data.frame(Team = games_today$Visitor)
team_list_home <- data.frame(Team = games_today$Home)
team_list <- rbind(team_list_away, team_list_home)
elo_list_away <- data.frame(newElo = games_today$nelov)
elo_list_home <- data.frame(newElo = games_today$neloh)
elo_list <- rbind(elo_list_away, elo_list_home)
change_list <- cbind(team_list, elo_list)

# Merge new list with previous and save as csv
end_list <- merge(ratings_today, change_list, all = TRUE)
end_list$RatingN <- ifelse(is.na(end_list$newElo), end_list$Rating, end_list$newElo)
end_list$Rating <- NULL
end_list$newElo <- NULL
end_list$Rating <- end_list$RatingN
end_list$RatingN <- NULL

end_list

# list of todays results should be saved as tomorrow's start

gamedate <- as.Date("20161012", "%Y%m%d")

filedate <- paste(gamedate + 1,"start.csv", sep = "")
write.csv(end_list, file = paste("/Users/derekpeterson/Documents/R/Elo/2018/",filedate, sep = ""))



gamestoday(2017, "2016-10-12")











