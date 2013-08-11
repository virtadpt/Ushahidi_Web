#!/usr/bin/perl

# sql_to_nosql.pl - This is a Perl script which takes the SQL database scripts
#    from Ushahidi (http://www.ushahidi.com/) and converts them into JSON
#    dumps suitable for import into CouchDB (http://couchdb.org/).

# This script takes as its arguments one or more SQL files and outputs one
# JSON dump which includes the converted contents of all of the SQL files.

# Variables
my $database = 'ushahidi';
my @tables = ('actions', 'actions_log', 'alert', 'alert_category', 'alert_sent', 'api_banned', 'api_log', 'api_settings', 'badge', 'badge_users', 'category', 'category_lang', 'checkin', 'city', 'cluster', 'comment', 'country', 'externalapp', 'feed', 'feed_item', 'form', 'form_field', 'form_field_option', 'form_response', 'geometry', 'incident', 'incident_category', 'incident_lang', 'incident_person', 'layer', 'level', 'location', 'maintenance', 'media', 'message', 'openid', 'page', 'permissions', 'permissions_roles', 'plugin', 'private_message', 'rating', 'reporter', 'roles', 'roles_users', 'scheduler', 'scheduler_log', 'service', 'sessions', 'settings', 'user_devices', 'user_tokens', 'users', 'verified');

foreach $table (@tables) {
    print "Table: " . $table . "\n";
    }

