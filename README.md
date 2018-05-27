OpenShift - MediaWiki
========

QuickStart MediaWiki 1.29.0 on OpenShift. It supports multi-site [Wiki
family](https://www.mediawiki.org/wiki/Manual:Wiki_family).

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


Quickstart v3
==========

1. Sign up at https://www.openshift.com and create a new project

2. On the web console, click "Add to Project" -> "Import YAML/JSON", and paste the contents of the YAML file [here](https://raw.githubusercontent.com/baip/openshift-mediawiki/master/openshift/templates/mediawiki-mysql.yaml). Or alternatively, use `oc` command line:
    ~~~
    oc new-app -f https://raw.githubusercontent.com/baip/openshift-mediawiki/master/openshift/templates/mediawiki-mysql.yaml
    ~~~

The default wiki can be accessed at `https://{app}-{project}.{shard}.{amws}.openshiftapps.com/` or `https://{app}-{project}.{shard}.{amws}.openshiftapps.com/meta/`.

3. After the app is created, you can further customize it by going to "Applications" -> "Deployments" -> "Environment" on the web console. To host another wiki called ABC, you need:

* `ABC_SITE_NAME` and `ABC_ADMIN_EMAIL` (required)
* `ABC_GOOGLE_ANALYTICS_ACCOUNT` (optional): if you use [Google Analytics](https://www.google.com/analytics/)
* `ABC_GOOGLE_LOGIN_SECRET` and `ABC_GOOGLE_LOGIN_APP_ID` (optional): follow the instructions for [Extension:GoogleLogin](https://www.mediawiki.org/wiki/Extension:GoogleLogin#Settings_in_Google_Developer_Console) to obtain the credentials for setting up login with Google.

The new wiki can be accessed at `https://{app}-{project}.{shard}.{amws}.openshiftapps.com/abc/`.

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
