# Team Joy
Example of git hook for measuring team joy using code as proxy

## To install this hook
copy commit-msg.rb to .git/hooks/commit-msg in any repository where you want to use this local commit hook.

Make sure to drop the .rb off the end of the file name when placed in the hooks directory or git will not pick it up.

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

