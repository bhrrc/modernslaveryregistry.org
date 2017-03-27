# TODO

## Features

- [x] Show statements on front page
  - [ ] Only show company's most recently seen statement
  - [x] Call to action to register if company has no statement
- [x] Form for registering companies
- [ ] Form for registering statements
  - [x] For existing company
  - [ ] For non existent company (register company in same form)

### Stats
- [ ] Percentages
  - [ ] Signature
  - [ ] Link
  - [ ] Board
  - [ ] All 3
  - [ ] 2 of them

### Admin / Security
- [ ] Only display hidden field when logged in

## UX
- [ ] Iframe statements - deal with "Refused to display '<statement URL>' in a frame because it set 'X-Frame-Options' to 'SAMEORIGIN'."
  - SO: http://stackoverflow.com/questions/18327314/how-to-allow-http-content-within-an-iframe-on-a-https-site
  - Could try to change all http URLs to https during import/save
  - Use a proxy (ugh)
- [ ] Company statements - most recent on top, and highlighted
- [ ] Show validation errors in forms
- [ ] Hint that hidden fields are hidden from public
- [ ] Display company HQ
  - [ ] Country
  - [ ] Flag

# Map
- [ ] Use Geonames to get HQ country geo location

## Performance
- [x] Add DB indices
- [ ] Pay for more dynos
- [ ] Speed up rendering
  - Cache (CloudFlare)
  - CSS: `table-layout: fixed;`

## Data

### Integrity
- [ ] Enforce HQ country
- [ ] Validate statement URL is URL, and exists, possibly store with https

### Import
- [x] Import countries from Geonames
- [x] Import sectors
- [x] Import companies
- [x] Import statements
- [x] Record who signed
- [ ] Get correct "seen" dates from public registry

## Styling

## Deployment
- [ ] Deploy to Heroku
- [ ] Map domain name
- [ ] https / let's encrypt

## Tech debt
- [x] Extract view logic to partials

## References
- Layout: https://dansup.github.io/bulma-templates/templates/profile.html
- Fake browser: http://codepen.io/endlesszero/pen/MYeWPQ
