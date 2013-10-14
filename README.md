# Redmine customization plugin

[![Build Status](https://travis-ci.org/Undev/redmine_customize.png)](https://travis-ci.org/Undev/redmine_customize)
[![Code Climate](https://codeclimate.com/github/Undev/redmine_customize.png)](https://codeclimate.com/github/Undev/redmine_customize)

Plugin for some Redmine customizations

## Customizations

### Allow other plugins to override translations

Patch to Redmine::I18n::Backend allows to load redmine core locale files first.
Locales supplied by plugins can now override redmine translations

### Make multiple select in filters bigger

Make multiple select in filters bigger by adding some css.

### Custom buttons

You can define your own (admin can make public) buttons for useful issue updates.
Buttons added to issue edit form, context menu and bulk edit form.

### Allow to hide sidebar blocks

Blocks in the sidebar can be hidden or showed individually.
All settings stored in user profile.

### Link to new issue with filled attributes

Added "Get url for this form" button on the new issue form.

### All visible projects in the jump box

Added all visible projects to the jump box. Change standard select to nice select2.

## License

Copyright (C) 2013 Undev.ru

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
