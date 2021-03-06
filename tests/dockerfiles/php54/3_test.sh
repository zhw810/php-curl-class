# Run tests inside container.
command=$(cat <<-END
mkdir --parents "/tmp/php-curl-class" &&
rsync --delete --exclude=".git" --exclude="vendor" --exclude="composer.lock" --links --recursive "/data/" "/tmp/php-curl-class/" &&
cd "/tmp/php-curl-class" &&
export TRAVIS_PHP_VERSION="5.4" &&
(
    [ ! -f "/tmp/.composer_updated" ] &&
    composer --no-interaction update &&
    touch "/tmp/.composer_updated" ||
    exit 0
) &&
bash "tests/before_script.sh" &&
bash "tests/script.sh"
END
)
set -x
docker exec --interactive --tty "php54" sh -c "${command}"
