# Teamwork

How to register an application to access your Teamwork account.

## Overview

Teamwork is a project management application similar to Jira. It has a public API that you can use
to access your own account. 

The steps to configure this application to access a Teamwork account are:

1. Create a 30 day trial account. 
2. Register in the developer portal.
3. Register an application.
4. Fill-in the teamwork.plist in this sample app with your registration data.

### 1. Create a trial account

Go to https://www.teamwork.com/ and click _Start Your Free Trial_. 

A trial lasts 30 days and doesn’t require a credit card. Your account will be available at the 
domain of your choosing. The URL will be similar to `http://YOUR_ID.teamwork.com`.

### 2. Register in the developer portal

- Log as user that owns the company.
- Go to `https://YOUR_ID.com/developer`
- Fill-in at least the _Name_. The following is optional: _Logo_, _Website_, _Privacy URL_, 
  _Terms URL_, _VAT_, _Email_, _Address_.

### 3. Create your first app

- Go to `https://YOUR_ID.teamwork.com/developer#/apps/welcome`.
- Click _Create your first app_.
- Fill in at least the _Name_, _Redirect URIs_, and choose a _Product_ for which you are creating the app. The following is optional: _Icon_, _Description_, _Short description_. If this is not a web app, use a custom protocol for the redirect URI (e.g. myapp://callback). 
- Click `Create App`.

I used _Teamwork Mobile Design_, _Teamwork_, `oauthexample://callback`.

### 4. Get your credentials

- Go to `https://YOUR_ID.teamwork.com/developer#/apps/list` to see a list of your apps
- Click the app you just created
- Go to the _Credentials_ tab
- Copy the values for Client ID, and Client secret

My registration data was 

| Field | Value |
|---|---|
| Name | _Teamwork Mobile Design_ | 
| Product | _Teamwork_ |
| Callback | `oauthexample://callback` |
| Client ID | [Redacted] |
| Client Secret | [Redacted] |

You need to copy the callback, client ID, and client Secret to the teamwork.plist file, with keys
`callback`, `key`, and `secret`.
