# cocona

[![CircleCI](https://circleci.com/gh/kironono/cocona/tree/master.svg?style=svg)](https://circleci.com/gh/kironono/cocona/tree/master)

Digital Video Recording solution for Linux.


## Requirements

* Ubuntu 16.04 LTS
* Ruby (MRI) 2.3.x.
* Redis 3.0.x
* PostgreSQL 9.5.x


## Installation

Install Ruby gems.

```
bundle i --path=./.bundle --binstubs=./.bundle/bin
```


## Setup

### Edit configure

* config/secrets.yml
* config/database.yml
* config/cable.yml
* config/settings.yml

### Create Database

```
rails db:create
```

### Migrate Database

```
rails db:migrate
```

### Setup Seed Data

```
rails db:seed
```

### Create first user

```
thor user_ctrl:create --name=cocona --email=cocona@example.com --password=password
```

## Run

```
foreman start
```

## License

cocona is licensed under the [MIT license](LICENSE).
