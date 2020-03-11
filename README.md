# AMF Reporting CLI

This is a quick little CLI hack I used to create certain AMF reports. It may or may not be expanded as needs arise.

## Usage

After checking out the repo, run `bin/setup` to install dependencies and create the database.
Then run it from the repo directory with `bundle exec amf`

```bash
Commands:
  amf amf_count                    # Display the number of records selected for the AMF Report
  amf amf_report                   # Produces the AMF valid accounts report
  amf count                        # Returns the number of Account records in the system
  amf diff_emails <FILE1> <FILE2>  # Takes two email lists and produces a list of those who appear in FILE1 but do not appear in FILE2
  amf funnel_report <FILE>         # Returns a report of users which match records in FILE against the MEGA data
  amf help [COMMAND]               # Describe available commands or one specific command
  amf load FILE                    # reads a MEGA report file and loads it into the working database
  amf version                      # Displays the program version information
```

Once installed, the first step is to run `amf laod FILE` where `FILE` is the MEGA report in CSV format.
This takes roughly five minutes to run, but will load the data into a sqlite3 database for ease of future reporting.

`amf help [command]` will give you more options as well.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PerfectAudience/amf_cli
