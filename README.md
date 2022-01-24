[![Maintainability](https://api.codeclimate.com/v1/badges/c03b02ca384c12616a7c/maintainability)](https://codeclimate.com/github/DocOnDev/team_joy/maintainability)

# Code Joy
Example of git hooks for measuring code joy

The commit-msg hook will reject commits that do not have a quality rating

The post-update hook will push the accepted commit to the developer view database

Contact Doc Norton if you want your open source project added to [Code Joy](https://www.code-joy.app).

## Install
### Standard install

* Copy the lib folder to .git/hooks/ in in any repository where you want to use this local commit hook.
* rename .git/hooks/commit-msg.rb to .git/hooks/commit-msg
* make .git/hooks/commit-msg executable
* rename .git/hooks/post-update.rb to .git/hooks/post-update
* make .git/hooks/post-update executable
* rename .git/hooks/joy_config_sample.yml to .git/hooks/joy_config.yml

```
cp lib/*.* [project-root]/.git/hooks
cd [project-root]
mv .git/hooks/commit-msg.rb .git/hooks/commit-msg
chmod +rx .git/hooks/commit-msg
mv .git/hooks/post-update.rb .git/hooks/post-update
chmod +rx .git/hooks/post-update
mv .git/hooks/joy_config_sample.yml .git/hooks/joy_config.yml
```

### Yorkie Install
Yorkie is a fork of Husky for vue projects.
Husky makes git hooks easier to manage.

* Copy the lib folder to a tj_hooks fiolder off of the root of your project.
* rename tj_hooks/commit-msg.rb to tj_hooks/commit-msg
* make tj_hooks/commit-msg executable
* rename tj_hooks/post-update.rb to tj_hooks/post-update
* make tj_hooks/post-update executable
* rename tj_hooks/joy_config_sample.yml to tj_hooks/joy_config.yml


```
cp lib/*.* [project-root]/tj_hooks
cd [project-root]
mv tj_hooks/commit-msg.rb tj_hooks/commit-msg
chmod +rx tj_hooks/commit-msg
mv tj_hooks/post-update.rb tj_hooks/post-update
chmod +rx tj_hooks/post-update
mv tj_hooks/joy_config_sample.yml tj_hooks/joy_config.yml
```
* Update package.json to include the new git hooks:

```
"gitHooks": {
  "commit-msg": "tj_hooks/commit-msg $GIT_PARAMS",
  "post-commit": "tj_hooks/post-commit $GIT_PARAMS"
}
```

## Configure
Update your joy_config.yml file to allow access to your data store. You will need the URI and Token.

Contact Doc Norton if you want your open source project added to [Code Joy](https://www.code-joy.app).

Head on over to [GraphCms](https://graphcms.com/) if you need a private data store.

Supported data stores include:

* GraphCms (default)


```
cms:
  type: GraphCms
  uri: https://some.graphcms.com/version/key/branch
  public: true
  token: SomeToken
score-file:
  path: ./score_file
```

## Basic use
Once installed, all commit messages must contain a quality rating bewtween 0 and 5 in the format of -n- where n is the rating.
Rating scale is roughly:

0 - Terrible quality<br />
1 - Very Poor quality<br />
2 - Poor quality<br />
3 - Good quality<br />
4 - Very Good quality<br />
5 - Excellent quality

### Usage Examples:

`git commit -m"US999999 -3- Added valid threshold check to controller"` <br/>
This commit message has a rating of 3 (Good quality)

`git commit -m"US999999 Added valid threshold check to controller"` <br/>
This commit message has no rating and will be rejected

`git commit -m"US999999 -7- Added valid threshold check to controller"` <br/>
This commit message has a rating of 7, which is too high, and will be rejected

### Overrides
This git hook can be ignored by using the `--no-verify` parameter.

`git commit -m"US999999 -7- Added valid threshold check to controller" --no-verify` <br/>
This commit message has a rating of 7, but the commit will be accepted because the no-verify flag will bypass the hook.
