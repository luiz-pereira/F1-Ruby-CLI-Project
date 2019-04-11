Objectives:

- This application allows the user to capture information about each F1 driver, and present information about him in a friendly and fast manner.
- Most information comes from several sites from wikipedia (F1 drivers list, F1 constructors list, profiles, 2018/2019 results).
- classify active drivers on ranking to try to predict what will be the next race's results.

#CLI
I've made separate classes for the CLI that will contain the dynamics of user interaction
Steps:
- Salutation
- Scrape for drivers list
- Scrape for teams list (will be used to get stats for drivers)
- Scrape team profile #struggling to get the drivers << Managed to get the drivers>>
- list of drivers or do you know the driver?
- search for driver
- scrape driver profile
- if status is active, search for last results and get team stats to estimate position for next race
- show card for driver


#environment file contain all requirements - I've used require_all to avoid going back to the file and inserting a new 'require' every time i create a new file.

classes:

- interface - performs the interaction with the user and calls classes and methods
 -F1 driver - each driver is an instance of this class, that contains many attributes
- F1 Team - each team is an instance of this class, that contains many attributes
- ScraperWikiDriver - used to scrape information about each driver
- ScraperWikiTeam - used to scrape information about each team
- Predictor - does all the calculations to rank each active driver and present to the user

Gems:

-nokogiri
-CLI
-pry
-require_all
-I/O console
-colorize

installations instructions:
-fork and close the repository
-run bundle install
-ruby ./bin/run to tun the application

