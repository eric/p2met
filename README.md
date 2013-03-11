# Papertrail l2met-style webhook

A simple webhook to take [l2met-styled messages][l2met] (generally logged from
Heroku) and send them to Librato Metrics.

[l2met]: https://github.com/ryandotsmith/l2met

## Deploying

### Step 1: Create a heroku app

    $ git clone https://github.com/eric/p2met
    $ cd p2met
    $ heroku create
    $ git push heroku master

### Step 2: Set your Librato Metrics API credentials (Optional)

    $ heroku addons:add librato
    
or 
    
    $ heroku config:add LIBRATO_USER=someguy@something.com LIBRATO_TOKEN=69fd475972db19b6c2ee1f68d08acff1c4bcbf5b

### Step 3: Create a Papertrail webhook

Find out more info here: http://help.papertrailapp.com/kb/how-it-works/web-hooks

The URL to send to will be:

    https://snowing-forest-293.herokuapp.com/submit
    
If you have chosen not to set your librato credentials, you can pass them
in the webhook request:

    https://snowing-forest-293.herokuapp.com/submit?librato_user=someguy@something.com&librato_token=69fd475972db19b6c2ee1f68d08acff1c4bcbf5b
