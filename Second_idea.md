# README
Base Outline:

- type in the name of a stock
- pull recent news articles and run through google natural language processing (to find sentiment on positive or negative words)
- add up the positive and neagtive words, plus compare to the priors day performance
- figure out if the next day of trading is going to be positive or negative

Database tables:

Users
 - username
 - password_digest
UserStocks (stocks to watch- join table)
Stocks
- symbol
- company name
- prices

Models:

Controllers:

API:
- zillow web services ID: X1-ZWz190zy8wb37v_4vl2o
- need to convert xml to json in backend to use (no json option available from zillow)

MVP:
- User can just type in the name of a stock
- recent news articles are anylized
- determine if news articles are positive or negative
- display results, "based on the news, this stock will increase the following day...", something like that

Stretch Features:
- Add calendar of economic events
- anylize prior day performance 




