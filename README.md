# Redmine Customization Plugin

[![Build Status](https://travis-ci.org/Undev/redmine_customize.png)](https://travis-ci.org/Undev/redmine_customize)
[![Code Climate](https://codeclimate.com/github/Undev/redmine_customize.png)](https://codeclimate.com/github/Undev/redmine_customize)

This plugin provides a number of useful features for Redmine customization.

* This plugin enables other plugins to override UI strings with localized strings
* The Redmine administrator can add a custom text for the 'account approval pending' notice
* The Redmine administrator can create links to be added to the top menu
* Users can create custom buttons and minimize sidebar blocks
* All projects become visible in the **Jump to a project** box
* Users can get a URL for a new issue draft 
* The plugin makes the selector in filters larger
* When a user copies an issue, watchers of the issue are copied as well
* Quotes are now inserted directly at the cursor's position in the issue note
* Users can submit an issue by pressing Cmd+Enter on the issue form page
* The plugin shows attachment descriptions on the issue page
* The plugin highlights notes in the issue history when accessed by direct links
* The plugin supports and preserves the project version sharing settings

## Compatibility

This plugin version is compatible only with Redmine 2.1.x and later.

## Installation

1. To install the plugins
    * Download the .ZIP archives, extract files and copy the plugin directories into #{REDMINE_ROOT}/plugins.
    
    Or

    * Change you current directory to your Redmine root directory:  

            cd {REDMINE_ROOT}
            
      Copy the plugins from GitHub using the following commands:
      
            git clone https://github.com/Undev/redmine__select2 plugins/redmine__select2
            git clone https://github.com/Undev/redmine_customize.git plugins/redmine_customize
            
2. Install the required gems using the command:  

        bundle install  

    * In case of bundle install errors, remove the Gemfile.lock file, update the local package index and install the required dependencies. Then execute the bundle install command again:  

            rm Gemfile.lock
            sudo apt-get update
            sudo apt-get install -y libxml2-dev libxslt-dev libpq-dev
            bundle install
            
3. This plugin requires a migration. Run the following command to upgrade your database (make a database backup before):  

        bundle exec rake redmine:plugins:migrate RAILS_ENV=production

4. Restart Redmine.

Now you should be able to see the plugins in **Administration > Plugins**.

## Usage

### Override UI strings with translations

The Redmine Customization Plugin enables other plugins to override UI strings with localized strings. Patch to Redmine::I18n::Backend allows to load redmine core locale files first.
Locales supplied by plugins can now override redmine translations

* The Redmine administrator can add a custom text for the 'account approval pending' notice
* The Redmine administrator can create links to be added to the top menu
* Users can create custom buttons and minimize sidebar blocks
* All projects become visible in the **Jump to a project** box
* Users can get a URL for a new issue draft 
* The plugin makes the selector in filters larger
* When a user copies an issue, watchers of the issue are copied as well
* Quotes are now inserted directly at the cursor's position in the issue note
* Users can submit an issue by pressing Cmd+Enter on the issue form page
* The plugin shows attachment descriptions on the issue page
* The plugin highlights notes in the issue history when accessed by direct links
* The plugin supports and preserves the project version sharing settings





### Allow other plugins to override translations



### Make multiple select in filters bigger

Make multiple select in filters bigger by adding some css.

### Custom buttons

You can define your own (admin can make public) buttons for useful issue updates.
Buttons added to issue edit form, context menu and bulk edit form.

### Allow to hide sidebar blocks

Blocks in the sidebar can be hidden or showed individually.
All settings stored in user profile.

### Link to new issue with filled attributes


with pre-filled attributes
Added "Get url for this form" button on the new issue form.

### All visible projects in the jump box

Added all visible projects to the jump box. Change standard select to nice select2.

### Insert quote at the cursor

Insert quote at the cursor when write comments instead replacing existing text

### Show description for attachment

Show description for attachment in the issue history

### Highlight note in history

Highlight note in history when open links with specific note (.../issues/XXX#note-YYY)

### Copy watchers when copying issue

Copy watchers and related issues when copying issue

### Respect version's sharing settings

Fixed links in version overview. Find issues according to version sharing settings (http://www.redmine.org/projects/redmine/wiki/RedmineProjectSettings#Versions)

### Submit form by Cmd+Enter

Submit form when updating issue or created one by hitting cmd+Enter (ctrl+Enter on Win, linux).

### Custom 'notice account pending' text

On the plugin settings page administrator can set custom text for 'notice account pending' text.
For example: 'Call administrator (+55555555) for approve your account)'

## License

Copyright (c) 2015 Undev

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.