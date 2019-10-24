#!/bin/sh -l

file_name=$1
tag_version=$2
echo "\nInput file name: $file_name : $tag_version"

([ -z "$GITHUB_ONLY_ON_COMMIT" ]) || exit 0

if test -f $file_name; then
    content=$(cat $file_name)
else
    content=$(echo "-- File doesn't exist --")
fi

echo "File Content: $content"
extract_string=$(echo $content | awk '/^([[:space:]])*(v|ver|version|V|VER|VERSION)?([[:blank:]])*([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,3})(\.([0-9]{1,3}))?[[:space:]]*$/{print $0}')
echo "Extracted string: $extract_string"

if [[ "$extract_string" == "" ]]; then 
    echo "\nInvalid version string"
    exit 0
else
    echo "\nValid version string found"
fi

major=$(echo $extract_string | cut -d'.' -f1) 
major=${major:(-2)}
minor=$(echo $extract_string | cut -d'.' -f2)
patch=$(echo $extract_string | cut -d'.' -f3)
build=$(echo $extract_string | cut -d'.' -f4)

if [[ $build = "" ]]; then
    oldver=$(echo $major.$minor.$patch)
    patch=$(expr $patch + 1)
    newver=$(echo $major.$minor.$patch)
else
    oldver=$(echo $major.$minor.$patch.$build)
    build=$(expr $build + 1)
    newver=$(echo $major.$minor.$patch.$build)
fi

echo "\nOld Ver: $oldver"
echo "\nUpdated version: $newver" 

newcontent=$(echo ${content/$oldver/$newver})
echo $newcontent > $file_name

echo "\nStarting Git Operations"
git config --global user.email "Bump-N-Tag@github-action.com"
git config --global user.name "Bump-N-Tag App"

git add -A 
git commit -m "Incremented to ${newver}"  -m "[skip ci]"
([ -n "$tag_version" ] && [ "$tag_version" = "true" ]) && (git tag -a "${newver}" -m "[skip ci]") || echo "No tag created"

git show-ref
git push --follow-tags "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" HEAD:${GITHUB_REF}


echo "\nEnd of Action\n\n"
exit 0