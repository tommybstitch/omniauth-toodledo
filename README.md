# OmniAuth Toodledo #

[![Build Status](https://secure.travis-ci.org/alswl/omniauth-toodledo.png?branch=develop)](http://travis-ci.org/alswl/omniauth-toodledo)

[![Dependency status][gemnasium-image]][gemnasium-url]

This gem is an OmniAuth 1.0 Strategy for the [Toodledo][toodledo].

It supports version 2 of the Toodledo API.

## Usage ##

Add the strategy to your `Gemfile` alongside OmniAuth:

```ruby
gem 'omniauth'
gem 'omniauth-toodledo'
```

Then integrate the strategy into your middleware:

```ruby
use OmniAuth::Builder do
  provider :toodledo, ENV['TOODLEDO_APP_ID'], ENV['TOODLEDO_APP_TOKEN']
end
```

In Rails, you'll want to add to the middleware stack:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :toodledo, ENV['TOODLEDO_APP_ID'], ENV['TOODLEDO_APP_TOKEN']
end
```

You will have to put in your app id and token.

For additional information, refer to the [Developer's API Documentation][doc].

## Note on Patches/Pull Requests ##

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version,
  that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## LICENSE ##

License under The MIT License. See [LICENSE](license) for details.

[toodledo]: http://www.toodledo.com
[doc]: http://api.toodledo.com/2/index.php
[license]: https://github.com/alswl/omniauth-toodledo/blob/master/LICENSE.md
[gemnasium-image]: https://gemnasium.com/alswl/omniauth-toodledo.png
[gemnasium-url]: https://gemnasium.com/alswl/omniauth-toodledo
