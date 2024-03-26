# 📚 CIET - Can I Eat This?

Ciet is an app for international tourists in Japan who have dietary preferences, such as being vegan, vegetarian, pescetarian, peanut-free etc..
Users can use this app to scan the ingredients list on food packaging with their smartphone camera to get a full list of all ingredients and the app tells them whether its compatible with their diet.

![image](https://github.com/Octosub/CIET/assets/135783511/8a7dba67-7482-451d-91a2-9b26dbea4fdd)
![image](https://github.com/Octosub/CIET/assets/135783511/83e1f353-a535-40d0-9342-2e6882e6f09a)
![image](https://github.com/Octosub/CIET/assets/135783511/341fed25-5bf2-4d20-b757-979e518f10ea)

<br>
App home: https://www.ciet.lol
   

## Getting Started
### Setup

Install gems
```
bundle install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.


### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Team Members
- [Felix Lange](https://www.linkedin.com/in/felix-edgar-lange/)
- [Koji Mimura](https://www.linkedin.com/in/nadleeh/)
- [Leandro Munoz](https://www.linkedin.com/in/leandro-a-munoz/)
- [Noah Taiga Endo](https://www.linkedin.com/in/noah-taiga-endo/)
