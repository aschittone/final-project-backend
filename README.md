# README




Base Outline:

- pull listings from zillow to anylize
- then enter in how they would buy the property, either with cash or a mortgage
- enter in a rent amount (suggest average monthly rent for the area)
- calculate what their monthly net will be (after suggested expenses for the property)

Database tables:

Users
 - username
 - password_digest
Listings (need to make fetch requests everytine "saved" section is loaded)
 - number
 - street
 - town
 - state
 - zip code 
UserListings (listings that users save- join table)

API:
- zillow web services ID: X1-ZWz190zy8wb37v_4vl2o
- need to convert xml to json in backend to use (no json option available from zillow)

MVP:
- User can enter in a property address 
- Call ZILLOW API to get property info and perform calucaltions to see rental cashflow
- Need selection for cash or mortgage 
- Display results

Stretch Features:
- Users will be able to save listings ot "track" them while they're on the market




