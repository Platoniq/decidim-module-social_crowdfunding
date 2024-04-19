# Decidim ♥ Goteo :: Integrate OpenSource Social Crowdfunding with OpenSource Digital Democracy

[![[CI] Test](https://github.com/Platoniq/decidim-module-social_crowdfunding/actions/workflows/test.yml/badge.svg)](https://github.com/Platoniq/decidim-module-social_crowdfunding/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/Platoniq/decidim-module-social_crowdfunding/branch/main/graph/badge.svg?token=KVPfyFtkMZ)](https://codecov.io/gh/Platoniq/decidim-module-social_crowdfunding)
[![Maintainability](https://api.codeclimate.com/v1/badges/1b039308fdce8a423faf/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-social_crowdfunding/maintainability)

## Goteo Api

This plugin requires access to the Goteo API, please referer for documentation to:

https://developers.goteo.org/doc

```bash
curl -i --basic --user "user:key" https://api.goteo.org/v1/projects/
```

```bash
"date-passed": "Tue, 13 Dec 2011 00:00:00 +0100", /_ Pasa de ronda _/
"date-succeeded": "Mon, 23 Jan 2012 00:00:00 +0100", /_ Pasa las dos rondas o la primera si solo hay una ronda _/
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-social_crowdfunding", git: "https://github.com/Platoniq/decidim-module-social_crowdfunding", branch: "main"
```

And then execute:

```bash
bundle
bundle exec rails decidim_social_crowdfunding:install:migrations
bundle exec rails decidim_decidim_awesome:webpacker:install
bundle exec rails db:migrate
```

* TODO: initializator required?

## Contributing

See [Decidim](https://github.com/Platoniq/decidim-module-social_crowdfunding).

### Developing

To start contributing to this project, first:

* Install the basic dependencies (such as Ruby and PostgreSQL)
* Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
 bundle
 DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
 cd development_app
 DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```bash
 bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

* Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
* Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
* Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
 bundle
 DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
 DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
 SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

https://crowdin.com/project/decidim-social-crowdfunding

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
