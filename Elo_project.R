

# Scraping hockey-reference.com for ELO ratings
# 6/24/2017 
# Derek


# Packages
library(rvest)
library(xml2)
library(dplyr)

# Scrape

# table 1 is the season results

### Example Code ###
url2 <- "http://www.hockey-reference.com/leagues/NHL_2018_games.html"
webpage2 <- read_html(url2)
nhl_table <- html_nodes(webpage2, "table")
nhl <- html_table(nhl_table[[1]])
head(nhl)

### End Example ###

get_results <- function(season) {     # Results for entire league for specified season
  
  # Season year = end of season year        # Example 2016-2017 = 2017
  
  format <- paste("NHL_", season, "_games.html", sep = "")
  seasonurl <- paste("http://www.hockey-reference.com/leagues/",format, sep = "")
  webpage2 <- read_html(seasonurl)
  nhl_table <- html_nodes(webpage2, "table")
  results <- data.frame(html_table(nhl_table[[1]]))
  
  #results <- data.frame(nhl_table[[1]])
  colnames(results) <- c("Date", "Visitor", "VG", "Home", "HG", "Type", "Att", "LOG", "Notes")
  results$VG <- as.integer(results$VG)
  results$HG <- as.integer(results$HG)
  
  
  return(results)
  
}


team_results <- function(team, season) {     # Results for speficied team and season
  
  teamdf <- get_results(season)              # Results for team using get_results function
  
  teamvisitor <- subset(teamdf,
                        Visitor == team
  )                    # Data frame for away games
  teamhome <- subset(teamdf,
                     Home == team
  )                       # Data frame for home games
  
  team_season <- rbind(teamvisitor, teamhome)               # Combine home and away games
  team_season <- team_season[order(team_season$Date), ]     # Order data frame chronologically
  
  return(team_season)                        # Print team results
  
  
}

team_results("Minnesota Wild", 2018)

get_results(2011)



