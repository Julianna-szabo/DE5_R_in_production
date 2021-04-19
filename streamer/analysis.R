library(rredis)
redisConnect()

## get frequencies
symbols <- redisMGet(redisKeys('symbol:*'))
symbols <- data.table(
  symbol = sub('^symbol:', '', names(symbols)),
  N = as.numeric(symbols))

# Include price

library(binancer)
binance_coins_prices()

symbols[, .N, by = symbol]
symbols[symbol=='ETHUSDT']
symbols[, from := substr(symbol, 1, 3)]
symbols <- merge(dt, binance_coins_prices(), by.x = 'from', by.y = 'symbol', all.x = TRUE, all.y = FALSE)
symbols[, value := as.numeric(quantity) * usd]
symbols[, sum(value)]


# Plots

p <- ggplot(klines, aes(close_time, close)) + geom_line()
q <- 


# push plots to slack
slackr_setup(username = 'juli', bot_user_oauth_token = token, icon_emoji = ':jenkins-rage:')
ggslackr(plot = p, channels = '#ba-de5-2020-bots', width = 12)

ggslackr(plot = q, channels = '#ba-de5-2020-bots', width = 12)