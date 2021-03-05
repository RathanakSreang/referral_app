# Referral APP

Web app which provide API for user to create referral to invite other members and an credit.

###Development
#### Using docker
You need to have `Docker` install

For first time or ever new migrations
```
docker-compose up -d
docker-compose exec api bundle exec rake db:setup db:migrate
docker-compose down
docker-compose up
```

- API doc
```
docker-compose exec api bundle exec rake swagger:docs
```

#### Using your local machine
You need to have `ruby-2.7.0`,  `rails-6.0.3`, `PostgreSQL 9.5`

- Configure database:
Setup database: Make you already install postgrest - `sudo -i -u postgres` - login to postgrest `psql` - the create user tobnhom_go
`CREATE ROLE referral_user WITH SUPERUSER CREATEDB LOGIN ENCRYPTED PASSWORD 'RathanakPassword';`

- Start server:
```
bundle install
rails db:setup db:migrate
rails s
```

- API doc
Generate API Doc
```
rake swagger:docs
```
Access API doc
`http://localhost:3000/swagger/index.html`
