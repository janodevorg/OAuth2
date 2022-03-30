# OAuth2 Authorization Overview

A walk through a sample OAuth2 authorization flow.

## A sample OAuth2 use case

Given the similarity between OAuth 1 and 2, this document applies to both of them.

1. The user opens an account on Twitter. 
2. The user installs a Twitter client on his phone.
3. The user opens the Twitter client. The client takes the user to Twitter.com, where he is asked 
   whether to authorize the client to access the timeline. 
4. If the user says yes, the web page returns control to the application, which now opens the 
   user’s timeline.

![Overview](oauth2-overview.png)

There are a few details to unpack here. 

In OAuth, every application that wants to access a service needs an identifier from that service.
This identifier is requested by the developer when he finishes developing his application. If 
later on, the application abuses the service, the identifier can be revoked, which renders the
application useless. Only identified applications on good standing can access an OAuth service.

On step three the application didn’t ask for user and password. Instead, it launched the browser 
and took the user to a page of the service provider. It is on this page that the user proves his
identity using login and password. At no point the application gets access to the user credentials.

On step four, the web page returns control to the application. It does so by asking the operative
system to open a link that belongs to the application. Included in that link, there is an access 
token, that grants access to the user’s timeline. If the user ever decides to stop using the 
application, he can go back to the service and remove the access token of the application.

In summary, OAuth limits the power of client application in the following ways:
- A service can revoke access to an application.
- An user can revoke access to an application.
- User credentials are never seen by the application.
