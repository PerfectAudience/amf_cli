# AMF Reporting CLI

This is a quick little CLI hack I used to create certain AMF reports. It may or may not be expanded as needs arise.

## Usage

After checking out the repo, run `bin/setup` to install dependencies and create the database.
Then run it from the repo directory with `bundle exec amf`

### Basic Commands

```bash
AMF commands:
  amf count                        # Returns the number of Account records in the system
  amf diff_emails <FILE1> <FILE2>  # Takes two email lists and produces a list of those who appear in FILE1 but do not appear in FILE2
  amf help [COMMAND]               # Describe available commands or one specific command
  amf load                         # Commands used to preload data into the system
  amf report                       # Commands used to create various reports
  amf version                      # Displays the program version information
```

### Load Commands

```bash
AMF::Load commands:
  amf load amfed FILE      # loads records who have had AMF activated
  amf load funnel FILE     # loads and produces the Click Funnel report
  amf load help [COMMAND]  # Describe subcommands or one specific subcommand
  amf load mega FILE       # reads a MEGA report file and loads it into the working database
  amf load stripe FILE     # loads stripe data
```

### Report Commands

```bash
AMF::Report commands:
  amf report filename        # returns a unique filename based on teh currently selected parameters
  amf report help [COMMAND]  # Describe subcommands or one specific subcommand
  amf report info            # Displays information about the AMF report using the current SQL parameters
  amf report report          # Produces the AMF valid accounts report (default command)
```

Once installed, the first step is to run `amf laod mega FILE` where `FILE` is the MEGA report in CSV format.
This takes roughly five minutes to run, but will load the data into a sqlite3 database for ease of future reporting.

`amf help [command]` will give you more options as well.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PerfectAudience/amf_cli
