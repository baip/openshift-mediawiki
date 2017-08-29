OpenShift - MediaWiki
========

QuickStart MediaWiki 1.29.0 on OpenShift.

Follow the steps below to build on OpenShift.

PreInstalled Plugins:

Cite,
CiteThisPage,
ConfirmAccount,
Gadgets,
GoogleLogin,
ImageMap,
InputBox,
Interwiki,
LocalisationUpdate,
Nuke,
ParserFunctions,
PdfHandler,
Poem,
Renameuser,
SpamBlacklist,
SyntaxHighlight_GeSHi,
TitleBlacklist,
UserMerge,
WikiEditor,
Google Analytics.


Whats new
==========

8/10/2015

Openshift uses HAProxy for loadbalancing in front of the servers.
This causes mediawiki to show the same internal proxy ip for all users.
I've written a small plugin to fix this.
Can be found under /extensions/OpenshiftMediawikiIpFix

30/09/2015

Plugins:

1. Scribunto (with standalone lua, enables you to do in wiki scripting and use popular features like infobox)
2. mobile frontend
3. google analytics (edit LocalSettings.php to set your google analytics account. edit line 165.)
Google analytics extension repo/code can be found here -> https://github.com/negati-ve/mediawiki-google-analytics-extension
* uploads moved to data directory. Uploads are now persistent.


Quickstart v3
==========

1. Sign up at https://www.openshift.com and create a new project
2. On the web console, "Add to Project" -> "Browse Catalog" -> "Data Stores" ->
   "MySQL (Persistent)". Note "Database Service Name" and "MySQL Database Name".
3. "Add to Project" -> "Browse Catalog" -> "PHP 7.0" and fill in this URL for
   this git repository
4. Click "advanced options", under "Deployment Configuration", "Add Environment
   Variable" as needed: `SITE_NAME`, `ADMIN_EMAIL`, `GOOGLE_ANALYTICS_ACCOUNT`,
   `GOOGLE_LOGIN_SECRET`, `GOOGLE_LOGIN_APP_ID`, `GOOGLE_LOGIN_DOMAIN`
5. Also set the following variables to: `OPENSHIFT_MYSQL_SERVICE_NAME="Database
   Service Name"`, `OPENSHIFT_APP_NAME="MySQL Database Name"`
5. "Add Environment Variable Using a Config Map or Secret", using the secret
   created by the database (e.g., "mysql") to set:
   `OPENSHIFT_MYSQL_DB_USERNAME`, `OPENSHIFT_MYSQL_DB_PASSWORD`
6. To automatically trigger a new build, follow the instructions
   [here](https://docs.openshift.com/online/getting_started/basic_walkthrough.html#bw-configuring-automated-builds)


Quickstart v2
==========

1. Create an account at https://www.openshift.com
2. Create a php application with mysql:
    ```
    $ rhc app create mediawiki php-5.4 mysql-5.5
    ```
3. Add this upstream mediawiki repo
    ```
    $ cd mediawiki
    $ git remote add upstream -m master https://github.com/negati-ve/openshift-mediawiki.git
    $ git pull -s recursive -X theirs upstream master
    ```
4. Then push the repo upstream
    ```
    $ git push
    ```
5. That's it, you can now checkout your application at:
    http://mediawiki-$yourlogin.rhcloud.com
6. Default Admin Username: admin
   Default Password: admin123


Updates
=======

In order to update or upgrade to the latest mediawiki, you'll need to re-pull
and re-push.

1. Pull from upstream:
    ```
    $ cd mediawiki/
    $ git pull -s recursive -X theirs upstream master
    ```
2. Push the new changes upstream
    ```
    $ git push
    ```


Repo layout
===========
php/ - Externally exposed php code goes here

libs/ - Additional libraries

misc/ - For not-externally exposed php code

../data - For persistent data

.openshift/pear.txt - list of pears to install

.openshift/action_hooks/build - Script that gets run every push, just prior to
    starting your app


Notes about layout
------------------
Please leave php, libs and data directories but feel free to create additional
directories if needed.

Note: Every time you push, everything in your remote repo dir gets recreated
please store long term items (like an sqlite database) in ../data which will
persist between pushes of your repo.
