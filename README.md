Objectives:

- This application will allow the user to capture information about each F1 grand prix winner, and present information about the winner.
- Most information will come from wikipedia. If possible, I'll try to get information about the driver in f1.com website and maybe predict his qualification for the upcoming race.

#CLI
I will do a separate class for the CLI that will contain the dynamics of user interaction
Steps:
- Salutation
- Scrape for drivers list
- Scrape for teams list (will be used to get stats for drivers)
- Scrape team profile #struggling to get the drivers << Managed to get the drivers>>
- *********Now I am scraping the drivers profiles using search tr.
- list of drivers or do you know the driver?
- search for driver
- scrape driver profile
- if status is active, search for last results and get team stats to estimate position for next race
- show card for driver


#environment file will contain all requirements

Probable classes:

- F1 driver (note: I tried to get all profiles, but it was taking too much time, so I will scrape only the ones that are selected)
- Team (Not originally required, but I could not find a way to get it from the original wiki)
- Grand prix
- ScraperWiki
- ScraperF1
- Predictor
- Download info

Gems:

-nokogiri
-CLI

