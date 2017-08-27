# Elo predictions twitter bot

require(twitteR)

# Macbook set path
setwd("/Users/derekpeterson/Documents/R/Elo/Twitter")

# PC set path
setwd("~/R/Elo/Elo2/Twitter/")



api_keys <- read.csv(file = "credentials.csv", stringsAsFactors = FALSE, header = TRUE)

setup_twitter_oauth(consumer_key = api_keys$consumer_key,
                    consumer_secret = api_keys$consumer_secret,
                    access_token = api_keys$token,
                    access_secret = api_keys$token_secret)

tweetday <- "2017-10-04"
games <- read.csv(file = paste(tweetday,"twitter.csv", sep = ""))
games$Tweet <- as.character(games$Tweet)


# set time for tweets to be sent in 24hr format

tweet_list <- games$Tweet
tweetdelay <- function(x, sendtime) {
  sendtime <- as.POSIXct(paste(Sys.Date(), sendtime, sep = " "), format = "%Y-%m-%d %H:%M:%OS")
  Sys.sleep(sendtime - Sys.time())
  for (i in 1:length(x)) {
    tweet(x[[i]])
    Sys.sleep(10)
  }
}



tweetdelay(tweet_list, "14:08:30")

