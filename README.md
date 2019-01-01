MediaWiki
========

Docker images and OpenShift QuickStart for MediaWiki 1.29.0. It supports
multi-site [Wiki family](https://www.mediawiki.org/wiki/Manual:Wiki_family).

* To host another wiki called ABC (accessible at `https://your.wiki.com/abc/`), you need:

1. `ABC_SITE_NAME` and `ABC_ADMIN_EMAIL` (required)
2. `ABC_GOOGLE_ANALYTICS_ACCOUNT` (optional): if you use [Google Analytics](https://www.google.com/analytics/)
3. `ABC_GOOGLE_LOGIN_SECRET` and `ABC_GOOGLE_LOGIN_APP_ID` (optional): follow the instructions for [Extension:GoogleLogin](https://www.mediawiki.org/wiki/Extension:GoogleLogin#Settings_in_Google_Developer_Console) to obtain the credentials for setting up login with Google.

* PreInstalled Plugins:

Cite,
CiteThisPage,
ConfirmAccount,
Gadgets,
GoogleAnalytics,
GoogleLogin,
ImageMap,
InputBox,
Interwiki,
LocalisationUpdate,
MobileFrontend,
Nuke,
ParserFunctions,
PdfHandler,
Poem,
Renameuser,
SpamBlacklist,
Scribunto,
SyntaxHighlight_GeSHi,
TitleBlacklist,
UserMerge,
WikiEditor,
Google Analytics.

* Default Admin Username: `admin`, Default Password: `admin123`.


Docker
==========

1. Create the following two files to provide database credentials and wiki
   settings:

`db.env`

    ~~~
    MYSQL_DATABASE=mediawiki
    MYSQL_ROOT_PASSWORD=CHANGE_ME_ROOT_PASSWORD
    ~~~

`app.env`

    ~~~
    OPENSHIFT_MYSQL_DB_HOST=mysql
    OPENSHIFT_MYSQL_DB_PORT=3306
    OPENSHIFT_APP_NAME=mediawiki
    OPENSHIFT_MYSQL_DB_USERNAME=root
    OPENSHIFT_MYSQL_DB_PASSWORD=CHANGE_ME_ROOT_PASSWORD
    SMTP_SERVER=smtp.CHANGE_ME.com
    SMTP_PORT=587
    SMTP_DOMAIN=CHANGE_ME.COM
    SMTP_USER_NAME=SOME_USER@CHANGE_ME.COM
    SMTP_PASSWORD=CHANGE_ME_SMTP_PASSWORD
    META_SITE_NAME=CHANGE_ME_SITE_NAME
    META_ADMIN_EMAIL=ADMIN@CHANGE_ME.COM
    ~~~

2. Add the following lines to `app.env`,

if you use Google Analytics:

    ~~~
    META_GOOGLE_ANALYTICS_ACCOUNT=UA-1234567-8
    ~~~

if you want Login via Google:

    ~~~
    META_GOOGLE_LOGIN_SECRET=abcdefg
    META_GOOGLE_LOGIN_APP_ID=987654321-hijklmnop.apps.googleusercontent.com
    META_GOOGLE_LOGIN_DOMAIN=YOUR_APP_DOMAIN_IF_NEEDED
    ~~~

3. Run `docker-compose up -d`.


Quickstart v3
==========

1. Sign up at https://www.openshift.com and create a new project

2. On the web console, click "Add to Project" -> "Import YAML/JSON", and paste the contents of the YAML file [here](https://raw.githubusercontent.com/baip/openshift-mediawiki/master/openshift/templates/mediawiki-mysql.yaml). Or alternatively, use `oc` command line:
    ~~~
    oc new-app -f https://raw.githubusercontent.com/baip/openshift-mediawiki/master/openshift/templates/mediawiki-mysql.yaml
    ~~~

The default wiki can be accessed at `https://{app}-{project}.{shard}.{amws}.openshiftapps.com/` or `https://{app}-{project}.{shard}.{amws}.openshiftapps.com/meta/`.

3. After the app is created, you can further customize it by going to "Applications" -> "Deployments" -> "Environment" on the web console.

4. To automatically trigger a new build, follow the instructions
   [here](https://docs.openshift.com/online/getting_started/basic_walkthrough.html#bw-configuring-automated-builds)


Quickstart v2
==========

1. Create an account at https://www.openshift.com

2. Create a PHP application with mysql:
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
