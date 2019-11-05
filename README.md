# Bump-N-Tag Version
GitHub Action program to handle application version file like auto-increment of version number based on GitHub events. This action program supports "push" and "pull-request" events.

## Inputs

### `file_name`

**Required** - The name of file contains version information.

### `tag_version`

**Optional** - Value can be 'true' or 'false'. If 'true' will create tag for this version and push the same to repository. By default it is always 'false'

### `Sample **VERSION** file content`

File may contain any of the below listed version formats. Prefix character or word can be in any of 'V' or 'VER' or 'VERSION' and supports both lower and upper case. Number of segments of version string can be either three or four where fourth segment represents build number. This program by default will always increment last segment part of version string.

```
v1.2.3
v 1.2.3
ver 1.2.3
version 1.2.3
VER 2.3.6.4
VERSION 1.2.4.55
```


## Example usage

```
name: App Version Actions
on: [push, pull_request]  # Recommended to use either of one event

jobs:
  Version-check:
    runs-on: ubuntu-latest
    name: Bump-N-Tag Version
    steps:
    - uses: actions/checkout@master
    - name: Increment version
      id: version   
      uses: vinodhraj/Bump-N-Tag-Version@master
      with:
        file_name: './VERSION'
        tag_version: "true"
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

