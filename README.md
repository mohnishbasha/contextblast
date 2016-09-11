# ContextBlast - Bring products & brands around you to life.

## Interact with your favorite products & brands
## Converse, Engage and Transact with products & brands


## Inspiration
There are billions of products and services that are used by consumers around the world. However, currently there is no good way for consumer to engage, converse, or interact with these offline products & brands in real time to derive valuable contextual information. 

On the other hand, there is currently no real platform that business can use to capture real time engagement of the consumers with their products and brands.

Imagine, if the products and brands can augment & talk to you to tell their stories, provide information, support and enable self serviceable commerce transactions.

Use Cases:
1. Enable TECHCRUNCH DISRUPT logo to provide contextual information to event attendees  to provide information on products being sold at the TechCrunch Store, information on the judges, show recent techcrunch post etc.

2. Lets says your laptop charger broke down, and you need to find the exact make, model and nearest store to find the charger. Lets say, if your charger itself can help you augment & find all that information and also empower you to do a buy transaction at one of these stores.

## What it does
Here is how the application works:
- We have provided a Mobile Application that brings up a camera interface which actively scans for products and brands from the image taken from the camera.
- Using Image recognition & AI via IBM Watson Visual API, we are able to derive context out of the images.
- Based on the context, we invoke various intents using IBM Watson Conversation API.
- Currently we are supporting the following intents.
-- Show products from techcrunch store
-- Show who is judging the disrupt hackathon
-- Show recent posts from Techcrunch REST API

## How we built it
- Android
- iOS
- IBM Speech2Text, Visual Recognition, Text2Speech, Conversation API
- Techcrunch REST API
- HereMaps API

## Challenges we ran into
- Defining the right context for a product.
- Contexts can differ based on product, time, location and other factors
- Minor API setup issues.

## Accomplishments that we're proud of
- We are proud that we were able to successfully complete a use case using the Sponsor API's.
- We are proud to launch the worlds first real time contextual service to enable offline products and brands provide digital informaton to its end users.

## What we learned
- IBM Watson Platform, Services and APIS
- HereMaps API
- Techcrunch Data

## What's next for ContextBlast
- Context Self Service Learning platform for business to define and enable intents, contexts for their products and services.
- Scale it to millions of products & brands.
- Enable a digital contextual layer around millions of products and brands.
