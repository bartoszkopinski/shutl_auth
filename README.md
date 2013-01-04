# ShutlAuth

You probably won't use this gem directly, as it is used by the
[https://github.com/shutl/shutl_resource](shutl_resource) gem

#Configuration

```ruby
Shutl::Auth.config do |c|
  c.url           = "<API_URL_GOES_HERE>"
  c.client_id     = "<CLIENT_ID>"
  c.client_secret = "<CLIENT_SECRET>"
end
```

