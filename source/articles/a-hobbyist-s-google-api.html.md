---
title: A Hobbyist's Google API
date: 2020-10-12 20:01 PDT
tags: google
---

Google's API is designed with "serious" apps in mind.  That's fine, but it can be obnoxiously cumbersome and heavyweight when all you want is an access token for your own account so you can write a little hobby script.  I recently went through the process of figuring this out.  Here's the rundown.

## Make An App

First things first:  you need to make an app.  Head on over to the [create a project](https://console.developers.google.com/projectcreate) page.  It doesn't matter what you name it or what organization it's under.  I just went with `No Organization`.

Once the app is created you'll land back at the dashboard.  Click on the [OAuth Consent Screen](https://console.developers.google.com/apis/credentials/consent) link in the left navigation.  Choose `External`  for the user type (it might be your only option anyway), then click `Create`.  Now there's a bunch of crap on the next form that doesn't matter.  Give it a name to make it happy, then click `Save` at the bottom.

## Credentials

Now go to the [Credentials](https://console.developers.google.com/apis/credentials) page.  Click `+ Create Credentials` on top and select `OAuth client ID`.  This next step really matters:  choose `Desktop App` from the selector for `Application Type`.  This makes sure we have the power to get a `refresh token`, which we can use to fetch new `access tokens` whenever we want without having to go back through the annoying web authentication flow.  The `Name` you give the client here doesn't matter.

Boom.  Now you've got a popup with a `Client ID` and a `Client Secret`.  These will be helpful.  Keep a copy of them on hand for the future steps.

## Authorization Scopes

You've got to figure out the authorization scope for whatever it is you want to do.  I wanted to access my Google Photos, and I found the authorization scopes [here](https://developers.google.com/photos/library/guides/authorization).  I chose `https://www.googleapis.com/auth/photoslibrary`.

## Web Auth Flow

Now we need to load a URL in our browser that will let us grant our newly created Google App the permissions it needs to access our Google Account data.  Replace `$CLIENT_ID` and `$SCOPE` with the values we figured out in the previous two steps.

```shell
https://accounts.google.com/o/oauth2/v2/auth?client_id=$CLIENT_ID&redirect_uri=https://localhost&response_type=code&scope=$SCOPE
```

## This app isn't verified!

Once you choose an account (and enter your password if necessary), you'll see a scary `This app is not verified!` screen.  Woopeedoo.  Click the `Advanced` link or whatever it's called (it's different in each browser), and click the scary link to go to the unsafe page.  Click through a few more `Allow` style Google forms and you'll ultimately land at a `localhost` address, which will fail to load anything.  This is fine.  Look in the URL.  It'll look like this:

```shell
https://localhost/?code=$CODE&scope=$SCOPE
```

Booyah.  That `$CODE` in the URL is what we're after.  Copy that sucker out for safe keeping.

## Curling for Tokens

Now we have to make a POST request to convert that `$CODE` into a juicy `refresh token`.  This is the final boss.  This will utilize all the variables we've gotten up until now:

```shell
curl -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$CODE&grant_type=authorization_code&redirect_uri=https://localhost" -X POST https://oauth2.googleapis.com/token
```

This will give you what you're really after.  And like most good things in life, it'll be in JSON:

```javascript
{
  "access_token": $ACCESS_TOKEN,
  "expires_in": 3599,
  "refresh_token": $REFRESH_TOKEN,
  "scope": $SCOPE,
  "token_type": "Bearer"
}
```

## Access Token

That `$ACCESS_TOKEN` is what will let you make successful API requests.  The exact form of that request is going to depend on what Google API you're trying to access.  But the headers in the POST command will always take the same form:

```javascript
{
  "Content-type": "application/json",
  "Authorization": `Bearer ${ACCESS_TOKEN}`
}
```

## Refresh Token

As you can see from that sad `expires_in` attribute: your `access_token` is only going to last you an hour.  But that's ok, the `refresh_token` is our saviour.  Whenever you need a new `access_token`: you can make another `POST` request using the `refresh_token`.  In my [Scriptable](https://scriptable.app) script, which is mostly javascript, it looks like this:

```javascript
const refreshRequest = new Request("https://oauth2.googleapis.com/token");
refreshRequest.method = "POST";
refreshRequest.body = [
  `client_id=${this.ClientID}`,
  `client_secret=${this.ClientSecret}`,
  "grant_type=refresh_token",
  `refresh_token=${this.RefreshToken}`
].join("&");
const tokenInfo = await refreshRequest.loadJSON();
```

The response will be a `JSON` object with another `access_token` in it.  Rinse and repeat every hour.  😃
