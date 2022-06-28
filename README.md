# Currency API

This is a simple Ruby app using the [Rails](http://rubyonrails.org) framework.

It collect currency data from [api.nbp.pl](http://api.nbp.pl/en.html) about average prices of it and store to DB using different gem like sidekiq-scheduler etc

## Running Locally

Make sure you have [Ruby](https://www.ruby-lang.org), [Bundler](http://bundler.io) installed.

```sh
git clone git@github.com:kuranovandry/currency-api.git
cd currency-api
bundle
rake db:create db:migrate (change database.yml example to your configuration)
rails s
```
Your app should now be running on [localhost:3000](http://localhost:3000/).

## Documentation

Every day at 1 a.m., sidekiq runs background job according to a schedule to collect currency data for the day.

You can query `/api/rate` to get data for all currencies (by default, a query without parameters returns data for today)
#### The following parameters are also accepted:

* date - return array of currency for that day (format YYYY-MM-DD)
* currency - return array of currency what was specified
* end_date and start_date - return array of currency in specified date period (format YYYY-MM-DD)

#### Sample requests and responses:

```
 /api/rates
 
 response:
{
    "data": [
        {
            "id": "4351",
            "type": "rate",
            "attributes": {
                "code": "THB",
                "currency_name": "bat (Tajlandia)",
                "average": "0.13",
                "date": "2022-06-29"
            }
        },
        {
            "id": "4352",
            "type": "rate",
            "attributes": {
                "code": "USD",
                "currency_name": "dolar amerykański",
                "average": "4.44",
                "date": "2022-06-29"
            }
        }
    ]
 }
```

```
 /api/rates?currency=CAD
 
 response:
{
    "data": [
        {
            "id": "4355",
            "type": "rate",
            "attributes": {
                "code": "CAD",
                "currency_name": "dolar kanadyjski",
                "average": "3.45",
                "date": "2022-06-29"
            }
        }
    ]
}
```

```
 /api/rates?date=2022-06-01
 
 response:
{
    "data": [
        {
            "id": "4357",
            "type": "rate",
            "attributes": {
                "code": "THB",
                "currency_name": "bat (Tajlandia)",
                "average": "0.13",
                "date": "2022-06-01"
            }
        },
        {
            "id": "4356",
            "type": "rate",
            "attributes": {
                "code": "USD",
                "currency_name": "dolar amerykański",
                "average": "4.44",
                "date": "2022-06-01"
            }
        }
    ]
 }
```

```
 /api/rates?start_date=2022-06-01&end_date=2022-06-30
 
 response:
{
    "data": [
        {
            "id": "4355",
            "type": "rate",
            "attributes": {
                "code": "THB",
                "currency_name": "bat (Tajlandia)",
                "average": "0.13",
                "date": "2022-06-01"
            }
        },
        {
            "id": "4354",
            "type": "rate",
            "attributes": {
                "code": "USD",
                "currency_name": "dolar amerykański",
                "average": "4.44",
                "date": "2022-06-30"
            }
        }
    ]
 }
```


## Running Locally by using docker

### Build the containers

```
docker compose build
```

### To build and spin up the Rails server:

```
docker compose up --build
```

### Before starting the server, Rails databases need to be created first.

```
docker compose exec web bundle exec bin/rails db:create db:migrate
```

### Run the tests

```
docker compose run web bundle exec rspec
```

#### Coverage

```
All Files ( 96.0% covered at 3.42 hits/line )
11 files in total.
175 relevant lines, 168 lines covered and 7 lines missed. ( 96.0% )
```

## Trade-offs / possible improvements

* add caching for Rate#index query, for example Rails.cache.fetch 
* improve existing git actions

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kuranovandry/currency-api.
