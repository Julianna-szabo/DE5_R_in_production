library(rredis)
redisConnect()

## get frequencies
library(data.table)
symbols <- redisMGet(redisKeys('symbol:*'))
symbols <- data.table(
  symbol = sub('^symbol:', '', names(symbols)),
  count = as.numeric(symbols))

# Include price

library(binancer)
price <- binance_coins_prices()

symbols[, from := substr(symbol, 1, 3)]
symbols <- merge(symbols, binance_coins_prices(), by.x = 'from', by.y = 'symbol', all.x = TRUE, all.y = FALSE)
symbols[, value := as.numeric(count) * usd]

sum <- (symbols[, sum(value)])

print(paste0("The sum of the transactions was $", sum))

# Plots
library(ggplot2)

p <- ggplot(symbols, aes(x = from, y = usd)) + 
  geom_point(stat = "identity") + 
  labs(title = "Price of different bitcoins", 
       y = "Price in USD", 
       x = "Type of bitcoin")

q <- ggplot(symbols, aes(x = from, y = count)) + 
  geom_bar(stat = "identity") +
  labs(title = "Number of transactions per bitcoin",
       y = "Number of transactions",
       x = "Type of bitcoin")


# push plots to slack
library(slackr)
library(botor)
botor(region = 'eu-west-1')
token <- ssm_get_parameter('slack')
slackr_setup(username = 'juli', bot_user_oauth_token = token, icon_emoji = ':moneybag:')
ggslackr(plot = p, channels = '#ba-de5-2020-bots', width = 12)
ggslackr(plot = q, channels = '#ba-de5-2020-bots', width = 12)