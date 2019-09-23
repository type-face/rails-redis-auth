# README

## Rails Authentication with Redis

A Rails authentication API that uses just Redis for data storage. 

My aim was to create an api that provided basic authentication with JWT that used Redis entirely for data storage. No relational database was used for this project. For basic authentication, only usernames and passwords are required to be stored, which Redis is fully capable of. Using just redis for data storage provides a lightweight, fast alternative to a full SQL database. Redis is capable of durable persistence, if configured appropriately, which would allow this approach to be used in production. However, devops was beyond the scope of this project.

This api provides endpoints to create a user, and to authenticate with user credentials to receive a JWT. It is expected that these auth tokens would be used by other apps and verified by those apps.


### To run:
1. `rails server`
2. `redis-server`

### Running tests:
`rspec`

### Endpoints
*POST /users*

params:
* username
* password

*POST /login*

params
* username
* password

