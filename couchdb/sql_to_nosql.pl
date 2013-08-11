#!/usr/bin/perl

# sql_to_nosql.pl - This is a Perl script which takes the SQL database scripts
#    from Ushahidi (http://www.ushahidi.com/) and converts them into JSON
#    dumps suitable for import into CouchDB (http://couchdb.org/).

# This script takes as its arguments one or more SQL files and outputs one
# JSON dump which includes the converted contents of all of the SQL files.

# Modules.
use Getopt::Long;
use DBI;

# Variables
my $database = 'ushahidi';
my $help, $username, $host, $password, $connect_string, $database_connection;

my @tables = ('actions', 'actions_log', 'alert', 'alert_category', 'alert_sent', 'api_banned', 'api_log', 'api_settings', 'badge', 'badge_users', 'category', 'category_lang', 'checkin', 'city', 'cluster', 'comment', 'country', 'externalapp', 'feed', 'feed_item', 'form', 'form_field', 'form_field_option', 'form_response', 'geometry', 'incident', 'incident_category', 'incident_lang', 'incident_person', 'layer', 'level', 'location', 'maintenance', 'media', 'message', 'openid', 'page', 'permissions', 'permissions_roles', 'plugin', 'private_message', 'rating', 'reporter', 'roles', 'roles_users', 'scheduler', 'scheduler_log', 'service', 'sessions', 'settings', 'user_devices', 'user_tokens', 'users', 'verified');

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

foreach $table (@tables) {
    print "Table: " . $table . "\n";
    }

# Clean up after ourselves.
$database_connection->disconnect();

# End of script.
exit (0);

# Function that displays help text to the user.  Catch-all.
sub help {
    print "USAGE: $0 --username=username (--host=host) --password=password";
    }

