# Ruboty::TwitterTrack

Ruboty handler to track terms in the twitter stream.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-twitter_track'
```

And then execute:

    $ bundle

## Usage

```
> @ruboty track tweets by ruboty 
Tracked 'ruboty'

@ruboty> https://twitter.com/haccht/status/123456789
@ruboty> https://twitter.com/haccht/status/123456790
@ruboty> https://twitter.com/haccht/status/123456791

> @ruboty list tweets tracking
@haccht

> @ruboty untrack tweets by ruboty
Untracked 'ruboty'
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
