# Cocona

[![CircleCI](https://circleci.com/gh/kironono/cocona/tree/master.svg?style=shield&circle-token=0dba2bf4e93f1c28c051340ac277c6d1f03bb29c)](https://circleci.com/gh/kironono/cocona/tree/master)

Digital Video Recorder.


## Requirements

* Ubuntu 16.04 LTS
* Ruby (MRI) 2.3.x.
* Redis 3.0.x
* PostgreSQL 9.5.x


## Installation

Install distribution packages.

```
```

Install Ruby gems.

```
bundle i --path=./.bundle --binstubs=./.bundle/bin
```


## Setup

### Edit configure

* config/secrets.yml
* config/database.yml
* config/redis.yml
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

## Run

```
foreman start
```
