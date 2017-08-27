# Elo predictions twitter bot

require(twitteR)

setwd("/Users/derekpeterson/Documents/R/Elo/Twitter")

api_keys <- read.csv(file = "credentials.csv", stringsAsFactors = FALSE)

setup_twitter_oauth(consumer_key = api_keys$consumer_key,
                    consumer_secret = api_keys$consumer_secret,
                    access_token = api_keys$token,
                    access_secret = api_keys$token_secret)

tweetday <- "2017-10-04"
games <- read.csv(file = paste(tweetday,"twitter.csv", sep = ""))

games$Tweet <- as.character(games$Tweet)



lapply(tweet_list, tweet)