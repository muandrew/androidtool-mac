
if [ -z "$1" ]
then
    echo "usage:"
    echo "sh release_tag.sh major.minor.patch" 
    exit 0
fi

git tag -a release/$1 -m "v$1"
