# Crystal API Backend

Just a proof-of-concept JSON API written in Crystal. I wanted to get a rough idea of the usability and performance of the language. Conclusion: it works, and it's fast.

## Features

* Built on top of Kemal
* Source organized around namespaced "concepts" (see src/concepts)
* Simple chainable string builder for SQL queries
* SQL query logging
* Global error handlers
* Routing sugar to map controller instance methods to block based Kemal handlers (see config/routes.cr)
* Secure BCrypt password generation with JWT tokens for API authentication
* Routing index action that can return a list of routes to frontend applications
* Config file and loader code to set environment variables from ENV or a yml file
* Migrations from micrate `./db/migrate`
* DB seeding via `./db/seed`
* Controller and model specs `crystal spec/backend_spec.cr` (runs in about 3s including compilation)
* Mock request code for testing API calls (Crystal still needs something similar to Rack::Test)

## Benchmarks

After running `./db/seed`, `crystal build src/backend.cr --release` and starting the server with `LOG_DB=false ./backend`

`curl -i -H "Content-Type: application/json" -X POST -d '{ "email": "admin@example.com", "password": "changeme"}' http://localhost:3000/api/sessions`

`export TOKEN=token-that-comes-back-on-successful-auth`

Using Siege with max concurrency:

`siege -c 255 -r 50 --header "Authorization: Bearer $TOKEN" --header "Content-Type: application/json" http://localhost:3000/api/users`

```
Transactions:          12750 hits
Availability:         100.00 %
Elapsed time:          33.49 secs
Data transferred:         1.87 MB
Response time:            0.00 secs
Transaction rate:       380.71 trans/sec
Throughput:           0.06 MB/sec
Concurrency:            1.18
Successful transactions:       12750
Failed transactions:             0
Longest transaction:          0.04
Shortest transaction:         0.00
```

That's pretty neat.

It uses ~10% of a single i7 CPU for the Crystal server.

## Automatic compilation and restart:

I use nodemon to detect changes and automatically restart the server and run tests:

`nodemon --exec crystal src/backend.cr`

`nodemon --exec crystal spec/backend_spec.cr`

It seems to get tripped up and needs to be restarted when the output is a really long stacktrace or something ¯\\_(ツ)_/¯
