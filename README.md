# Ruboty::TwitterTrack

Ruboty handler to track the twitter stream with the given words.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-twitter_track'
```

And then execute:

    $ bundle

## Usage

```
> @ruboty twitter track by rubygems
@ruboty> Tracked 'rubygems'.

@ruboty> https://twitter.com/haccht/status/123456789
@ruboty> https://twitter.com/haccht/status/123456790
@ruboty> https://twitter.com/haccht/status/123456791

> @ruboty twitter tracking
@ruboty> '100: rubygems'

> @ruboty twitter untrack 100
@ruboty> Untracked '100: rubygems'.
```

## Env

Requires twitter access tokens.  
https://apps.twitter.com

```
export CONSUMER_KEY=
export CONSUMER_SECRET=
export ACCESS_TOKEN=
export ACCESS_TOKEN_SECRET=
```
