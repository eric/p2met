# Papertrail to Librato Metrics

A simple webhook to take [l2met-styled messages][l2met] (generally logged from
Heroku) and send them to Librato Metrics. Built specifically for use with the
Heroku Labs
[log-runtime-metrics][log-runtime-metrics].

[l2met]: https://github.com/ryandotsmith/l2met
[log-runtime-metrics]: https://devcenter.heroku.com/articles/log-runtime-metrics

## Deploying

### Step 0: Register for Papertrail and Librato Metrics

These instructions assume you have a [Papertrail][papertrail] and
[Librato Metrics][librato-metrics] account. Both are available as Heroku
add-ons.

    $ heroku addons:add papertrail
    $ heroku addons:add librato

### Step 1: Create a new Heroku app

    $ git clone https://github.com/eric/p2met
    $ cd p2met
    $ heroku create
    $ git push heroku master

### Step 2: Create a Librato Metrics API token

Sign into your Librato Metrics account and
[create a new API token][librato-api-token] with record only access.

![Generate Librato Metrics API Token.png](http://cl.ly/image/422k2g363z0i/Generate%20Librato%20Metrics%20API%20Token.png)

### Step 3: Configure Papertrail

Create the following Papertrail saved search:

    source= AND measure= AND val=

Configure the search to [alert using a web hook][papertrail-webhook] to the
p2met app created in step 1. Fill in `LIBRATO_USER` and `LIBRATO_API_TOKEN`
with the email address of your Librato Metrics account and the token created
in step 2.

    https://snowing-forest-293.herokuapp.com/submit?librato_user=LIBRATO_USER&librato_token=LIBRATO_TOKEN

[papertrail]: https://papertrailapp.com
[librato-metrics]: https://metrics.librato.com
[librato-api-token]: https://metrics.librato.com/account#api_tokens
[papertrail-webhook]: http://help.papertrailapp.com/kb/how-it-works/web-hooks
