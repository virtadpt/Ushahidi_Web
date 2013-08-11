#!/usr/bin/perl

# sql_to_nosql.pl - This is a Perl script which takes the SQL database scripts
#    from Ushahidi (http://www.ushahidi.com/) and converts them into JSON
#    dumps suitable for import into CouchDB (http://couchdb.org/) written to
#    separate files in the current working directory.

# by: The Doctor [412/724/301/703][ZS <drwho at virtadpt dot net>]
# Github: https://github.com/virtadpt

# Modules.
use Getopt::Long;
use DBI;
use JSON;

# Variables
# $database: The name of the Ushahidi database.
# $help: Whether or not the user is requesting help.
# $username: The username to connect to the MySQL database with.
# $host: The hostname of the MySQL database server.  Defaults to localhost.
# $password: The password to the MySQL account.
# $connect_string: The database connection string to pass to DBI::DBD.
# $database_connection: Database connection handle returned by DBI::DBD.
# $query: Reference to a prepared MySQL query.
# $table: Name of the database table being accessed in the loop.
# $outfile: Name of the JSON file to create.
# $json_text: A line of JSON-formatted data.
my $database = 'ushahidi';
my $help, $username, $host, $password, $connect_string, $database_connection;
my $query, $table, $outfile, $json_text;

# This is a list of all of the tables in the Ushahidi database.
my @tables = ('actions', 'actions_log', 'alert', 'alert_category',
	      'alert_sent', 'api_banned', 'api_log', 'api_settings', 'badge',
	      'badge_users', 'category', 'category_lang', 'checkin', 'city',
	      'cluster', 'comment', 'country', 'externalapp', 'feed',
	      'feed_item', 'form', 'form_field', 'form_field_option',
	      'form_response', 'geometry', 'incident', 'incident_category',
	      'incident_lang', 'incident_person', 'layer', 'level', 'location',
	      'maintenance', 'media', 'message', 'openid', 'page',
	      'permissions', 'permissions_roles', 'plugin', 'private_message',
	      'rating', 'reporter', 'roles', 'roles_users', 'scheduler',
	      'scheduler_log', 'service', 'sessions', 'settings',
	      'user_devices', 'user_tokens', 'users', 'verified');

# @data: Holds results from MySQL queries.
my @data;

# This script needs some command line args, so set up an argument vector parser.
GetOptions(	"help"		=> \$help,
		"username=s"	=> \$username,
		"host=s"	=> \$host,
		"password=s"	=> \$password);

# Parse the arguments passed to the script.
# User has explicitly asked for help.
if ($help) {
    help();
    exit (0);
    }

# No username.
if (! $username) {
    print "ERROR: No MySQL database username to connect with.\n";
    help();
    exit (1);
    }
chomp $username;

# No hostname.
if (! $host) {
    $host = 'localhost';
    }
chomp $host;

# No MySQL password.
if (! $password) {
    print "ERROR: No MySQL database password to connect with.\n";
    help();
    exit (1);
    }
chomp $password;

# Set up the database connection.
$connect_string = "DBI:mysql:host=" . $host;
$database_connection = DBI->connect($connect_string, $username, $password)
    or die "ERROR: Could not connect to MySQL database.\n";

# Access the Ushahidi database.
$query = "use ushahidi;";
$database_connection->do($query)
    or die "ERROR: Could not access database 'ushahidi'.\n";

# Walk the list of tables in the database.
foreach $table (@tables) {
    # Test if the output file exists.  If it does, delete it.
    $outfile = $table . ".json";
    if ( -e $outfile ) {
        print "Output file " . $outfile . " exists.  Deleting it.\n";
        unlink $outfile;
        }

    # Create the output JSON file.
    if ( ! open OUTFILE, ">$outfile") {
        print "ERROR: Unable to open JSON output file " . $outfile . "\n";
        exit(1);
        }

    # Select the contents of the entire database table.
    $query = $database_connection->prepare("SELECT * from " . $table . ";");
    $query->execute()
        or die "ERROR: Unable to SELECT contents of table " . $table . ".\n";

    # JSON encod each line from the table and write it to the output file.
    while (@data = $query->fetchrow_array()) {
        $json_text = encode_json(\@data);
        print OUTFILE $json_text . "\n";
        }

    close OUTFILE;
    }

# Clean up after ourselves.
$database_connection->disconnect();

# End of script.
exit (0);

# Function that displays help text to the user.  Catch-all.
sub help {
    print "USAGE: $0 --username=username (--host=host) --password=password";
    }

