# Clockwork

## Data
Many features of Clockwork require data from the `tz` and `cldr` database. However, the native format is too cumbersome for Clockwork to parse directly.
We have included a Python script in the `data` directory that fetches raw data from the source, processes them into the
format that Clockwork recognizes, and stores the result data in subdirectories in `data`. By default this repo is shipped
with the latest processed data, but if you want to include the latest data, head into the `bin` directory and run
`sh fetch_data.sh`, which calls the Python script and makes sure that no annoying `__pycache__` caches are created.

Notice that the script requires `Python 3.7`, `pip3`, and, of course, an active Internet connection.
